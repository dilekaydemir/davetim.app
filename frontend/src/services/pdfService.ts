import html2canvas from 'html2canvas';
import jsPDF from 'jspdf';
import toast from 'react-hot-toast';

export interface PDFExportOptions {
  filename?: string;
  quality?: number;
  orientation?: 'portrait' | 'landscape';
  format?: 'a4' | 'letter';
}

class PDFService {
  /**
   * Export HTML element to PDF
   * @param element - HTML element to convert
   * @param options - PDF export options
   */
  async exportToPDF(element: HTMLElement, options: PDFExportOptions = {}): Promise<Blob | null> {
    const {
      quality = 2,
      orientation = 'portrait',
      format = 'a4'
    } = options;

    try {
      console.log('📄 Starting PDF generation...');
      toast.loading('PDF oluşturuluyor...', { id: 'pdf-export' });

      // Convert HTML to canvas
      const canvas = await html2canvas(element, {
        scale: quality,
        useCORS: true,
        logging: false,
        backgroundColor: '#ffffff',
        windowWidth: element.scrollWidth,
        windowHeight: element.scrollHeight,
      });

      console.log('✅ Canvas created:', canvas.width, 'x', canvas.height);

      // Get image data from canvas
      const imgData = canvas.toDataURL('image/png');

      // Calculate PDF dimensions
      const imgWidth = canvas.width;
      const imgHeight = canvas.height;
      
      // A4 dimensions in mm
      const pdfWidth = orientation === 'portrait' ? 210 : 297;
      const pdfHeight = orientation === 'portrait' ? 297 : 210;
      
      // Calculate scaling to fit the page
      const ratio = Math.min(pdfWidth / imgWidth, pdfHeight / imgHeight);
      const scaledWidth = imgWidth * ratio;
      const scaledHeight = imgHeight * ratio;
      
      // Center the image on the page
      const x = (pdfWidth - scaledWidth) / 2;
      const y = (pdfHeight - scaledHeight) / 2;

      // Create PDF
      const pdf = new jsPDF({
        orientation,
        unit: 'mm',
        format
      });

      pdf.addImage(imgData, 'PNG', x, y, scaledWidth, scaledHeight);

      // Get PDF as blob
      const pdfBlob = pdf.output('blob');

      console.log('✅ PDF generated successfully');
      toast.success('PDF hazır!', { id: 'pdf-export' });

      return pdfBlob;
    } catch (error: any) {
      console.error('❌ PDF generation error:', error);
      toast.error('PDF oluşturulurken bir hata oluştu', { id: 'pdf-export' });
      return null;
    }
  }

  /**
   * Download PDF file
   * @param blob - PDF blob
   * @param filename - Download filename
   */
  downloadPDF(blob: Blob, filename: string = 'davetiye.pdf') {
    try {
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = filename;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);
      
      console.log('✅ PDF downloaded:', filename);
      toast.success('PDF indirildi!');
    } catch (error) {
      console.error('❌ PDF download error:', error);
      toast.error('PDF indirme hatası');
    }
  }

  /**
   * Export and download PDF in one step
   * @param element - HTML element to convert
   * @param options - PDF export options
   */
  async exportAndDownload(element: HTMLElement, options: PDFExportOptions = {}): Promise<void> {
    const blob = await this.exportToPDF(element, options);
    if (blob) {
      this.downloadPDF(blob, options.filename || 'davetiye.pdf');
    }
  }

  /**
   * Generate shareable image from HTML element
   * @param element - HTML element to convert
   * @param quality - Image quality (1-3)
   */
  async exportToImage(element: HTMLElement, quality: number = 2): Promise<Blob | null> {
    try {
      console.log('🖼️ Generating image...');
      toast.loading('Görsel oluşturuluyor...', { id: 'image-export' });

      const canvas = await html2canvas(element, {
        scale: quality,
        useCORS: true,
        logging: false,
        backgroundColor: '#ffffff',
      });

      const blob = await new Promise<Blob | null>((resolve) => {
        canvas.toBlob((blob) => resolve(blob), 'image/png', 0.95);
      });

      if (blob) {
        console.log('✅ Image generated successfully');
        toast.success('Görsel hazır!', { id: 'image-export' });
      }

      return blob;
    } catch (error: any) {
      console.error('❌ Image generation error:', error);
      toast.error('Görsel oluşturulurken bir hata oluştu', { id: 'image-export' });
      return null;
    }
  }

  /**
   * Download image file
   * @param blob - Image blob
   * @param filename - Download filename
   */
  downloadImage(blob: Blob, filename: string = 'davetiye.png') {
    try {
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = filename;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);
      
      console.log('✅ Image downloaded:', filename);
      toast.success('Görsel indirildi!');
    } catch (error) {
      console.error('❌ Image download error:', error);
      toast.error('Görsel indirme hatası');
    }
  }

  /**
   * Copy share link to clipboard
   * @param invitationId - Invitation ID
   */
  copyShareLink(invitationId: string): void {
    const shareUrl = `${window.location.origin}/i/${invitationId}`;
    
    navigator.clipboard.writeText(shareUrl)
      .then(() => {
        console.log('✅ Share link copied:', shareUrl);
        toast.success('Link kopyalandı!');
      })
      .catch((error) => {
        console.error('❌ Copy error:', error);
        toast.error('Link kopyalanamadı');
      });
  }

  /**
   * Share via Web Share API (mobile)
   * @param title - Share title
   * @param text - Share text
   * @param url - Share URL
   */
  async share(title: string, text: string, url: string): Promise<void> {
    if (navigator.share) {
      try {
        await navigator.share({
          title,
          text,
          url
        });
        console.log('✅ Shared successfully');
      } catch (error) {
        console.error('❌ Share error:', error);
      }
    } else {
      // Fallback: copy to clipboard
      navigator.clipboard.writeText(url)
        .then(() => toast.success('Link kopyalandı!'))
        .catch(() => toast.error('Paylaşım desteklenmiyor'));
    }
  }
}

export const pdfService = new PDFService();
