import React, { useState, useRef } from 'react';
import { Upload, X, Image as ImageIcon, Loader2, Lock } from 'lucide-react';
import { uploadService } from '../../services/uploadService';
import { useSubscription } from '../../hooks/useSubscription';
import toast from 'react-hot-toast';

interface ImageUploadProps {
  invitationId: string;
  userId: string;
  currentImageUrl?: string | null;
  currentPosition?: 'profile' | 'background' | 'banner' | 'watermark';
  onImageUploaded: (imageUrl: string) => void;
  onImageRemoved: () => void;
  onPositionChange?: (position: 'profile' | 'background' | 'banner' | 'watermark') => void;
}

const ImageUpload: React.FC<ImageUploadProps> = ({
  invitationId,
  userId,
  currentImageUrl,
  currentPosition = 'profile',
  onImageUploaded,
  onImageRemoved,
  onPositionChange
}) => {
  const subscription = useSubscription();
  const [isUploading, setIsUploading] = useState(false);
  const [isDragging, setIsDragging] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  
  // Plan kontrolü - görsel yükleme izni var mı?
  const canUpload = subscription.planConfig?.limits.imageUpload || false;

  const handleFileSelect = async (file: File) => {
    if (!file) return;
    
    // Size kontrolü (max 5MB per file)
    const maxSize = 5 * 1024 * 1024; // 5MB
    if (file.size > maxSize) {
      toast.error('Dosya boyutu 5MB\'dan küçük olmalıdır');
      return;
    }
    
    // Plan kontrolü - Genel upload yetkisi
    const access = await subscription.canUploadImage();
    if (!access.allowed) {
      toast.error(access.reason || 'Görsel yükleme için PRO plana yükseltin!');
      return;
    }

    // Storage limiti kontrolü
    const fileSizeMB = file.size / (1024 * 1024); // Convert to MB
    const storageCheck = await subscription.canUploadImageWithSize(fileSizeMB);
    if (!storageCheck.allowed) {
      toast.error(storageCheck.reason || 'Yetersiz depolama alanı!');
      return;
    }

    setIsUploading(true);
    try {
      // Upload image
      const imageUrl = await uploadService.uploadImage(file, userId, invitationId);
      
      // Update invitation with image URL
      await uploadService.updateInvitationImage(invitationId, imageUrl);
      
      // Notify parent component
      onImageUploaded(imageUrl);
      
      // Refresh subscription to update storage usage
      await subscription.refreshSubscription();
    } catch (error) {
      console.error('Image upload failed:', error);
    } finally {
      setIsUploading(false);
    }
  };

  const handleFileInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      handleFileSelect(file);
    }
  };

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);

    const file = e.dataTransfer.files?.[0];
    if (file && file.type.startsWith('image/')) {
      handleFileSelect(file);
    } else {
      toast.error('Lütfen bir görsel dosyası seçin');
    }
  };

  const handleRemoveImage = async () => {
    if (!currentImageUrl) return;

    try {
      setIsUploading(true);
      
      // Check if this is an external image (e.g. from Unsplash, template default)
      const isExternalImage = currentImageUrl.includes('unsplash.com') || 
                              !currentImageUrl.includes('supabase');
      
      if (!isExternalImage) {
        // Only delete from storage if it's our uploaded image
        await uploadService.deleteImage(currentImageUrl, userId);
      }
      
      // Always update invitation to remove image reference
      await uploadService.removeInvitationImage(invitationId);
      
      // Notify parent component
      onImageRemoved();
      
      toast.success('Görsel kaldırıldı');
    } catch (error) {
      console.error('Image removal failed:', error);
      toast.error('Görsel kaldırılırken hata oluştu');
    } finally {
      setIsUploading(false);
    }
  };

  const handleClickUpload = () => {
    fileInputRef.current?.click();
  };

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <label className="block text-sm font-medium text-gray-700">
          Davetiye Görseli
        </label>
        <span className="text-xs text-gray-500">
          JPG, PNG, WebP, GIF (Max 5MB)
        </span>
      </div>

      {currentImageUrl ? (
        // Show current image with remove option
        <div className="relative group">
          <img
            src={currentImageUrl}
            alt="Davetiye görseli"
            className="w-full h-48 object-cover rounded-lg border-2 border-gray-200"
          />
          <div className="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-40 transition-all rounded-lg flex items-center justify-center">
            <button
              onClick={handleRemoveImage}
              disabled={isUploading}
              className="opacity-0 group-hover:opacity-100 transition-opacity bg-red-500 hover:bg-red-600 text-white rounded-lg px-4 py-2 flex items-center gap-2 disabled:opacity-50"
            >
              {isUploading ? (
                <>
                  <Loader2 className="h-4 w-4 animate-spin" />
                  Siliniyor...
                </>
              ) : (
                <>
                  <X className="h-4 w-4" />
                  Görseli Kaldır
                </>
              )}
            </button>
          </div>
        </div>
      ) : (
        // Show upload area
        <div
          onDragOver={canUpload ? handleDragOver : undefined}
          onDragLeave={canUpload ? handleDragLeave : undefined}
          onDrop={canUpload ? handleDrop : undefined}
          onClick={canUpload ? handleClickUpload : undefined}
          className={`
            relative border-2 border-dashed rounded-lg p-8 text-center transition-all
            ${!canUpload ? 'cursor-not-allowed opacity-60' : 'cursor-pointer'}
            ${isDragging 
              ? 'border-primary-500 bg-primary-50' 
              : 'border-gray-300 hover:border-gray-400 bg-gray-50'
            }
            ${isUploading ? 'opacity-50 cursor-not-allowed' : ''}
          `}
        >
          {!canUpload && (
            <div className="absolute inset-0 flex flex-col items-center justify-center bg-gray-100 bg-opacity-90 rounded-lg z-10">
              <Lock className="h-8 w-8 text-gray-400 mb-2" />
              <div className="text-sm font-medium text-gray-600">PRO Özelliği</div>
              <div className="text-xs text-gray-500">Görsel yüklemek için yükseltin</div>
            </div>
          )}
          <input
            ref={fileInputRef}
            type="file"
            accept="image/jpeg,image/png,image/webp,image/gif"
            onChange={handleFileInputChange}
            className="hidden"
            disabled={isUploading}
          />

          {isUploading ? (
            <div className="flex flex-col items-center gap-3">
              <Loader2 className="h-12 w-12 text-primary-500 animate-spin" />
              <p className="text-sm text-gray-600">Görsel yükleniyor...</p>
            </div>
          ) : (
            <div className="flex flex-col items-center gap-3">
              {isDragging ? (
                <Upload className="h-12 w-12 text-primary-500" />
              ) : (
                <ImageIcon className="h-12 w-12 text-gray-400" />
              )}
              <div>
                <p className="text-sm font-medium text-gray-700">
                  Görsel yüklemek için tıklayın veya sürükleyin
                </p>
                <p className="text-xs text-gray-500 mt-1">
                  Davetiyenizde görüntülenecek fotoğraf veya logo
                </p>
              </div>
            </div>
          )}
        </div>
      )}

      {/* Image Position Selector - only show if image exists */}
      {currentImageUrl && onPositionChange && (
        <div className="space-y-2">
          <label className="block text-sm font-medium text-gray-700">
            Görsel Konumu
          </label>
          <div className="grid grid-cols-2 gap-2">
            <button
              type="button"
              onClick={() => onPositionChange('profile')}
              className={`p-3 rounded-lg border-2 text-sm transition-all ${
                currentPosition === 'profile'
                  ? 'border-primary-500 bg-primary-50 text-primary-700'
                  : 'border-gray-200 hover:border-primary-200'
              }`}
            >
              <div className="font-semibold">👤 Profil</div>
              <div className="text-xs text-gray-500">Yuvarlak, orta üstte</div>
            </button>
            
            <button
              type="button"
              onClick={() => onPositionChange('background')}
              className={`p-3 rounded-lg border-2 text-sm transition-all ${
                currentPosition === 'background'
                  ? 'border-primary-500 bg-primary-50 text-primary-700'
                  : 'border-gray-200 hover:border-primary-200'
              }`}
            >
              <div className="font-semibold">🖼️ Arka Plan</div>
              <div className="text-xs text-gray-500">Tüm davetiyeyi kaplar</div>
            </button>
            
            <button
              type="button"
              onClick={() => onPositionChange('banner')}
              className={`p-3 rounded-lg border-2 text-sm transition-all ${
                currentPosition === 'banner'
                  ? 'border-primary-500 bg-primary-50 text-primary-700'
                  : 'border-gray-200 hover:border-primary-200'
              }`}
            >
              <div className="font-semibold">📋 Üst Banner</div>
              <div className="text-xs text-gray-500">Üstte dikdörtgen</div>
            </button>
            
            <button
              type="button"
              onClick={() => onPositionChange('watermark')}
              className={`p-3 rounded-lg border-2 text-sm transition-all ${
                currentPosition === 'watermark'
                  ? 'border-primary-500 bg-primary-50 text-primary-700'
                  : 'border-gray-200 hover:border-primary-200'
              }`}
            >
              <div className="font-semibold">💧 Logo/Filigran</div>
              <div className="text-xs text-gray-500">Sağ alt köşede</div>
            </button>
          </div>
        </div>
      )}

      <p className="text-xs text-gray-500">
        💡 İpucu: Görsel konumunu değiştirerek farklı görünümler oluşturabilirsiniz.
      </p>
    </div>
  );
};

export default ImageUpload;

