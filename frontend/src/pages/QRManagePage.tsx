import React, { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { mediaService, type Media, type GuestUploadRecord } from '../services/mediaService';
import { supabase } from '../services/supabase';
import { Loader2, QrCode, Download, Video, Image as ImageIcon, Trash2, User, Eye, Calendar, HardDrive, Play, Pause, Plus, Upload, X, Maximize2, MoreVertical, Edit3 } from 'lucide-react';
import toast from 'react-hot-toast';

const QRManagePage: React.FC = () => {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const invitationId = searchParams.get('invitationId');

  const [loading, setLoading] = useState(true);
  const [media, setMedia] = useState<Media | null>(null);
  const [allowGuest, setAllowGuest] = useState(false);
  const [guestUploads, setGuestUploads] = useState<GuestUploadRecord[]>([]);
  const [signedUrls, setSignedUrls] = useState<Record<string, string>>({});
  const [playingVideo, setPlayingVideo] = useState<string | null>(null);
  const [uploading, setUploading] = useState(false);
  const [selectedMedia, setSelectedMedia] = useState<{url: string, type: 'video' | 'image', title: string} | null>(null);
  const [deleteDialog, setDeleteDialog] = useState<{type: 'guest', id: string, title: string} | null>(null);
  const [deleting, setDeleting] = useState(false);

  // Helper functions
  const formatFileSize = (bytes: number): string => {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  const formatDate = (dateString: string): string => {
    return new Date(dateString).toLocaleDateString('tr-TR');
  };

  const toggleVideoPlay = (videoId: string) => {
    setPlayingVideo(playingVideo === videoId ? null : videoId);
  };

  const handleToggleGuest = async () => {
    if (!media) return;
    
    try {
      await mediaService.updateMedia(media.id, { allow_guest_upload: !allowGuest });
      setAllowGuest(!allowGuest);
      toast.success(allowGuest ? 'Davetli yüklemeleri kapatıldı' : 'Davetli yüklemeleri açıldı');
    } catch (error) {
      toast.error('Ayarlar güncellenemedi');
    }
  };

  const handleDownload = async (url: string, filename: string) => {
    try {
      const response = await fetch(url);
      const blob = await response.blob();
      const downloadUrl = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = downloadUrl;
      link.download = filename;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      window.URL.revokeObjectURL(downloadUrl);
    } catch (error) {
      toast.error('Dosya indirilemedi');
    }
  };

  const handleMediaClick = (url: string, type: 'video' | 'image', title: string) => {
    setSelectedMedia({ url, type, title });
  };

  const handleDeleteMedia = async () => {
    if (!deleteDialog || !media) return;
    
    setDeleting(true);
    try {
      if (deleteDialog.type === 'guest') {
        // Guest upload'ı sil
        await mediaService.deleteGuestUpload(deleteDialog.id);
        setGuestUploads(prev => prev.filter(upload => upload.id !== deleteDialog.id));
        toast.success('Medya silindi');
        
        // Guest uploads count'u güncelle
        if (media) {
          setMedia(prev => prev ? {
            ...prev,
            guest_uploads_count: (prev.guest_uploads_count || 0) - 1
          } : null);
        }
      }
      setDeleteDialog(null);
    } catch (error) {
      toast.error('Silme işlemi başarısız');
    } finally {
      setDeleting(false);
    }
  };

  useEffect(() => {
    const load = async () => {
      try {
        if (!invitationId) {
          toast.error('Davetiye ID bulunamadı');
          navigate('/media');
          return;
        }

        const mediaData = await mediaService.getMediaByInvitationId(invitationId);
        if (!mediaData) {
          toast.error('QR medya bulunamadı');
          navigate('/media');
          return;
        }

        setMedia(mediaData);
        setAllowGuest(mediaData.allow_guest_upload || false);

        // Guest uploads'ları yükle
        const guestUploadsData = await mediaService.getGuestUploads(mediaData.qr_code);
        setGuestUploads(guestUploadsData);

        // Signed URLs oluştur
        const urls: Record<string, string> = {};
        
        // Ana medya için signed URL
        if (mediaData.storage_path) {
          const signedUrl = await mediaService.generateSignedUrl(mediaData.storage_path);
          urls[mediaData.id] = signedUrl;
        }

        // Guest uploads için signed URLs
        for (const upload of guestUploadsData) {
          if (upload.storage_path) {
            const signedUrl = await mediaService.generateSignedUrl(upload.storage_path);
            urls[upload.id] = signedUrl;
          }
        }

        setSignedUrls(urls);
      } catch (error) {
        console.error('Load error:', error);
        toast.error('Veriler yüklenemedi');
      } finally {
        setLoading(false);
      }
    };

    load();
  }, [invitationId, navigate]);

  const handleAdditionalUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file || !media) return;

    setUploading(true);
    try {
      const result = await mediaService.uploadAdditionalMedia(media.invitation_id!, file);
      setGuestUploads(prev => [...prev, result]);
      
      // Signed URL oluştur
      if (result.storage_path) {
        const signedUrl = await mediaService.generateSignedUrl(result.storage_path);
        setSignedUrls(prev => ({ ...prev, [result.id]: signedUrl }));
      }
      
      // Guest uploads count'u güncelle
      setMedia(prev => prev ? {
        ...prev,
        guest_uploads_count: (prev.guest_uploads_count || 0) + 1
      } : null);
    } catch (error) {
      console.error('Upload error:', error);
    } finally {
      setUploading(false);
      e.target.value = ''; // Reset input
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-primary-500" />
      </div>
    );
  }

  if (!media) {
    return (
      <div className="min-h-screen flex items-center justify-center p-6">
        <div className="text-center">
          <p className="text-gray-700 mb-4">Bu davetiye için QR oluşturulmamış.</p>
          <button onClick={() => navigate(`/media/upload?invitationId=${invitationId}`)} className="btn-primary">QR Oluştur</button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-gray-100">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 sticky top-0 z-40 backdrop-blur-sm bg-white/90">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center gap-3">
              <button 
                onClick={() => navigate(-1)}
                className="p-2 rounded-lg hover:bg-gray-100 transition-colors"
              >
                <X className="h-5 w-5" />
              </button>
              <div className="flex items-center gap-2">
                <QrCode className="h-6 w-6 text-primary-600" />
                <h1 className="text-xl font-bold text-gray-900">QR Medya Galerisi</h1>
              </div>
            </div>
            <div className="flex items-center gap-3">
              {media.qr_image_url && (
                <button
                  onClick={() => handleDownload(media.qr_image_url, `qr-${media.qr_code}.png`)}
                  className="btn-outline flex items-center gap-2"
                >
                  <Download className="h-4 w-4" />
                  QR İndir
                </button>
              )}
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Info Card */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 mb-8">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <div className="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-4">
              <div className="flex items-center gap-2 mb-2">
                <QrCode className="h-4 w-4 text-blue-600" />
                <span className="text-sm font-medium text-blue-900">QR Kod</span>
              </div>
              <p className="font-mono text-xs text-blue-700 break-all">{media.qr_code}</p>
            </div>
            
            <div className="bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-4">
              <div className="flex items-center gap-2 mb-2">
                <Eye className="h-4 w-4 text-green-600" />
                <span className="text-sm font-medium text-green-900">Görüntülenme</span>
              </div>
              <p className="text-lg font-bold text-green-700">{media.view_count}</p>
            </div>
            
            <div className="bg-gradient-to-br from-purple-50 to-purple-100 rounded-xl p-4">
              <div className="flex items-center gap-2 mb-2">
                <HardDrive className="h-4 w-4 text-purple-600" />
                <span className="text-sm font-medium text-purple-900">Saklama</span>
              </div>
              <p className="text-lg font-bold text-purple-700">
                {media.storage_plan === '1_year' ? '1 Yıl' : '3 Ay'}
              </p>
            </div>
            
            <div className="bg-gradient-to-br from-orange-50 to-orange-100 rounded-xl p-4">
              <div className="flex items-center gap-2 mb-2">
                <User className="h-4 w-4 text-orange-600" />
                <span className="text-sm font-medium text-orange-900">Davetli Yüklemeleri</span>
              </div>
              <p className="text-lg font-bold text-orange-700">{media.guest_uploads_count || 0}</p>
            </div>
          </div>
          
          <div className="mt-6 pt-6 border-t border-gray-200">
            <label className="flex items-center gap-3 cursor-pointer">
              <input 
                type="checkbox" 
                checked={allowGuest} 
                onChange={handleToggleGuest}
                className="w-4 h-4 text-primary-600 bg-gray-100 border-gray-300 rounded focus:ring-primary-500"
              />
              <span className="text-sm font-medium text-gray-700">Davetli yüklemelerine izin ver</span>
            </label>
          </div>
        </div>

        {/* Media Gallery */}
        <div className="space-y-8">
          {/* Davet Sahibi Medyası Section */}
          <div>
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center gap-3">
                <div className="p-2 bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl">
                  <User className="h-5 w-5 text-white" />
                </div>
                <div>
                  <h2 className="text-xl font-bold text-gray-900">Davet Sahibi Medyası</h2>
                  <p className="text-sm text-gray-600">Ana medya ve ek yüklemeler</p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <button 
                  onClick={() => navigate(`/media/upload?invitationId=${invitationId}`)} 
                  className="btn-outline flex items-center gap-2"
                >
                  <Edit3 className="h-4 w-4" />
                  Güncelle
                </button>
                <label className="btn-primary flex items-center gap-2 cursor-pointer">
                  <Plus className="h-4 w-4" />
                  {uploading ? 'Yükleniyor...' : 'Ekle'}
                  <input
                    type="file"
                    accept="image/*,video/*"
                    onChange={handleAdditionalUpload}
                    disabled={uploading}
                    className="hidden"
                  />
                </label>
              </div>
            </div>
          
            {/* Ana Medya Card */}
            <div className="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow group">
              <div className="aspect-video bg-gray-100 relative">
                {media.type === 'video' ? (
                  <>
                    <video 
                      src={signedUrls[media.id] || media.storage_url} 
                      controls={playingVideo === media.id}
                      className="w-full h-full object-cover"
                      onPlay={() => setPlayingVideo(media.id)}
                      onPause={() => setPlayingVideo(null)}
                    />
                    {playingVideo !== media.id && (
                      <div className="absolute inset-0 bg-black/30 flex items-center justify-center">
                        <button
                          onClick={() => toggleVideoPlay(media.id)}
                          className="bg-white/20 hover:bg-white/30 rounded-full p-4 transition-colors"
                        >
                          <Play className="h-8 w-8 text-white" />
                        </button>
                      </div>
                    )}
                  </>
                ) : (
                  <img 
                    src={signedUrls[media.id] || media.storage_url} 
                    alt={media.title || 'Media'} 
                    className="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform duration-300" 
                    onClick={() => handleMediaClick(signedUrls[media.id] || media.storage_url, media.type, media.title || 'Davet Sahibi Medyası')}
                  />
                )}
                
                {/* Overlay Actions */}
                <div className="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-colors duration-300">
                  <div className="absolute top-3 left-3 flex gap-2">
                    <span className={`px-2 py-1 text-xs font-semibold rounded-full ${
                      media.type === 'video' ? 'bg-blue-500 text-white' : 'bg-green-500 text-white'
                    }`}>
                      {media.type === 'video' ? '🎥' : '📸'}
                    </span>
                    <span className="px-2 py-1 text-xs font-semibold rounded-full bg-blue-600 text-white">
                      👑 Ana
                    </span>
                  </div>
                  
                  
                  <div className="absolute bottom-3 right-3 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button
                      onClick={() => handleMediaClick(signedUrls[media.id] || media.storage_url, media.type, media.title || 'Davet Sahibi Medyası')}
                      className="p-2 bg-white/90 hover:bg-white text-gray-900 rounded-full transition-colors"
                    >
                      <Maximize2 className="h-4 w-4" />
                    </button>
                  </div>
                </div>
              </div>
              
              <div className="p-6">
                <div className="flex items-start justify-between mb-3">
                  <div className="flex-1">
                    <h3 className="font-semibold text-gray-900 mb-1">
                      {media.title || 'Ana Medya'}
                    </h3>
                    {media.description && (
                      <p className="text-sm text-gray-600 line-clamp-2">
                        {media.description}
                      </p>
                    )}
                  </div>
                </div>
                
                {/* Media Stats */}
                <div className="grid grid-cols-2 gap-3 text-xs text-gray-500 mb-4">
                  <div className="flex items-center gap-1">
                    <HardDrive className="h-3 w-3" />
                    <span>{formatFileSize(media.file_size)}</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <Calendar className="h-3 w-3" />
                    <span>{formatDate(media.created_at)}</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <Eye className="h-3 w-3" />
                    <span>{media.view_count} görüntüleme</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <QrCode className="h-3 w-3" />
                    <span>{media.scan_count} scan</span>
                  </div>
                </div>
                
                {/* Actions */}
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => handleDownload(signedUrls[media.id] || media.storage_url, media.file_name)}
                    className="flex-1 btn-outline text-sm py-2 flex items-center justify-center gap-2"
                  >
                    <Download className="h-4 w-4" />
                    İndir
                  </button>
                  <button
                    onClick={() => handleMediaClick(signedUrls[media.id] || media.storage_url, media.type, media.title || 'Davet Sahibi Medyası')}
                    className="flex-1 btn-outline text-sm py-2 flex items-center justify-center gap-2"
                  >
                    <Maximize2 className="h-4 w-4" />
                    Büyüt
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Davetli Yüklemeleri Section */}
          {guestUploads.length > 0 && (
            <div>
              <div className="flex items-center gap-3 mb-6">
                <div className="p-2 bg-gradient-to-br from-green-500 to-green-600 rounded-xl">
                  <User className="h-5 w-5 text-white" />
                </div>
                <div>
                  <h2 className="text-xl font-bold text-gray-900">Davetli Yüklemeleri</h2>
                  <p className="text-sm text-gray-600">{guestUploads.length} medya dosyası</p>
                </div>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                {guestUploads.map(upload => (
                  <div key={upload.id} className="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow group">
                    <div className="aspect-video bg-gray-100 relative">
                      {upload.type === 'video' ? (
                        <>
                          <video 
                            src={signedUrls[upload.id] || upload.storage_url} 
                            controls={playingVideo === upload.id}
                            className="w-full h-full object-cover"
                            onPlay={() => setPlayingVideo(upload.id)}
                            onPause={() => setPlayingVideo(null)}
                          />
                          {playingVideo !== upload.id && (
                            <div className="absolute inset-0 bg-black/30 flex items-center justify-center">
                              <button
                                onClick={() => toggleVideoPlay(upload.id)}
                                className="bg-white/20 hover:bg-white/30 rounded-full p-3 transition-colors"
                              >
                                <Play className="h-6 w-6 text-white" />
                              </button>
                            </div>
                          )}
                        </>
                      ) : (
                        <img 
                          src={signedUrls[upload.id] || upload.storage_url} 
                          alt={upload.file_name} 
                          className="w-full h-full object-cover cursor-pointer hover:scale-105 transition-transform duration-300" 
                          onClick={() => handleMediaClick(signedUrls[upload.id] || upload.storage_url, upload.type, upload.file_name)}
                        />
                      )}
                      
                      {/* Overlay Actions */}
                      <div className="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-colors duration-300">
                        <div className="absolute top-3 left-3 flex gap-2">
                          <span className={`px-2 py-1 text-xs font-semibold rounded-full ${
                            upload.type === 'video' ? 'bg-blue-500 text-white' : 'bg-green-500 text-white'
                          }`}>
                            {upload.type === 'video' ? '🎥' : '📸'}
                          </span>
                          <span className="px-2 py-1 text-xs font-semibold rounded-full bg-green-600 text-white">
                            👤 {upload.guest_name || 'Davetli'}
                          </span>
                        </div>
                        
                        <div className="absolute top-3 right-3 opacity-0 group-hover:opacity-100 transition-opacity">
                          <button
                            onClick={() => setDeleteDialog({type: 'guest', id: upload.id, title: upload.guest_name || 'Davetli Medyası'})}
                            className="p-2 bg-red-500 hover:bg-red-600 text-white rounded-full transition-colors"
                          >
                            <Trash2 className="h-4 w-4" />
                          </button>
                        </div>
                        
                        <div className="absolute bottom-3 right-3 opacity-0 group-hover:opacity-100 transition-opacity">
                          <button
                            onClick={() => handleMediaClick(signedUrls[upload.id] || upload.storage_url, upload.type, upload.guest_name || 'Davetli Medyası')}
                            className="p-2 bg-white/90 hover:bg-white text-gray-900 rounded-full transition-colors"
                          >
                            <Maximize2 className="h-4 w-4" />
                          </button>
                        </div>
                      </div>
                    </div>
                    
                    <div className="p-4">
                      <div className="flex items-start justify-between mb-2">
                        <div className="flex-1">
                          <h3 className="font-semibold text-gray-900 text-sm mb-1">
                            {upload.guest_name || 'Davetli'}
                          </h3>
                          {upload.note && (
                            <p className="text-xs text-gray-600 line-clamp-2">
                              {upload.note}
                            </p>
                          )}
                        </div>
                      </div>
                      
                      {/* Upload Info */}
                      <div className="grid grid-cols-2 gap-2 text-xs text-gray-500 mb-3">
                        <div className="flex items-center gap-1">
                          <HardDrive className="h-3 w-3" />
                          <span>{formatFileSize(upload.file_size)}</span>
                        </div>
                        <div className="flex items-center gap-1">
                          <Calendar className="h-3 w-3" />
                          <span>{formatDate(upload.created_at)}</span>
                        </div>
                      </div>
                      
                      {/* Actions */}
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => handleDownload(signedUrls[upload.id] || upload.storage_url, upload.file_name)}
                          className="flex-1 btn-outline text-xs py-2 flex items-center justify-center gap-1"
                        >
                          <Download className="h-3 w-3" />
                          İndir
                        </button>
                        <button
                          onClick={() => handleMediaClick(signedUrls[upload.id] || upload.storage_url, upload.type, upload.guest_name || 'Davetli Medyası')}
                          className="flex-1 btn-outline text-xs py-2 flex items-center justify-center gap-1"
                        >
                          <Maximize2 className="h-3 w-3" />
                          Büyüt
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Delete Confirmation Dialog */}
      {deleteDialog && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl max-w-md w-full p-6">
            <div className="flex items-center gap-3 mb-4">
              <div className="p-2 bg-red-100 rounded-full">
                <Trash2 className="h-5 w-5 text-red-600" />
              </div>
              <h3 className="text-lg font-semibold text-gray-900">Medyayı Sil</h3>
            </div>
            
            <p className="text-gray-600 mb-6">
              "{deleteDialog.title}" medyasını silmek istediğinizden emin misiniz? 
              Bu işlem geri alınamaz.
            </p>
            
            <div className="flex items-center gap-3">
              <button
                onClick={() => setDeleteDialog(null)}
                className="flex-1 btn-outline"
                disabled={deleting}
              >
                İptal
              </button>
              <button
                onClick={handleDeleteMedia}
                disabled={deleting}
                className="flex-1 bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
              >
                {deleting ? (
                  <>
                    <Loader2 className="h-4 w-4 animate-spin" />
                    Siliniyor...
                  </>
                ) : (
                  <>
                    <Trash2 className="h-4 w-4" />
                    Sil
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Media Preview Modal */}
      {selectedMedia && (
        <div className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl max-w-4xl max-h-[90vh] w-full overflow-hidden">
            <div className="flex items-center justify-between p-4 border-b">
              <h3 className="text-lg font-semibold truncate">{selectedMedia.title}</h3>
              <div className="flex items-center gap-2">
                <button
                  onClick={() => handleDownload(selectedMedia.url, selectedMedia.title)}
                  className="btn-outline text-sm py-2 px-3 flex items-center gap-2"
                >
                  <Download className="h-4 w-4" />
                  İndir
                </button>
                <button
                  onClick={() => setSelectedMedia(null)}
                  className="btn-outline text-sm py-2 px-3 flex items-center gap-2"
                >
                  <X className="h-4 w-4" />
                  Kapat
                </button>
              </div>
            </div>
            <div className="p-4 overflow-auto max-h-[calc(90vh-80px)]">
              {selectedMedia.type === 'video' ? (
                <video 
                  src={selectedMedia.url} 
                  controls 
                  className="w-full h-auto max-h-[70vh]"
                  autoPlay
                />
              ) : (
                <img 
                  src={selectedMedia.url} 
                  alt={selectedMedia.title}
                  className="w-full h-auto max-h-[70vh] object-contain mx-auto"
                />
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default QRManagePage;