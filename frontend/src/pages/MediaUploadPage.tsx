import React, { useState, useEffect } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { Upload, Video, Image as ImageIcon, Loader2, CheckCircle, AlertTriangle, ArrowLeft, Trash2 } from 'lucide-react';
import { mediaService, type Media, type GuestUploadRecord } from '../services/mediaService';
import { supabase } from '../services/supabase';
import { useSubscription } from '../hooks/useSubscription';
import toast from 'react-hot-toast';

const MediaUploadPage: React.FC = () => {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const subscription = useSubscription();
  const invitationId = searchParams.get('invitationId') || undefined;
  
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [preview, setPreview] = useState<string | null>(null);
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [isUploading, setIsUploading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState(0);
  const [canUpload, setCanUpload] = useState(false);
  const [existingMedia, setExistingMedia] = useState<Media | null>(null);
  const [guestUploads, setGuestUploads] = useState<GuestUploadRecord[]>([]);
  const [signedUrls, setSignedUrls] = useState<Record<string, string>>({});

  // Check if user can upload media
  useEffect(() => {
    const checkAccess = async () => {
      const access = await subscription.canUseQRMedia();
      setCanUpload(access.allowed);
    };
    checkAccess();
  }, [subscription]);

  // Load existing QR media and guest uploads
  useEffect(() => {
    const loadExisting = async () => {
      if (!invitationId) return;
      try {
        const media = await mediaService.getMediaByInvitationId(invitationId);
        setExistingMedia(media);
        if (media?.qr_code) {
          const uploads = await mediaService.getGuestUploads(media.qr_code);
          setGuestUploads(uploads);
          
          // Generate signed URLs
          const urlMap: Record<string, string> = {};
          
          // Host media signed URL
          if (media.storage_path) {
            const { data: signed } = await supabase.storage
              .from('qr-media')
              .createSignedUrl(media.storage_path, 60 * 60);
            if (signed?.signedUrl) {
              urlMap[media.id] = signed.signedUrl;
            }
          }
          
          // Guest uploads signed URLs
          for (const upload of uploads) {
            if (upload.storage_path) {
              const { data: signed } = await supabase.storage
                .from('qr-media')
                .createSignedUrl(upload.storage_path, 60 * 60);
              if (signed?.signedUrl) {
                urlMap[upload.id] = signed.signedUrl;
              }
            }
          }
          
          setSignedUrls(urlMap);
        }
      } catch {}
    };
    loadExisting();
  }, [invitationId]);

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Validate
    const validation = mediaService.validateMediaFile(file);
    if (!validation.valid) {
      toast.error(validation.error!);
      return;
    }

    setSelectedFile(file);
    
    // Auto-fill title from filename
    if (!title) {
      const nameWithoutExt = file.name.replace(/\.[^/.]+$/, '');
      setTitle(nameWithoutExt);
    }

    // Create preview
    const reader = new FileReader();
    reader.onloadend = () => {
      setPreview(reader.result as string);
    };
    reader.readAsDataURL(file);
  };

  const handleDrop = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    const file = e.dataTransfer.files[0];
    if (file) {
      // Simulate file input
      const input = document.createElement('input');
      input.type = 'file';
      const dataTransfer = new DataTransfer();
      dataTransfer.items.add(file);
      input.files = dataTransfer.files;
      
      handleFileSelect({ target: input } as any);
    }
  };

  const handleDragOver = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
  };

  const handleUpload = async () => {
    if (!selectedFile) {
      toast.error('Lütfen bir dosya seçin');
      return;
    }

    if (!title.trim()) {
      toast.error('Lütfen bir başlık girin');
      return;
    }

    setIsUploading(true);
    setUploadProgress(10);

    try {
      // Simulate progress
      const progressInterval = setInterval(() => {
        setUploadProgress(prev => Math.min(prev + 10, 90));
      }, 200);

      const media = await mediaService.createMedia({
        file: selectedFile,
        title: title.trim(),
        description: description.trim() || undefined,
        invitation_id: invitationId,
      });

      clearInterval(progressInterval);
      setUploadProgress(100);

      // Show success and redirect
      toast.success('Medya başarıyla yüklendi!');
      
      setTimeout(() => {
        navigate(invitationId ? `/editor/${invitationId}` : '/media');
      }, 1000);
    } catch (error) {
      console.error('Upload error:', error);
      setUploadProgress(0);
    } finally {
      setIsUploading(false);
    }
  };

  const formatFileSize = (bytes: number): string => {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return `${parseFloat((bytes / Math.pow(k, i)).toFixed(2))} ${sizes[i]}`;
  };

  if (!canUpload) {
    return (
      <div className="min-h-screen bg-gray-50 py-8">
        <div className="max-w-4xl mx-auto px-4">
          <div className="bg-white rounded-xl shadow-sm p-12 text-center">
            <div className="bg-purple-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6">
              <Video className="h-10 w-10 text-purple-600" />
            </div>
            <h1 className="text-3xl font-bold text-gray-900 mb-4">
              QR Medya - Premium Özelliği
            </h1>
            <p className="text-gray-600 mb-8 max-w-lg mx-auto">
              Video ve fotoğraflarınızı QR kod ile paylaşmak için Premium plana yükseltin.
            </p>
            <button
              onClick={() => navigate('/pricing')}
              className="btn-primary bg-gradient-to-r from-purple-600 to-pink-600"
            >
              Premium'a Geç
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-4xl mx-auto px-4">
        {/* Header */}
        <div className="mb-8">
          <button
            onClick={() => navigate(invitationId ? `/editor/${invitationId}` : '/media')}
            className="flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-4"
          >
            <ArrowLeft className="h-5 w-5" />
            Geri Dön
          </button>
          <h1 className="text-3xl font-bold text-gray-900">
            {existingMedia ? 'QR Medya Güncelle' : 'Yeni Medya Yükle'}
          </h1>
          <p className="text-gray-600 mt-2">
            {existingMedia 
              ? 'Mevcut QR kodunuza yeni medya ekleyin' 
              : 'Video veya fotoğraf yükleyin ve QR kod ile paylaşın'}
          </p>
        </div>

        {/* Existing Media Info */}
        {existingMedia && (
          <div className="bg-blue-50 border border-blue-200 rounded-xl p-6 mb-8">
            <div className="flex items-start justify-between">
              <div className="flex-1">
                <h3 className="font-semibold text-blue-900 mb-2">Mevcut QR Medya</h3>
                <p className="text-sm text-blue-800 mb-2">
                  QR Kod: <span className="font-mono">{existingMedia.qr_code}</span>
                </p>
                <p className="text-sm text-blue-800">
                  Davetli yüklemeleri: {guestUploads.length} adet
                </p>
              </div>
              {existingMedia.qr_image_url && (
                <img src={existingMedia.qr_image_url} alt="QR" className="w-20 h-20" />
              )}
            </div>
          </div>
        )}

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Left: Upload Area */}
          <div className="space-y-6">
            {/* File Upload */}
            <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
              <h2 className="text-lg font-semibold text-gray-900 mb-4">Dosya Seç</h2>
              
              {!selectedFile ? (
                <div
                  onDrop={handleDrop}
                  onDragOver={handleDragOver}
                  className="border-2 border-dashed border-gray-300 rounded-lg p-12 text-center hover:border-primary-500 transition-colors cursor-pointer"
                >
                  <input
                    type="file"
                    id="media-file"
                    accept="video/mp4,video/quicktime,video/webm,image/jpeg,image/png,image/webp,image/gif"
                    onChange={handleFileSelect}
                    className="hidden"
                  />
                  <label htmlFor="media-file" className="cursor-pointer">
                    <Upload className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                    <p className="text-lg font-medium text-gray-900 mb-2">
                      Dosya yükle veya sürükle-bırak
                    </p>
                    <p className="text-sm text-gray-600 mb-4">
                      Video: MP4, MOV, WebM (max 100MB)<br />
                      Görsel: JPG, PNG, WEBP, GIF (max 10MB)
                    </p>
                    <span className="btn-primary inline-block">
                      Dosya Seç
                    </span>
                  </label>
                </div>
              ) : (
                <div className="space-y-4">
                  {/* Preview */}
                  <div className="relative aspect-video bg-gray-100 rounded-lg overflow-hidden">
                    {selectedFile.type.startsWith('video/') ? (
                      <video
                        src={preview || ''}
                        controls
                        className="w-full h-full object-cover"
                      />
                    ) : (
                      <img
                        src={preview || ''}
                        alt="Preview"
                        className="w-full h-full object-cover"
                      />
                    )}
                  </div>

                  {/* File Info */}
                  <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                    <div className="flex items-center gap-3">
                      {selectedFile.type.startsWith('video/') ? (
                        <Video className="h-8 w-8 text-blue-600" />
                      ) : (
                        <ImageIcon className="h-8 w-8 text-green-600" />
                      )}
                      <div>
                        <p className="font-medium text-gray-900">{selectedFile.name}</p>
                        <p className="text-sm text-gray-600">{formatFileSize(selectedFile.size)}</p>
                      </div>
                    </div>
                    <button
                      onClick={() => {
                        setSelectedFile(null);
                        setPreview(null);
                      }}
                      className="text-red-600 hover:text-red-700"
                    >
                      Kaldır
                    </button>
                  </div>
                </div>
              )}
            </div>

            {/* Details Form */}
            {selectedFile && (
              <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
                <h2 className="text-lg font-semibold text-gray-900 mb-4">Detaylar</h2>
                
                <div className="space-y-4">
                  {/* Title */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Başlık *
                    </label>
                    <input
                      type="text"
                      value={title}
                      onChange={(e) => setTitle(e.target.value)}
                      placeholder="Örn: Düğün Davetiyesi Videosu"
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      maxLength={255}
                    />
                  </div>

                  {/* Description */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Açıklama (Opsiyonel)
                    </label>
                    <textarea
                      value={description}
                      onChange={(e) => setDescription(e.target.value)}
                      placeholder="Medya hakkında kısa bir açıklama..."
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      rows={3}
                      maxLength={500}
                    />
                    <p className="text-xs text-gray-500 mt-1">
                      {description.length}/500 karakter
                    </p>
                  </div>

                  {/* Storage Plan removed: determined automatically by subscription */}
                </div>
              </div>
            )}
          </div>

          {/* Right: Info & Actions */}
          <div className="space-y-6">
            {/* Info Card */}
            <div className="bg-blue-50 rounded-xl p-6 border border-blue-100">
              <div className="flex items-start gap-3">
                <CheckCircle className="h-6 w-6 text-blue-600 flex-shrink-0 mt-1" />
                <div>
                  <h3 className="font-semibold text-blue-900 mb-2">QR Medya Nasıl Çalışır?</h3>
                  <ul className="space-y-2 text-sm text-blue-800">
                    <li>✓ Video veya fotoğraf yükleyin</li>
                    <li>✓ Benzersiz QR kod oluşturulur</li>
                    <li>✓ QR kodu davetiyenize ekleyin</li>
                    <li>✓ Misafirler QR'ı tarayarak medyayı görüntüler</li>
                    <li>✓ Saklama süresi planınıza göre otomatik belirlenir</li>
                  </ul>
                </div>
              </div>
            </div>

            {/* Upload Button */}
            {selectedFile && (
              <div className="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
                <button
                  onClick={handleUpload}
                  disabled={isUploading || !title.trim()}
                  className="w-full btn-primary flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {isUploading ? (
                    <>
                      <Loader2 className="h-5 w-5 animate-spin" />
                      Yükleniyor... {uploadProgress}%
                    </>
                  ) : (
                    <>
                      <Upload className="h-5 w-5" />
                      Medyayı Yükle ve QR Oluştur
                    </>
                  )}
                </button>

                {/* Progress Bar */}
                {isUploading && (
                  <div className="mt-4">
                    <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                      <div
                        className="h-full bg-primary-600 transition-all duration-300"
                        style={{ width: `${uploadProgress}%` }}
                      />
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* Warnings */}
            <div className="bg-yellow-50 rounded-xl p-6 border border-yellow-100">
              <div className="flex items-start gap-3">
                <AlertTriangle className="h-6 w-6 text-yellow-600 flex-shrink-0 mt-1" />
                <div>
                  <h3 className="font-semibold text-yellow-900 mb-2">Önemli Notlar</h3>
                  <ul className="space-y-2 text-sm text-yellow-800">
                    <li>• Medya, planınıza bağlı sürede otomatik silinir</li>
                    <li>• QR kod sildikten sonra çalışmaz</li>
                    <li>• Video kalitesi optimize edilebilir</li>
                    <li>• Telif haklı içerik yüklemeyiniz</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MediaUploadPage;

