import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { X, CreditCard, Lock, AlertCircle, Loader2 } from 'lucide-react';
import { paymentService } from '../../services/paymentService';
import { subscriptionService } from '../../services/subscriptionService';
import { useAuthStore } from '../../store/authStore';
import { authService } from '../../services/authService';
import { useSubscription } from '../../hooks/useSubscription';
import toast from 'react-hot-toast';
import type { CardInfo, AddressInfo } from '../../types/payment';
import type { PlanTier } from '../../config/plans';

interface PaymentModalProps {
  isOpen: boolean;
  onClose: () => void;
  planTier: 'pro' | 'premium';
  billingPeriod: 'monthly' | 'yearly';
  amount: number;
}

const PaymentModal: React.FC<PaymentModalProps> = ({
  isOpen,
  onClose,
  planTier,
  billingPeriod,
  amount,
}) => {
  const navigate = useNavigate();
  const { user, initialize, updateUser } = useAuthStore();
  const { refreshSubscription } = useSubscription();
  const [loading, setLoading] = useState(false);
  const [useTestCard, setUseTestCard] = useState(false);
  
  // Form state
  const [cardInfo, setCardInfo] = useState<CardInfo>({
    cardHolderName: '',
    cardNumber: '',
    expireMonth: '',
    expireYear: '',
    cvc: '',
  });

  const [billingAddress, setBillingAddress] = useState<AddressInfo>({
    contactName: user?.fullName || '',
    city: '',
    country: 'Turkey',
    address: '',
    zipCode: '',
  });

  const [errors, setErrors] = useState<Record<string, string>>({});

  if (!isOpen || !user) return null;

  const handleTestCardToggle = () => {
    if (!useTestCard) {
      const testCard = paymentService.getTestCards().success;
      setCardInfo(testCard);
      setUseTestCard(true);
      toast.success('Test kartı bilgileri yüklendi');
    } else {
      setCardInfo({
        cardHolderName: '',
        cardNumber: '',
        expireMonth: '',
        expireYear: '',
        cvc: '',
      });
      setUseTestCard(false);
    }
  };

  const validateForm = (): boolean => {
    const newErrors: Record<string, string> = {};

    // Validate card info
    if (!cardInfo.cardHolderName.trim()) {
      newErrors.cardHolderName = 'Kart sahibi adı gerekli';
    }
    if (!cardInfo.cardNumber.replace(/\s/g, '').match(/^\d{16}$/)) {
      newErrors.cardNumber = 'Geçerli bir kart numarası girin';
    }
    if (!cardInfo.expireMonth.match(/^(0[1-9]|1[0-2])$/)) {
      newErrors.expireMonth = 'Geçerli ay (01-12)';
    }
    if (!cardInfo.expireYear.match(/^\d{4}$/)) {
      newErrors.expireYear = 'Geçerli yıl (YYYY)';
    }
    if (!cardInfo.cvc.match(/^\d{3}$/)) {
      newErrors.cvc = 'Geçerli CVV (3 hane)';
    }

    // Validate billing address
    if (!billingAddress.contactName.trim()) {
      newErrors.contactName = 'İsim gerekli';
    }
    if (!billingAddress.city.trim()) {
      newErrors.city = 'Şehir gerekli';
    }
    if (!billingAddress.address.trim()) {
      newErrors.address = 'Adres gerekli';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!validateForm()) {
      toast.error('Lütfen tüm alanları doğru doldurun');
      return;
    }

    setLoading(true);

    try {
      // Process payment
      const result = await paymentService.processSubscriptionPayment({
        planTier,
        billingPeriod,
        customerId: user.id,
        customerName: user.fullName.split(' ')[0] || 'User',
        customerSurname: user.fullName.split(' ').slice(1).join(' ') || 'Name',
        customerEmail: user.email,
        customerPhone: user.phone || '+905551234567',
        billingAddress,
        cardInfo: {
          ...cardInfo,
          cardNumber: cardInfo.cardNumber.replace(/\s/g, ''),
        },
        installment: 1,
      });

      // Status codes: 0 = SUCCESS, 1 = PENDING, 2 = FAILED, 3 = WAITING_3D_SECURE
      if (result.success && (result.status === 'WAITING_3D' || result.status === 1 || result.status === 3)) {
        // Save pending payment data and transaction ID for callback
        sessionStorage.setItem('pending_payment', JSON.stringify({
          planTier,
          billingPeriod,
          amount,
        }));
        sessionStorage.setItem('last_transaction_id', result.transactionId);
        console.log('💾 Saved transaction ID to sessionStorage:', result.transactionId);
        
        // Handle 3D Secure with improved method
        toast.success('3D Secure doğrulaması başlatıl\u0131yor...');
        
        if (result.threeDSecureHtmlContent) {
          // Use the improved 3D Secure handler from paymentService
          paymentService.handle3DSecure(result.threeDSecureHtmlContent, 'popup');
        } else {
          toast.error('3D Secure içeriği alınamadı');
        }
        
        // Close modal after opening 3D Secure
        onClose();
      } else if (result.success && (result.status === 'SUCCESS' || result.status === 0)) {
        // Direct success (without 3D Secure)
        await subscriptionService.upgradeSubscription(
          user.id,
          planTier,
          billingPeriod,
          result.transactionId
        );
        
        await subscriptionService.savePaymentHistory(
          user.id,
          result.transactionId,
          result.providerTransactionId,
          'iyzico',
          amount,
          'TRY',
          'SUCCESS',
          planTier,
          billingPeriod
        );

        // Force refresh auth state without page reload
        console.log('🔄 Force refreshing auth state...');
        sessionStorage.removeItem('pending_payment');
        
        // Wait a bit for database to settle
        console.log('⏳ Waiting 1 second for database to settle...');
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Get fresh user data from Supabase
        console.log('🔄 Fetching fresh user data from database...');
        const freshUser = await authService.getCurrentUser();
        console.log('📊 Fresh user data:', freshUser);
        console.log('📊 Fresh subscription tier:', freshUser?.subscriptionTier);
        
        // Update auth store with fresh data
        if (freshUser) {
          console.log('🔄 Updating auth store with fresh data...');
          updateUser(freshUser);
          
          // Force storage to persist immediately
          const currentState = useAuthStore.getState();
          localStorage.setItem('auth-store', JSON.stringify({
            state: {
              user: freshUser,
              session: currentState.session,
              isInitialized: currentState.isInitialized
            },
            version: 0
          }));
          
          console.log('✅ Auth store updated');
          console.log('✅ Updated user:', useAuthStore.getState().user);
          
          // Dispatch custom event to force re-render
          console.log('📢 Dispatching subscription update event...');
          window.dispatchEvent(new CustomEvent('subscription-updated', { 
            detail: { user: freshUser } 
          }));
        }

        // Refresh subscription hook
        console.log('🔄 Refreshing subscription hook...');
        await refreshSubscription();
        console.log('✅ Subscription hook refreshed');
        
        // Small delay to ensure UI updates propagate
        await new Promise(resolve => setTimeout(resolve, 800));

        toast.success('Ödeme başarılı! 🎉');
        onClose();
        
        // Navigate to account page (no reload)
        navigate('/account');
      } else {
        // Payment failed or unknown status
        console.error('❌ Payment failed or unknown status:', result);
        console.error('  - success:', result.success);
        console.error('  - status:', result.status);
        console.error('  - errorMessage:', result.errorMessage);
        toast.error(result.errorMessage || 'Ödeme başarısız');
      }
    } catch (error: any) {
      console.error('❌ Payment error:', error);
      toast.error('Ödeme sırasında bir hata oluştu');
    } finally {
      setLoading(false);
    }
  };

  const formatCardNumber = (value: string) => {
    return value.replace(/\s/g, '').replace(/(\d{4})/g, '$1 ').trim();
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
        <div className="relative bg-white rounded-2xl shadow-xl max-w-2xl w-full p-6 max-h-[90vh] overflow-y-auto">
          {/* Close button */}
          <button
            onClick={onClose}
            className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
            disabled={loading}
          >
            <X className="h-6 w-6" />
          </button>

          {/* Header */}
          <div className="mb-6">
            <div className="flex items-center mb-2">
              <CreditCard className="h-6 w-6 text-primary-600 mr-2" />
              <h2 className="text-2xl font-bold text-gray-900">
                Ödeme Bilgileri
              </h2>
            </div>
            <p className="text-gray-600">
              {planTier.toUpperCase()} - {billingPeriod === 'monthly' ? 'Aylık' : 'Yıllık'} Abonelik
            </p>
            <div className="mt-2">
              <span className="text-3xl font-bold text-gray-900">₺{amount}</span>
              <span className="text-gray-600 ml-2">
                / {billingPeriod === 'monthly' ? 'ay' : 'yıl'}
              </span>
            </div>
          </div>

          {/* Test Card Toggle (Development) */}
          {import.meta.env.DEV && (
            <div className="mb-4 p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
              <button
                type="button"
                onClick={handleTestCardToggle}
                className="text-sm text-yellow-800 hover:text-yellow-900 font-medium"
              >
                🧪 {useTestCard ? 'Test kartını temizle' : 'Test kartı kullan'}
              </button>
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Card Information */}
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Kart Bilgileri</h3>
              
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Kart Sahibi Adı
                  </label>
                  <input
                    type="text"
                    value={cardInfo.cardHolderName}
                    onChange={(e) => setCardInfo({ ...cardInfo, cardHolderName: e.target.value.toUpperCase() })}
                    className={`input ${errors.cardHolderName ? 'border-red-500' : ''}`}
                    placeholder="AHMET YILMAZ"
                    disabled={loading}
                  />
                  {errors.cardHolderName && (
                    <p className="text-sm text-red-600 mt-1">{errors.cardHolderName}</p>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Kart Numarası
                  </label>
                  <input
                    type="text"
                    value={formatCardNumber(cardInfo.cardNumber)}
                    onChange={(e) => setCardInfo({ ...cardInfo, cardNumber: e.target.value.replace(/\s/g, '') })}
                    className={`input ${errors.cardNumber ? 'border-red-500' : ''}`}
                    placeholder="1234 5678 9012 3456"
                    maxLength={19}
                    disabled={loading}
                  />
                  {errors.cardNumber && (
                    <p className="text-sm text-red-600 mt-1">{errors.cardNumber}</p>
                  )}
                </div>

                <div className="grid grid-cols-3 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                      Ay
                    </label>
                    <input
                      type="text"
                      value={cardInfo.expireMonth}
                      onChange={(e) => setCardInfo({ ...cardInfo, expireMonth: e.target.value })}
                      className={`input ${errors.expireMonth ? 'border-red-500' : ''}`}
                      placeholder="12"
                      maxLength={2}
                      disabled={loading}
                    />
                    {errors.expireMonth && (
                      <p className="text-sm text-red-600 mt-1">{errors.expireMonth}</p>
                    )}
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                      Yıl
                    </label>
                    <input
                      type="text"
                      value={cardInfo.expireYear}
                      onChange={(e) => setCardInfo({ ...cardInfo, expireYear: e.target.value })}
                      className={`input ${errors.expireYear ? 'border-red-500' : ''}`}
                      placeholder="2030"
                      maxLength={4}
                      disabled={loading}
                    />
                    {errors.expireYear && (
                      <p className="text-sm text-red-600 mt-1">{errors.expireYear}</p>
                    )}
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                      CVV
                    </label>
                    <input
                      type="text"
                      value={cardInfo.cvc}
                      onChange={(e) => setCardInfo({ ...cardInfo, cvc: e.target.value })}
                      className={`input ${errors.cvc ? 'border-red-500' : ''}`}
                      placeholder="123"
                      maxLength={3}
                      disabled={loading}
                    />
                    {errors.cvc && (
                      <p className="text-sm text-red-600 mt-1">{errors.cvc}</p>
                    )}
                  </div>
                </div>
              </div>
            </div>

            {/* Billing Address */}
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Fatura Adresi</h3>
              
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Ad Soyad
                  </label>
                  <input
                    type="text"
                    value={billingAddress.contactName}
                    onChange={(e) => setBillingAddress({ ...billingAddress, contactName: e.target.value })}
                    className={`input ${errors.contactName ? 'border-red-500' : ''}`}
                    disabled={loading}
                  />
                  {errors.contactName && (
                    <p className="text-sm text-red-600 mt-1">{errors.contactName}</p>
                  )}
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                      Şehir
                    </label>
                    <input
                      type="text"
                      value={billingAddress.city}
                      onChange={(e) => setBillingAddress({ ...billingAddress, city: e.target.value })}
                      className={`input ${errors.city ? 'border-red-500' : ''}`}
                      placeholder="Istanbul"
                      disabled={loading}
                    />
                    {errors.city && (
                      <p className="text-sm text-red-600 mt-1">{errors.city}</p>
                    )}
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                      Posta Kodu
                    </label>
                    <input
                      type="text"
                      value={billingAddress.zipCode}
                      onChange={(e) => setBillingAddress({ ...billingAddress, zipCode: e.target.value })}
                      className="input"
                      placeholder="34000"
                      disabled={loading}
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Adres
                  </label>
                  <textarea
                    value={billingAddress.address}
                    onChange={(e) => setBillingAddress({ ...billingAddress, address: e.target.value })}
                    className={`input ${errors.address ? 'border-red-500' : ''}`}
                    rows={3}
                    disabled={loading}
                  />
                  {errors.address && (
                    <p className="text-sm text-red-600 mt-1">{errors.address}</p>
                  )}
                </div>
              </div>
            </div>

            {/* Security Notice */}
            <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
              <div className="flex items-start">
                <Lock className="h-5 w-5 text-blue-600 mr-2 mt-0.5" />
                <div className="text-sm text-blue-800">
                  <p className="font-medium mb-1">Güvenli Ödeme</p>
                  <p>Ödemeniz SSL sertifikası ile korunmaktadır. Kart bilgileriniz asla saklanmaz.</p>
                </div>
              </div>
            </div>

            {/* Submit Button */}
            <div className="space-y-3">
              <button
                type="submit"
                disabled={loading}
                className="w-full btn-primary flex items-center justify-center gap-2"
              >
                {loading ? (
                  <>
                    <Loader2 className="h-5 w-5 animate-spin" />
                    İşleniyor...
                  </>
                ) : (
                  <>
                    <Lock className="h-5 w-5" />
                    ₺{amount} Öde
                  </>
                )}
              </button>

              <button
                type="button"
                onClick={onClose}
                disabled={loading}
                className="w-full btn-outline"
              >
                İptal
              </button>
            </div>

            {/* Terms */}
            <p className="text-xs text-gray-500 text-center">
              Ödeme yaparak <a href="/terms" className="text-primary-600 hover:underline">Kullanım Koşulları</a> ve <a href="/privacy" className="text-primary-600 hover:underline">Gizlilik Politikası</a>'nı kabul etmiş olursunuz.
            </p>
          </form>
        </div>
      </div>
    </div>
  );
};

export default PaymentModal;

