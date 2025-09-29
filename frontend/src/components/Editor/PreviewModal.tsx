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
}

const PreviewModal: React.FC<PreviewModalProps> = ({
  isOpen,
  onClose,
  invitation,
  invitationData
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
              className="bg-white border-2 border-gray-200 rounded-lg p-8 max-w-2xl mx-auto"
              style={{
                minHeight: '600px',
                background: invitation?.template?.preview_url 
                  ? `url(${invitation.template.preview_url}) center/cover no-repeat`
                  : 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
              }}
            >
              {/* Invitation Content */}
              <div className="text-center space-y-6 text-white">
                {/* Title */}
                <h1 className="text-4xl md:text-5xl font-bold mb-8 drop-shadow-lg">
                  {invitationData.title || 'Davetiye Başlığı'}
                </h1>

                {/* Date & Time */}
                {invitationData.eventDate && (
                  <div className="space-y-2">
                    <p className="text-2xl font-semibold drop-shadow-md">
                      📅 {formatDate(invitationData.eventDate)}
                    </p>
                    {invitationData.eventTime && (
                      <p className="text-xl drop-shadow-md">
                        🕐 {invitationData.eventTime}
                      </p>
                    )}
                  </div>
                )}

                {/* Location */}
                {invitationData.location && (
                  <div className="mt-6">
                    <p className="text-xl font-medium drop-shadow-md">
                      📍 {invitationData.location}
                    </p>
                  </div>
                )}

                {/* Message */}
                {invitationData.message && (
                  <div className="mt-8 bg-white bg-opacity-20 backdrop-blur-sm rounded-lg p-6">
                    <p className="text-lg leading-relaxed whitespace-pre-wrap">
                      {invitationData.message}
                    </p>
                  </div>
                )}

                {/* Decorative Element */}
                <div className="mt-12 pt-8 border-t-2 border-white border-opacity-30">
                  <p className="text-lg italic opacity-90">
                    Sizleri aramızda görmekten mutluluk duyarız
                  </p>
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
