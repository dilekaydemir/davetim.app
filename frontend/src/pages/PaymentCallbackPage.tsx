import React, { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { Loader2, CheckCircle, XCircle, AlertCircle } from 'lucide-react';
import { paymentService } from '../services/paymentService';
import { subscriptionService } from '../services/subscriptionService';
import { useAuthStore } from '../store/authStore';
import toast from 'react-hot-toast';

/**
 * Payment Callback Page
 * Handles 3D Secure redirect and payment verification
 */
const PaymentCallbackPage: React.FC = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { user, initialize } = useAuthStore();
  
  const [status, setStatus] = useState<'processing' | 'success' | 'failure' | 'error'>('processing');
  const [message, setMessage] = useState('Ödeme işleminiz kontrol ediliyor...');
  const [transactionId, setTransactionId] = useState<string | null>(null);
  const [countdown, setCountdown] = useState<number | null>(null);

  useEffect(() => {
    // Check if this is a POST callback from İyzico (will have form data in body)
    // Since we can't directly access POST data in frontend, we'll use query params
    // that İyzico adds to the callback URL after successful 3D Secure
    handlePaymentCallback();
  }, [searchParams]);

  const handleSuccessfulPayment = async (txId: string | null, params: URLSearchParams) => {
    setStatus('success');
    setMessage('Ödemeniz başarıyla tamamlandı! 🎉');
    if (txId) setTransactionId(txId);

    // Get plan details from sessionStorage
    const planData = sessionStorage.getItem('pending_payment');
    if (planData && user) {
      const { planTier, billingPeriod } = JSON.parse(planData);
      
      // Upgrade subscription
      await subscriptionService.upgradeSubscription(user.id, planTier, billingPeriod, txId || '');

      // Save payment history
      const amount = parseFloat(params.get('amount') || '0');
      const currency = params.get('currency') || 'TRY';
      
      await subscriptionService.savePaymentHistory(
        user.id,
        txId || '',
        params.get('providerTransactionId') || '',
        'iyzico',
        amount,
        currency,
        'SUCCESS',
        planTier,
        billingPeriod,
        `${planTier.toUpperCase()} - ${billingPeriod === 'monthly' ? 'Aylık' : 'Yıllık'} Abonelik`
      );

      // Clear pending payment
      sessionStorage.removeItem('pending_payment');
      sessionStorage.removeItem('last_transaction_id');

      // Refresh auth state
      await initialize();
    }

    // Start countdown and redirect to account page
    setCountdown(5);
    const countdownInterval = setInterval(() => {
      setCountdown(prev => {
        if (prev === null || prev <= 1) {
          clearInterval(countdownInterval);
          navigate('/account');
          return null;
        }
        return prev - 1;
      });
    }, 1000);
  };

  const handleFailedPayment = async (txId: string | null, error: string | null) => {
    setStatus('failure');
    setMessage(error || 'Ödeme işlemi başarısız oldu');
    if (txId) setTransactionId(txId);
    
    toast.error('Ödeme başarısız! Lütfen tekrar deneyin.');

    // Save failed payment to history
    if (user) {
      const planData = sessionStorage.getItem('pending_payment');
      if (planData) {
        const { planTier, billingPeriod } = JSON.parse(planData);
        await subscriptionService.savePaymentHistory(
          user.id,
          txId || '',
          '',
          'iyzico',
          0,
          'TRY',
          'FAILURE',
          planTier,
          billingPeriod,
          undefined,
          error || undefined
        );
      }
      sessionStorage.removeItem('pending_payment');
      sessionStorage.removeItem('last_transaction_id');
    }

    // Start countdown and redirect to pricing
    setCountdown(5);
    const countdownInterval = setInterval(() => {
      setCountdown(prev => {
        if (prev === null || prev <= 1) {
          clearInterval(countdownInterval);
          navigate('/pricing');
          return null;
        }
        return prev - 1;
      });
    }, 1000);
  };

  const handlePaymentCallback = async () => {
    try {
      // Development logging only
      if (import.meta.env.DEV) {
        console.log('🔍 Payment callback started');
        console.log('📍 Current URL:', window.location.href);
        console.log('📦 URL Search Params:', Array.from(searchParams.entries()));
      }
      
      // Backend proxy'den gelen parametreler (priority)
      const success = searchParams.get('success');
      const statusParam = searchParams.get('status');
      const errorParam = searchParams.get('error');
      
      // Transaction ID - backend'den veya sessionStorage'dan
      let txId = searchParams.get('transactionId') || 
                 searchParams.get('transaction_id') ||
                 sessionStorage.getItem('last_transaction_id');
      
      console.log('🔍 Transaction ID:', txId);
      console.log('✅ Success param:', success);
      console.log('📊 Status param:', statusParam);
      console.log('❌ Error param:', errorParam);
      
      // Backend'den direkt sonuç geldi mi?
      if (success !== null) {
        if (success === 'true') {
          // Backend başarılı dedi, direkt işle
          console.log('✅ Payment successful (from backend callback)');
          await handleSuccessfulPayment(txId, searchParams);
          return;
        } else {
          // Backend başarısız dedi
          console.log('❌ Payment failed (from backend callback)');
          await handleFailedPayment(txId, errorParam);
          return;
        }
      }
      
      // Fallback: Transaction ID yoksa sessionStorage'dan al
      if (!txId) {
        const pendingPayment = sessionStorage.getItem('pending_payment');
        console.log('📦 Pending payment:', pendingPayment);
        
        if (pendingPayment) {
          setStatus('processing');
          setMessage('Ödeme işleminiz kontrol ediliyor...');
          console.log('⏳ No transaction ID yet, retrying in 2 seconds...');
          setTimeout(() => {
            handlePaymentCallback();
          }, 2000);
          return;
        } else {
          console.error('❌ No transaction ID found!');
          setStatus('error');
          setMessage('İşlem kimliği bulunamadı. Lütfen hesap sayfanızdan ödeme durumunu kontrol edin.');
          return;
        }
      }

      setTransactionId(txId);

      // Check payment status
      const result = await paymentService.checkPaymentStatus(txId);

      if (result.success && result.status === 'SUCCESS') {
        // Payment successful
        setStatus('success');
        setMessage('Ödemeniz başarıyla tamamlandı! 🎉');

        // Get plan details from transaction ID or session storage
        const planData = sessionStorage.getItem('pending_payment');
        if (planData && user) {
          const { planTier, billingPeriod } = JSON.parse(planData);
          
          // Upgrade subscription
          await subscriptionService.upgradeSubscription(
            user.id,
            planTier,
            billingPeriod,
            txId
          );

          // Save payment to history
          await subscriptionService.savePaymentHistory(
            user.id,
            txId,
            result.transactionId,
            'iyzico',
            result.amount || 0,
            result.currency || 'TRY',
            'SUCCESS',
            planTier,
            billingPeriod,
            `${planTier.toUpperCase()} - ${billingPeriod === 'monthly' ? 'Aylık' : 'Yıllık'} Abonelik`
          );

          // Clear pending payment and transaction ID
          sessionStorage.removeItem('pending_payment');
          sessionStorage.removeItem('last_transaction_id');

          // Refresh auth state to get updated subscription
          await initialize();
        }

        // Redirect to dashboard after 3 seconds
        setTimeout(() => {
          navigate('/dashboard');
        }, 3000);

      } else if (result.status === 'FAILURE') {
        // Payment failed
        setStatus('failure');
        setMessage(result.errorMessage || 'Ödeme işlemi başarısız oldu');
        
        toast.error('Ödeme başarısız! Lütfen tekrar deneyin.');

        // Save failed payment to history
        if (user) {
          const planData = sessionStorage.getItem('pending_payment');
          if (planData) {
            const { planTier, billingPeriod } = JSON.parse(planData);
            await subscriptionService.savePaymentHistory(
              user.id,
              txId,
              result.transactionId,
              'iyzico',
              result.amount || 0,
              result.currency || 'TRY',
              'FAILURE',
              planTier,
              billingPeriod,
              undefined,
              result.errorMessage
            );
          }
          sessionStorage.removeItem('pending_payment');
          sessionStorage.removeItem('last_transaction_id');
        }

        // Redirect to pricing after 5 seconds
        setTimeout(() => {
          navigate('/pricing');
        }, 5000);

      } else if (result.status === 'PENDING' || result.status === 'WAITING_3D') {
        // Still processing
        setStatus('processing');
        setMessage('Ödeme işleminiz hala devam ediyor. Lütfen bekleyin...');
        
        // Retry after 3 seconds
        setTimeout(() => {
          handlePaymentCallback();
        }, 3000);

      } else {
        // Unknown status
        setStatus('error');
        setMessage('Beklenmeyen bir durum oluştu. Lütfen destek ile iletişime geçin.');
      }

    } catch (error: any) {
      console.error('❌ Payment callback error:', error);
      setStatus('error');
      setMessage('Ödeme kontrolü sırasında bir hata oluştu');
      toast.error('Bir hata oluştu. Lütfen destek ile iletişime geçin.');
    }
  };

  const getIcon = () => {
    switch (status) {
      case 'processing':
        return <Loader2 className="h-20 w-20 text-blue-500 animate-spin" />;
      case 'success':
        return <CheckCircle className="h-20 w-20 text-green-500" />;
      case 'failure':
        return <XCircle className="h-20 w-20 text-red-500" />;
      case 'error':
        return <AlertCircle className="h-20 w-20 text-orange-500" />;
    }
  };

  const getStatusColor = () => {
    switch (status) {
      case 'processing':
        return 'text-blue-600';
      case 'success':
        return 'text-green-600';
      case 'failure':
        return 'text-red-600';
      case 'error':
        return 'text-orange-600';
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-xl max-w-md w-full p-8 text-center">
        {/* Icon */}
        <div className="flex justify-center mb-6">
          {getIcon()}
        </div>

        {/* Status Message */}
        <h1 className={`text-2xl font-bold mb-4 ${getStatusColor()}`}>
          {status === 'processing' && 'İşlem Devam Ediyor'}
          {status === 'success' && 'Ödeme Başarılı!'}
          {status === 'failure' && 'Ödeme Başarısız'}
          {status === 'error' && 'Bir Hata Oluştu'}
        </h1>

        <p className="text-gray-600 mb-6">{message}</p>

        {/* Transaction ID */}
        {transactionId && (
          <div className="bg-gray-50 rounded-lg p-4 mb-6">
            <p className="text-xs text-gray-500 mb-1">İşlem Numarası</p>
            <p className="text-sm font-mono text-gray-700 break-all">{transactionId}</p>
          </div>
        )}

        {/* Countdown */}
        {countdown !== null && countdown > 0 && (
          <div className="mb-6">
            <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
              <p className="text-sm text-blue-800 text-center">
                {status === 'success' ? 'Hesap sayfasına' : 'Fiyatlandırma sayfasına'} yönlendiriliyorsunuz...
              </p>
              <p className="text-2xl font-bold text-blue-600 text-center mt-2">
                {countdown}
              </p>
            </div>
          </div>
        )}

        {/* Action Buttons */}
        <div className="space-y-3">
          {status === 'success' && (
            <button
              onClick={() => navigate('/account')}
              className="w-full btn-primary"
            >
              Hesabıma Git
            </button>
          )}

          {status === 'failure' && (
            <button
              onClick={() => navigate('/pricing')}
              className="w-full btn-primary"
            >
              Tekrar Dene
            </button>
          )}

          {status === 'error' && (
            <>
              <button
                onClick={() => navigate('/pricing')}
                className="w-full btn-primary"
              >
                Fiyatlandırmaya Dön
              </button>
              <button
                onClick={() => navigate('/account')}
                className="w-full btn-outline"
              >
                Hesabıma Git
              </button>
            </>
          )}

          {status !== 'processing' && (
            <p className="text-xs text-gray-500 mt-4">
              Sorun yaşıyorsanız, lütfen <a href="mailto:destek@davetim.app" className="text-primary-600 hover:underline">destek@davetim.app</a> ile iletişime geçin.
            </p>
          )}
        </div>
      </div>
    </div>
  );
};

export default PaymentCallbackPage;

