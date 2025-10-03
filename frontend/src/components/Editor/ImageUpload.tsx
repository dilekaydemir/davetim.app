import React, { useState, useRef } from 'react';
import { Upload, X, Image as ImageIcon, Loader2 } from 'lucide-react';
import { uploadService } from '../../services/uploadService';
import toast from 'react-hot-toast';

interface ImageUploadProps {
  invitationId: string;
  userId: string;
  currentImageUrl?: string | null;
  onImageUploaded: (imageUrl: string) => void;
  onImageRemoved: () => void;
}

const ImageUpload: React.FC<ImageUploadProps> = ({
  invitationId,
  userId,
  currentImageUrl,
  onImageUploaded,
  onImageRemoved
}) => {
  const [isUploading, setIsUploading] = useState(false);
  const [isDragging, setIsDragging] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileSelect = async (file: File) => {
    if (!file) return;

    setIsUploading(true);
    try {
      // Upload image
      const imageUrl = await uploadService.uploadImage(file, userId, invitationId);
      
      // Update invitation with image URL
      await uploadService.updateInvitationImage(invitationId, imageUrl);
      
      // Notify parent component
      onImageUploaded(imageUrl);
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
      
      // Delete from storage
      await uploadService.deleteImage(currentImageUrl, userId);
      
      // Update invitation
      await uploadService.removeInvitationImage(invitationId);
      
      // Notify parent component
      onImageRemoved();
    } catch (error) {
      console.error('Image removal failed:', error);
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
          onDragOver={handleDragOver}
          onDragLeave={handleDragLeave}
          onDrop={handleDrop}
          onClick={handleClickUpload}
          className={`
            border-2 border-dashed rounded-lg p-8 text-center cursor-pointer transition-all
            ${isDragging 
              ? 'border-primary-500 bg-primary-50' 
              : 'border-gray-300 hover:border-gray-400 bg-gray-50'
            }
            ${isUploading ? 'opacity-50 cursor-not-allowed' : ''}
          `}
        >
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

      <p className="text-xs text-gray-500">
        💡 İpucu: Yüklediğiniz görsel, davetiyenizin başlığının üzerinde görünecektir.
      </p>
    </div>
  );
};

export default ImageUpload;

