import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Check, Crown, Star, Zap } from 'lucide-react';
import { useAuthStore } from '../store/authStore';
import { PLAN_CONFIGS, type PlanTier } from '../config/plans';
import PaymentModal from '../components/Payment/PaymentModal';
import toast from 'react-hot-toast';

const PricingPage: React.FC = () => {
  const navigate = useNavigate();
  const { user } = useAuthStore();
  const [billingPeriod, setBillingPeriod] = useState<'monthly' | 'yearly'>('monthly');
  const [paymentModal, setPaymentModal] = useState<{
    isOpen: boolean;
    planTier: 'pro' | 'premium';
    amount: number;
  }>({
    isOpen: false,
    planTier: 'pro',
    amount: 0,
  });

  // Planları plans.ts'den al ve display için formatla
  const plans = [
    {
      id: 'free' as PlanTier,
      name: PLAN_CONFIGS.free.name,
      price: PLAN_CONFIGS.free.price,
      description: 'Tek kullanım için',
      icon: <Star className="h-6 w-6" />,
      color: 'gray',
      features: [
        `${PLAN_CONFIGS.free.limits.invitationsLifetime} davetiye (tek kullanım)`,
        `${PLAN_CONFIGS.free.limits.basicTemplatesCount} temel şablon`,
        'Temel özelleştirme',
        'PDF + PNG indirme (sınırsız)',
        'Link paylaşımı',
        `Temel RSVP (max ${PLAN_CONFIGS.free.limits.maxGuestsPerInvitation} kişi)`,
        `${PLAN_CONFIGS.free.limits.storageMB}MB depolama`
      ],
      limitations: [
        'Premium şablonlar yok',
        'Görsel yükleme yok',
        'Sosyal medya paylaşımı yok',
        '"Powered by Davetim" watermark'
      ],
      popular: false,
      cta: 'Ücretsiz Başla',
      badge: null,
      hasYearly: false
    },
    {
      id: 'pro' as PlanTier,
      name: PLAN_CONFIGS.pro.name,
      price: PLAN_CONFIGS.pro.price,
      description: 'Düzenli kullanım için',
      icon: <Zap className="h-6 w-6" />,
      color: 'primary',
      features: [
        `Aylık ${PLAN_CONFIGS.pro.limits.invitationsPerMonth} davetiye`,
        'Tüm PRO şablonlar',
        'Görsel yükleme',
        'Sosyal medya paylaşımı (WhatsApp, Telegram, Instagram)',
        'Sınırsız RSVP',
        'Excel export',
        'PDF + PNG indirme (sınırsız)',
        `${PLAN_CONFIGS.pro.limits.storageMB}MB depolama`
      ],
      limitations: [],
      popular: true,
      cta: 'PRO\'ya Başla',
      badge: 'Sadece Aylık',
      hasYearly: false
    },
    {
      id: 'premium' as PlanTier,
      name: PLAN_CONFIGS.premium.name,
      price: PLAN_CONFIGS.premium.price,
      description: 'Sınırsız + gelişmiş',
      icon: <Crown className="h-6 w-6" />,
      color: 'gradient',
      features: [
        'Sınırsız davetiye',
        'PRO\'nun tüm özellikleri',
        '🎥 QR medya yükleme (3 ay)',
        '🎥 Yıllıkta medya 1 yıl saklanır',
        '🤖 AI tasarım önerileri',
        '7/24 öncelikli destek',
        `${PLAN_CONFIGS.premium.limits.storageMB}MB depolama`,
        'Gelişmiş analitik'
      ],
      limitations: [],
      popular: false,
      cta: 'PREMIUM\'a Başla',
      badge: 'Yıllık: Medya 1 yıl saklanır',
      hasYearly: true
    }
  ];

  const handlePlanSelect = (planId: string, planPrice: { monthly: number; yearly: number }, hasYearly?: boolean) => {
    if (planId === 'free') {
      if (!user) {
        navigate('/signup');
      } else {
        toast.info('Zaten ücretsiz plandasınız');
      }
      return;
    }

    // Check if user is logged in
    if (!user) {
      toast.error('Ödeme yapmak için giriş yapmalısınız');
      navigate('/auth');
      return;
    }

    // Calculate amount based on plan and billing period
    const amount = hasYearly === false ? planPrice.monthly : planPrice[billingPeriod];

    // Open payment modal
    setPaymentModal({
      isOpen: true,
      planTier: planId as 'pro' | 'premium',
      amount,
    });
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
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Size Uygun Planı Seçin
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            İhtiyacınıza göre tasarlanmış esnek fiyatlandırma. 
            İstediğiniz zaman yükseltebilir, ödeme sonrası 3 gün içinde iptal edebilirsiniz.
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
                className={`px-6 py-2 rounded-md text-sm font-medium transition-colors ${
                  billingPeriod === 'yearly'
                    ? 'bg-primary-500 text-white'
                    : 'text-gray-700 hover:text-gray-900'
                }`}
              >
                Yıllık
              </button>
            </div>
          </div>
        </div>

        {/* Pricing Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
          {plans.map((plan: any) => (
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
              
              {/* Plan Badge */}
              {plan.badge && !plan.popular && (
                <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                  <span className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-4 py-2 rounded-full text-xs font-medium">
                    {plan.badge}
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
                    ₺{plan.hasYearly === false || !plan.price.yearly ? plan.price.monthly : plan.price[billingPeriod]}
                  </span>
                  {(plan.hasYearly === false || !plan.price.yearly ? plan.price.monthly : plan.price[billingPeriod]) > 0 && (
                    <span className="text-gray-600 ml-2">
                      /{plan.hasYearly === false ? 'ay' : billingPeriod === 'monthly' ? 'ay' : 'yıl'}
                    </span>
                  )}
                </div>
                {billingPeriod === 'yearly' && plan.hasYearly !== false && plan.price.yearly > 0 && (
                  <p className="text-sm text-gray-500 mt-1">
                    (₺{Math.round(plan.price.yearly / 12)}/ay)
                  </p>
                )}
                {plan.hasYearly === false && (
                  <p className="text-xs text-gray-500 mt-1">
                    Sadece aylık abonelik
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
                onClick={() => handlePlanSelect(plan.id, plan.price, plan.hasYearly)}
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
                İptal ve İade Politikası
              </h3>
              <p className="text-gray-600">
                ✅ <strong>3 gün içinde:</strong> Tam ücret iadesi alırsınız, ancak hemen FREE plana düşersiniz.<br/>
                ❌ <strong>3 gün sonra:</strong> İade alamazsınız, ama dönem sonuna kadar tüm özellikleri kullanabilirsiniz.
              </p>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">
                Ücretsiz plan yeterli mi?
              </h3>
              <p className="text-gray-600">
                Ücretsiz plan ile tek davetiye oluşturabilir ve temel özellikleri kullanabilirsiniz. 
                Daha fazla davetiye ve premium özellikler için PRO veya PREMIUM plana yükseltebilirsiniz.
              </p>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">
                Hangi ödeme yöntemlerini kabul ediyorsunuz?
              </h3>
              <p className="text-gray-600">
                Kredi kartı ve banka kartı ile güvenli ödeme alabiliyoruz. 
                Tüm ödemeler SSL ile korunur ve güvenlidir.
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

      {/* Payment Modal */}
      <PaymentModal
        isOpen={paymentModal.isOpen}
        onClose={() => setPaymentModal({ ...paymentModal, isOpen: false })}
        planTier={paymentModal.planTier}
        billingPeriod={billingPeriod}
        amount={paymentModal.amount}
      />
    </div>
  );
};

export default PricingPage;
