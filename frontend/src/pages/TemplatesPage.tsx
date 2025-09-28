import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Star, Crown, Search } from 'lucide-react';

const TemplatesPage: React.FC = () => {
  const navigate = useNavigate();
  const [selectedCategory, setSelectedCategory] = React.useState('all');
  const [searchTerm, setSearchTerm] = React.useState('');

  const categories = [
    { id: 'all', name: 'Tümü', count: 5 },
    { id: 'wedding', name: 'Düğün', count: 2 },
    { id: 'birthday', name: 'Doğum Günü', count: 1 },
    { id: 'baby', name: 'Baby Shower', count: 1 },
    { id: 'corporate', name: 'Kurumsal', count: 1 }
  ];

  // Mock template data - will be replaced with API call
  const templates = [
    {
      id: 1,
      name: 'Altın Düğün',
      category: 'wedding',
      description: 'Lüks altın çerçeveli düğün davetiyesi',
      isPremium: true,
      rating: 4.9,
      downloads: 1250,
      preview: '/templates/previews/altin-dugun.jpg'
    },
    {
      id: 2,
      name: 'Vintage Aşk',
      category: 'wedding',
      description: 'Romantik pembe tonlarında vintage tarzı',
      isPremium: true,
      rating: 4.8,
      downloads: 980,
      preview: '/templates/previews/vintage-ask.jpg'
    },
    {
      id: 3,
      name: 'Renkli Parti',
      category: 'birthday',
      description: 'Canlı renklerle eğlenceli doğum günü',
      isPremium: true,
      rating: 4.7,
      downloads: 756,
      preview: '/templates/previews/renkli-parti.jpg'
    },
    {
      id: 4,
      name: 'Pastel Bebek',
      category: 'baby',
      description: 'Soft pastel renklerde baby shower',
      isPremium: true,
      rating: 4.9,
      downloads: 432,
      preview: '/templates/previews/pastel-bebek.jpg'
    },
    {
      id: 5,
      name: 'Kurumsal Etkinlik',
      category: 'corporate',
      description: 'Profesyonel mavi-beyaz kurumsal',
      isPremium: true,
      rating: 4.6,
      downloads: 234,
      preview: '/templates/previews/kurumsal-etkinlik.jpg'
    }
  ];

  const filteredTemplates = templates.filter(template => {
    const matchesCategory = selectedCategory === 'all' || template.category === selectedCategory;
    const matchesSearch = template.name.toLowerCase().includes(searchTerm.toLowerCase());
    return matchesCategory && matchesSearch;
  });

  const handleTemplateSelect = (templateId: number) => {
    navigate(`/editor/${templateId}`);
  };

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Davetiye Şablonları
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Özel günleriniz için profesyonel tasarlanmış şablonlar. 
            Hemen seçin ve kişiselleştirin!
          </p>
        </div>

        {/* Search & Filter */}
        <div className="flex flex-col lg:flex-row gap-6 mb-8">
          {/* Search */}
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
            <input
              type="text"
              placeholder="Şablon ara..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            />
          </div>

          {/* Category Filter */}
          <div className="flex flex-wrap gap-2">
            {categories.map((category) => (
              <button
                key={category.id}
                onClick={() => setSelectedCategory(category.id)}
                className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                  selectedCategory === category.id
                    ? 'bg-primary-500 text-white'
                    : 'bg-white text-gray-700 hover:bg-primary-50 border border-gray-300'
                }`}
              >
                {category.name} ({category.count})
              </button>
            ))}
          </div>
        </div>

        {/* Templates Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {filteredTemplates.map((template) => (
            <div
              key={template.id}
              className="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 cursor-pointer group"
              onClick={() => handleTemplateSelect(template.id)}
            >
              {/* Template Preview */}
              <div className="relative h-64 bg-gradient-to-br from-primary-100 to-primary-200 flex items-center justify-center overflow-hidden">
                {/* Preview placeholder - will be replaced with actual images */}
                <div className="text-primary-700 font-semibold text-lg text-center">
                  {template.name}
                  <div className="text-sm text-primary-600 mt-2">Önizleme</div>
                </div>
                
                {/* Premium Badge */}
                {template.isPremium && (
                  <div className="absolute top-3 right-3 bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-3 py-1 rounded-full text-xs font-semibold flex items-center gap-1">
                    <Crown className="h-3 w-3" />
                    Premium
                  </div>
                )}

                {/* Hover Overlay */}
                <div className="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-10 transition-all duration-300 flex items-center justify-center">
                  <button className="bg-white text-primary-600 px-6 py-2 rounded-lg font-semibold opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-y-2 group-hover:translate-y-0">
                    Bu Şablonu Kullan
                  </button>
                </div>
              </div>

              {/* Template Info */}
              <div className="p-6">
                <h3 className="text-lg font-semibold text-gray-900 mb-2">
                  {template.name}
                </h3>
                <p className="text-gray-600 text-sm mb-4">
                  {template.description}
                </p>
                
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div className="flex items-center gap-1">
                      <Star className="h-4 w-4 text-yellow-400 fill-current" />
                      <span className="text-sm text-gray-600">{template.rating}</span>
                    </div>
                    <div className="text-sm text-gray-500">
                      {template.downloads} kullanım
                    </div>
                  </div>
                  
                  {template.isPremium ? (
                    <span className="text-primary-600 font-semibold text-sm">PRO</span>
                  ) : (
                    <span className="text-green-600 font-semibold text-sm">Ücretsiz</span>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* No Results */}
        {filteredTemplates.length === 0 && (
          <div className="text-center py-12">
            <div className="text-gray-500 text-lg mb-4">
              Aradığınız kriterlere uygun şablon bulunamadı
            </div>
            <button
              onClick={() => {
                setSearchTerm('');
                setSelectedCategory('all');
              }}
              className="btn-secondary"
            >
              Filtreleri Temizle
            </button>
          </div>
        )}

        {/* CTA Section */}
        <div className="bg-primary-50 rounded-2xl p-8 mt-16 text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            Özel Şablon İsteğiniz Var mı?
          </h2>
          <p className="text-gray-600 mb-6">
            Premium planla özel tasarım taleplerinde bulunabilir, 
            kendi şablonlarınızı yükleyebilirsiniz.
          </p>
          <button
            onClick={() => navigate('/pricing')}
            className="btn-primary"
          >
            Premium'a Yükseltin
          </button>
        </div>
      </div>
    </div>
  );
};

export default TemplatesPage;
