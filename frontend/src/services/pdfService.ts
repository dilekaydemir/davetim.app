import html2canvas from 'html2canvas';
import jsPDF from 'jspdf';
import toast from 'react-hot-toast';

export interface PDFExportOptions {
  filename?: string;
  quality?: number;
  orientation?: 'portrait' | 'landscape';
  format?: 'a4' | 'letter';
}

class PDFService {
  /**
   * PROFESSIONAL QUALITY EXPORT
   * This method ensures maximum quality for paid users
   */
  private async createHighQualityCanvas(element: HTMLElement, scale: number = 4): Promise<HTMLCanvasElement> {
    // Create a high-quality clone
    const clone = element.cloneNode(true) as HTMLElement;
    
    // Ensure all images are loaded with crossOrigin
    const images = clone.querySelectorAll('img');
    const imagePromises: Promise<void>[] = [];
    
    images.forEach((img) => {
      if (!img.complete) {
        imagePromises.push(
          new Promise((resolve) => {
            img.onload = () => resolve();
            img.onerror = () => resolve(); // Continue even if image fails
          })
        );
      }
      
      // Set crossOrigin for CORS
      img.crossOrigin = 'anonymous';
      
      // Force image reload if needed
      const src = img.src;
      img.src = '';
      img.src = src;
    });
    
    // Wait for all images to load
    await Promise.all(imagePromises);
    
    // Position clone off-screen but in DOM for accurate rendering
    clone.style.position = 'fixed';
    clone.style.left = '-99999px';
    clone.style.top = '0';
    clone.style.width = `${element.offsetWidth}px`;
    clone.style.height = `${element.offsetHeight}px`;
    clone.style.overflow = 'visible';
    clone.style.transform = 'none';
    
    // Add to DOM
    document.body.appendChild(clone);
    
    // Force reflow to ensure all styles are computed
    clone.offsetHeight;
    
    // Wait for fonts and layout
    await document.fonts.ready;
    await new Promise(resolve => setTimeout(resolve, 800));
    
    try {
      // ULTRA HIGH QUALITY SETTINGS
      const canvas = await html2canvas(clone, {
        // QUALITY SETTINGS
        scale: scale,                    // 4x scale for ultra quality
        useCORS: true,                   // Enable CORS for images
        allowTaint: false,               // Strict CORS mode
        logging: false,                  // Disable console logs
        
        // BACKGROUND
        backgroundColor: '#ffffff',      // White background
        
        // DIMENSIONS - Exact match
        windowWidth: element.offsetWidth,
        windowHeight: element.offsetHeight,
        width: element.offsetWidth,
        height: element.offsetHeight,
        
        // POSITIONING
        x: 0,
        y: 0,
        scrollX: 0,
        scrollY: 0,
        
        // IMAGE QUALITY
        imageTimeout: 30000,             // 30 seconds for images
        
        // RENDERING OPTIONS
        foreignObjectRendering: false,   // Use native rendering
        removeContainer: false,          // Keep container for debugging
        
        // CANVAS OPTIONS
        canvas: undefined,               // Let html2canvas create canvas
        
        // CALLBACK for additional processing
        onclone: (clonedDoc, clonedElement) => {
          // Apply additional fixes to cloned element
          const allElements = clonedElement.querySelectorAll('*');
          
          allElements.forEach((el) => {
            const htmlEl = el as HTMLElement;
            const computedStyle = window.getComputedStyle(el);
            
            // Fix positioned elements
            if (computedStyle.position === 'absolute' || computedStyle.position === 'fixed') {
              // Get actual position
              const rect = el.getBoundingClientRect();
              const parentRect = clonedElement.getBoundingClientRect();
              
              htmlEl.style.position = 'absolute';
              htmlEl.style.left = `${rect.left - parentRect.left}px`;
              htmlEl.style.top = `${rect.top - parentRect.top}px`;
              htmlEl.style.transform = 'none';
              htmlEl.style.margin = '0';
            }
            
            // Ensure images have proper sizing
            if (el.tagName === 'IMG') {
              const img = el as HTMLImageElement;
              img.style.maxWidth = '100%';
              img.style.height = 'auto';
              img.style.imageRendering = 'high-quality';
              img.style.imageRendering = '-webkit-optimize-contrast';
            }
            
            // Fix text rendering
            if (el.textContent && el.textContent.trim()) {
              htmlEl.style.webkitFontSmoothing = 'antialiased';
              htmlEl.style.textRendering = 'optimizeLegibility';
            }
            
            // Preserve z-index
            const zIndex = computedStyle.zIndex;
            if (zIndex && zIndex !== 'auto') {
              htmlEl.style.zIndex = zIndex;
            }
          });
          
          // Fix root element
          clonedElement.style.position = 'relative';
          clonedElement.style.left = '0';
          clonedElement.style.transform = 'none';
        }
      });
      
      return canvas;
    } finally {
      // Always cleanup
      document.body.removeChild(clone);
    }
  }

  /**
   * Export HTML element to HIGH QUALITY PDF
   * @param element - HTML element to convert
   * @param options - PDF export options
   */
  async exportToPDF(element: HTMLElement, options: PDFExportOptions = {}): Promise<Blob | null> {
    const {
      quality = 4, // ULTRA HIGH QUALITY (4x)
      orientation = 'portrait',
      format = 'a4'
    } = options;

    try {
      console.log('📄 Starting PROFESSIONAL PDF generation...');
      toast.loading('Yüksek kaliteli PDF oluşturuluyor...', { id: 'pdf-export' });

      // Create ultra high quality canvas
      const canvas = await this.createHighQualityCanvas(element, quality);

      console.log('✅ Ultra quality canvas created:', canvas.width, 'x', canvas.height);

      // Convert canvas to high quality PNG data
      const imgData = canvas.toDataURL('image/png', 1.0);

      // Calculate PDF dimensions (A4: 210x297mm)
      const pdfWidth = orientation === 'portrait' ? 210 : 297;
      const pdfHeight = orientation === 'portrait' ? 297 : 210;
      
      // Calculate aspect ratio
      const canvasAspectRatio = canvas.width / canvas.height;
      const pdfAspectRatio = pdfWidth / pdfHeight;
      
      let imgWidth, imgHeight, x, y;
      
      if (canvasAspectRatio > pdfAspectRatio) {
        // Canvas is wider - fit to width
        imgWidth = pdfWidth;
        imgHeight = pdfWidth / canvasAspectRatio;
        x = 0;
        y = (pdfHeight - imgHeight) / 2;
      } else {
        // Canvas is taller - fit to height
        imgHeight = pdfHeight;
        imgWidth = pdfHeight * canvasAspectRatio;
        x = (pdfWidth - imgWidth) / 2;
        y = 0;
      }

      // Create PDF with maximum quality settings
      const pdf = new jsPDF({
        orientation,
        unit: 'mm',
        format,
        compress: false, // NO COMPRESSION for maximum quality
        precision: 16,   // Maximum precision
        userUnit: 1.0
      });

      // Add image with MAXIMUM quality (PNG, no compression)
      pdf.addImage(
        imgData,
        'PNG',           // PNG format for best quality
        x,
        y,
        imgWidth,
        imgHeight,
        undefined,
        'NONE'          // NO COMPRESSION
      );

      // Get PDF as blob
      const pdfBlob = pdf.output('blob');

      console.log('✅ PROFESSIONAL PDF generated:', pdfBlob.size, 'bytes');
      toast.success('Yüksek kaliteli PDF hazır!', { id: 'pdf-export' });

      return pdfBlob;
    } catch (error: any) {
      console.error('❌ PDF generation error:', error);
      toast.error('PDF oluşturulurken bir hata oluştu', { id: 'pdf-export' });
      return null;
    }
  }

  /**
   * Download PDF file
   * @param blob - PDF blob
   * @param filename - Download filename
   */
  downloadPDF(blob: Blob, filename: string = 'davetiye.pdf') {
    try {
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = filename;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);
      
      console.log('✅ PDF downloaded:', filename);
      toast.success('PDF indirildi!');
    } catch (error) {
      console.error('❌ PDF download error:', error);
      toast.error('PDF indirme hatası');
    }
  }

  /**
   * Export and download PDF in one step
   * @param element - HTML element to convert
   * @param options - PDF export options
   */
  async exportAndDownload(element: HTMLElement, options: PDFExportOptions = {}): Promise<void> {
    const blob = await this.exportToPDF(element, options);
    if (blob) {
      this.downloadPDF(blob, options.filename || 'davetiye.pdf');
    }
  }

  /**
   * Generate ULTRA HIGH QUALITY shareable image
   * @param element - HTML element to convert
   * @param quality - Image quality (4-6 for professional use)
   */
  async exportToImage(element: HTMLElement, quality: number = 5): Promise<Blob | null> {
    try {
      console.log('🖼️ Generating PROFESSIONAL quality image...');
      toast.loading('Yüksek kaliteli görsel oluşturuluyor...', { id: 'image-export' });

      // Create ultra high quality canvas (5x scale for images)
      const canvas = await this.createHighQualityCanvas(element, quality);

      console.log('✅ Ultra quality canvas created:', canvas.width, 'x', canvas.height);

      // Convert to blob with MAXIMUM quality
      const blob = await new Promise<Blob | null>((resolve) => {
        canvas.toBlob(
          (blob) => resolve(blob),
          'image/png',  // PNG for maximum quality
          1.0           // Maximum quality (no compression)
        );
      });

      if (blob) {
        console.log('✅ PROFESSIONAL image generated:', blob.size, 'bytes');
        toast.success('Yüksek kaliteli görsel hazır!', { id: 'image-export' });
      }

      return blob;
    } catch (error: any) {
      console.error('❌ Image generation error:', error);
      toast.error('Görsel oluşturulurken bir hata oluştu', { id: 'image-export' });
      return null;
    }
  }

  /**
   * Download image file
   * @param blob - Image blob
   * @param filename - Download filename
   */
  downloadImage(blob: Blob, filename: string = 'davetiye.png') {
    try {
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = filename;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);
      
      console.log('✅ Image downloaded:', filename);
      toast.success('Görsel indirildi!');
    } catch (error) {
      console.error('❌ Image download error:', error);
      toast.error('Görsel indirme hatası');
    }
  }

  /**
   * Copy share link to clipboard
   * @param invitationId - Invitation ID
   */
  copyShareLink(invitationId: string): void {
    const shareUrl = `${window.location.origin}/i/${invitationId}`;
    
    navigator.clipboard.writeText(shareUrl)
      .then(() => {
        console.log('✅ Share link copied:', shareUrl);
        toast.success('Link kopyalandı!');
      })
      .catch((error) => {
        console.error('❌ Copy error:', error);
        toast.error('Link kopyalanamadı');
      });
  }

  /**
   * Share via Web Share API (mobile)
   * @param title - Share title
   * @param text - Share text
   * @param url - Share URL
   */
  async share(title: string, text: string, url: string): Promise<void> {
    if (navigator.share) {
      try {
        await navigator.share({
          title,
          text,
          url
        });
        console.log('✅ Shared successfully');
      } catch (error) {
        console.error('❌ Share error:', error);
      }
    } else {
      // Fallback: copy to clipboard
      navigator.clipboard.writeText(url)
        .then(() => toast.success('Link kopyalandı!'))
        .catch(() => toast.error('Paylaşım desteklenmiyor'));
    }
  }
}

export const pdfService = new PDFService();
