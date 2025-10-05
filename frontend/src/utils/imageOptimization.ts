/**
 * Image optimization utilities for Supabase Storage
 */

export interface ImageTransformOptions {
  width?: number;
  height?: number;
  quality?: number;
  format?: 'webp' | 'jpeg' | 'png';
  resize?: 'cover' | 'contain' | 'fill';
}

/**
 * Get optimized image URL from Supabase Storage
 * Uses Supabase's built-in image transformation
 */
export function getOptimizedImageUrl(
  url: string,
  options: ImageTransformOptions = {}
): string {
  if (!url) return '';

  // If not a Supabase URL, return as is
  if (!url.includes('supabase.co/storage')) {
    return url;
  }

  const {
    width,
    height,
    quality = 80,
    format = 'webp',
    resize = 'cover'
  } = options;

  try {
    const urlObj = new URL(url);
    const searchParams = new URLSearchParams();

    if (width) searchParams.set('width', width.toString());
    if (height) searchParams.set('height', height.toString());
    searchParams.set('quality', quality.toString());
    searchParams.set('format', format);
    searchParams.set('resize', resize);

    urlObj.search = searchParams.toString();
    return urlObj.toString();
  } catch (error) {
    console.error('Error optimizing image URL:', error);
    return url;
  }
}

/**
 * Get responsive image srcset for different screen sizes
 */
export function getResponsiveImageSrcSet(url: string): string {
  if (!url) return '';

  const sizes = [320, 640, 960, 1280, 1920];
  return sizes
    .map(width => `${getOptimizedImageUrl(url, { width })} ${width}w`)
    .join(', ');
}

/**
 * Compress image before upload (client-side)
 */
export async function compressImage(
  file: File,
  maxSizeMB: number = 2,
  maxWidthOrHeight: number = 1920
): Promise<File> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    
    reader.onload = (e) => {
      const img = new Image();
      
      img.onload = () => {
        const canvas = document.createElement('canvas');
        let width = img.width;
        let height = img.height;

        // Calculate new dimensions
        if (width > height) {
          if (width > maxWidthOrHeight) {
            height = (height * maxWidthOrHeight) / width;
            width = maxWidthOrHeight;
          }
        } else {
          if (height > maxWidthOrHeight) {
            width = (width * maxWidthOrHeight) / height;
            height = maxWidthOrHeight;
          }
        }

        canvas.width = width;
        canvas.height = height;

        const ctx = canvas.getContext('2d');
        if (!ctx) {
          reject(new Error('Could not get canvas context'));
          return;
        }

        ctx.drawImage(img, 0, 0, width, height);

        // Convert to blob
        canvas.toBlob(
          (blob) => {
            if (!blob) {
              reject(new Error('Could not compress image'));
              return;
            }

            // Check if compressed size is acceptable
            const sizeMB = blob.size / 1024 / 1024;
            if (sizeMB > maxSizeMB) {
              // Try with lower quality
              canvas.toBlob(
                (blob) => {
                  if (!blob) {
                    reject(new Error('Could not compress image'));
                    return;
                  }
                  const compressedFile = new File([blob], file.name, {
                    type: 'image/jpeg',
                    lastModified: Date.now(),
                  });
                  resolve(compressedFile);
                },
                'image/jpeg',
                0.7
              );
            } else {
              const compressedFile = new File([blob], file.name, {
                type: 'image/jpeg',
                lastModified: Date.now(),
              });
              resolve(compressedFile);
            }
          },
          'image/jpeg',
          0.9
        );
      };

      img.onerror = () => reject(new Error('Could not load image'));
      img.src = e.target?.result as string;
    };

    reader.onerror = () => reject(new Error('Could not read file'));
    reader.readAsDataURL(file);
  });
}

/**
 * Lazy load image with IntersectionObserver
 */
export function setupLazyLoading() {
  if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const img = entry.target as HTMLImageElement;
          const src = img.dataset.src;
          
          if (src) {
            img.src = src;
            img.removeAttribute('data-src');
            imageObserver.unobserve(img);
          }
        }
      });
    });

    // Observe all images with data-src attribute
    document.querySelectorAll('img[data-src]').forEach((img) => {
      imageObserver.observe(img);
    });

    return imageObserver;
  }

  return null;
}

