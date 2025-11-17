/**
 * EditorPageV2 - Professional Canva-style Editor
 * 
 * Layout: 3-Panel Design
 * - Left: Narrow toolbar (tools, zoom, actions)
 * - Center: Large canvas with grid
 * - Right: Properties panel OR Layers panel (tabbed)
 * 
 * Features:
 * - Keyboard shortcuts (Ctrl+Z/Y, Del, Ctrl+D, Arrow keys)
 * - Undo/Redo with history
 * - Canvas size presets (Portrait, Landscape, Square)
 * - Smooth element manipulation (drag, resize, rotate)
 * - Layer management (visibility, lock, reorder)
 * - Inline text editing (double-click)
 * - Mobile responsive with touch support
 */

import React, { useEffect, useState, useRef, useCallback } from 'react';
import { useParams, useNavigate, useSearchParams } from 'react-router-dom';
import { 
  ArrowLeft, Layers as LayersIcon, Settings, Users, Loader2, Palette,
  AlignLeft, AlignCenter, AlignRight, AlignHorizontalJustifyCenter, AlignVerticalJustifyCenter
} from 'lucide-react';
import { mediaService, type Media } from '../services/mediaService';
import { templateService, type Template } from '../services/templateService';
import { invitationService, type Invitation } from '../services/invitationService';
import { useAuth } from '../store/authStore';
import { useSubscription } from '../hooks/useSubscription';
import { useKeyboardShortcuts } from '../hooks/useKeyboardShortcuts';
import { useUndoRedo } from '../hooks/useUndoRedo';
import { pdfService } from '../services/pdfService';
import { Toolbar } from '../components/Editor/Toolbar';
import { LayersPanel, type Layer } from '../components/Editor/LayersPanel';
import { PropertiesPanel, type ElementProperties } from '../components/Editor/PropertiesPanel';
import { DesignPanel } from '../components/Editor/DesignPanel';
import { DraggableElement } from '../components/Editor/DraggableElement';
import { DecorativeElementsGallery } from '../components/Editor/DecorativeElementsGallery';
import PreviewModal from '../components/Editor/PreviewModal';
import GuestList from '../components/Editor/GuestList';
import toast from 'react-hot-toast';
import { ALL_FONTS, type FontFamily, getFontFamily } from '../utils/fonts';
import { getTemplateFullUrl } from '../utils/templateImageUrl';

// Canvas size presets
const CANVAS_PRESETS = {
  portrait: { width: 480, height: 680, label: 'Dikey (A4)' },
  landscape: { width: 680, height: 480, label: 'Yatay (A4)' },
  square: { width: 600, height: 600, label: 'Kare (Instagram)' },
  story: { width: 480, height: 854, label: 'Story (9:16)' }
} as const;

type CanvasPreset = keyof typeof CANVAS_PRESETS;

// Element type for unified state management
interface EditorElement {
  id: string;
  type: 'text' | 'image' | 'decoration' | 'divider';
  name: string;
  content?: string;
  imageUrl?: string;
  position: { x: number; y: number };
  size: { width: number; height: number };
  rotation: number;
  opacity: number;
  visible: boolean;
  locked: boolean;
  zIndex: number;
  style?: {
    fontSize?: number;
    fontWeight?: string;
    fontFamily?: string;
    color?: string;
    textAlign?: 'left' | 'center' | 'right';
    fontStyle?: string;
    textDecoration?: string;
  };
}

const EditorPageV2: React.FC = () => {
  const { templateId: invitationId } = useParams();
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { isAuthenticated, user } = useAuth();
  const subscription = useSubscription();

  // Core state
  const [template, setTemplate] = useState<Template | null>(null);
  const [invitation, setInvitation] = useState<Invitation | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  
  // Canvas state
  const [canvasPreset, setCanvasPreset] = useState<CanvasPreset>('portrait');
  const [zoom, setZoom] = useState(100);
  const [showGrid, setShowGrid] = useState(false);
  const canvasRef = useRef<HTMLDivElement>(null);

  // Editor state
  const [activeTool, setActiveTool] = useState<'select' | 'text' | 'shape'>('select');
  const [elements, setElements] = useState<EditorElement[]>([]);
  const [selectedElementId, setSelectedElementId] = useState<string | null>(null);
  const [rightPanel, setRightPanel] = useState<'design' | 'properties' | 'layers' | 'guests'>('design');
  
  // Image layer ordering per mode (profile/banner/watermark)
  const [imageLayers, setImageLayers] = useState<{ profile: number; banner: number; watermark: number }>({
    profile: 260,
    banner: 240,
    watermark: 280
  });
  // Image transforms for draggable/resizable image (excluding background)
  const [imageTransforms, setImageTransforms] = useState<{
    profile: { position: { x: number; y: number }; size: { width: number; height: number }; rotation: number; opacity: number };
    banner: { position: { x: number; y: number }; size: { width: number; height: number }; rotation: number; opacity: number };
    watermark: { position: { x: number; y: number }; size: { width: number; height: number }; rotation: number; opacity: number };
  }>({
    profile: { position: { x: 50, y: 15 }, size: { width: 160, height: 160 }, rotation: 0, opacity: 1 },
    banner: { position: { x: 50, y: 8 }, size: { width: 600, height: 200 }, rotation: 0, opacity: 1 },
    watermark: { position: { x: 90, y: 90 }, size: { width: 64, height: 64 }, rotation: 0, opacity: 0.6 }
  });
  
  // Undo/Redo
  const undoRedo = useUndoRedo<EditorElement[]>(elements, 50);

  // Modals
  const [isPreviewOpen, setIsPreviewOpen] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isGalleryOpen, setIsGalleryOpen] = useState(false);
  
  // QR Media
  const [qrMedia, setQrMedia] = useState<Media | null>(null);
  const [showQrOnDesign, setShowQrOnDesign] = useState(false);
  const [qrPosition, setQrPosition] = useState<'top-left' | 'top-right' | 'bottom-left' | 'bottom-right'>('top-right');
  const [qrSize, setQrSize] = useState<number>(96);

  // Colors
  const [colors, setColors] = useState({
    primary: '#667eea',
    secondary: '#764ba2',
    background: '#ffffff',
    text: '#ffffff',
    accent: '#f56565'
  });
  
  // Font
  const [selectedFont, setSelectedFont] = useState<FontFamily>('Playfair Display');
  
  // Template original design for reset
  const [templateOriginalDesign, setTemplateOriginalDesign] = useState<{
    colors?: typeof colors;
    imageUrl?: string | null;
    imagePosition?: typeof formData.imagePosition;
  } | null>(null);

  // Form data (for invitation details)
  const [formData, setFormData] = useState({
    title: '',
    eventDate: '',
    eventTime: '',
    location: '',
    customMessage: '',
    imageUrl: '' as string | null,
    imagePosition: 'profile' as 'profile' | 'background' | 'banner' | 'watermark',
    logoShape: 'circle' as 'circle' | 'square'
  });

  // Load data on mount
  useEffect(() => {
    if (!isAuthenticated) {
      toast.error('Davetiye oluşturmak için giriş yapmalısınız');
      navigate('/auth');
      return;
    }
    
    if (subscription.isLoading && user?.id) {
      return;
    }
    
    loadData();
  }, [invitationId, searchParams, isAuthenticated, subscription.isLoading, user?.id]);

  async function loadData() {
    setIsLoading(true);
    
    try {
      if (invitationId) {
        // Load existing invitation
        const invitationData = await invitationService.getInvitation(invitationId);
        
        if (!invitationData) {
          toast.error('Davetiye bulunamadı');
          navigate('/dashboard');
          return;
        }
        
         setInvitation(invitationData);
         setTemplate(invitationData.template);
         
         // Store template's original design for reset
         if (invitationData.template) {
           const templateImageUrl = getTemplateFullUrl(
             invitationData.template.default_image_url || invitationData.template.thumbnail_url
           );
           const templateColors = invitationData.template.color_palette ? {
             primary: invitationData.template.color_palette.primary || '#667eea',
             secondary: invitationData.template.color_palette.secondary || '#764ba2',
             background: invitationData.template.color_palette.background || '#ffffff',
             text: invitationData.template.color_palette.text || '#ffffff',
             accent: invitationData.template.color_palette.accent || '#f56565'
           } : undefined;
           
           setTemplateOriginalDesign({
             colors: templateColors,
             imageUrl: templateImageUrl,
             imagePosition: 'background'
           });
         }
         
         // Load QR media
        try {
          const media = await mediaService.getMediaByInvitationId(invitationData.id);
          setQrMedia(media);
        } catch {}
        
        // Load form data
        setFormData({
          title: invitationData.title || '',
          eventDate: invitationData.event_date?.split('T')[0] || '',
          eventTime: invitationData.event_time || '',
          location: invitationData.event_location_name || '',
          customMessage: invitationData.content?.message || '',
          imageUrl: invitationData.image_url || null,
          imagePosition: invitationData.content?.imagePosition || 'profile',
          logoShape: invitationData.content?.logoShape === 'square' ? 'square' : 'circle'
        });

        // Load canvas preset if saved (portrait / landscape / square / story)
        if (invitationData.content?.canvasPreset) {
          const presetKey = invitationData.content.canvasPreset as CanvasPreset;
          if (presetKey in CANVAS_PRESETS) {
            setCanvasPreset(presetKey);
          }
        }
        
        // Load image layers (z-index) if saved
        if (invitationData.content?.imageLayers) {
          setImageLayers({
            profile: invitationData.content.imageLayers.profile ?? 260,
            banner: invitationData.content.imageLayers.banner ?? 240,
            watermark: invitationData.content.imageLayers.watermark ?? 280
          });
        }
        
        // Load image transforms (position, size, rotation, opacity) if saved
        if (invitationData.content?.imageTransforms) {
          setImageTransforms(prev => ({
            profile: {
              position: invitationData.content.imageTransforms.profile?.position || prev.profile.position,
              size: invitationData.content.imageTransforms.profile?.size || prev.profile.size,
              rotation: invitationData.content.imageTransforms.profile?.rotation ?? prev.profile.rotation,
              opacity: invitationData.content.imageTransforms.profile?.opacity ?? prev.profile.opacity
            },
            banner: {
              position: invitationData.content.imageTransforms.banner?.position || prev.banner.position,
              size: invitationData.content.imageTransforms.banner?.size || prev.banner.size,
              rotation: invitationData.content.imageTransforms.banner?.rotation ?? prev.banner.rotation,
              opacity: invitationData.content.imageTransforms.banner?.opacity ?? prev.banner.opacity
            },
            watermark: {
              position: invitationData.content.imageTransforms.watermark?.position || prev.watermark.position,
              size: invitationData.content.imageTransforms.watermark?.size || prev.watermark.size,
              rotation: invitationData.content.imageTransforms.watermark?.rotation ?? prev.watermark.rotation,
              opacity: invitationData.content.imageTransforms.watermark?.opacity ?? prev.watermark.opacity
            }
          }));
        }
        
         // Load colors
         if (invitationData.content?.colors) {
           setColors(invitationData.content.colors);
         }
         
         // Load font
         if (invitationData.custom_design?.font) {
           setSelectedFont(invitationData.custom_design.font as FontFamily);
         }
        
        // Load QR settings
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
        
        // Load elements from saved data
        const loadedElements: EditorElement[] = [];
        
        // Prepare combined date content once (from invitation's date/time)
        const dateContentFromInvitation =
          invitationData.event_date && invitationData.event_time
            ? `${invitationData.event_date.split('T')[0]} ${invitationData.event_time}`
            : invitationData.event_date?.split('T')[0] || invitationData.event_time || '';

        // Load text elements – normalize all semantic types (title, date, etc.) to 'text'
        if (invitationData.content?.textElements && Array.isArray(invitationData.content.textElements)) {
          invitationData.content.textElements.forEach((el: any) => {
            let content = el.content || '';

            // If this is a date element and its content is empty, derive from invitation date/time
            if (el.type === 'date' && (!content || !content.trim())) {
              content = dateContentFromInvitation;
            }

            loadedElements.push({
              id: el.id,
              type: 'text', // normalize to 'text' so rendering & styling logic always works
              name:
                el.type === 'title'
                  ? 'Başlık'
                  : el.type === 'date'
                  ? 'Tarih'
                  : el.type === 'location'
                  ? 'Konum'
                  : el.type === 'message'
                  ? 'Mesaj'
                  : el.type === 'footer'
                  ? 'Footer'
                  : 'Metin',
              content,
              position: el.position,
              size: el.size,
              rotation: 0,
              opacity: 1,
              visible: el.visible !== false,
              locked: false,
              zIndex: el.zIndex || 300,
              // ensure style exists so later color/font updates can safely extend it
              style: el.style || {}
            });
          });
        }
        
        // Load decorative elements
        if (invitationData.content?.decorativeElements && Array.isArray(invitationData.content.decorativeElements)) {
          invitationData.content.decorativeElements.forEach((el: any, i: number) => {
            if (el.imageUrl && el.name) {
              loadedElements.push({
                id: el.id,
                type: 'decoration',
                name: el.name,
                imageUrl: el.imageUrl,
                position: el.position,
                size: el.size,
                rotation: el.rotation || 0,
                opacity: el.opacity || 1,
                visible: true,
                locked: false,
                zIndex: el.zIndex || 250 + i
              });
            }
          });
        }
        
         // If no elements loaded, create defaults
         if (loadedElements.length === 0) {
           const dateContent = invitationData.event_date && invitationData.event_time 
             ? `${invitationData.event_date.split('T')[0]} ${invitationData.event_time}` 
             : invitationData.event_date?.split('T')[0] || invitationData.event_time || '';
           
           loadedElements.push(
             {
               id: 'title',
               type: 'text',
               name: 'Başlık',
               content: invitationData.title || 'Etkinlik Başlığı',
               position: { x: 50, y: 20 },
               size: { width: 400, height: 80 },
               rotation: 0,
               opacity: 1,
               visible: true,
               locked: false,
               zIndex: 300,
               style: { fontSize: 32, fontWeight: 'bold', textAlign: 'center', color: colors.text, fontFamily: selectedFont }
             },
             {
               id: 'date',
               type: 'text',
               name: 'Tarih',
               content: dateContent,
               position: { x: 50, y: 40 },
               size: { width: 300, height: 40 },
               rotation: 0,
               opacity: 1,
               visible: true,
               locked: false,
               zIndex: 300,
               style: { fontSize: 18, textAlign: 'center', color: colors.text, fontFamily: selectedFont }
             },
             {
               id: 'location',
               type: 'text',
               name: 'Konum',
               content: invitationData.event_location_name || 'Konum',
               position: { x: 50, y: 55 },
               size: { width: 350, height: 40 },
               rotation: 0,
               opacity: 1,
               visible: true,
               locked: false,
               zIndex: 300,
               style: { fontSize: 16, textAlign: 'center', color: colors.text, fontFamily: selectedFont }
             },
             {
               id: 'message',
               type: 'text',
               name: 'Mesaj',
               content: invitationData.content?.message || '',
               position: { x: 50, y: 70 },
               size: { width: 400, height: 60 },
               rotation: 0,
               opacity: 1,
               visible: true,
               locked: false,
               zIndex: 300,
               style: { fontSize: 14, textAlign: 'center', color: colors.text, fontFamily: selectedFont }
             }
           );
         }
        
         setElements(loadedElements);
         undoRedo.reset(loadedElements);
        
      } else {
        // Create new invitation from template
        const templateSlug = searchParams.get('template');
        
        if (!templateSlug) {
          toast.error('Şablon seçilmedi');
          navigate('/templates');
          return;
        }
        
        const templateData = await templateService.getTemplateById(templateSlug);
        
        if (!templateData) {
          toast.error('Şablon bulunamadı');
          navigate('/templates');
          return;
        }
        
        // Check access
        const templateTier = templateData.tier as 'free' | 'pro' | 'premium';
        const canAccess = subscription.canAccessTemplate(templateTier);
        
        if (!canAccess) {
          const tierNames = { free: 'Ücretsiz', pro: 'PRO', premium: 'PREMIUM' };
          toast.error(`Bu şablon ${tierNames[templateTier]} plan gerektirir!`);
          navigate('/templates');
          return;
        }
        
        setTemplate(templateData);
        
        // Load template colors
        const templateColors = {
          primary: templateData.color_palette?.primary || '#667eea',
          secondary: templateData.color_palette?.secondary || '#764ba2',
          background: templateData.color_palette?.background || '#ffffff',
          text: templateData.color_palette?.text || '#ffffff',
          accent: templateData.color_palette?.accent || '#f56565'
        };
        setColors(templateColors);
        
        // Create new invitation
        const templateImageUrl = getTemplateFullUrl(templateData.default_image_url || templateData.thumbnail_url);
        
        const newInvitation = await invitationService.createInvitation({
          template_id: templateData.id,
          title: `${templateData.category || 'Etkinlik'} Davetiyesi`,
          event_type: templateData.category || '',
          image_url: templateImageUrl,
          content: {
            colors: templateColors,
            imagePosition: 'background',
            logoShape: 'circle',
            message: `${templateData.name} ile hazırlanan özel davetiyenize hoş geldiniz.`
          }
        });
        
        if (newInvitation) {
          setInvitation(newInvitation);
          navigate(`/editor/${newInvitation.id}`, { replace: true });
        }
      }
    } catch (error) {
      console.error('Error loading data:', error);
      toast.error('Veri yüklenirken hata oluştu');
    } finally {
      setIsLoading(false);
    }
  }

  // Sync elements with undo/redo
  useEffect(() => {
    setElements(undoRedo.state);
  }, [undoRedo.state]);

  // Update undo/redo when elements change (but not during undo/redo)
  const updateElements = useCallback((newElements: EditorElement[]) => {
    setElements(newElements);
    undoRedo.set(newElements);
  }, [undoRedo]);

  // Keyboard shortcuts
  useKeyboardShortcuts({
    onSave: handleSave,
    onPreview: () => setIsPreviewOpen(true),
    onExport: handleDownload,
    onUndo: undoRedo.undo,
    onRedo: undoRedo.redo,
    onDelete: handleDeleteSelected,
    onDuplicate: handleDuplicateSelected,
    onZoomIn: () => setZoom(Math.min(200, zoom + 10)),
    onZoomOut: () => setZoom(Math.max(25, zoom - 10)),
    onZoomReset: () => setZoom(100),
    onToggleGrid: () => setShowGrid(!showGrid),
    onMoveUp: () => handleMoveSelected('up'),
    onMoveDown: () => handleMoveSelected('down'),
    onMoveLeft: () => handleMoveSelected('left'),
    onMoveRight: () => handleMoveSelected('right')
  });

  // Element operations
  function handleDeleteSelected() {
    if (!selectedElementId) return;
    const newElements = elements.filter(el => el.id !== selectedElementId);
    updateElements(newElements);
    setSelectedElementId(null);
    toast.success('Öğe silindi');
  }

  function handleDuplicateSelected() {
    if (!selectedElementId) return;
    const element = elements.find(el => el.id === selectedElementId);
    if (!element) return;

    const newElement: EditorElement = {
      ...element,
      id: `${element.type}-${Date.now()}`,
      name: `${element.name} (Kopya)`,
      position: { x: element.position.x + 5, y: element.position.y + 5 },
      zIndex: Math.max(...elements.map(e => e.zIndex)) + 1
    };

    updateElements([...elements, newElement]);
    setSelectedElementId(newElement.id);
    toast.success('Öğe çoğaltıldı');
  }

  function handleMoveSelected(direction: 'up' | 'down' | 'left' | 'right') {
    if (!selectedElementId) return;
    const newElements = elements.map(el => {
      if (el.id !== selectedElementId) return el;
      
      const step = 1; // 1% movement
      switch (direction) {
        case 'up':
          return { ...el, position: { ...el.position, y: Math.max(0, el.position.y - step) } };
        case 'down':
          return { ...el, position: { ...el.position, y: Math.min(100, el.position.y + step) } };
        case 'left':
          return { ...el, position: { ...el.position, x: Math.max(0, el.position.x - step) } };
        case 'right':
          return { ...el, position: { ...el.position, x: Math.min(100, el.position.x + step) } };
        default:
          return el;
      }
    });
    
    updateElements(newElements);
  }

  // Layer operations
  function handleToggleVisibility(id: string) {
    const newElements = elements.map(el =>
      el.id === id ? { ...el, visible: !el.visible } : el
    );
    updateElements(newElements);
  }

  function handleToggleLock(id: string) {
    const newElements = elements.map(el =>
      el.id === id ? { ...el, locked: !el.locked } : el
    );
    updateElements(newElements);
  }

  function handleDeleteLayer(id: string) {
    const newElements = elements.filter(el => el.id !== id);
    updateElements(newElements);
    if (selectedElementId === id) {
      setSelectedElementId(null);
    }
    toast.success('Öğe silindi');
  }

  function handleDuplicateLayer(id: string) {
    const element = elements.find(el => el.id === id);
    if (!element) return;

    const newElement: EditorElement = {
      ...element,
      id: `${element.type}-${Date.now()}`,
      name: `${element.name} (Kopya)`,
      position: { x: element.position.x + 5, y: element.position.y + 5 },
      zIndex: Math.max(...elements.map(e => e.zIndex)) + 1
    };

    updateElements([...elements, newElement]);
    toast.success('Öğe çoğaltıldı');
  }

  function handleReorderLayer(id: string, direction: 'up' | 'down') {
    const sortedElements = [...elements].sort((a, b) => b.zIndex - a.zIndex);
    const index = sortedElements.findIndex(el => el.id === id);
    
    if (index === -1) return;
    if (direction === 'up' && index === 0) return;
    if (direction === 'down' && index === sortedElements.length - 1) return;

    const targetIndex = direction === 'up' ? index - 1 : index + 1;
    const temp = sortedElements[index].zIndex;
    sortedElements[index].zIndex = sortedElements[targetIndex].zIndex;
    sortedElements[targetIndex].zIndex = temp;

    updateElements(sortedElements);
  }

  // Save function
  async function handleSave() {
    if (!invitation) return;
    
    setIsSaving(true);
    
    try {
      // Convert elements to saveable format
      const textElements = elements.filter(el => el.type === 'text' || el.type === 'divider');
      const decorativeElements = elements.filter(el => el.type === 'decoration');
      
       await invitationService.updateInvitation(invitation.id, {
         title: formData.title,
         event_date: formData.eventDate || undefined,
         event_time: formData.eventTime || undefined,
         event_location_name: formData.location || undefined,
         image_url: formData.imageUrl || undefined,
         content: {
           message: formData.customMessage,
           colors: colors,
           imagePosition: formData.imagePosition,
           logoShape: formData.logoShape,
        imageLayers: imageLayers,
        imageTransforms: imageTransforms,
          canvasPreset,
          canvasSize: {
            width: canvasDimensions.width,
            height: canvasDimensions.height
          },
           textElements: textElements,
           decorativeElements: decorativeElements
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
      
      toast.success('Kaydedildi!');
    } catch (error) {
      console.error('Save error:', error);
      toast.error('Kaydetme hatası');
    } finally {
      setIsSaving(false);
    }
  }

  // Toggle publish status (draft <-> published)
  async function handleTogglePublish() {
    if (!invitation) return;
    
    const newStatus = invitation.status === 'published' ? 'draft' : 'published';
    const statusText = newStatus === 'published' ? 'yayınlandı' : 'taslağa alındı';

    // Yayına alma sırasında davetiye hakkı kontrolü (FREE / PRO)
    if (newStatus === 'published' && invitation.status === 'draft') {
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

        if (newStatus === 'published' && invitation.status === 'draft') {
          await subscription.refreshSubscription();
          toast.success('Davetiye yayınlandı');
        } else {
          toast.success(`Davetiye ${statusText}`);
        }
      }
    } catch (error) {
      console.error('Toggle publish error:', error);
      toast.error('Status güncellenemedi');
    }
  }

  async function handleDownload() {
    if (!invitation) return;
    await handleSave();
    setIsPreviewOpen(true);
  }

  function handleShare() {
    if (invitation?.id) {
      pdfService.copyShareLink(invitation.id);
    }
  }
  
  function handleInputChange(e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) {
    const { name, value } = e.target;
    const nextForm = {
      ...formData,
      [name]: value
    };
    setFormData(nextForm);
    
    // Update corresponding text elements on canvas
    const newElements = elements.map(el => {
      // Başlık
      if (name === 'title' && (el.id === 'title' || el.name === 'Başlık')) {
        return { ...el, content: value };
      }
      // Konum
      if (name === 'location' && (el.id === 'location' || el.name === 'Konum')) {
        return { ...el, content: value };
      }
      // Özel Mesaj
      if (name === 'customMessage' && (el.id === 'message' || el.name === 'Mesaj')) {
        return { ...el, content: value };
      }
      // Tarih + Saat birleşimi
      if ((name === 'eventDate' || name === 'eventTime') && (el.id === 'date' || el.name === 'Tarih')) {
        const dateStr = name === 'eventDate' ? value : nextForm.eventDate;
        const timeStr = name === 'eventTime' ? value : nextForm.eventTime;
        const dateContent =
          dateStr && timeStr ? `${dateStr} ${timeStr}` : dateStr || timeStr || '';
        return { ...el, content: dateContent };
      }
      return el;
    });
    
    updateElements(newElements);
  }
  
  function handleAddDecorativeElement(graphic: any) {
    const newElement: EditorElement = {
      id: `decoration-${Date.now()}`,
      type: 'decoration',
      name: graphic.name,
      imageUrl: graphic.imageUrl,
      position: { x: 50, y: 50 },
      size: graphic.defaultSize,
      rotation: 0,
      opacity: 1,
      visible: true,
      locked: false,
      zIndex: Math.max(...elements.map(e => e.zIndex), 250) + 1
    };
    updateElements([...elements, newElement]);
    setSelectedElementId(newElement.id);
    toast.success(`${graphic.name} eklendi!`, { icon: '✨' });
  }
  
  function handleResetToTemplate() {
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
  }
  
  // Alignment functions (Canva/Photoshop style)
  function handleAlignLeft() {
    if (!selectedElementId) {
      toast.error('Lütfen bir element seçin');
      return;
    }
    const newElements = elements.map(el => {
      if (el.id !== selectedElementId) return el;
      // Convert pixel size to percentage
      const widthPercent = (el.size.width / canvasDimensions.width) * 100;
      return { ...el, position: { ...el.position, x: 2 } };
    });
    updateElements(newElements);
    toast.success('Sola hizalandı');
  }
  
  function handleAlignCenter() {
    if (!selectedElementId) {
      toast.error('Lütfen bir element seçin');
      return;
    }
    const newElements = elements.map(el => {
      if (el.id !== selectedElementId) return el;
      // Convert pixel size to percentage
      const widthPercent = (el.size.width / canvasDimensions.width) * 100;
      return { ...el, position: { ...el.position, x: 50 - widthPercent / 2 } };
    });
    updateElements(newElements);
    toast.success('Ortaya hizalandı');
  }
  
  function handleAlignRight() {
    if (!selectedElementId) {
      toast.error('Lütfen bir element seçin');
      return;
    }
    const newElements = elements.map(el => {
      if (el.id !== selectedElementId) return el;
      // Convert pixel size to percentage
      const widthPercent = (el.size.width / canvasDimensions.width) * 100;
      return { ...el, position: { ...el.position, x: 98 - widthPercent } };
    });
    updateElements(newElements);
    toast.success('Sağa hizalandı');
  }
  
  function handleAlignTop() {
    if (!selectedElementId) {
      toast.error('Lütfen bir element seçin');
      return;
    }
    const newElements = elements.map(el => {
      if (el.id !== selectedElementId) return el;
      return { ...el, position: { ...el.position, y: 2 } };
    });
    updateElements(newElements);
    toast.success('Üste hizalandı');
  }
  
  function handleAlignMiddle() {
    if (!selectedElementId) {
      toast.error('Lütfen bir element seçin');
      return;
    }
    const newElements = elements.map(el => {
      if (el.id !== selectedElementId) return el;
      // Convert pixel size to percentage
      const heightPercent = (el.size.height / canvasDimensions.height) * 100;
      return { ...el, position: { ...el.position, y: 50 - heightPercent / 2 } };
    });
    updateElements(newElements);
    toast.success('Dikey ortaya hizalandı');
  }
  
  function handleAlignBottom() {
    if (!selectedElementId) {
      toast.error('Lütfen bir element seçin');
      return;
    }
    const newElements = elements.map(el => {
      if (el.id !== selectedElementId) return el;
      // Convert pixel size to percentage
      const heightPercent = (el.size.height / canvasDimensions.height) * 100;
      return { ...el, position: { ...el.position, y: 98 - heightPercent } };
    });
    updateElements(newElements);
    toast.success('Alta hizalandı');
  }

  // Convert layers to Layer format for LayersPanel
  const layers: Layer[] = elements.map(el => ({
    id: el.id,
    type: el.type,
    name: el.name,
    visible: el.visible,
    locked: el.locked,
    zIndex: el.zIndex
  }));

  // Get selected element for PropertiesPanel
  const selectedElement: ElementProperties | null = (() => {
    if (!selectedElementId) return null;
    
    // Special case: main image (profile / banner / watermark)
    if (selectedElementId.startsWith('main-image-')) {
      const mode = selectedElementId.replace('main-image-', '') as 'profile' | 'banner' | 'watermark';
      const t = imageTransforms[mode];
      return {
        id: selectedElementId,
        type: 'image',
        content: undefined,
        position: t.position,
        size: t.size,
        rotation: t.rotation,
        opacity: t.opacity,
        style: {}
      };
    }
    
    return (elements.find(el => el.id === selectedElementId) as ElementProperties) || null;
  })();

  // Update selected element
  function handleUpdateElement(updates: Partial<ElementProperties>) {
    if (!selectedElementId) return;
    
    // Main image: update imageTransforms instead of elements[]
    if (selectedElementId.startsWith('main-image-')) {
      const mode = selectedElementId.replace('main-image-', '') as 'profile' | 'banner' | 'watermark';
      setImageTransforms(prev => {
        const current = prev[mode];
        let nextPosition = updates.position || current.position;
        let nextSize = updates.size || current.size;
        const nextRotation = updates.rotation !== undefined ? updates.rotation : current.rotation;
        const nextOpacity = updates.opacity !== undefined ? updates.opacity : current.opacity;
        
        // Ensure perfect circle for profile and circular logo
        if (mode === 'profile' || (mode === 'watermark' && formData.logoShape === 'circle')) {
          const side = Math.min(nextSize.width, nextSize.height);
          nextSize = { width: side, height: side };
        }
        
        return {
          ...prev,
          [mode]: {
            position: nextPosition,
            size: nextSize,
            rotation: nextRotation,
            opacity: nextOpacity
          }
        };
      });
      return;
    }
    
    // Default: update normal elements
    const newElements = elements.map(el =>
      el.id === selectedElementId ? { ...el, ...updates } : el
    );
    updateElements(newElements);
  }

  // Add new element functions
  function handleAddTextElement() {
    const newElement: EditorElement = {
      id: `text-${Date.now()}`,
      type: 'text',
      name: 'Yeni Metin',
      content: 'Yeni Metin',
      position: { x: 50, y: 50 },
      size: { width: 300, height: 60 },
      rotation: 0,
      opacity: 1,
      visible: true,
      locked: false,
      zIndex: Math.max(...elements.map(e => e.zIndex), 300) + 1,
      style: {
        fontSize: 24,
        fontWeight: 'normal',
        textAlign: 'center',
        color: colors.text,
        fontFamily: 'Playfair Display'
      }
    };
    updateElements([...elements, newElement]);
    setSelectedElementId(newElement.id);
    toast.success('Metin eklendi');
  }


  function handleAddShapeElement() {
    const newElement: EditorElement = {
      id: `divider-${Date.now()}`,
      type: 'divider',
      name: 'Çizgi',
      position: { x: 50, y: 50 },
      size: { width: 100, height: 4 },
      rotation: 0,
      opacity: 1,
      visible: true,
      locked: false,
      zIndex: Math.max(...elements.map(e => e.zIndex), 300) + 1,
      style: {
        color: colors.accent
      }
    };
    updateElements([...elements, newElement]);
    setSelectedElementId(newElement.id);
    toast.success('Çizgi eklendi');
  }

  // Handle tool changes
  useEffect(() => {
    if (activeTool === 'text') {
      handleAddTextElement();
      setActiveTool('select');
    } else if (activeTool === 'shape') {
      handleAddShapeElement();
      setActiveTool('select');
    }
  }, [activeTool]);

  // Canvas dimensions
  const canvasDimensions = CANVAS_PRESETS[canvasPreset];

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
    <div className="h-screen flex flex-col bg-gray-100 overflow-hidden">
      {/* Top Header */}
      <div className="bg-white border-b border-gray-200 px-2 md:px-4 py-2 flex items-center justify-between z-20">
        <div className="flex items-center gap-2 md:gap-3">
          <button
            onClick={() => navigate('/dashboard')}
            className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <ArrowLeft className="h-4 w-4 md:h-5 md:w-5 text-gray-600" />
          </button>
          <div className="hidden sm:block">
            <h1 className="text-xs md:text-sm font-bold text-gray-900">{template.name}</h1>
            <p className="text-xs text-gray-500">
              {invitation.status === 'draft' && <span className="text-yellow-600">● Taslak</span>}
              {invitation.status === 'published' && <span className="text-green-600">● Yayında</span>}
            </p>
          </div>
        </div>

         {/* Canvas Size Selector & Alignment - Hidden on mobile */}
         <div className="hidden md:flex items-center gap-2">
           {/* Alignment Tools (Canva style) */}
           {selectedElementId && (
             <div className="flex items-center gap-1 mr-2 pr-2 border-r border-gray-300">
               <button
                 onClick={handleAlignLeft}
                 className="p-1.5 hover:bg-gray-100 rounded transition-colors"
                 title="Sola Hizala"
               >
                 <AlignLeft className="h-4 w-4 text-gray-600" />
               </button>
               <button
                 onClick={handleAlignCenter}
                 className="p-1.5 hover:bg-gray-100 rounded transition-colors"
                 title="Yatay Ortala"
               >
                 <AlignHorizontalJustifyCenter className="h-4 w-4 text-gray-600" />
               </button>
               <button
                 onClick={handleAlignRight}
                 className="p-1.5 hover:bg-gray-100 rounded transition-colors"
                 title="Sağa Hizala"
               >
                 <AlignRight className="h-4 w-4 text-gray-600" />
               </button>
               <div className="w-px h-4 bg-gray-300 mx-1" />
               <button
                 onClick={handleAlignTop}
                 className="p-1.5 hover:bg-gray-100 rounded transition-colors"
                 title="Üste Hizala"
               >
                 <AlignLeft className="h-4 w-4 text-gray-600 rotate-90" />
               </button>
               <button
                 onClick={handleAlignMiddle}
                 className="p-1.5 hover:bg-gray-100 rounded transition-colors"
                 title="Dikey Ortala"
               >
                 <AlignVerticalJustifyCenter className="h-4 w-4 text-gray-600" />
               </button>
               <button
                 onClick={handleAlignBottom}
                 className="p-1.5 hover:bg-gray-100 rounded transition-colors"
                 title="Alta Hizala"
               >
                 <AlignRight className="h-4 w-4 text-gray-600 rotate-90" />
               </button>
             </div>
           )}
           
           <select
             value={canvasPreset}
             onChange={(e) => setCanvasPreset(e.target.value as CanvasPreset)}
             className="px-3 py-1.5 text-sm border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
           >
             {Object.entries(CANVAS_PRESETS).map(([key, { label }]) => (
               <option key={key} value={key}>{label}</option>
             ))}
           </select>
           
           <div className="text-xs text-gray-500">
             {canvasDimensions.width} × {canvasDimensions.height}px
           </div>
         </div>

        {/* Undo/Redo + Publish - Compact on mobile */}
        <div className="flex items-center gap-1 md:gap-3">
          <button
            onClick={undoRedo.undo}
            disabled={!undoRedo.canUndo}
            className="px-2 md:px-3 py-1.5 text-xs md:text-sm bg-gray-100 hover:bg-gray-200 disabled:opacity-40 disabled:cursor-not-allowed rounded-lg transition-colors"
            title="Geri Al (Ctrl+Z)"
          >
            <span className="hidden md:inline">↶ Geri</span>
            <span className="md:hidden">↶</span>
          </button>

          {/* Publish / Unpublish */}
          <button
            onClick={handleTogglePublish}
            className={`hidden sm:inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs md:text-sm font-medium transition-all border ${
              invitation.status === 'published'
                ? 'bg-green-50 text-green-700 border-green-300 hover:bg-green-100'
                : 'bg-primary-50 text-primary-700 border-primary-300 hover:bg-primary-100'
            }`}
            title={invitation.status === 'published' ? 'Yayında' : 'Yayınla'}
          >
            <span className="text-base">
              {invitation.status === 'published' ? '✓' : '📝'}
            </span>
            <span>{invitation.status === 'published' ? 'Yayında' : 'Yayınla'}</span>
          </button>
          <button
            onClick={undoRedo.redo}
            disabled={!undoRedo.canRedo}
            className="px-2 md:px-3 py-1.5 text-xs md:text-sm bg-gray-100 hover:bg-gray-200 disabled:opacity-40 disabled:cursor-not-allowed rounded-lg transition-colors"
            title="İleri Al (Ctrl+Y)"
          >
            <span className="hidden md:inline">İleri ↷</span>
            <span className="md:hidden">↷</span>
          </button>
          
          {/* Mobile Menu Button */}
          <button
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            className="md:hidden p-2 bg-primary-600 text-white rounded-lg"
          >
            <Settings className="h-4 w-4" />
          </button>
        </div>
      </div>

      {/* Main Content: 3-Panel Layout */}
      <div className="flex-1 flex overflow-hidden">
        {/* Left Toolbar - Hidden on mobile */}
        <div className="hidden md:block">
          <Toolbar
            activeTool={activeTool}
            onToolChange={setActiveTool}
            zoom={zoom}
            onZoomChange={setZoom}
            showGrid={showGrid}
            onToggleGrid={() => setShowGrid(!showGrid)}
            onSave={handleSave}
            onPreview={() => setIsPreviewOpen(true)}
            onShare={handleShare}
            onDownload={handleDownload}
            isSaving={isSaving}
          />
        </div>

         {/* Center Canvas */}
         <div className="flex-1 flex flex-col overflow-hidden bg-gray-100">
           <div className="flex-1 flex items-center justify-center p-4 overflow-hidden">
            <div
              ref={canvasRef}
              className="bg-white shadow-2xl rounded-lg relative overflow-hidden"
              style={{
                width: `${canvasDimensions.width * (zoom / 100)}px`,
                height: `${canvasDimensions.height * (zoom / 100)}px`,
                transformOrigin: 'center',
                backgroundImage: formData.imagePosition === 'background' && formData.imageUrl
                  ? `url(${formData.imageUrl})`
                  : `linear-gradient(135deg, ${colors.primary} 0%, ${colors.secondary} 100%)`,
                backgroundSize: 'cover',
                backgroundPosition: 'center'
              }}
            >
              {/* Grid overlay */}
              {showGrid && (
                <div 
                  className="absolute inset-0 pointer-events-none"
                  style={{
                    backgroundImage: 'linear-gradient(rgba(0,0,0,0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(0,0,0,0.05) 1px, transparent 1px)',
                    backgroundSize: '20px 20px',
                    zIndex: 500
                  }}
                />
              )}
               {/* Background gradient overlay (if background image is set) */}
               {formData.imagePosition === 'background' && formData.imageUrl && (
                 <div 
                   className="absolute inset-0 pointer-events-none" 
                   style={{ 
                     background: `linear-gradient(135deg, ${colors.primary}CC 0%, ${colors.secondary}CC 100%)`,
                     zIndex: 1
                   }}
                 />
               )}

               {/* Draggable main image (Profile/Banner/Watermark) */}
               {!isPreviewOpen && !isGalleryOpen && formData.imageUrl && formData.imagePosition !== 'background' && (() => {
                 const currentMode = formData.imagePosition as 'profile' | 'banner' | 'watermark';
                 const t = imageTransforms[currentMode];
                 return (
                   <DraggableElement
                     id={`main-image-${currentMode}`}
                     type="decoration"
                     imageUrl={formData.imageUrl || undefined}
                     imageFit={currentMode === 'banner' ? 'cover' : 'cover'}
                     zIndex={imageLayers[currentMode]}
                     position={t.position}
                     size={t.size}
                     rotation={t.rotation}
                     opacity={t.opacity}
                     onSelect={(id) => {
                       setSelectedElementId(id);
                       setRightPanel('properties');
                     }}
                     onUpdate={(updates) => {
                       setImageTransforms(prev => ({
                         ...prev,
                         [currentMode]: (() => {
                           const current = prev[currentMode];
                           let nextPosition = updates.position || current.position;
                           let nextSize = updates.size || current.size;
                           const nextRotation = updates.rotation !== undefined ? updates.rotation : current.rotation;
                           const nextOpacity = updates.opacity !== undefined ? updates.opacity : current.opacity;
                           
                           // Ensure perfect circle for profile and circular logo
                           if (currentMode === 'profile' || (currentMode === 'watermark' && formData.logoShape === 'circle')) {
                             const side = Math.min(nextSize.width, nextSize.height);
                             nextSize = { width: side, height: side };
                           }
                           
                           return {
                             position: nextPosition,
                             size: nextSize,
                             rotation: nextRotation,
                             opacity: nextOpacity
                           };
                         })()
                       }));
                     }}
                     onChangeZ={(action) => {
                       const allZ = [
                         ...elements.map(e => e.zIndex),
                         imageLayers.profile,
                         imageLayers.banner,
                         imageLayers.watermark
                       ];
                       const maxZ = Math.max(...allZ);
                       const minZ = Math.min(...allZ);
                       setImageLayers(prev => ({
                         ...prev,
                         [currentMode]: action === 'front' ? maxZ + 1 : minZ - 1
                       }));
                     }}
                     onDelete={() => {
                       setFormData({ ...formData, imageUrl: null });
                       toast.success('Görsel kaldırıldı');
                     }}
                     containerRef={canvasRef}
                     style={{
                       borderRadius: currentMode === 'profile'
                         ? '50%'
                         : (currentMode === 'watermark'
                           ? (formData.logoShape === 'circle' ? '50%' : '0')
                           : '8px'),
                       border: currentMode === 'profile' ? `4px solid ${colors.accent}` : 'none',
                       overflow: 'hidden',
                       boxShadow: currentMode === 'profile' || currentMode === 'banner'
                         ? '0 4px 12px rgba(0,0,0,0.15)'
                         : undefined
                     }}
                   />
                 );
               })()}

               {/* Render elements */}
               {elements.filter(el => el.visible).map((element) => {
                 // Prepare content for different element types
                 let renderedContent: React.ReactNode = element.content;
                 
                if (element.type === 'text') {
                  renderedContent = (
                    <div
                      style={{
                        fontSize: `${element.style?.fontSize || 16}px`,
                        fontWeight: element.style?.fontWeight || 'normal',
                        // Element-level overrides first, then global theme as fallback
                        fontFamily: element.style?.fontFamily || selectedFont,
                        color: element.style?.color || colors.text,
                        textAlign: element.style?.textAlign || 'center',
                        fontStyle: element.style?.fontStyle || 'normal',
                        textDecoration: element.style?.textDecoration || 'none',
                        width: '100%',
                        height: '100%',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent:
                          element.style?.textAlign === 'left'
                            ? 'flex-start'
                            : element.style?.textAlign === 'right'
                            ? 'flex-end'
                            : 'center',
                        padding: '8px',
                        wordWrap: 'break-word',
                        whiteSpace: 'pre-wrap'
                      }}
                    >
                      {element.content || 'Metin'}
                    </div>
                  );
                } else if (element.type === 'divider') {
                  renderedContent = (
                    <div
                      style={{
                        width: '100%',
                        height: '100%',
                        // Element-level color override or global accent
                        backgroundColor: element.style?.color || colors.accent,
                        borderRadius: '2px'
                      }}
                    />
                  );
                } else if (element.type === 'decoration' && element.imageUrl) {
                   renderedContent = (
                     <img
                       src={element.imageUrl}
                       alt={element.name}
                       style={{
                         width: '100%',
                         height: '100%',
                         objectFit: 'contain',
                         pointerEvents: 'none'
                       }}
                       crossOrigin="anonymous"
                     />
                   );
                 }

                 return (
                   <DraggableElement
                     key={element.id}
                     id={element.id}
                     type={element.type === 'divider' ? 'decoration' : element.type}
                     content={renderedContent}
                     imageUrl={element.imageUrl}
                     position={element.position}
                     size={element.size}
                     rotation={element.rotation}
                     opacity={element.opacity}
                     zIndex={element.zIndex}
                     isSelected={selectedElementId === element.id}
                     locked={element.locked}
                     onSelect={setSelectedElementId}
                     onUpdate={(updates) => handleUpdateElement(updates)}
                     onDelete={() => handleDeleteLayer(element.id)}
                     onDuplicate={() => handleDuplicateLayer(element.id)}
                     onToggleLock={() => handleToggleLock(element.id)}
                     onChangeZ={(action) => {
                       const allZ = elements.map(e => e.zIndex);
                       const maxZ = Math.max(...allZ);
                       const minZ = Math.min(...allZ);
                       const newElements = elements.map(el =>
                         el.id === element.id
                           ? { ...el, zIndex: action === 'front' ? maxZ + 1 : minZ - 1 }
                           : el
                       );
                       updateElements(newElements);
                     }}
                     containerRef={canvasRef}
                     style={element.type === 'text' ? {} : element.style}
                   />
                 );
               })}

              {/* QR Code */}
              {showQrOnDesign && qrMedia?.qr_image_url && (
                <img
                  src={qrMedia.qr_image_url}
                  alt="QR"
                  style={{ 
                    width: `${qrSize}px`, 
                    height: `${qrSize}px`,
                    zIndex: 400
                  }}
                  className={`absolute bg-white p-2 rounded-md shadow ${
                    qrPosition === 'top-left' ? 'top-4 left-4' :
                    qrPosition === 'top-right' ? 'top-4 right-4' :
                    qrPosition === 'bottom-left' ? 'bottom-4 left-4' :
                    'bottom-4 right-4'
                  }`}
                />
              )}
            </div>
          </div>
        </div>

         {/* Right Panel - Hidden on mobile, shown as bottom sheet */}
         <div className="hidden lg:flex w-80 bg-white border-l border-gray-200 flex-col">
           {/* Panel Tabs */}
           <div className="flex border-b border-gray-200 overflow-x-auto scrollbar-thin">
             <button
               onClick={() => setRightPanel('design')}
               className={`flex-shrink-0 px-3 py-2.5 text-xs font-medium transition-colors ${
                 rightPanel === 'design'
                   ? 'text-primary-600 border-b-2 border-primary-600 bg-primary-50'
                   : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
               }`}
             >
               <Palette className="h-4 w-4 inline mr-1" />
               Tasarım
             </button>
             <button
               onClick={() => setRightPanel('properties')}
               className={`flex-shrink-0 px-3 py-2.5 text-xs font-medium transition-colors ${
                 rightPanel === 'properties'
                   ? 'text-primary-600 border-b-2 border-primary-600 bg-primary-50'
                   : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
               }`}
             >
               <Settings className="h-4 w-4 inline mr-1" />
               Özellikler
             </button>
             <button
               onClick={() => setRightPanel('layers')}
               className={`flex-shrink-0 px-3 py-2.5 text-xs font-medium transition-colors ${
                 rightPanel === 'layers'
                   ? 'text-primary-600 border-b-2 border-primary-600 bg-primary-50'
                   : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
               }`}
             >
               <LayersIcon className="h-4 w-4 inline mr-1" />
               Katmanlar
             </button>
             <button
               onClick={() => setRightPanel('guests')}
               className={`flex-shrink-0 px-3 py-2.5 text-xs font-medium transition-colors ${
                 rightPanel === 'guests'
                   ? 'text-primary-600 border-b-2 border-primary-600 bg-primary-50'
                   : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
               }`}
             >
               <Users className="h-4 w-4 inline mr-1" />
               Davetliler
             </button>
           </div>

           {/* Panel Content */}
           <div className="flex-1 overflow-hidden">
             {rightPanel === 'design' && invitation && user && (
               <DesignPanel
                 formData={formData}
                 onFormChange={handleInputChange}
                 colors={colors}
                 onColorsChange={(newColors) => {
                   setColors(newColors);
                   const updatedElements = elements.map(el => {
                     // Text-like elements: everything except decoration/image/divider
                     if (el.type !== 'decoration' && el.type !== 'image' && el.type !== 'divider') {
                       return {
                         ...el,
                         style: {
                           ...(el.style || {}),
                           color: newColors.text
                         }
                       };
                     }
                     // Divider elements use accent color
                     if (el.type === 'divider') {
                       return {
                         ...el,
                         style: {
                           ...(el.style || {}),
                           color: newColors.accent
                         }
                       };
                     }
                     return el;
                   });
                   updateElements(updatedElements);
                   toast.success('Renkler tüm elementlere uygulandı');
                 }}
                 defaultColors={templateOriginalDesign?.colors}
                 selectedFont={selectedFont}
                 onFontChange={(newFont) => {
                   setSelectedFont(newFont);
                   const updatedElements = elements.map(el => {
                     // Apply font to all text-like elements (exclude decoration/image/divider)
                     if (el.type !== 'decoration' && el.type !== 'image' && el.type !== 'divider') {
                       return {
                         ...el,
                         style: {
                           ...(el.style || {}),
                           fontFamily: newFont
                         }
                       };
                     }
                     return el;
                   });
                   updateElements(updatedElements);
                   toast.success('Yazı tipi tüm metinlere uygulandı');
                 }}
                 invitationId={invitation.id}
                 userId={user.id}
                 onImageUploaded={(imageUrl) => setFormData({ ...formData, imageUrl })}
                 onImageRemoved={() => setFormData({ ...formData, imageUrl: null })}
                 onPositionChange={(position) => setFormData({ ...formData, imagePosition: position })}
                 onLogoShapeChange={(shape) => setFormData({ ...formData, logoShape: shape })}
                 onOpenGallery={() => setIsGalleryOpen(true)}
                 onResetToTemplate={handleResetToTemplate}
                 hasTemplateOriginal={!!templateOriginalDesign}
                 currentPlan={subscription.currentPlan}
               />
             )}
               {rightPanel === 'design' && invitation && user && (
                 <DesignPanel
                   formData={formData}
                   onFormChange={handleInputChange}
                   colors={colors}
                   onColorsChange={(newColors) => {
                     setColors(newColors);
                     // Update all text-like and divider elements with new colors
                     const updatedElements = elements.map(el => {
                       if (el.type !== 'decoration' && el.type !== 'image' && el.type !== 'divider') {
                         return {
                           ...el,
                           style: {
                             ...(el.style || {}),
                             color: newColors.text
                           }
                         };
                       } else if (el.type === 'divider') {
                         return {
                           ...el,
                           style: {
                             ...(el.style || {}),
                             color: newColors.accent
                           }
                         };
                       }
                       return el;
                     });
                     updateElements(updatedElements);
                     toast.success('Renkler tüm elementlere uygulandı');
                   }}
                   defaultColors={templateOriginalDesign?.colors}
                   selectedFont={selectedFont}
                   onFontChange={(newFont) => {
                     setSelectedFont(newFont);
                     // Update all text-like elements with new font
                     const updatedElements = elements.map(el => {
                       if (el.type !== 'decoration' && el.type !== 'image' && el.type !== 'divider') {
                         return {
                           ...el,
                           style: {
                             ...(el.style || {}),
                             fontFamily: newFont
                           }
                         };
                       }
                       return el;
                     });
                     updateElements(updatedElements);
                     toast.success('Yazı tipi tüm metinlere uygulandı');
                   }}
                   invitationId={invitation.id}
                   userId={user.id}
                   onImageUploaded={(imageUrl) => setFormData({ ...formData, imageUrl })}
                   onImageRemoved={() => setFormData({ ...formData, imageUrl: null })}
                   onPositionChange={(position) => setFormData({ ...formData, imagePosition: position })}
                   onLogoShapeChange={(shape) => setFormData({ ...formData, logoShape: shape })}
                   onOpenGallery={() => setIsGalleryOpen(true)}
                   onResetToTemplate={handleResetToTemplate}
                   hasTemplateOriginal={!!templateOriginalDesign}
                   currentPlan={subscription.currentPlan}
                 />
               )}
             {rightPanel === 'properties' && (
               <PropertiesPanel
                 selectedElement={selectedElement}
                 onUpdate={handleUpdateElement}
                 onDelete={handleDeleteSelected}
                 colors={colors}
               />
             )}
             {rightPanel === 'layers' && (
               <LayersPanel
                 layers={layers}
                 selectedLayerId={selectedElementId}
                 onSelectLayer={setSelectedElementId}
                 onToggleVisibility={handleToggleVisibility}
                 onToggleLock={handleToggleLock}
                 onDeleteLayer={handleDeleteLayer}
                 onDuplicateLayer={handleDuplicateLayer}
                 onReorderLayer={handleReorderLayer}
               />
             )}
             {rightPanel === 'guests' && invitation && (
               <div className="p-4 overflow-auto h-full">
                 <GuestList
                   invitationId={invitation.id}
                   invitationTitle={invitation.title}
                   invitationStatus={invitation.status}
                 />
               </div>
             )}
           </div>
         </div>
      </div>

      {/* Mobile Bottom Sheet */}
      {isMobileMenuOpen && (
        <div className="lg:hidden fixed inset-0 z-50 bg-black/50" onClick={() => setIsMobileMenuOpen(false)}>
          <div 
            className="absolute bottom-0 left-0 right-0 bg-white rounded-t-2xl max-h-[80vh] overflow-hidden flex flex-col"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Handle */}
            <div className="flex justify-center py-2">
              <div className="w-12 h-1 bg-gray-300 rounded-full" />
            </div>

             {/* Tabs */}
             <div className="flex border-b border-gray-200 overflow-x-auto scrollbar-thin">
               <button
                 onClick={() => setRightPanel('design')}
                 className={`flex-shrink-0 px-3 py-2 text-xs font-medium transition-colors ${
                   rightPanel === 'design'
                     ? 'text-primary-600 border-b-2 border-primary-600 bg-primary-50'
                     : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                 }`}
               >
                 <Palette className="h-4 w-4 inline mr-1" />
                 Tasarım
               </button>
               <button
                 onClick={() => setRightPanel('properties')}
                 className={`flex-shrink-0 px-3 py-2 text-xs font-medium transition-colors ${
                   rightPanel === 'properties'
                     ? 'text-primary-600 border-b-2 border-primary-600 bg-primary-50'
                     : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                 }`}
               >
                 <Settings className="h-4 w-4 inline mr-1" />
                 Özellikler
               </button>
               <button
                 onClick={() => setRightPanel('layers')}
                 className={`flex-shrink-0 px-3 py-2 text-xs font-medium transition-colors ${
                   rightPanel === 'layers'
                     ? 'text-primary-600 border-b-2 border-primary-600 bg-primary-50'
                     : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                 }`}
               >
                 <LayersIcon className="h-4 w-4 inline mr-1" />
                 Katmanlar
               </button>
               <button
                 onClick={() => setRightPanel('guests')}
                 className={`flex-shrink-0 px-3 py-2 text-xs font-medium transition-colors ${
                   rightPanel === 'guests'
                     ? 'text-primary-600 border-b-2 border-primary-600 bg-primary-50'
                     : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                 }`}
               >
                 <Users className="h-4 w-4 inline mr-1" />
                 Davetliler
               </button>
             </div>

             {/* Content */}
             <div className="flex-1 overflow-auto">
               {rightPanel === 'design' && invitation && user && (
                 <DesignPanel
                   formData={formData}
                   onFormChange={handleInputChange}
                   colors={colors}
                   onColorsChange={(newColors) => {
                     setColors(newColors);
                     // Update all text and divider elements with new colors
                     const updatedElements = elements.map(el => {
                       if (el.type === 'text' && el.style) {
                         return { ...el, style: { ...el.style, color: newColors.text } };
                       } else if (el.type === 'divider' && el.style) {
                         return { ...el, style: { ...el.style, color: newColors.accent } };
                       }
                       return el;
                     });
                     updateElements(updatedElements);
                     toast.success('Renkler tüm elementlere uygulandı');
                   }}
                   defaultColors={templateOriginalDesign?.colors}
                   selectedFont={selectedFont}
                   onFontChange={(newFont) => {
                     setSelectedFont(newFont);
                     // Update all text elements with new font
                     const updatedElements = elements.map(el => {
                       if (el.type === 'text' && el.style) {
                         return { ...el, style: { ...el.style, fontFamily: newFont } };
                       }
                       return el;
                     });
                     updateElements(updatedElements);
                     toast.success('Yazı tipi tüm metinlere uygulandı');
                   }}
                   invitationId={invitation.id}
                   userId={user.id}
                   onImageUploaded={(imageUrl) => setFormData({ ...formData, imageUrl })}
                   onImageRemoved={() => setFormData({ ...formData, imageUrl: null })}
                   onPositionChange={(position) => setFormData({ ...formData, imagePosition: position })}
                   onLogoShapeChange={(shape) => setFormData({ ...formData, logoShape: shape })}
                   onOpenGallery={() => setIsGalleryOpen(true)}
                   onResetToTemplate={handleResetToTemplate}
                   hasTemplateOriginal={!!templateOriginalDesign}
                   currentPlan={subscription.currentPlan}
                 />
               )}
               {rightPanel === 'properties' && (
                 <PropertiesPanel
                   selectedElement={selectedElement}
                   onUpdate={handleUpdateElement}
                   onDelete={handleDeleteSelected}
                   colors={colors}
                 />
               )}
               {rightPanel === 'layers' && (
                 <LayersPanel
                   layers={layers}
                   selectedLayerId={selectedElementId}
                   onSelectLayer={setSelectedElementId}
                   onToggleVisibility={handleToggleVisibility}
                   onToggleLock={handleToggleLock}
                   onDeleteLayer={handleDeleteLayer}
                   onDuplicateLayer={handleDuplicateLayer}
                   onReorderLayer={handleReorderLayer}
                 />
               )}
               {rightPanel === 'guests' && invitation && (
                 <div className="p-4">
                   <GuestList
                     invitationId={invitation.id}
                     invitationTitle={invitation.title}
                     invitationStatus={invitation.status}
                   />
                 </div>
               )}
             </div>
          </div>
        </div>
      )}

      {/* Preview Modal */}
      {isPreviewOpen && invitation && (
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
          textFields={[]}
          decorativeElements={elements.filter(el => el.type === 'decoration').map(el => ({
            id: el.id,
            type: 'decoration',
            name: el.name,
            imageUrl: el.imageUrl || '',
            position: el.position,
            size: el.size,
            rotation: el.rotation,
            opacity: el.opacity,
            zIndex: el.zIndex
          }))}
          textElements={elements.filter(el => el.type === 'text' || el.type === 'divider') as any}
          logoShape={formData.logoShape}
          imageTransforms={imageTransforms}
          imageLayers={imageLayers}
          selectedFont={selectedFont}
          canvasSize={canvasDimensions}
        />
      )}
       
       {/* Decorative Elements Gallery */}
       <DecorativeElementsGallery
         isOpen={isGalleryOpen}
         onClose={() => setIsGalleryOpen(false)}
         onSelectGraphic={handleAddDecorativeElement}
       />
     </div>
   );
 };
 
 export default EditorPageV2;

