import React, { useEffect, useState, useRef } from 'react';
import { useParams, useNavigate, useSearchParams } from 'react-router-dom';
import { ArrowLeft, Download, Share2, Eye, Save, Palette, Loader2, FileText, Users } from 'lucide-react';
import { templateService, type Template } from '../services/templateService';
import { invitationService, type Invitation } from '../services/invitationService';
import { useAuth } from '../store/authStore';
import { useSubscription } from '../hooks/useSubscription';
import { pdfService } from '../services/pdfService';
import PreviewModal from '../components/Editor/PreviewModal';
import ColorPicker from '../components/Editor/ColorPicker';
import ImageUpload from '../components/Editor/ImageUpload';
import GuestList from '../components/Editor/GuestList';
import toast from 'react-hot-toast';

const EditorPage: React.FC = () => {
  const { templateId: invitationId } = useParams();
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { isAuthenticated, user } = useAuth();
  const subscription = useSubscription();

  // State
  const [template, setTemplate] = useState<Template | null>(null);
  const [invitation, setInvitation] = useState<Invitation | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [isPreviewOpen, setIsPreviewOpen] = useState(false);
  const [activeTab, setActiveTab] = useState<'details' | 'guests'>('details');
  
  // Use ref to prevent duplicate creation across re-renders
  const isCreatingRef = useRef(false);
  const hasCreatedRef = useRef(false);
  
  // Form data
  const [formData, setFormData] = useState({
    title: '',
    eventDate: '',
    eventTime: '',
    location: '',
    customMessage: '',
    imageUrl: '' as string | null,
    imagePosition: 'profile' as 'profile' | 'background' | 'banner' | 'watermark'
  });

  // Color customization
  const [colors, setColors] = useState({
    primary: '#667eea',
    secondary: '#764ba2',
    background: '#ffffff',
    text: '#ffffff',
    accent: '#f56565'
  });

  const [selectedFont, setSelectedFont] = useState('normal');

  // Load template or invitation
  useEffect(() => {
    if (!isAuthenticated) {
      toast.error('Davetiye oluşturmak için giriş yapmalısınız');
      navigate('/auth');
      return;
    }
    
    loadData();
  }, [invitationId, searchParams, isAuthenticated]);

  const loadData = async () => {
    setIsLoading(true);
    
    try {
      // Check if we're editing an existing invitation
      if (invitationId) {
        const invitationData = await invitationService.getInvitation(invitationId);
        
        if (!invitationData) {
          toast.error('Davetiye bulunamadı');
          navigate('/dashboard');
          return;
        }
        
        setInvitation(invitationData);
        setTemplate(invitationData.template);
        
        // Load invitation data into form
        setFormData({
          title: invitationData.title || '',
          eventDate: invitationData.event_date?.split('T')[0] || '',
          eventTime: invitationData.event_time || '',
          location: invitationData.event_location_name || '',
          customMessage: invitationData.content?.message || '',
          imageUrl: invitationData.image_url || null,
          imagePosition: invitationData.content?.imagePosition || 'profile'
        });
        
        // Load colors if exists
        if (invitationData.content?.colors) {
          setColors(invitationData.content.colors);
        }
        
      } else {
        // Creating new invitation from template
        const templateSlug = searchParams.get('template');
        
        if (!templateSlug) {
          toast.error('Şablon seçilmedi');
          navigate('/templates');
          return;
        }
        
        // Prevent duplicate creation using ref (persists across re-renders)
        if (isCreatingRef.current || hasCreatedRef.current) {
          console.log('⏸️ Already creating/created invitation, skipping...');
          return;
        }
        
        isCreatingRef.current = true;
        console.log('✨ Creating new invitation for template:', templateSlug);
        
        const templateData = await templateService.getTemplateBySlug(templateSlug);
        
        if (!templateData) {
          toast.error('Şablon bulunamadı');
          navigate('/templates');
          isCreatingRef.current = false;
          return;
        }
        
        // Premium/PRO şablon kontrolü - Free plan sadece 'free' tier'a erişebilir
        const isPremiumOrProTemplate = templateData.tier === 'premium' || templateData.tier === 'pro';
        if (isPremiumOrProTemplate && !subscription.planConfig?.limits.premiumTemplates) {
          toast.error('Bu şablon PRO veya PREMIUM plan gerektirir!');
          navigate('/templates');
          isCreatingRef.current = false;
          return;
        }
        
        setTemplate(templateData);
        
        // Create new invitation
        const newInvitation = await invitationService.createInvitation({
          template_id: templateData.id,
          title: `Yeni ${templateData.category?.name || 'Etkinlik'}`,
          event_type: templateData.category?.slug || '',
          content: {}
        });
        
        if (newInvitation) {
          setInvitation(newInvitation);
          hasCreatedRef.current = true; // Mark as created
          isCreatingRef.current = false;
          console.log('✅ Invitation created, redirecting...');
          // Redirect to edit URL
          navigate(`/editor/${newInvitation.id}`, { replace: true });
        } else {
          isCreatingRef.current = false;
        }
      }
    } catch (error) {
      console.error('Error loading data:', error);
      toast.error('Veri yüklenirken hata oluştu');
    } finally {
      setIsLoading(false);
    }
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const handleSave = async () => {
    if (!invitation) return;
    
    setIsSaving(true);
    
    try {
      const success = await invitationService.updateInvitation(invitation.id, {
        title: formData.title,
        event_date: formData.eventDate || null,
        event_time: formData.eventTime || null,
        event_location_name: formData.location || null,
        content: {
          message: formData.customMessage,
          colors: colors,
          imagePosition: formData.imagePosition
        },
        custom_design: {
          font: selectedFont
        }
      });
      
      if (success) {
        // Reload invitation data
        const updated = await invitationService.getInvitation(invitation.id);
        if (updated) {
          setInvitation(updated);
        }
      }
    } catch (error) {
      console.error('Save error:', error);
    } finally {
      setIsSaving(false);
    }
  };

  const handlePreview = () => {
    setIsPreviewOpen(true);
  };

  const handleDownload = async () => {
    if (!invitation) return;
    
    // Save first
    await handleSave();
    
    // Then open preview modal for download
    setIsPreviewOpen(true);
  };

  const handleTogglePublish = async () => {
    if (!invitation) return;
    
    const newStatus = invitation.status === 'published' ? 'draft' : 'published';
    const statusText = newStatus === 'published' ? 'yayınlandı' : 'taslağa alındı';
    
    try {
      const updated = await invitationService.updateInvitation(invitation.id, {
        status: newStatus
      });
      
      if (updated) {
        setInvitation(updated);
        toast.success(`Davetiye ${statusText}`);
      }
    } catch (error) {
      console.error('Toggle publish error:', error);
      toast.error('Status güncellenemedi');
    }
  };

  const handleShare = () => {
    if (invitation?.id) {
      pdfService.copyShareLink(invitation.id);
    }
  };

  // Loading state
  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <Loader2 className="h-8 w-8 animate-spin text-primary-500 mx-auto mb-4" />
          <p className="text-gray-600">Yükleniyor...</p>
        </div>
      </div>
    );
  }

  if (!template || !invitation) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <p className="text-gray-600 mb-4">Davetiye bulunamadı</p>
          <button onClick={() => navigate('/templates')} className="btn-primary">
            Şablonlara Dön
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b sticky top-0 z-10">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center space-x-4">
              <button
                onClick={() => navigate('/dashboard')}
                className="flex items-center space-x-2 text-gray-600 hover:text-gray-900"
              >
                <ArrowLeft className="h-5 w-5" />
                <span>Geri</span>
              </button>
              <div>
                <h1 className="text-lg font-semibold text-gray-900">
                  {template.name} - Düzenle
                </h1>
                <p className="text-sm text-gray-500">
                  {invitation.status === 'draft' ? '📝 Taslak' : invitation.status === 'published' ? '🌐 Yayında' : '🗄️ Arşivlendi'}
                  {invitation.updated_at && ` • ${new Date(invitation.updated_at).toLocaleString('tr-TR')}`}
                </p>
              </div>
            </div>

            <div className="flex items-center space-x-3">
              <button
                onClick={handleSave}
                disabled={isSaving}
                className="btn-secondary flex items-center gap-2 disabled:opacity-50"
              >
                {isSaving ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />}
                {isSaving ? 'Kaydediliyor...' : 'Kaydet'}
              </button>
              <button
                onClick={handleTogglePublish}
                className={`btn-outline flex items-center gap-2 ${
                  invitation.status === 'published' 
                    ? 'bg-green-50 text-green-700 border-green-300 hover:bg-green-100' 
                    : 'bg-yellow-50 text-yellow-700 border-yellow-300 hover:bg-yellow-100'
                }`}
              >
                {invitation.status === 'published' ? '✓ Yayında' : '📝 Yayınla'}
              </button>
              <button
                onClick={handlePreview}
                className="btn-outline flex items-center gap-2"
              >
                <Eye className="h-4 w-4" />
                Önizle
              </button>
              <button
                onClick={handleShare}
                className="btn-outline flex items-center gap-2"
              >
                <Share2 className="h-4 w-4" />
                Paylaş
              </button>
              <button
                onClick={handleDownload}
                className="btn-primary flex items-center gap-2"
              >
                <Download className="h-4 w-4" />
                İndir
              </button>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Editor Panel */}
          <div className="bg-white rounded-lg shadow">
            {/* Tabs */}
            <div className="border-b border-gray-200">
              <div className="flex">
                <button
                  onClick={() => setActiveTab('details')}
                  className={`flex items-center gap-2 px-6 py-3 font-medium border-b-2 transition-colors ${
                    activeTab === 'details'
                      ? 'border-primary-500 text-primary-600'
                      : 'border-transparent text-gray-600 hover:text-gray-900'
                  }`}
                >
                  <FileText className="h-4 w-4" />
                  Davetiye Bilgileri
                </button>
                <button
                  onClick={() => setActiveTab('guests')}
                  className={`flex items-center gap-2 px-6 py-3 font-medium border-b-2 transition-colors ${
                    activeTab === 'guests'
                      ? 'border-primary-500 text-primary-600'
                      : 'border-transparent text-gray-600 hover:text-gray-900'
                  }`}
                >
                  <Users className="h-4 w-4" />
                  Davetli Listesi
                </button>
              </div>
            </div>

            <div className="p-6">
              {/* Details Tab */}
              {activeTab === 'details' && (
                <div className="space-y-6">
              {/* Title */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Etkinlik Başlığı
                </label>
                <input
                  type="text"
                  name="title"
                  value={formData.title}
                  onChange={handleInputChange}
                  className="input-field"
                  placeholder="Örn: Sevgi & Ahmet Düğünü"
                  maxLength={40}
                />
                <p className="text-xs text-gray-500 mt-1">
                  {formData.title.length}/40 karakter
                </p>
              </div>

              {/* Date & Time */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Etkinlik Tarihi
                  </label>
                  <input
                    type="date"
                    name="eventDate"
                    value={formData.eventDate}
                    onChange={handleInputChange}
                    className="input-field"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Etkinlik Saati
                  </label>
                  <input
                    type="time"
                    name="eventTime"
                    value={formData.eventTime}
                    onChange={handleInputChange}
                    className="input-field"
                  />
                </div>
              </div>

              {/* Location */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Konum / Adres
                </label>
                <input
                  type="text"
                  name="location"
                  value={formData.location}
                  onChange={handleInputChange}
                  className="input-field"
                  placeholder="Örn: Grand Hotel, İstanbul"
                  maxLength={60}
                />
                <p className="text-xs text-gray-500 mt-1">
                  {formData.location.length}/60 karakter
                </p>
              </div>

              {/* Custom Message */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Özel Mesaj (İsteğe bağlı)
                </label>
                <textarea
                  name="customMessage"
                  value={formData.customMessage}
                  onChange={handleInputChange}
                  className="input-field resize-none"
                  rows={3}
                  placeholder="Örn: Mutluluğumuzu paylaşmak istiyoruz"
                  maxLength={100}
                />
                <p className="text-xs text-gray-500 mt-1">
                  {formData.customMessage.length}/100 karakter
                </p>
              </div>

              {/* Image Upload */}
              {invitation && user && (
                <div className="border-t pt-6">
                  <ImageUpload
                    invitationId={invitation.id}
                    userId={user.id}
                    currentImageUrl={formData.imageUrl}
                    currentPosition={formData.imagePosition}
                    onImageUploaded={(imageUrl) => {
                      setFormData({ ...formData, imageUrl });
                    }}
                    onImageRemoved={() => {
                      setFormData({ ...formData, imageUrl: null });
                    }}
                    onPositionChange={(position) => {
                      setFormData({ ...formData, imagePosition: position });
                    }}
                  />
                </div>
              )}

              {/* Color Customization */}
              <div className="border-t pt-6">
                <ColorPicker
                  colors={colors}
                  onChange={setColors}
                />
              </div>
                </div>
              )}

              {/* Guests Tab */}
              {activeTab === 'guests' && invitation && (
                <GuestList 
                  invitationId={invitation.id}
                  invitationTitle={invitation.title}
                />
              )}
            </div>
          </div>

          {/* Preview Panel */}
          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-semibold text-gray-900">
                Önizleme
              </h2>
              <div className="text-sm text-gray-500">
                A4 Format - Yazdırmaya Hazır
              </div>
            </div>

            {/* Live Preview */}
            <div 
              className="rounded-lg shadow-lg overflow-hidden relative"
              style={{
                minHeight: '600px',
                background: formData.imagePosition === 'background' && formData.imageUrl
                  ? `url(${formData.imageUrl})` 
                  : `linear-gradient(135deg, ${colors.primary} 0%, ${colors.secondary} 100%)`,
                backgroundSize: 'cover',
                backgroundPosition: 'center'
              }}
            >
              {/* Gradient overlay for background image */}
              {formData.imagePosition === 'background' && formData.imageUrl && (
                <div 
                  className="absolute inset-0" 
                  style={{ 
                    background: `linear-gradient(135deg, ${colors.primary}CC 0%, ${colors.secondary}CC 100%)`
                  }}
                />
              )}
              
              {/* Watermark - bottom right */}
              {formData.imagePosition === 'watermark' && formData.imageUrl && (
                <img
                  src={formData.imageUrl}
                  alt="Logo"
                  className="absolute bottom-4 right-4 w-16 h-16 object-contain opacity-60"
                />
              )}
              
              <div className="p-8 md:p-12 flex items-center justify-center min-h-[600px] relative z-10">
                <div className="text-center space-y-4 max-w-sm">
                  {/* Banner Image - top */}
                  {formData.imagePosition === 'banner' && formData.imageUrl && (
                    <div className="mb-6 -mx-8 -mt-8 mb-8">
                      <img
                        src={formData.imageUrl}
                        alt="Banner"
                        className="w-full h-32 object-cover"
                      />
                    </div>
                  )}
                  
                  {/* Profile Image - circular */}
                  {formData.imagePosition === 'profile' && formData.imageUrl && (
                    <div className="mb-6">
                      <img
                        src={formData.imageUrl}
                        alt="Profil"
                        className="w-32 h-32 md:w-40 md:h-40 object-cover rounded-full mx-auto border-4"
                        style={{ borderColor: colors.accent }}
                      />
                    </div>
                  )}
                  
                  {/* Title */}
                  <div 
                    className="text-2xl md:text-4xl font-serif font-bold"
                    style={{ color: colors.text }}
                  >
                    {formData.title || 'Etkinlik Başlığı'}
                  </div>
                  
                  {/* Accent Divider */}
                  <div 
                    className="w-24 h-1 mx-auto rounded-full"
                    style={{ backgroundColor: colors.accent }}
                  />
                  
                  {/* Date & Time Card */}
                  <div 
                    className="p-4 rounded-lg"
                    style={{ 
                      backgroundColor: colors.background,
                      color: colors.primary
                    }}
                  >
                    <div className="font-medium">
                      {formData.eventDate ? new Date(formData.eventDate).toLocaleDateString('tr-TR', {
                        weekday: 'long',
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric'
                      }) : 'Tarih Seçin'}
                    </div>
                    <div className="mt-1">
                      {formData.eventTime || 'Saat Seçin'}
                    </div>
                  </div>
                  
                  {/* Accent Divider */}
                  <div 
                    className="w-24 h-1 mx-auto rounded-full"
                    style={{ backgroundColor: colors.accent }}
                  />
                  
                  {/* Location */}
                  <div style={{ color: colors.text, opacity: 0.95 }}>
                    {formData.location || 'Konum Belirtin'}
                  </div>
                  
                  {/* Custom Message */}
                  {formData.customMessage && (
                    <>
                      <div 
                        className="w-16 h-1 mx-auto rounded-full"
                        style={{ backgroundColor: colors.accent }}
                      />
                      <div 
                        className="text-sm italic p-4 rounded-lg"
                        style={{ 
                          backgroundColor: colors.background,
                          color: colors.primary,
                          border: `2px solid ${colors.accent}`
                        }}
                      >
                        "{formData.customMessage}"
                      </div>
                    </>
                  )}

                  {/* Decorative Footer */}
                  <div 
                    className="mt-12 pt-8"
                    style={{ 
                      borderTop: `2px solid ${colors.accent}40`,
                      color: colors.text
                    }}
                  >
                    <p className="text-lg italic opacity-90">
                      Sizleri aramızda görmekten mutluluk duyarız
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <div className="mt-6 text-center text-sm text-gray-500">
              ⚡ Gerçek zamanlı önizleme - Değişiklikler anında görünür
            </div>
          </div>
        </div>
      </div>

      {/* Preview Modal */}
      <PreviewModal
        isOpen={isPreviewOpen}
        onClose={() => setIsPreviewOpen(false)}
        invitation={invitation}
        invitationData={{
          title: formData.title,
          eventDate: formData.eventDate,
          eventTime: formData.eventTime,
          location: formData.location,
          message: formData.customMessage,
          imageUrl: formData.imageUrl,
          imagePosition: formData.imagePosition
        }}
        colors={colors}
      />
    </div>
  );
};

export default EditorPage;
