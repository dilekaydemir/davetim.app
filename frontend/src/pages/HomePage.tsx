import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { ArrowRight, Check, Star, Users, Clock, Download } from 'lucide-react';
import { SEOHead, JSONLDSchema, CanonicalURL, ResourceHints } from '../components/SEO/SEOHead';

const HomePage: React.FC = () => {
  const navigate = useNavigate();

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
      highPrice: '49',
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

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {/* Template previews - will be dynamic later */}
            {['Altın Düğün', 'Vintage Aşk', 'Renkli Parti'].map((template, index) => (
              <div key={index} className="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow">
                <div className="h-64 bg-gradient-to-br from-primary-100 to-primary-200 flex items-center justify-center">
                  <div className="text-primary-700 font-semibold text-lg">{template}</div>
                </div>
                <div className="p-6">
                  <h3 className="text-lg font-semibold text-gray-900 mb-2">{template}</h3>
                  <p className="text-gray-600 text-sm mb-4">
                    Özel günleriniz için tasarlandı
                  </p>
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-1">
                      <Star className="h-4 w-4 text-yellow-400 fill-current" />
                      <span className="text-sm text-gray-600">4.9</span>
                    </div>
                    <span className="text-primary-600 font-semibold">Premium</span>
                  </div>
                </div>
              </div>
            ))}
          </div>

          <div className="text-center mt-12">
            <Link
              to="/templates"
              className="btn-primary text-lg px-8 py-4 inline-flex items-center gap-2"
            >
              Tüm Şablonları Gör
              <ArrowRight className="h-5 w-5" />
            </Link>
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
