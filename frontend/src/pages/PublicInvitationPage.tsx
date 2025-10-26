import React, { useEffect, useState, useRef } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Download, Share2, Loader2 } from 'lucide-react';
import { invitationService, type Invitation } from '../services/invitationService';
import { pdfService } from '../services/pdfService';
import { PublicInvitationSkeleton } from '../components/Skeleton/Skeleton';
import toast from 'react-hot-toast';

const PublicInvitationPage: React.FC = () => {
  const { invitationId } = useParams<{ invitationId: string }>();
  const navigate = useNavigate();
  
  const [invitation, setInvitation] = useState<Invitation | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isExporting, setIsExporting] = useState(false);
  
  // Prevent duplicate loads and toasts in React Strict Mode
  const hasLoadedRef = useRef(false);
  const hasShownErrorRef = useRef(false);

  useEffect(() => {
    // Skip if already loaded
    if (hasLoadedRef.current) return;
    hasLoadedRef.current = true;
    
    loadInvitation();
  }, [invitationId]);

  const loadInvitation = async () => {
    if (!invitationId) {
      if (!hasShownErrorRef.current) {
        hasShownErrorRef.current = true;
        toast.error('Geçersiz davetiye');
      }
      navigate('/');
      return;
    }

    setIsLoading(true);
    try {
      const data = await invitationService.getInvitation(invitationId);
      
      if (!data) {
        if (!hasShownErrorRef.current) {
          hasShownErrorRef.current = true;
          toast.error('Davetiye bulunamadı');
        }
        navigate('/');
        return;
      }

      // Show status badge for non-published invitations
      // But still allow viewing (since they have the link)
      if (data.status !== 'published') {
        console.log('⚠️ Viewing draft invitation:', data.id);
      }

      setInvitation(data);
      
      // Increment view count only for published invitations
      if (data.status === 'published') {
        await invitationService.incrementViewCount(invitationId);
      }
    } catch (error) {
      console.error('Error loading invitation:', error);
      if (!hasShownErrorRef.current) {
        hasShownErrorRef.current = true;
        toast.error('Davetiye yüklenirken bir hata oluştu');
      }
      navigate('/');
    } finally {
      setIsLoading(false);
    }
  };

  const handleDownloadPDF = async () => {
    const previewElement = document.getElementById('invitation-preview');
    if (!previewElement || !invitation) return;
    
    setIsExporting(true);
    try {
      await pdfService.exportAndDownload(previewElement, {
        filename: `${invitation.title || 'davetiye'}.pdf`,
        quality: 2,
        orientation: 'portrait'
      });
    } finally {
      setIsExporting(false);
    }
  };

  const handleShare = () => {
    const shareUrl = window.location.href;
    const shareText = invitation?.title 
      ? `${invitation.title} - Davetiye` 
      : 'Davetiye';

    if (navigator.share) {
      pdfService.share(shareText, 'Davetiyeyi görüntülemek için tıklayın', shareUrl);
    } else {
      navigator.clipboard.writeText(shareUrl)
        .then(() => toast.success('Link kopyalandı!'))
        .catch(() => toast.error('Link kopyalanamadı'));
    }
  };

  const formatDate = (dateStr: string) => {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleDateString('tr-TR', { 
      day: 'numeric', 
      month: 'long', 
      year: 'numeric',
      weekday: 'long'
    });
  };

  if (isLoading) {
    return <PublicInvitationSkeleton />;
  }

  if (!invitation) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <p className="text-gray-600 mb-4">Davetiye bulunamadı</p>
          <button onClick={() => navigate('/')} className="btn-primary">
            Ana Sayfaya Dön
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-blue-50/20 to-purple-50/20">
      {/* Draft Banner - Modern */}
      {invitation.status !== 'published' && (
        <div className="bg-gradient-to-r from-amber-50 to-yellow-50 border-b border-amber-200/50 backdrop-blur-sm py-4">
          <div className="max-w-4xl mx-auto px-4">
            <div className="flex items-center justify-center gap-2 text-sm">
              <div className="bg-amber-200 rounded-full p-1.5">
                <span className="text-amber-700 text-xs">⚠️</span>
              </div>
              <p className="text-amber-900">
                <strong className="font-semibold">Önizleme Modu:</strong> Bu davetiye henüz yayınlanmamış
              </p>
            </div>
          </div>
        </div>
      )}

      {/* Header Actions - Modern & Sticky */}
      <div className="sticky top-0 z-10 bg-white/80 backdrop-blur-md border-b border-gray-200/50 shadow-sm">
        <div className="max-w-4xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <button
              onClick={() => navigate('/')}
              className="flex items-center gap-2 px-4 py-2 text-gray-700 hover:text-gray-900 hover:bg-gray-100 rounded-xl transition-all font-medium"
            >
              <span className="text-lg">←</span>
              <span className="hidden sm:inline">Ana Sayfa</span>
            </button>
            {/* Only show share/download buttons for published invitations */}
            {invitation.status === 'published' && (
              <div className="flex items-center gap-2">
                <button
                  onClick={handleShare}
                  className="flex items-center gap-2 px-4 py-2 bg-white border-2 border-gray-200 text-gray-700 hover:border-primary-500 hover:text-primary-600 rounded-xl transition-all font-medium shadow-sm hover:shadow-md"
                >
                  <Share2 className="h-4 w-4" />
                  <span className="hidden sm:inline">Paylaş</span>
                </button>
                <button
                  onClick={handleDownloadPDF}
                  disabled={isExporting}
                  className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white rounded-xl transition-all font-medium shadow-md hover:shadow-lg disabled:opacity-50"
                >
                  {isExporting ? (
                    <Loader2 className="h-4 w-4 animate-spin" />
                  ) : (
                    <Download className="h-4 w-4" />
                  )}
                  <span className="hidden sm:inline">{isExporting ? 'İndiriliyor...' : 'PDF İndir'}</span>
                </button>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="py-8">

      {/* Invitation Preview - Modern Card */}
      <div className="max-w-4xl mx-auto px-4">
        <div 
          id="invitation-preview"
          className="bg-white shadow-2xl rounded-2xl overflow-hidden relative border border-white/50 backdrop-blur-sm"
          style={{
            minHeight: '600px',
            backgroundImage: invitation.image_url && invitation.content?.imagePosition === 'background'
              ? `url(${invitation.image_url})`
              : invitation.content?.colors 
                ? `linear-gradient(135deg, ${invitation.content.colors.primary} 0%, ${invitation.content.colors.secondary} 100%)`
                : 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            backgroundSize: 'cover',
            backgroundPosition: 'center'
          }}
        >
          {/* Gradient overlay for background image */}
          {invitation.content?.imagePosition === 'background' && invitation.image_url && (
            <div 
              className="absolute inset-0" 
              style={{ 
                background: invitation.content?.colors
                  ? `linear-gradient(135deg, ${invitation.content.colors.primary}CC 0%, ${invitation.content.colors.secondary}CC 100%)`
                  : 'linear-gradient(135deg, #667eeaCC 0%, #764ba2CC 100%)'
              }}
            />
          )}
          
          {/* Watermark - bottom right */}
          {invitation.content?.imagePosition === 'watermark' && invitation.image_url && (
            <img
              src={invitation.image_url}
              alt="Logo"
              className="absolute bottom-4 right-4 w-16 h-16 object-contain opacity-60"
            />
          )}
          
          <div className="p-8 md:p-12 flex items-center justify-center min-h-[600px] relative z-10">
            <div 
              className="text-center space-y-4 max-w-sm"
              style={{ 
                color: invitation.content?.colors?.text || '#ffffff'
              }}
            >
              {/* Banner Image - top */}
              {invitation.content?.imagePosition === 'banner' && invitation.image_url && (
                <div className="mb-6 -mx-8 -mt-8 mb-8">
                  <img
                    src={invitation.image_url}
                    alt="Banner"
                    className="w-full h-32 object-cover"
                  />
                </div>
              )}
              
              {/* Profile Image - circular */}
              {invitation.content?.imagePosition === 'profile' && invitation.image_url && (
                <div className="mb-6">
                  <img
                    src={invitation.image_url}
                    alt="Profil"
                    className="w-32 h-32 md:w-40 md:h-40 object-cover rounded-full mx-auto border-4"
                    style={{ borderColor: invitation.content?.colors?.accent || '#f56565' }}
                  />
                </div>
              )}
              
              {/* Title */}
              <div className="text-2xl md:text-4xl font-serif font-bold">
                {invitation.title}
              </div>
              
              {/* Accent Divider */}
              <div 
                className="w-24 h-1 mx-auto rounded-full"
                style={{ 
                  backgroundColor: invitation.content?.colors?.accent || '#f56565'
                }}
              />
              
              {/* Date & Time Card */}
              {invitation.event_date && (
                <div 
                  className="p-4 rounded-lg"
                  style={{ 
                    backgroundColor: invitation.content?.colors?.background || '#ffffff',
                    color: invitation.content?.colors?.primary || '#667eea'
                  }}
                >
                  <div className="font-medium">
                    {formatDate(invitation.event_date)}
                  </div>
                  {invitation.event_time && (
                    <div className="mt-1">
                      {invitation.event_time}
                    </div>
                  )}
                </div>
              )}
              
              {/* Accent Divider */}
              <div 
                className="w-24 h-1 mx-auto rounded-full"
                style={{ 
                  backgroundColor: invitation.content?.colors?.accent || '#f56565'
                }}
              />
              
              {/* Location */}
              {invitation.event_location_name && (
                <div style={{ opacity: 0.95 }}>
                  {invitation.event_location_name}
                </div>
              )}
              
              {/* Custom Message */}
              {invitation.content?.message && (
                <>
                  <div 
                    className="w-16 h-1 mx-auto rounded-full"
                    style={{ 
                      backgroundColor: invitation.content?.colors?.accent || '#f56565'
                    }}
                  />
                  <div 
                    className="text-sm italic p-4 rounded-lg"
                    style={{ 
                      backgroundColor: invitation.content?.colors?.background || '#ffffff',
                      color: invitation.content?.colors?.primary || '#667eea',
                      border: `2px solid ${invitation.content?.colors?.accent || '#f56565'}`
                    }}
                  >
                    "{invitation.content.message}"
                  </div>
                </>
              )}

              {/* Decorative Footer */}
              <div 
                className="mt-12 pt-8"
                style={{ 
                  borderTop: `2px solid ${invitation.content?.colors?.accent || '#ffffff'}40`
                }}
              >
                <p className="text-lg italic opacity-90">
                  Sizleri aramızda görmekten mutluluk duyarız
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Footer Info - Modern */}
        <div className="mt-8 bg-white/80 backdrop-blur-sm rounded-xl border border-gray-200/50 p-4 shadow-sm">
          <div className="text-center space-y-3">
            <div className="flex items-center justify-center">
              <a href="/" className="flex items-center gap-2 group">
                <div className="w-8 h-8 bg-gradient-to-br from-primary-500 to-primary-600 rounded-lg flex items-center justify-center shadow-sm group-hover:shadow-md transition-all">
                  <span className="text-white font-bold text-base">D</span>
                </div>
                <span className="text-base font-bold bg-gradient-to-r from-gray-900 to-gray-700 bg-clip-text text-transparent">
                  Davetim
                </span>
              </a>
            </div>
            <div className="pt-2 border-t border-gray-200/50">
              <p className="text-xs text-gray-600">
                Kendi davetiyenizi oluşturmak için{' '}
                <a 
                  href="/signup" 
                  className="text-primary-600 hover:text-primary-700 font-semibold transition-colors inline-flex items-center gap-1"
                >
                  ücretsiz kayıt olun
                  <span className="text-base">→</span>
                </a>
              </p>
            </div>
          </div>
        </div>
      </div>
      </div>
    </div>
  );
};

export default PublicInvitationPage;
