import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { Video, Image as ImageIcon, Calendar, Eye, QrCode, Loader2, AlertTriangle, Download, Upload, Mic, MessageSquare } from 'lucide-react';
import { mediaService, type Media, type GuestUploadRecord } from '../services/mediaService';
import { supabase } from '../services/supabase';
import toast from 'react-hot-toast';

const PublicMediaPage: React.FC = () => {
  const { qrCode } = useParams<{ qrCode: string }>();
  const [media, setMedia] = useState<Media | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [guestUploads, setGuestUploads] = useState<GuestUploadRecord[]>([]);
  const [guestName, setGuestName] = useState('');
  const [guestNote, setGuestNote] = useState('');
  const [guestFile, setGuestFile] = useState<File | null>(null);
  const [isGuestUploading, setIsGuestUploading] = useState(false);

  useEffect(() => {
    if (qrCode) {
      loadMedia();
    }
  }, [qrCode]);

  const loadMedia = async () => {
    setIsLoading(true);
    setError(null);

    try {
      console.log('Loading media for QR code:', qrCode);
      
      const data = await mediaService.getMediaByQRCode(qrCode!);
      
      if (!data) {
        setError('Medya bulunamadı veya süresi dolmuş');
        return;
      }

      // If bucket is private, generate signed URL from storage_path
      if (data.storage_path) {
        const { data: signed } = await supabase.storage
          .from('qr-media')
          .createSignedUrl(data.storage_path, 60 * 60); // 1 hour
        if (signed?.signedUrl) {
          data.storage_url = signed.signedUrl as any;
        }
      }
      setMedia(data);
      // Load guest uploads if allowed
      if (data.allow_guest_upload) {
        const uploads = await mediaService.getGuestUploads(qrCode!);
        setGuestUploads(uploads);
      }

      // Increment view count
      await mediaService.incrementViewCount(data.id);
    } catch (err: any) {
      console.error('Load media error:', err);
      setError('Medya yüklenirken bir hata oluştu');
    } finally {
      setIsLoading(false);
    }
  };

  const handleGuestFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0] || null;
    setGuestFile(file);
  };

  const handleGuestUpload = async () => {
    if (!qrCode || !guestFile) {
      toast.error('Lütfen bir dosya seçin');
      return;
    }
    try {
      setIsGuestUploading(true);
      const record = await mediaService.uploadGuestMedia({
        qrCode,
        file: guestFile,
        guestName: guestName || undefined,
        note: guestNote || undefined,
      });
      setGuestUploads(prev => [record, ...prev]);
      setGuestFile(null);
      setGuestName('');
      setGuestNote('');
    } catch (err) {
      // toast already shown
    } finally {
      setIsGuestUploading(false);
    }
  };

  const formatDate = (dateString: string): string => {
    return new Date(dateString).toLocaleDateString('tr-TR', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
    });
  };

  const handleDownload = () => {
    if (!media) return;

    const link = document.createElement('a');
    link.href = media.storage_url;
    link.download = media.file_name;
    link.target = '_blank';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    toast.success('İndirme başlatıldı');
  };

  // Loading State
  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center">
        <div className="text-center">
          <Loader2 className="h-12 w-12 animate-spin text-primary-500 mx-auto mb-4" />
          <p className="text-white text-lg">Medya yükleniyor...</p>
        </div>
      </div>
    );
  }

  // Error State
  if (error || !media) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center p-4">
        <div className="bg-white rounded-xl shadow-xl p-8 md:p-12 text-center max-w-md">
          <div className="bg-red-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6">
            <AlertTriangle className="h-10 w-10 text-red-600" />
          </div>
          <h1 className="text-2xl font-bold text-gray-900 mb-4">
            Medya Bulunamadı
          </h1>
          <p className="text-gray-600 mb-8">
            {error || 'Bu QR kod geçersiz veya medyanın süresi dolmuş olabilir.'}
          </p>
          <a
            href="/"
            className="btn-primary inline-block"
          >
            Ana Sayfaya Dön
          </a>
        </div>
      </div>
    );
  }

  // Success: Display Media
  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900">
      <div className="max-w-6xl mx-auto px-4 py-8 md:py-12">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center gap-2 bg-primary-500 text-white px-4 py-2 rounded-full mb-4">
            <QrCode className="h-5 w-5" />
            <span className="font-semibold">QR Medya</span>
          </div>
          <h1 className="text-3xl md:text-4xl font-bold text-white mb-2">
            {media.title}
          </h1>
          {media.description && (
            <p className="text-gray-300 text-lg max-w-2xl mx-auto">
              {media.description}
            </p>
          )}
        </div>

        {/* Host Message */}
        {media.owner_message_url && (
          <div className="bg-white bg-opacity-10 backdrop-blur-sm rounded-xl p-4 md:p-6 border border-white border-opacity-20 mb-6">
            <div className="flex items-center gap-3 mb-3">
              <Mic className="h-5 w-5 text-pink-400" />
              <h3 className="text-white font-semibold">Davet Sahibi Mesajı</h3>
            </div>
            {media.owner_message_type === 'audio' && (
              <audio src={media.owner_message_url} controls className="w-full" />
            )}
            {media.owner_message_type === 'video' && (
              <video src={media.owner_message_url} controls className="w-full rounded-lg" />
            )}
            {media.owner_message_type === 'image' && (
              <img src={media.owner_message_url} alt={media.owner_message_title || 'Mesaj'} className="w-full rounded-lg" />
            )}
            {media.owner_message_title && (
              <p className="text-gray-300 mt-2">{media.owner_message_title}</p>
            )}
          </div>
        )}

        {/* Media Viewer */}
        <div className="bg-black rounded-2xl overflow-hidden shadow-2xl mb-8">
          {media.type === 'video' ? (
            <video
              src={media.storage_url}
              controls
              autoPlay
              className="w-full max-h-[70vh] mx-auto"
              poster={media.thumbnail_url}
            >
              Tarayıcınız video oynatmayı desteklemiyor.
            </video>
          ) : (
            <img
              src={media.storage_url}
              alt={media.title || 'Media'}
              className="w-full max-h-[70vh] object-contain mx-auto"
            />
          )}
        </div>

        {/* Info Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          {/* Type */}
          <div className="bg-white bg-opacity-10 backdrop-blur-sm rounded-xl p-6 border border-white border-opacity-20">
            <div className="flex items-center gap-3 mb-2">
              {media.type === 'video' ? (
                <Video className="h-6 w-6 text-blue-400" />
              ) : (
                <ImageIcon className="h-6 w-6 text-green-400" />
              )}
              <h3 className="text-white font-semibold">Tür</h3>
            </div>
            <p className="text-gray-300">
              {media.type === 'video' ? 'Video' : 'Görsel'}
            </p>
          </div>

          {/* Views */}
          <div className="bg-white bg-opacity-10 backdrop-blur-sm rounded-xl p-6 border border-white border-opacity-20">
            <div className="flex items-center gap-3 mb-2">
              <Eye className="h-6 w-6 text-purple-400" />
              <h3 className="text-white font-semibold">Görüntülenme</h3>
            </div>
            <p className="text-gray-300">
              {media.view_count} kez görüntülendi
            </p>
          </div>

          {/* Date */}
          <div className="bg-white bg-opacity-10 backdrop-blur-sm rounded-xl p-6 border border-white border-opacity-20">
            <div className="flex items-center gap-3 mb-2">
              <Calendar className="h-6 w-6 text-yellow-400" />
              <h3 className="text-white font-semibold">Yükleme Tarihi</h3>
            </div>
            <p className="text-gray-300">
              {formatDate(media.created_at)}
            </p>
          </div>
        </div>

        {/* Guest Upload Section */}
        {media.allow_guest_upload && (
          <div className="bg-white bg-opacity-10 backdrop-blur-sm rounded-xl p-6 border border-white border-opacity-20 mb-10">
            <div className="flex items-center gap-3 mb-4">
              <Upload className="h-5 w-5 text-green-400" />
              <h3 className="text-white font-semibold">Davetliler İçin Yükleme</h3>
            </div>
            <p className="text-gray-300 mb-4">
              Etkinlikten fotoğraf veya kısa videolarınızı yükleyin. ({media.guest_uploads_count || 0}/{media.guest_uploads_limit || 50})
            </p>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <input
                type="text"
                placeholder="İsminiz (opsiyonel)"
                value={guestName}
                onChange={e => setGuestName(e.target.value)}
                className="input"
              />
              <input
                type="text"
                placeholder="Kısa not (opsiyonel)"
                value={guestNote}
                onChange={e => setGuestNote(e.target.value)}
                className="input"
              />
              <input type="file" accept="image/*,video/*" onChange={handleGuestFileChange} className="input" />
            </div>
            <div className="mt-4">
              <button
                onClick={handleGuestUpload}
                disabled={isGuestUploading || !guestFile}
                className="btn-primary inline-flex items-center gap-2"
              >
                {isGuestUploading ? (
                  <>
                    <Loader2 className="h-4 w-4 animate-spin" /> Yükleniyor...
                  </>
                ) : (
                  <>
                    <Upload className="h-4 w-4" /> Yükle
                  </>
                )}
              </button>
            </div>
          </div>
        )}

        {/* Guest Uploads List */}
        {guestUploads.length > 0 && (
          <div className="bg-white bg-opacity-10 backdrop-blur-sm rounded-xl p-6 border border-white border-opacity-20 mb-8">
            <div className="flex items-center gap-3 mb-4">
              <MessageSquare className="h-5 w-5 text-blue-400" />
              <h3 className="text-white font-semibold">Davetli Yüklemeleri</h3>
            </div>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {guestUploads.map(item => (
                <div key={item.id} className="bg-black/40 rounded-lg overflow-hidden">
                  {item.type === 'video' ? (
                    <video src={item.storage_url} controls className="w-full h-40 object-cover" />
                  ) : (
                    <img src={item.storage_url} alt={item.file_name} className="w-full h-40 object-cover" />
                  )}
                  {(item.guest_name || item.note) && (
                    <div className="p-2 text-xs text-gray-300">
                      {item.guest_name && <div className="font-semibold">{item.guest_name}</div>}
                      {item.note && <div className="text-gray-400">{item.note}</div>}
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}
        {/* Actions */}
        <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
          <button
            onClick={handleDownload}
            className="btn-primary bg-white text-gray-900 hover:bg-gray-100 flex items-center gap-2"
          >
            <Download className="h-5 w-5" />
            Medyayı İndir
          </button>
          <a
            href="/"
            className="btn-outline border-white text-white hover:bg-white hover:text-gray-900"
          >
            Davetim ile Oluştur
          </a>
        </div>

        {/* Footer */}
        <div className="text-center mt-12">
          <p className="text-gray-400 text-sm">
            Bu medya{' '}
            <a
              href="/"
              className="text-primary-400 hover:text-primary-300 font-semibold"
            >
              Davetim
            </a>
            {' '}ile oluşturulmuştur
          </p>
          {media.expires_at && (
            <p className="text-gray-500 text-xs mt-2">
              Bu medya {formatDate(media.expires_at)} tarihine kadar erişilebilir olacaktır
            </p>
          )}
        </div>
      </div>
    </div>
  );
};

export default PublicMediaPage;

