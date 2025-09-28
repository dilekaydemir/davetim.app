import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowLeft, Download, Share2, Eye, Save, Palette } from 'lucide-react';

const EditorPage: React.FC = () => {
  const { templateId } = useParams();
  const navigate = useNavigate();
  
  // Mock form data - will be connected to form management
  const [formData, setFormData] = React.useState({
    title: 'Sevgi & Ahmet Düğünü',
    eventDate: '2025-06-15',
    eventTime: '16:00',
    location: 'Grand Hotel, İstanbul',
    customMessage: 'Mutluluğumuzu paylaşmak istiyoruz'
  });

  const [selectedColor, setSelectedColor] = React.useState('default');
  const [selectedFont, setSelectedFont] = React.useState('normal');

  // Mock template data
  const template = {
    id: templateId,
    name: 'Altın Düğün',
    category: 'wedding',
    isPremium: true
  };

  const colorOptions = [
    { id: 'default', name: 'Orijinal', preview: 'bg-gradient-to-r from-yellow-400 to-orange-500' },
    { id: 'variant1', name: 'Mavi Altın', preview: 'bg-gradient-to-r from-blue-400 to-indigo-500' },
    { id: 'variant2', name: 'Pembe Altın', preview: 'bg-gradient-to-r from-pink-400 to-rose-500' }
  ];

  const fontOptions = [
    { id: 'normal', name: 'Normal' },
    { id: 'large', name: 'Büyük' }
  ];

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const handleSave = () => {
    // TODO: Save invitation to backend
    console.log('Saving invitation:', { templateId, formData, selectedColor, selectedFont });
    alert('Davetiye kaydedildi!');
  };

  const handleDownload = () => {
    // TODO: Generate and download PDF
    console.log('Downloading PDF:', { templateId, formData, selectedColor, selectedFont });
    alert('PDF indiriliyor...');
  };

  const handleShare = () => {
    // TODO: Implement sharing functionality
    console.log('Sharing invitation');
    alert('Paylaşım özelliği yakında eklenecek!');
  };

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
                  Son kaydedilme: Bugün 14:30
                </p>
              </div>
            </div>

            <div className="flex items-center space-x-3">
              <button
                onClick={handleSave}
                className="btn-secondary flex items-center gap-2"
              >
                <Save className="h-4 w-4" />
                Kaydet
              </button>
              <button
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
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-xl font-semibold text-gray-900 mb-6">
              Davetiye Bilgileri
            </h2>

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

              {/* Customization */}
              <div className="border-t pt-6">
                <h3 className="text-lg font-medium text-gray-900 mb-4 flex items-center gap-2">
                  <Palette className="h-5 w-5" />
                  Görünüm Ayarları
                </h3>

                {/* Color Options */}
                <div className="mb-6">
                  <label className="block text-sm font-medium text-gray-700 mb-3">
                    Renk Teması
                  </label>
                  <div className="grid grid-cols-3 gap-3">
                    {colorOptions.map((color) => (
                      <button
                        key={color.id}
                        onClick={() => setSelectedColor(color.id)}
                        className={`p-3 rounded-lg border-2 transition-colors ${
                          selectedColor === color.id
                            ? 'border-primary-500 bg-primary-50'
                            : 'border-gray-200 hover:border-gray-300'
                        }`}
                      >
                        <div className={`w-full h-8 rounded ${color.preview} mb-2`} />
                        <span className="text-sm font-medium">{color.name}</span>
                      </button>
                    ))}
                  </div>
                </div>

                {/* Font Size */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-3">
                    Font Boyutu
                  </label>
                  <div className="grid grid-cols-2 gap-3">
                    {fontOptions.map((font) => (
                      <button
                        key={font.id}
                        onClick={() => setSelectedFont(font.id)}
                        className={`p-3 rounded-lg border-2 transition-colors ${
                          selectedFont === font.id
                            ? 'border-primary-500 bg-primary-50'
                            : 'border-gray-200 hover:border-gray-300'
                        }`}
                      >
                        <span className={`font-medium ${font.id === 'large' ? 'text-lg' : 'text-base'}`}>
                          {font.name}
                        </span>
                      </button>
                    ))}
                  </div>
                </div>
              </div>
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

            {/* Mock Preview */}
            <div className="aspect-[3/4] bg-gradient-to-br from-yellow-100 to-orange-100 rounded-lg border-2 border-dashed border-gray-300 flex items-center justify-center p-8">
              <div className="text-center space-y-4 max-w-sm">
                <div className={`text-2xl font-serif font-bold text-gray-800 ${selectedFont === 'large' ? 'text-3xl' : 'text-2xl'}`}>
                  {formData.title || 'Etkinlik Başlığı'}
                </div>
                
                <div className="w-24 h-px bg-gray-400 mx-auto" />
                
                <div className="text-gray-700">
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
                
                <div className="w-24 h-px bg-gray-400 mx-auto" />
                
                <div className="text-gray-600">
                  {formData.location || 'Konum Belirtin'}
                </div>
                
                {formData.customMessage && (
                  <>
                    <div className="w-16 h-px bg-gray-400 mx-auto" />
                    <div className="text-gray-600 text-sm italic">
                      "{formData.customMessage}"
                    </div>
                  </>
                )}
              </div>
            </div>

            <div className="mt-6 text-center text-sm text-gray-500">
              ⚡ Gerçek zamanlı önizleme - Değişiklikler anında görünür
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default EditorPage;
