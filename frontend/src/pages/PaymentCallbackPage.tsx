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

  useEffect(() => {
    handlePaymentCallback();
  }, []);

  const handlePaymentCallback = async () => {
    try {
      // Get transaction ID from URL params
      const txId = searchParams.get('transactionId') || 
                   searchParams.get('transaction_id') ||
                   searchParams.get('conversationId');
      
      if (!txId) {
        setStatus('error');
        setMessage('İşlem kimliği bulunamadı');
        return;
      }

      setTransactionId(txId);

      // Check payment status
      const result = await paymentService.checkPaymentStatus(txId);

      if (result.success && (result.status === 'SUCCESS' || result.status === 0)) {
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

          // Clear pending payment
          sessionStorage.removeItem('pending_payment');

          // Refresh auth state to get updated subscription
          await initialize();
        }

        // Redirect to dashboard after 3 seconds
        setTimeout(() => {
          navigate('/dashboard');
        }, 3000);

      } else if (result.status === 'FAILURE' || result.status === 2) {
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
        }

        // Redirect to pricing after 5 seconds
        setTimeout(() => {
          navigate('/pricing');
        }, 5000);

      } else if (result.status === 'PENDING' || result.status === 'WAITING_3D' || result.status === 1) {
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

        {/* Action Buttons */}
        <div className="space-y-3">
          {status === 'success' && (
            <button
              onClick={() => navigate('/dashboard')}
              className="w-full btn-primary"
            >
              Dashboard'a Git
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

