import React, { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { ArrowRight, Check, Star, Users, Clock, Download } from 'lucide-react';
import { SEOHead, JSONLDSchema, CanonicalURL, ResourceHints } from '../components/SEO/SEOHead';
import { templateService, type Template } from '../services/templateService';
import { getOptimizedUnsplashUrl } from '../utils/imageOptimization';

const HomePage: React.FC = () => {
  const navigate = useNavigate();
  
  // State for templates
  const [featuredTemplates, setFeaturedTemplates] = useState<Template[]>([]);
  const [isLoadingTemplates, setIsLoadingTemplates] = useState(true);

  // Load featured templates
  useEffect(() => {
    loadFeaturedTemplates();
  }, []);

  const loadFeaturedTemplates = async () => {
    try {
      setIsLoadingTemplates(true);
      // Get 3 featured templates for homepage
      const templates = await templateService.getFeaturedTemplates(3);
      setFeaturedTemplates(templates);
    } catch (error) {
      console.error('Error loading featured templates:', error);
    } finally {
      setIsLoadingTemplates(false);
    }
  };

  // Schema.org structured data
  const schemaData = {
    '@context': 'https://schema.org',
    '@type': 'WebApplication',
    name: 'Davetim',
    applicationCategory: 'DesignApplication',
    operatingSystem: 'Web',
    offers: {
      '@type': 'AggregateOffer',
      lowPrice: '0',
      highPrice: '79',
      priceCurrency: 'TRY',
      offerCount: '3',
    },
    aggregateRating: {
      '@type': 'AggregateRating',
      ratingValue: '4.9',
      reviewCount: '10000',
    },
    description: 'Özel günleriniz için profesyonel dijital davetiyeler oluşturun. Hazır şablonlar, kolay düzenleme, RSVP takibi.',
  };

  const features = [
    {
      icon: <Clock className="h-6 w-6 text-primary-500" />,
      title: "5 Dakikada Hazır",
      description: "Şablonu seçin, bilgilerinizi girin ve profesyonel davetiyeniz hazır!"
    },
    {
      icon: <Download className="h-6 w-6 text-primary-500" />,
      title: "HD PDF İndirme",
      description: "Yazdırmaya hazır, yüksek çözünürlüklü PDF formatında indirin."
    },
    {
      icon: <Users className="h-6 w-6 text-primary-500" />,
      title: "WhatsApp Paylaşım",
      description: "Davetiyenizi sosyal medyada kolayca paylaşın."
    }
  ];

  const stats = [
    { number: "10,000+", label: "Mutlu Kullanıcı" },
    { number: "50,000+", label: "Oluşturulan Davetiye" },
    { number: "4.9", label: "Kullanıcı Puanı" },
  ];

  return (
    <>
      {/* SEO Meta Tags */}
      <SEOHead
        title="Davetim - Profesyonel Dijital Davetiye Oluşturucu | Ücretsiz Dene"
        description="Özel günleriniz için profesyonel dijital davetiyeler oluşturun. 100+ hazır şablon, kolay düzenleme, RSVP takibi, WhatsApp paylaşım. Ücretsiz başlayın!"
        keywords="dijital davetiye, online davetiye, davetiye tasarımı, düğün davetiyesi, nişan davetiyesi, doğum günü davetiyesi, ücretsiz davetiye"
        url="https://davetim.app"
        type="website"
      />
      <JSONLDSchema data={schemaData} />
      <CanonicalURL url="https://davetim.app" />
      <ResourceHints />

      <div className="min-h-screen">
        {/* Hero Section */}
      <section className="bg-gradient-to-br from-primary-50 to-orange-50 pt-20 pb-16 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="text-center">
            <h1 className="text-4xl sm:text-6xl font-bold text-gray-900 mb-6">
              <span className="text-primary-500">5 Dakikada</span><br />
              Profesyonel Davetiye
            </h1>
            <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
              Düğün, doğum günü, baby shower ve tüm özel anlarınız için 
              hazır şablonlarla hemen davetiye oluşturun.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
              <button
                onClick={() => navigate('/templates')}
                className="btn-primary text-lg px-8 py-4 flex items-center gap-2"
              >
                Hemen Başla
                <ArrowRight className="h-5 w-5" />
              </button>
              <Link
                to="/pricing"
                className="btn-outline text-lg px-8 py-4"
              >
                Fiyatları İncele
              </Link>
            </div>
          </div>

          {/* Stats */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-16">
            {stats.map((stat, index) => (
              <div key={index} className="text-center">
                <div className="text-3xl font-bold text-primary-600">{stat.number}</div>
                <div className="text-gray-600">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl sm:text-4xl font-bold text-gray-900 mb-4">
              Neden Davetim?
            </h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              Türkiye'nin en hızlı ve kullanıcı dostu davetiye platformu
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {features.map((feature, index) => (
              <div key={index} className="text-center p-6 rounded-xl bg-white shadow-lg border">
                <div className="flex justify-center mb-4">
                  {feature.icon}
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-2">
                  {feature.title}
                </h3>
                <p className="text-gray-600">
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Template Preview Section */}
      <section className="bg-gray-50 py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl sm:text-4xl font-bold text-gray-900 mb-4">
              Profesyonel Şablonlar
            </h2>
            <p className="text-xl text-gray-600">
              Her özel anınız için özel tasarlanmış şablonlar
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto">
            {isLoadingTemplates ? (
              // Loading skeleton
              Array.from({ length: 3 }).map((_, index) => (
                <div key={index} className="bg-white rounded-xl shadow-lg overflow-hidden animate-pulse">
                  <div className="h-64 bg-gray-200"></div>
                  <div className="p-6">
                    <div className="h-4 bg-gray-200 rounded mb-2"></div>
                    <div className="h-3 bg-gray-200 rounded mb-4"></div>
                    <div className="flex items-center justify-between">
                      <div className="h-3 bg-gray-200 rounded w-12"></div>
                      <div className="h-3 bg-gray-200 rounded w-16"></div>
                    </div>
                  </div>
                </div>
              ))
            ) : featuredTemplates.length > 0 ? (
              // Real templates
              featuredTemplates.map((template) => (
                <Link
                  key={template.id}
                  to={`/editor?template=${template.slug}`}
                  className="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow group"
                >
                  <div className="h-64 relative overflow-hidden">
                    <img
                      src={getOptimizedUnsplashUrl(template.preview_image_url, { width: 400, quality: 85 })}
                      alt={template.name}
                      className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                      loading="lazy"
                    />
                    {template.tier !== 'free' && (
                      <div className="absolute top-3 right-3">
                        <span className={`inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${
                          template.tier === 'pro' 
                            ? 'bg-blue-100 text-blue-800' 
                            : 'bg-purple-100 text-purple-800'
                        }`}>
                          {template.tier === 'pro' ? 'PRO' : 'PREMIUM'}
                        </span>
                      </div>
                    )}
                  </div>
                  <div className="p-6">
                    <h3 className="text-lg font-semibold text-gray-900 mb-2">{template.name}</h3>
                    <p className="text-gray-600 text-sm mb-4">
                      {template.description || 'Özel günleriniz için tasarlandı'}
                    </p>
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-1">
                        <Star className="h-4 w-4 text-yellow-400 fill-current" />
                        <span className="text-sm text-gray-600">4.9</span>
                      </div>
                      <span className={`font-semibold ${
                        template.tier === 'free' 
                          ? 'text-green-600' 
                          : template.tier === 'pro' 
                            ? 'text-blue-600' 
                            : 'text-purple-600'
                      }`}>
                        {template.tier === 'free' ? 'Ücretsiz' : template.tier === 'pro' ? 'PRO' : 'PREMIUM'}
                      </span>
                    </div>
                  </div>
                </Link>
              ))
            ) : (
              // Fallback with static templates if no data (3 templates)
              [
                { name: 'Klasik Beyaz Düğün', tier: 'free', image: 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400&h=600&fit=crop&crop=center' },
                { name: 'Lüks Altın Düğün', tier: 'pro', image: 'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=600&fit=crop&crop=center' },
                { name: 'Saray Düğünü', tier: 'premium', image: 'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=600&fit=crop&crop=center' }
              ].map((template, index) => (
                <div
                  key={index}
                  className="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow group"
                >
                  <div className="h-64 relative overflow-hidden">
                    <img
                      src={template.image}
                      alt={template.name}
                      className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                      loading="lazy"
                    />
                    {template.tier !== 'free' && (
                      <div className="absolute top-3 right-3">
                        <span className={`inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${
                          template.tier === 'pro' 
                            ? 'bg-blue-100 text-blue-800' 
                            : 'bg-purple-100 text-purple-800'
                        }`}>
                          {template.tier === 'pro' ? 'PRO' : 'PREMIUM'}
                        </span>
                      </div>
                    )}
                  </div>
                  <div className="p-6">
                    <h3 className="text-lg font-semibold text-gray-900 mb-2">{template.name}</h3>
                    <p className="text-gray-600 text-sm mb-4">
                      Özel günleriniz için tasarlandı
                    </p>
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-1">
                        <Star className="h-4 w-4 text-yellow-400 fill-current" />
                        <span className="text-sm text-gray-600">4.9</span>
                      </div>
                      <span className={`font-semibold ${
                        template.tier === 'free' 
                          ? 'text-green-600' 
                          : template.tier === 'pro' 
                            ? 'text-blue-600' 
                            : 'text-purple-600'
                      }`}>
                        {template.tier === 'free' ? 'Ücretsiz' : template.tier === 'pro' ? 'PRO' : 'PREMIUM'}
                      </span>
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>

          <div className="text-center mt-12">
            <Link
              to="/templates"
              className="btn-primary text-lg px-8 py-4 inline-flex items-center gap-2 hover:scale-105 transition-transform"
            >
              Tüm Şablonları Gör
              <ArrowRight className="h-5 w-5" />
            </Link>
            <p className="text-gray-500 text-sm mt-3">
              100+ profesyonel şablon arasından seçin
            </p>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="bg-primary-600 py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="text-3xl sm:text-4xl font-bold text-white mb-4">
            Hemen Başlayın!
          </h2>
          <p className="text-xl text-primary-100 mb-8">
            İlk davetiyenizi ücretsiz oluşturun. Kredi kartı gerektirmez.
          </p>
          <button
            onClick={() => navigate('/templates')}
            className="bg-white text-primary-600 hover:bg-gray-100 font-semibold text-lg px-8 py-4 rounded-lg transition-colors inline-flex items-center gap-2"
          >
            Ücretsiz Başla
            <ArrowRight className="h-5 w-5" />
          </button>
        </div>
      </section>
      </div>
    </>
  );
};

export default HomePage;
