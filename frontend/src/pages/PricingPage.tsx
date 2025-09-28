import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Check, Crown, Star, Zap } from 'lucide-react';

const PricingPage: React.FC = () => {
  const navigate = useNavigate();
  const [billingPeriod, setBillingPeriod] = React.useState<'monthly' | 'yearly'>('monthly');

  const plans = [
    {
      id: 'free',
      name: 'Ücretsiz',
      price: { monthly: 0, yearly: 0 },
      description: 'Başlangıç için ideal',
      icon: <Star className="h-6 w-6" />,
      color: 'gray',
      features: [
        '2 premium şablon',
        'Ayda 3 indirme',
        'HD PDF çıktısı',
        'Temel destek',
        '10MB depolama'
      ],
      limitations: [
        'Sınırlı şablon seçenekleri',
        'Aylık indirme limiti',
        'Temel özellikler'
      ],
      popular: false,
      cta: 'Ücretsiz Başla'
    },
    {
      id: 'pro',
      name: 'PRO',
      price: { monthly: 29, yearly: 290 },
      description: 'Kişisel kullanım için',
      icon: <Zap className="h-6 w-6" />,
      color: 'primary',
      features: [
        'Tüm premium şablonlar',
        'Sınırsız indirme',
        'HD PDF + JPG çıktısı',
        'WhatsApp direkt paylaşım',
        'Öncelikli destek',
        '100MB depolama',
        'Renk ve font özelleştirme',
        'Davetiye geçmişi'
      ],
      limitations: [],
      popular: true,
      cta: 'PRO\'ya Başla'
    },
    {
      id: 'premium',
      name: 'PREMIUM',
      price: { monthly: 49, yearly: 490 },
      description: 'Profesyonel kullanım için',
      icon: <Crown className="h-6 w-6" />,
      color: 'gradient',
      features: [
        'PRO\'nun tüm özellikleri',
        'AI davetiye önerileri',
        'Özel tasarım talepleri',
        'Toplu davetiye oluşturma',
        '7/24 öncelikli destek',
        '1GB depolama',
        'Marka logosu ekleme',
        'Analitik raporları',
        'API erişimi'
      ],
      limitations: [],
      popular: false,
      cta: 'PREMIUM\'a Başla'
    }
  ];

  const handlePlanSelect = (planId: string) => {
    if (planId === 'free') {
      navigate('/signup');
    } else {
      // TODO: Navigate to payment page with selected plan
      console.log('Selected plan:', planId, 'billing:', billingPeriod);
      alert(`${planId.toUpperCase()} planı seçildi! Ödeme sayfası yakında eklenecek.`);
    }
  };

  const getPlanCardClass = (plan: any) => {
    if (plan.popular) {
      return 'border-2 border-primary-500 relative transform scale-105 shadow-xl';
    }
    return 'border border-gray-200 hover:border-primary-300 shadow-lg hover:shadow-xl transition-all duration-200';
  };

  const getButtonClass = (plan: any) => {
    switch (plan.color) {
      case 'primary':
        return 'btn-primary w-full';
      case 'gradient':
        return 'w-full bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-white font-medium px-6 py-3 rounded-lg transition-all duration-200';
      default:
        return 'btn-outline w-full';
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center mb-16">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Size Uygun Planı Seçin
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            İhtiyacınıza göre tasarlanmış esnek fiyatlandırma. 
            İstediğiniz zaman yükseltebilir veya iptal edebilirsiniz.
          </p>
        </div>

        {/* Billing Toggle */}
        <div className="flex justify-center mb-12">
          <div className="bg-white rounded-lg p-1 border border-gray-200">
            <div className="flex">
              <button
                onClick={() => setBillingPeriod('monthly')}
                className={`px-6 py-2 rounded-md text-sm font-medium transition-colors ${
                  billingPeriod === 'monthly'
                    ? 'bg-primary-500 text-white'
                    : 'text-gray-700 hover:text-gray-900'
                }`}
              >
                Aylık
              </button>
              <button
                onClick={() => setBillingPeriod('yearly')}
                className={`px-6 py-2 rounded-md text-sm font-medium transition-colors relative ${
                  billingPeriod === 'yearly'
                    ? 'bg-primary-500 text-white'
                    : 'text-gray-700 hover:text-gray-900'
                }`}
              >
                Yıllık
                <span className="absolute -top-2 -right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full">
                  2 ay bedava
                </span>
              </button>
            </div>
          </div>
        </div>

        {/* Pricing Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
          {plans.map((plan) => (
            <div
              key={plan.id}
              className={`bg-white rounded-2xl p-8 ${getPlanCardClass(plan)}`}
            >
              {/* Popular Badge */}
              {plan.popular && (
                <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                  <span className="bg-primary-500 text-white px-4 py-2 rounded-full text-sm font-medium">
                    En Popüler
                  </span>
                </div>
              )}

              {/* Plan Header */}
              <div className="text-center mb-8">
                <div className={`inline-flex items-center justify-center w-12 h-12 rounded-full mb-4 ${
                  plan.color === 'primary' ? 'bg-primary-100 text-primary-600' :
                  plan.color === 'gradient' ? 'bg-gradient-to-r from-purple-100 to-pink-100 text-purple-600' :
                  'bg-gray-100 text-gray-600'
                }`}>
                  {plan.icon}
                </div>
                <h3 className="text-2xl font-bold text-gray-900 mb-2">
                  {plan.name}
                </h3>
                <p className="text-gray-600">
                  {plan.description}
                </p>
              </div>

              {/* Pricing */}
              <div className="text-center mb-8">
                <div className="flex items-end justify-center">
                  <span className="text-4xl font-bold text-gray-900">
                    ₺{plan.price[billingPeriod]}
                  </span>
                  {plan.price[billingPeriod] > 0 && (
                    <span className="text-gray-600 ml-2">
                      /{billingPeriod === 'monthly' ? 'ay' : 'yıl'}
                    </span>
                  )}
                </div>
                {billingPeriod === 'yearly' && plan.price.yearly > 0 && (
                  <p className="text-sm text-gray-500 mt-1">
                    (₺{Math.round(plan.price.yearly / 12)}/ay)
                  </p>
                )}
              </div>

              {/* Features */}
              <div className="mb-8">
                <ul className="space-y-3">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-center">
                      <Check className="h-5 w-5 text-green-500 mr-3 flex-shrink-0" />
                      <span className="text-gray-700">{feature}</span>
                    </li>
                  ))}
                </ul>
              </div>

              {/* CTA Button */}
              <button
                onClick={() => handlePlanSelect(plan.id)}
                className={getButtonClass(plan)}
              >
                {plan.cta}
              </button>

              {/* Limitations */}
              {plan.limitations.length > 0 && (
                <div className="mt-6 pt-6 border-t border-gray-200">
                  <p className="text-sm text-gray-500 mb-2">Sınırlamalar:</p>
                  <ul className="space-y-1">
                    {plan.limitations.map((limitation, index) => (
                      <li key={index} className="text-sm text-gray-500">
                        • {limitation}
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </div>
          ))}
        </div>

        {/* FAQ Section */}
        <div className="bg-white rounded-2xl p-8 mb-16">
          <h2 className="text-2xl font-bold text-gray-900 text-center mb-8">
            Sık Sorulan Sorular
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">
                Planımı istediğim zaman değiştirebilir miyim?
              </h3>
              <p className="text-gray-600">
                Evet, istediğiniz zaman planınızı yükseltebilir veya düşürebilirsiniz. 
                Değişiklikler hemen geçerli olur.
              </p>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">
                Ücretsiz deneme süresi var mı?
              </h3>
              <p className="text-gray-600">
                PRO ve PREMIUM planlar için 7 günlük ücretsiz deneme sunuyoruz. 
                Kredi kartı bilgisi gereklidir.
              </p>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">
                İptal etmek istediğimde ne olur?
              </h3>
              <p className="text-gray-600">
                İstediğiniz zaman iptal edebilirsiniz. İptal sonrası mevcut dönemin 
                sonuna kadar hizmet almaya devam edersiniz.
              </p>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">
                Hangi ödeme yöntemlerini kabul ediyorsunuz?
              </h3>
              <p className="text-gray-600">
                Kredi kartı, banka kartı ve havale ile ödeme alabiliyoruz. 
                Tüm ödemeler güvenli SSL ile korunur.
              </p>
            </div>
          </div>
        </div>

        {/* Support CTA */}
        <div className="bg-primary-50 rounded-2xl p-8 text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            Hala karar veremediniz mi?
          </h2>
          <p className="text-gray-600 mb-6 max-w-2xl mx-auto">
            Ekibimiz size en uygun planı seçmenizde yardımcı olmaktan mutluluk duyacaktır. 
            Ücretsiz danışmanlık için bizimle iletişime geçin.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <button className="btn-primary">
              Canlı Destek
            </button>
            <button className="btn-outline">
              WhatsApp ile İletişim
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PricingPage;
