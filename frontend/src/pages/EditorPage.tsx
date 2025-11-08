import React, { useEffect, useState, useRef } from 'react';
import { useParams, useNavigate, useSearchParams } from 'react-router-dom';
import { ArrowLeft, Download, Share2, Eye, Save, Palette, Loader2, FileText, Users, QrCode } from 'lucide-react';
import { mediaService, type Media } from '../services/mediaService';
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
import { validateTitle, validateLocation, validateTime, validateFutureDate } from '../utils/validation';

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
  const [qrMedia, setQrMedia] = useState<Media | null>(null);
  
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

  // Store template's original design for reset
  const [templateOriginalDesign, setTemplateOriginalDesign] = useState<{
    colors?: typeof colors;
    imageUrl?: string | null;
    imagePosition?: typeof formData.imagePosition;
  } | null>(null);

  const [selectedFont, setSelectedFont] = useState('normal');
  const [showQrOnDesign, setShowQrOnDesign] = useState(false);
  const [qrPosition, setQrPosition] = useState<'top-left' | 'top-right' | 'bottom-left' | 'bottom-right'>('top-right');
  const [qrSize, setQrSize] = useState<number>(96);

  // Form validation errors
  const [errors, setErrors] = useState({
    title: '',
    eventDate: '',
    eventTime: '',
    location: ''
  });

  // Load template or invitation
  useEffect(() => {
    if (!isAuthenticated) {
      toast.error('Davetiye oluşturmak için giriş yapmalısınız');
      navigate('/auth');
      return;
    }
    
    loadData();
  }, [invitationId, searchParams, isAuthenticated]);

  // Debug: Log formData changes
  useEffect(() => {
    console.log('🖼️ FormData updated:');
    console.log('  - imagePosition:', formData.imagePosition);
    console.log('  - imageUrl:', formData.imageUrl);
    console.log('  - Should show background?', formData.imagePosition === 'background' && formData.imageUrl);
  }, [formData.imageUrl, formData.imagePosition]);

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
        // Load existing QR media (optional)
        try {
          const media = await mediaService.getMediaByInvitationId(invitationData.id);
          setQrMedia(media);
        } catch {}
        setTemplate(invitationData.template);
        
        console.log('📝 Loading invitation data...');
        console.log('📸 Invitation image_url:', invitationData.image_url);
        console.log('📍 Invitation imagePosition:', invitationData.content?.imagePosition);
        
        // Store template's original design for reset functionality
        if (invitationData.template) {
          const templateDesign = invitationData.template.design_config || {};
          const templateImageUrl = templateDesign.backgroundImage || invitationData.template.preview_image_url || null;
          const templateImagePosition = templateDesign.imagePosition || 'background';
          const templateColors = templateDesign.colors ? {
            primary: templateDesign.colors.primary || '#667eea',
            secondary: templateDesign.colors.secondary || '#764ba2',
            background: templateDesign.colors.background || '#ffffff',
            text: templateDesign.colors.text || '#ffffff',
            accent: templateDesign.colors.accent || '#f56565'
          } : undefined;
          
          setTemplateOriginalDesign({
            colors: templateColors,
            imageUrl: templateImageUrl,
            imagePosition: templateImagePosition
          });
        }
        
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
        
        // Load QR settings if exists
        if (invitationData.settings) {
          if (typeof invitationData.settings.showQrOnDesign === 'boolean') {
            setShowQrOnDesign(invitationData.settings.showQrOnDesign);
          }
          if (invitationData.settings.qrPosition) {
            setQrPosition(invitationData.settings.qrPosition);
          }
          if (invitationData.settings.qrSize) {
            setQrSize(invitationData.settings.qrSize);
          }
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
        
        // Şablon erişim kontrolü - Kullanıcının bu tier'a erişimi var mı?
        const templateTier = templateData.tier as 'free' | 'pro' | 'premium';
        if (!subscription.canAccessTemplate(templateTier)) {
          const tierNames = { free: 'Ücretsiz', pro: 'PRO', premium: 'PREMIUM' };
          toast.error(`Bu şablon ${tierNames[templateTier]} plan gerektirir!`);
          navigate('/templates');
          isCreatingRef.current = false;
          return;
        }
        
        setTemplate(templateData);
        
        // Load template design configuration
        const templateDesign = templateData.design_config || {};
        console.log('🎨 Template design config:', templateDesign);
        
        // Apply template colors if exists
        const templateColors = templateDesign.colors ? {
          primary: templateDesign.colors.primary || '#667eea',
          secondary: templateDesign.colors.secondary || '#764ba2',
          background: templateDesign.colors.background || '#ffffff',
          text: templateDesign.colors.text || '#ffffff',
          accent: templateDesign.colors.accent || '#f56565'
        } : null;
        
        if (templateColors) {
          setColors(templateColors);
        }
        
        // Apply template background image and position
        // Use design_config.backgroundImage if available, otherwise use preview_image_url
        const templateImageUrl = templateDesign.backgroundImage || templateData.preview_image_url || null;
        const templateImagePosition = templateDesign.imagePosition || 'background';
        
        // Store original design for reset
        setTemplateOriginalDesign({
          colors: templateColors || undefined,
          imageUrl: templateImageUrl,
          imagePosition: templateImagePosition
        });
        
        console.log('📸 Template image URL:', templateImageUrl);
        console.log('📍 Template image position:', templateImagePosition);
        
        // Set default form data with template info
        setFormData({
          title: `${templateData.category?.name || 'Etkinlik'} Davetiyesi`,
          eventDate: '',
          eventTime: '',
          location: '',
          customMessage: `${templateData.name} ile hazırlanan özel davetiyenize hoş geldiniz.`,
          imageUrl: templateImageUrl,
          imagePosition: templateImagePosition
        });
        
        // Create new invitation with template design
        const newInvitation = await invitationService.createInvitation({
          template_id: templateData.id,
          title: `${templateData.category?.name || 'Etkinlik'} Davetiyesi`,
          event_type: templateData.category?.slug || '',
          image_url: templateImageUrl,
          content: {
            colors: templateDesign.colors || colors,
            imagePosition: templateImagePosition,
            message: `${templateData.name} ile hazırlanan özel davetiyenize hoş geldiniz.`
          }
        });
        
        console.log('✅ New invitation created with image_url:', newInvitation?.image_url);
        
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
    const { name, value } = e.target;
    
    setFormData({
      ...formData,
      [name]: value
    });

    // Clear error for this field when user starts typing
    if (errors[name as keyof typeof errors]) {
      setErrors({
        ...errors,
        [name]: ''
      });
    }
  };

  // Real-time validation on blur
  const handleBlur = (e: React.FocusEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    const newErrors = { ...errors };

    switch (name) {
      case 'title':
        const titleResult = validateTitle(value, 3, 40);
        newErrors.title = titleResult.isValid ? '' : titleResult.error!;
        break;
      case 'eventDate':
        const dateResult = validateFutureDate(value);
        newErrors.eventDate = dateResult.isValid ? '' : dateResult.error!;
        break;
      case 'eventTime':
        const timeResult = validateTime(value);
        newErrors.eventTime = timeResult.isValid ? '' : timeResult.error!;
        break;
      case 'location':
        const locationResult = validateLocation(value);
        newErrors.location = locationResult.isValid ? '' : locationResult.error!;
        break;
    }

    setErrors(newErrors);
  };

  // Validate form before saving
  const validateForm = (): boolean => {
    const newErrors = {
      title: '',
      eventDate: '',
      eventTime: '',
      location: ''
    };

    // Title validation (required)
    const titleResult = validateTitle(formData.title, 3, 40);
    if (!titleResult.isValid) {
      newErrors.title = titleResult.error!;
    }

    // Date validation (optional, but must be future if provided)
    if (formData.eventDate) {
      const dateResult = validateFutureDate(formData.eventDate);
      if (!dateResult.isValid) {
        newErrors.eventDate = dateResult.error!;
      }
    }

    // Time validation (optional, but must be valid format if provided)
    if (formData.eventTime) {
      const timeResult = validateTime(formData.eventTime);
      if (!timeResult.isValid) {
        newErrors.eventTime = timeResult.error!;
      }
    }

    // Location validation (optional)
    if (formData.location) {
      const locationResult = validateLocation(formData.location);
      if (!locationResult.isValid) {
        newErrors.location = locationResult.error!;
      }
    }

    setErrors(newErrors);

    // Check if there are any errors
    const hasErrors = Object.values(newErrors).some(error => error !== '');
    
    if (hasErrors) {
      const firstError = Object.values(newErrors).find(error => error !== '');
      toast.error(firstError || 'Lütfen formu kontrol edin', { duration: 5000 });
    }

    return !hasErrors;
  };

  const handleSave = async () => {
    if (!invitation) return;
    
    // Validate form before saving
    if (!validateForm()) {
      return;
    }
    
    setIsSaving(true);
    
    try {
      const updated = await invitationService.updateInvitation(invitation.id, {
        title: formData.title,
        event_date: formData.eventDate || undefined,
        event_time: formData.eventTime || undefined,
        event_location_name: formData.location || undefined,
        image_url: formData.imageUrl || undefined,
        content: {
          message: formData.customMessage,
          colors: colors,
          imagePosition: formData.imagePosition
        },
        custom_design: {
          font: selectedFont
        },
        settings: {
          showQrOnDesign: showQrOnDesign,
          qrPosition: qrPosition,
          qrSize: qrSize
        }
      });
      
      if (updated) {
        setInvitation(updated);
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
    
    // Yayınlama sırasında kullanım hakkı kontrolü (FREE ve PRO için)
    if (newStatus === 'published' && invitation.status === 'draft') {
      // PREMIUM kullanıcılar sınırsız, kontrol yapma
      if (subscription.currentPlan !== 'premium') {
        const canCreate = await subscription.canCreateInvitation();
        
        if (!canCreate.allowed) {
          toast.error(canCreate.reason || 'Davetiye yayınlama hakkınız kalmadı!');
          navigate('/pricing');
          return;
        }
      }
    }
    
    try {
      const updated = await invitationService.updateInvitation(invitation.id, {
        status: newStatus
      });
      
      if (updated) {
        setInvitation(updated);
        
        // Yayınlama başarılı, subscription'ı güncelle
        if (newStatus === 'published' && invitation.status === 'draft') {
          // Subscription service'in counter'ını güncelle
          await subscription.refreshSubscription();
        } else {
          toast.success(`Davetiye ${statusText}`);
        }
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

  const handleResetToTemplate = () => {
    if (!templateOriginalDesign) {
      toast.error('Şablon bilgisi bulunamadı');
      return;
    }

    // Reset colors
    if (templateOriginalDesign.colors) {
      setColors(templateOriginalDesign.colors);
    }

    // Reset image
    setFormData({
      ...formData,
      imageUrl: templateOriginalDesign.imageUrl || null,
      imagePosition: templateOriginalDesign.imagePosition || 'background'
    });

    toast.success('Şablon varsayılanlarına dönüldü');
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
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-blue-50/20 to-purple-50/20">
      {/* Header - Modern & Minimalist */}
      <div className="bg-white/80 backdrop-blur-md border-b border-gray-200/50 sticky top-0 z-10 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            {/* Left: Back Button & Title */}
            <div className="flex items-center gap-4">
              <button
                onClick={() => navigate('/dashboard')}
                className="p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-all"
                title="Dashboard'a Dön"
              >
                <ArrowLeft className="h-5 w-5" />
              </button>
              <div className="hidden sm:block">
                <h1 className="text-lg font-bold text-gray-900">
                  {template.name}
                </h1>
                <div className="flex items-center gap-2 text-xs text-gray-500">
                  {invitation.status === 'draft' && <span className="px-2 py-0.5 bg-yellow-100 text-yellow-700 rounded-full">Taslak</span>}
                  {invitation.status === 'published' && <span className="px-2 py-0.5 bg-green-100 text-green-700 rounded-full">Yayında</span>}
                  {invitation.updated_at && <span>• {new Date(invitation.updated_at).toLocaleString('tr-TR', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' })}</span>}
                </div>
              </div>
            </div>

            {/* Right: Action Buttons - Responsive */}
            <div className="flex items-center gap-2">
              {/* Save Button */}
              <button
                onClick={handleSave}
                disabled={isSaving}
                className="p-2 sm:px-4 sm:py-2 bg-white border border-gray-300 hover:bg-gray-50 text-gray-700 rounded-lg transition-all disabled:opacity-50 flex items-center gap-2"
                title="Kaydet"
              >
                {isSaving ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />}
                <span className="hidden sm:inline">{isSaving ? 'Kaydediliyor...' : 'Kaydet'}</span>
              </button>
              
              {/* Publish/Unpublish Button */}
              <button
                onClick={handleTogglePublish}
                className={`p-2 sm:px-4 sm:py-2 rounded-lg font-medium transition-all flex items-center gap-2 ${
                  invitation.status === 'published' 
                    ? 'bg-green-50 text-green-700 border border-green-300 hover:bg-green-100' 
                    : 'bg-primary-50 text-primary-700 border border-primary-300 hover:bg-primary-100'
                }`}
                title={invitation.status === 'published' ? 'Yayında' : 'Yayınla'}
              >
                {invitation.status === 'published' ? '✓' : '📝'}
                <span className="hidden md:inline">{invitation.status === 'published' ? 'Yayında' : 'Yayınla'}</span>
              </button>
              
              {/* Preview Button */}
              <button
                onClick={handlePreview}
                className="p-2 sm:px-3 sm:py-2 text-gray-700 hover:bg-gray-100 rounded-lg transition-all"
                title="Önizle"
              >
                <Eye className="h-4 w-4" />
              </button>
              
              {/* Share Button */}
              <button
                onClick={invitation.status === 'published' ? handleShare : undefined}
                disabled={invitation.status !== 'published'}
                className={`p-2 sm:px-3 sm:py-2 rounded-lg transition-all ${
                  invitation.status === 'published'
                    ? 'text-gray-700 hover:bg-gray-100 cursor-pointer'
                    : 'text-gray-400 bg-gray-50 cursor-not-allowed'
                }`}
                title={invitation.status === 'published' ? 'Paylaş' : 'Paylaşmak için önce yayınlayın'}
              >
                <Share2 className="h-4 w-4" />
              </button>
              
              {/* Download Button */}
              <button
                onClick={invitation.status === 'published' ? handleDownload : undefined}
                disabled={invitation.status !== 'published'}
                className={`p-2 rounded-lg transition-all shadow-sm ${
                  invitation.status === 'published'
                    ? 'bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white hover:shadow-md cursor-pointer'
                    : 'bg-gray-200 text-gray-400 cursor-not-allowed'
                }`}
                title={invitation.status === 'published' ? 'İndir' : 'İndirmek için önce yayınlayın'}
              >
                <Download className="h-4 w-4" />
              </button>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Editor Panel - Modern & Minimalist */}
          <div className="bg-white rounded-2xl shadow-sm border border-gray-200/50 overflow-hidden">
            {/* Tabs - Modern Design */}
            <div className="bg-gray-50/50 border-b border-gray-200/50">
              <div className="flex p-2 gap-2">
                <button
                  onClick={() => setActiveTab('details')}
                  className={`flex-1 flex items-center justify-center gap-2 px-4 py-2.5 font-medium rounded-lg transition-all ${
                    activeTab === 'details'
                      ? 'bg-white text-primary-600 shadow-sm'
                      : 'text-gray-600 hover:text-gray-900 hover:bg-white/50'
                  }`}
                >
                  <FileText className="h-4 w-4" />
                  <span className="hidden sm:inline">Davetiye</span>
                </button>
                <button
                  onClick={() => setActiveTab('guests')}
                  className={`flex-1 flex items-center justify-center gap-2 px-4 py-2.5 font-medium rounded-lg transition-all ${
                    activeTab === 'guests'
                      ? 'bg-white text-primary-600 shadow-sm'
                      : 'text-gray-600 hover:text-gray-900 hover:bg-white/50'
                  }`}
                >
                  <Users className="h-4 w-4" />
                  <span className="hidden sm:inline">Davetliler</span>
                </button>
              </div>
            </div>

            <div className="p-4 sm:p-6 max-h-[calc(100vh-200px)] overflow-y-auto">
              {/* Details Tab */}
              {activeTab === 'details' && (
                <div className="space-y-4">
              {/* Title - Compact */}
              <div>
                <label className="block text-xs font-bold text-gray-900 mb-1.5">
                  ✏️ Etkinlik Başlığı <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  name="title"
                  value={formData.title}
                  onChange={handleInputChange}
                  onBlur={handleBlur}
                  className={`w-full px-3 py-2 border-2 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all text-sm ${
                    errors.title ? 'border-red-500 focus:ring-red-500' : 'border-gray-200'
                  }`}
                  placeholder="Örn: Sevgi & Ahmet Düğünü"
                  maxLength={40}
                  required
                />
                {errors.title ? (
                  <p className="text-xs text-red-600 mt-1 flex items-center gap-1">
                    <span>⚠️</span> {errors.title}
                  </p>
                ) : (
                  <p className="text-xs text-gray-500 mt-1">
                    {formData.title.length}/40 karakter
                  </p>
                )}
              </div>

              {/* Date & Time - Compact */}
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-bold text-gray-900 mb-1.5">
                    📅 Tarih
                  </label>
                  <input
                    type="date"
                    name="eventDate"
                    value={formData.eventDate}
                    onChange={handleInputChange}
                    onBlur={handleBlur}
                    className={`w-full px-3 py-2 border-2 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all text-sm ${
                      errors.eventDate ? 'border-red-500 focus:ring-red-500' : 'border-gray-200'
                    }`}
                    min={new Date().toISOString().split('T')[0]}
                  />
                  {errors.eventDate && (
                    <p className="text-xs text-red-600 mt-1 flex items-center gap-1">
                      <span>⚠️</span> {errors.eventDate}
                    </p>
                  )}
                </div>
                <div>
                  <label className="block text-xs font-bold text-gray-900 mb-1.5">
                    🕐 Saat
                  </label>
                  <input
                    type="time"
                    name="eventTime"
                    value={formData.eventTime}
                    onChange={handleInputChange}
                    onBlur={handleBlur}
                    className={`w-full px-3 py-2 border-2 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all text-sm ${
                      errors.eventTime ? 'border-red-500 focus:ring-red-500' : 'border-gray-200'
                    }`}
                  />
                  {errors.eventTime && (
                    <p className="text-xs text-red-600 mt-1 flex items-center gap-1">
                      <span>⚠️</span> {errors.eventTime}
                    </p>
                  )}
                </div>
              </div>

              {/* Location - Compact */}
              <div>
                <label className="block text-xs font-bold text-gray-900 mb-1.5">
                  📍 Konum / Adres
                </label>
                <input
                  type="text"
                  name="location"
                  value={formData.location}
                  onChange={handleInputChange}
                  onBlur={handleBlur}
                  className={`w-full px-3 py-2 border-2 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all text-sm ${
                    errors.location ? 'border-red-500 focus:ring-red-500' : 'border-gray-200'
                  }`}
                  placeholder="Örn: Grand Hotel, İstanbul"
                  maxLength={60}
                />
                {errors.location ? (
                  <p className="text-xs text-red-600 mt-1 flex items-center gap-1">
                    <span>⚠️</span> {errors.location}
                  </p>
                ) : (
                  <p className="text-xs text-gray-500 mt-1">
                    {formData.location.length}/60 karakter
                  </p>
                )}
              </div>

              {/* Custom Message - Compact */}
              <div>
                <label className="block text-xs font-bold text-gray-900 mb-1.5">
                  💬 Özel Mesaj <span className="text-gray-500 text-xs font-normal">(İsteğe bağlı)</span>
                </label>
                <textarea
                  name="customMessage"
                  value={formData.customMessage}
                  onChange={handleInputChange}
                  className="w-full px-3 py-2 border-2 border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all resize-none text-sm"
                  rows={3}
                  placeholder="Örn: Mutluluğumuzu paylaşmak istiyoruz"
                  maxLength={100}
                />
                <p className="text-xs text-gray-500 mt-1">
                  {formData.customMessage.length}/100 karakter
                </p>
              </div>

              {/* Image Upload - Compact */}
              {invitation && user && (
                <div className="border-t border-gray-200/50 pt-4">
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

              {/* Reset to Template Button - Compact */}
              {templateOriginalDesign && (
                <div className="border-t border-gray-200/50 pt-4">
                  <button
                    onClick={handleResetToTemplate}
                    className="w-full flex items-center justify-between p-2.5 bg-gradient-to-r from-amber-50 to-orange-50 hover:from-amber-100 hover:to-orange-100 border border-amber-200 rounded-lg transition-all group"
                  >
                    <div className="flex items-center gap-2">
                      <div className="bg-amber-200 rounded-lg p-1.5">
                        <Palette className="h-3.5 w-3.5 text-amber-700" />
                      </div>
                      <div className="text-left">
                        <p className="text-xs font-bold text-amber-900">Varsayılana Dön</p>
                        <p className="text-xs text-amber-700">Şablonun orijinal tasarımı</p>
                      </div>
                    </div>
                    <span className="text-amber-700 group-hover:text-amber-900 transition-colors text-lg">↻</span>
                  </button>
                </div>
              )}

              {/* Color Customization - Compact */}
              <div className="border-t border-gray-200/50 pt-4">
                <div className="mb-3 flex items-center gap-2">
                  <Palette className="h-4 w-4 text-gray-700" />
                  <h3 className="text-xs font-bold text-gray-900">Renk Özelleştirme</h3>
                </div>
                <ColorPicker
                  colors={colors}
                  onChange={setColors}
                  defaultColors={templateOriginalDesign?.colors}
                />
              </div>

              {/* QR Media (Optional) - Ultra Compact & Modern */}
              <div className="border-t border-gray-200/50 pt-4">
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center gap-2">
                    <div className="p-1.5 bg-gradient-to-br from-purple-100 to-pink-100 rounded-lg">
                      <QrCode className="h-3.5 w-3.5 text-purple-700" />
                    </div>
                    <h3 className="text-xs font-bold text-gray-900">QR Medya <span className="text-xs text-gray-500 font-normal">(Opsiyonel)</span></h3>
                  </div>
                  {qrMedia && (
                    <div className="flex items-center gap-2">
                      <button
                        onClick={invitation.status === 'published' ? () => navigate(`/media/manage?invitationId=${invitation.id}`) : undefined}
                        disabled={invitation.status !== 'published'}
                        className={`px-3 py-1.5 rounded-lg font-semibold transition-all text-xs ${
                          invitation.status === 'published'
                            ? 'bg-white hover:bg-gray-50 text-gray-700 border border-gray-300 hover:border-primary-300'
                            : 'bg-gray-100 text-gray-400 cursor-not-allowed'
                        }`}
                        title={invitation.status === 'published' ? 'QR Medya Yönet' : 'Yayınlamadan QR yönetilemez'}
                      >
                        Yönet
                      </button>
                      <button
                        onClick={invitation.status === 'published' ? () => navigate(`/media/upload?invitationId=${invitation.id}`) : undefined}
                        disabled={invitation.status !== 'published'}
                        className={`px-3 py-1.5 rounded-lg font-semibold transition-all text-xs shadow-sm ${
                          invitation.status === 'published'
                            ? 'bg-gradient-to-r from-primary-600 to-primary-700 hover:from-primary-700 hover:to-primary-800 text-white hover:shadow-md'
                            : 'bg-gray-200 text-gray-400 cursor-not-allowed'
                        }`}
                        title={invitation.status === 'published' ? 'QR Medya Güncelle' : 'Yayınlamadan QR güncellenemez'}
                      >
                        Güncelle
                      </button>
                    </div>
                  )}
                </div>
                {qrMedia ? (
                  <div className="mt-3 p-3 bg-gradient-to-br from-purple-50/50 to-pink-50/50 rounded-xl border border-purple-200/30">
                    <div className="flex items-center justify-between mb-3">
                      <div className="flex-1 min-w-0">
                        <p className="text-xs font-bold text-gray-700 mb-0.5">QR Kod</p>
                        <p className="font-mono text-xs text-gray-600 truncate">{qrMedia.qr_code}</p>
                      </div>
                      {qrMedia.qr_image_url && (
                        <img src={qrMedia.qr_image_url} alt="QR" className="w-16 h-16 object-contain rounded-lg bg-white p-1 shadow-sm ml-3" />
                      )}
                    </div>
                    
                    {/* Stats - Compact */}
                    <div className="flex items-center gap-3 text-xs text-gray-600 mb-3 pb-3 border-b border-purple-200/30">
                      <span className="flex items-center gap-1">
                        📦 {qrMedia.storage_plan === '1_year' ? '1 yıl' : '3 ay'}
                      </span>
                      <span className="flex items-center gap-1">
                        👁️ {qrMedia.view_count}
                      </span>
                      <span className="flex items-center gap-1">
                        📱 {qrMedia.scan_count}
                      </span>
                    </div>

                    {/* Guest Upload Status */}
                    <div className="mb-3">
                      <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-semibold ${
                        qrMedia.allow_guest_upload 
                          ? 'bg-green-100 text-green-700' 
                          : 'bg-gray-100 text-gray-600'
                      }`}>
                        {qrMedia.allow_guest_upload ? '✓ Davetli yüklemeleri açık' : '✗ Davetli yüklemeleri kapalı'}
                      </span>
                    </div>

                    {/* Show QR on Design Toggle */}
                    <label className="flex items-center gap-2 cursor-pointer group">
                      <input 
                        type="checkbox" 
                        checked={showQrOnDesign} 
                        onChange={() => setShowQrOnDesign(!showQrOnDesign)}
                        className="w-4 h-4 text-primary-600 bg-white border-gray-300 rounded focus:ring-2 focus:ring-primary-500 transition-all"
                      />
                      <span className="text-xs font-semibold text-gray-700 group-hover:text-gray-900 transition-colors">
                        Davetiyede QR kodu göster
                      </span>
                    </label>

                    {/* QR Position & Size - Compact */}
                    {showQrOnDesign && (
                      <div className="mt-3 pt-3 border-t border-purple-200/30 space-y-3">
                        <div>
                          <label className="block text-xs font-bold text-gray-700 mb-1.5">Konum</label>
                          <select
                            className="w-full px-3 py-2 border-2 border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all text-xs"
                            value={qrPosition}
                            onChange={(e) => setQrPosition(e.target.value as any)}
                          >
                            <option value="top-left">Sol Üst</option>
                            <option value="top-right">Sağ Üst</option>
                            <option value="bottom-left">Sol Alt</option>
                            <option value="bottom-right">Sağ Alt</option>
                          </select>
                        </div>
                        <div>
                          <label className="block text-xs font-bold text-gray-700 mb-1.5">
                            Boyut: <span className="text-primary-600">{qrSize}px</span>
                          </label>
                          <input
                            type="range"
                            min={72}
                            max={160}
                            step={4}
                            value={qrSize}
                            onChange={(e) => setQrSize(Number(e.target.value))}
                            className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-primary-600"
                          />
                          <div className="flex justify-between text-xs text-gray-500 mt-1">
                            <span>72px</span>
                            <span>160px</span>
                          </div>
                        </div>
                      </div>
                    )}
                  </div>
                ) : (
                  <div className="mt-3 p-3 bg-gradient-to-br from-amber-50/50 to-orange-50/50 rounded-lg border border-amber-200/30">
                    <div className="flex items-start gap-2 mb-2">
                      <span className="text-lg">ℹ️</span>
                      <div className="flex-1">
                        <p className="text-xs font-semibold text-gray-900 mb-1">
                          QR Medya Henüz Oluşturulmadı
                        </p>
                        <p className="text-xs text-gray-600">
                          {invitation.status === 'published' 
                            ? 'QR medya oluşturarak davetlilerinizin fotoğraf ve video paylaşmasını sağlayabilirsiniz.' 
                            : 'QR medya oluşturmak için önce davetiyeyi yayınlamanız gerekiyor.'}
                        </p>
                      </div>
                    </div>
                    {invitation.status === 'published' && (
                      <button
                        onClick={() => navigate(`/media/upload?invitationId=${invitation.id}`)}
                        className="w-full mt-2 px-3 py-2 bg-gradient-to-r from-primary-600 to-primary-700 hover:from-primary-700 hover:to-primary-800 text-white font-semibold rounded-lg shadow-sm hover:shadow-md transition-all text-xs"
                      >
                        QR Medya Oluştur
                      </button>
                    )}
                  </div>
                )}
              </div>
                </div>
              )}

              {/* Guests Tab */}
              {activeTab === 'guests' && invitation && (
                <GuestList 
                  invitationId={invitation.id}
                  invitationTitle={invitation.title}
                  invitationStatus={invitation.status}
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
                backgroundImage: formData.imagePosition === 'background' && formData.imageUrl
                  ? `url(${formData.imageUrl})` 
                  : `linear-gradient(135deg, ${colors.primary} 0%, ${colors.secondary} 100%)`,
                backgroundSize: 'cover',
                backgroundPosition: 'center'
              }}
            >
              {/* Show QR on design */}
              {showQrOnDesign && qrMedia?.qr_image_url && (
                <img
                  src={qrMedia.qr_image_url}
                  alt="QR"
                  style={{ width: `${qrSize}px`, height: `${qrSize}px` }}
                  className={
                    `absolute bg-white p-2 rounded-md shadow ` +
                    (qrPosition === 'top-left' ? 'top-4 left-4' : '') +
                    (qrPosition === 'top-right' ? 'top-4 right-4' : '') +
                    (qrPosition === 'bottom-left' ? 'bottom-4 left-4' : '') +
                    (qrPosition === 'bottom-right' ? 'bottom-4 right-4' : '')
                  }
                />
              )}
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
        qrData={showQrOnDesign && qrMedia?.qr_image_url ? {
          qrImageUrl: qrMedia.qr_image_url,
          qrPosition: qrPosition,
          qrSize: qrSize
        } : null}
      />
    </div>
  );
};

export default EditorPage;
