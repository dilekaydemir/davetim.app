import React, { useRef } from 'react';
import { X, Download, Share2, Image as ImageIcon, Loader2 } from 'lucide-react';
import { pdfService } from '../../services/pdfService';
import type { Invitation } from '../../services/invitationService';

interface PreviewModalProps {
  isOpen: boolean;
  onClose: () => void;
  invitation: Invitation | null;
  invitationData: {
    title: string;
    eventDate: string;
    eventTime: string;
    location: string;
    message: string;
  };
  colors?: {
    primary: string;
    secondary: string;
    background: string;
    text: string;
    accent: string;
  };
}

const PreviewModal: React.FC<PreviewModalProps> = ({
  isOpen,
  onClose,
  invitation,
  invitationData,
  colors = {
    primary: '#667eea',
    secondary: '#764ba2',
    background: '#ffffff',
    text: '#ffffff',
    accent: '#f56565'
  }
}) => {
  const previewRef = useRef<HTMLDivElement>(null);
  const [isExporting, setIsExporting] = React.useState(false);

  if (!isOpen) return null;

  const handleExportPDF = async () => {
    if (!previewRef.current) return;
    
    setIsExporting(true);
    try {
      await pdfService.exportAndDownload(previewRef.current, {
        filename: `${invitationData.title || 'davetiye'}.pdf`,
        quality: 2,
        orientation: 'portrait'
      });
    } finally {
      setIsExporting(false);
    }
  };

  const handleExportImage = async () => {
    if (!previewRef.current) return;
    
    setIsExporting(true);
    try {
      const blob = await pdfService.exportToImage(previewRef.current, 2);
      if (blob) {
        pdfService.downloadImage(blob, `${invitationData.title || 'davetiye'}.png`);
      }
    } finally {
      setIsExporting(false);
    }
  };

  const handleShare = () => {
    if (invitation?.id) {
      pdfService.copyShareLink(invitation.id);
    }
  };

  const formatDate = (dateStr: string) => {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleDateString('tr-TR', { 
      day: 'numeric', 
      month: 'long', 
      year: 'numeric' 
    });
  };

  return (
    <div className="fixed inset-0 z-50 overflow-y-auto">
      {/* Backdrop */}
      <div 
        className="fixed inset-0 bg-black bg-opacity-50 transition-opacity"
        onClick={onClose}
      />

      {/* Modal */}
      <div className="flex min-h-full items-center justify-center p-4">
        <div className="relative bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-hidden">
          {/* Header */}
          <div className="flex items-center justify-between p-4 border-b border-gray-200">
            <h2 className="text-xl font-semibold text-gray-900">
              Davetiye Önizleme
            </h2>
            <button
              onClick={onClose}
              className="p-2 text-gray-400 hover:text-gray-600 rounded-lg hover:bg-gray-100 transition-colors"
            >
              <X className="h-5 w-5" />
            </button>
          </div>

          {/* Preview Content */}
          <div className="p-6 overflow-y-auto max-h-[calc(90vh-180px)]">
            <div 
              ref={previewRef}
              className="bg-white rounded-lg shadow-lg overflow-hidden max-w-2xl mx-auto"
              style={{
                minHeight: '600px',
                background: `linear-gradient(135deg, ${colors.primary} 0%, ${colors.secondary} 100%)`
              }}
            >
              <div className="p-8 md:p-12 flex items-center justify-center min-h-[600px]">
                <div className="text-center space-y-4 max-w-sm" style={{ color: colors.text }}>
                  {/* Title */}
                  <div className="text-2xl md:text-4xl font-serif font-bold">
                    {invitationData.title || 'Davetiye Başlığı'}
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
                      {invitationData.eventDate ? formatDate(invitationData.eventDate) : 'Tarih Seçin'}
                    </div>
                    <div className="mt-1">
                      {invitationData.eventTime || 'Saat Seçin'}
                    </div>
                  </div>
                  
                  {/* Accent Divider */}
                  <div 
                    className="w-24 h-1 mx-auto rounded-full"
                    style={{ backgroundColor: colors.accent }}
                  />
                  
                  {/* Location */}
                  <div style={{ opacity: 0.95 }}>
                    {invitationData.location || 'Konum Belirtin'}
                  </div>
                  
                  {/* Custom Message */}
                  {invitationData.message && (
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
                        "{invitationData.message}"
                      </div>
                    </>
                  )}

                  {/* Decorative Footer */}
                  <div 
                    className="mt-12 pt-8"
                    style={{ 
                      borderTop: `2px solid ${colors.accent}40`
                    }}
                  >
                    <p className="text-lg italic opacity-90">
                      Sizleri aramızda görmekten mutluluk duyarız
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Actions */}
          <div className="flex items-center justify-end gap-3 p-4 border-t border-gray-200 bg-gray-50">
            <button
              onClick={handleShare}
              className="btn-secondary flex items-center gap-2"
              disabled={!invitation?.id}
            >
              <Share2 className="h-4 w-4" />
              Link Kopyala
            </button>
            
            <button
              onClick={handleExportImage}
              className="btn-secondary flex items-center gap-2"
              disabled={isExporting}
            >
              {isExporting ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <ImageIcon className="h-4 w-4" />
              )}
              PNG İndir
            </button>

            <button
              onClick={handleExportPDF}
              className="btn-primary flex items-center gap-2"
              disabled={isExporting}
            >
              {isExporting ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <Download className="h-4 w-4" />
              )}
              PDF İndir
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PreviewModal;
