import axios from 'axios';
import toast from 'react-hot-toast';
import type {
  PaymentRequest,
  PaymentResponse,
  RefundRequest,
  RefundResponse,
  PaymentStatusResponse,
  SubscriptionPaymentData,
} from '../types/payment';

// Payment service base URL
const PAYMENT_API_BASE_URL = import.meta.env.VITE_PAYMENT_API_URL || 'http://localhost:5000/api/payment';

// Validate payment API URL in production
if (import.meta.env.PROD && PAYMENT_API_BASE_URL.includes('localhost')) {
  console.error('❌ PRODUCTION ERROR: Payment API URL is still localhost!');
  console.error('Set VITE_PAYMENT_API_URL=https://payment.dilcomsys.com/api/payment in .env');
}

class PaymentService {
  private api = axios.create({
    baseURL: PAYMENT_API_BASE_URL,
    headers: {
      'Content-Type': 'application/json',
    },
    timeout: 30000, // 30 seconds for payment operations
  });

  /**
   * Get available payment providers
   */
  async getProviders(): Promise<string[]> {
    try {
      const response = await this.api.get('/providers');
      return response.data;
    } catch (error: any) {
      console.error('❌ Get providers error:', error);
      toast.error('Ödeme sağlayıcıları yüklenemedi');
      throw error;
    }
  }

  /**
   * Process payment with İyzico
   */
  async processPayment(paymentData: PaymentRequest): Promise<PaymentResponse> {
    try {
      console.log('💳 Processing payment:', paymentData.transactionId);
      console.log('📦 Payment data:', JSON.stringify(paymentData, null, 2));
      
      const response = await this.api.post('/iyzico/process', paymentData);
      const result = response.data as PaymentResponse;

      console.log('✅ Payment response:', result);
      
      if (!result.success) {
        console.error('❌ Payment failed:', result.errorMessage, result.errorCode);
      }
      
      return result;
    } catch (error: any) {
      console.error('❌ Payment processing error:', error);
      
      const errorMessage = error.response?.data?.errorMessage || 
                          error.response?.data?.message ||
                          'Ödeme işlemi sırasında bir hata oluştu';
      
      toast.error(errorMessage);
      throw error;
    }
  }

  /**
   * Check payment status
   */
  async checkPaymentStatus(transactionId: string): Promise<PaymentStatusResponse> {
    try {
      const response = await this.api.get(`/iyzico/status/${transactionId}`);
      return response.data;
    } catch (error: any) {
      console.error('❌ Payment status check error:', error);
      throw error;
    }
  }

  /**
   * Refund payment
   */
  async refundPayment(refundData: RefundRequest): Promise<RefundResponse> {
    try {
      const response = await this.api.post('/iyzico/refund', refundData);
      toast.success('İade işlemi başarılı');
      return response.data;
    } catch (error: any) {
      console.error('❌ Refund error:', error);
      toast.error('İade işlemi başarısız oldu');
      throw error;
    }
  }

  /**
   * Cancel payment
   */
  async cancelPayment(paymentTransactionId: string): Promise<PaymentResponse> {
    try {
      const response = await this.api.post(`/iyzico/cancel/${paymentTransactionId}`);
      toast.success('Ödeme iptal edildi');
      return response.data;
    } catch (error: any) {
      console.error('❌ Cancel payment error:', error);
      toast.error('Ödeme iptali başarısız oldu');
      throw error;
    }
  }

  /**
   * Process subscription payment (helper for davetim.app)
   */
  async processSubscriptionPayment(
    subscriptionData: SubscriptionPaymentData
  ): Promise<PaymentResponse> {
    const { planTier, billingPeriod, customerId, customerName, customerSurname, customerEmail, customerPhone, billingAddress, cardInfo, installment } = subscriptionData;

    // Calculate amount based on plan and period
    const planPrices = {
      pro: { monthly: 39, yearly: 390 },
      premium: { monthly: 79, yearly: 790 },
    };

    const amount = planPrices[planTier][billingPeriod];
    const transactionId = `SUB-${Date.now()}-${customerId.slice(0, 8)}`;

    const paymentRequest: PaymentRequest = {
      transactionId,
      amount,
      currency: 'TRY',
      description: `Davetim.app ${planTier.toUpperCase()} - ${billingPeriod === 'monthly' ? 'Aylık' : 'Yıllık'} Abonelik`,
      customer: {
        id: customerId,
        name: customerName,
        surname: customerSurname,
        email: customerEmail,
        phone: customerPhone,
        identityNumber: '11111111111', // TODO: Get from user input if needed
        ipAddress: await this.getClientIP(),
      },
      billingAddress,
      shippingAddress: billingAddress, // Same as billing for digital product
      basketItems: [
        {
          id: `PLAN-${planTier.toUpperCase()}`,
          name: `Davetim.app ${planTier.toUpperCase()} Abonelik`,
          category: 'Dijital Hizmet',
          price: amount,
          quantity: 1,
          itemType: 'VIRTUAL',
        },
      ],
      cardInfo,
      use3DSecure: true, // ✅ Production: 3D Secure enabled
      installment: installment || 1,
      
      // Backend callback URL (İyzico POST burayı çağırır)
      // callbackUrl: Backend'in callback endpoint'i (İyzico için)
      // NOT: Bu backend tarafından otomatik set ediliyor, burada göndermeye gerek yok
      
      // Client redirect URL (Backend başarı/hata sonrası kullanıcıyı buraya yönlendirir)
      clientRedirectUrl: `${window.location.origin}/payment/callback`,
    };

    return this.processPayment(paymentRequest);
  }

  /**
   * Handle 3D Secure redirect (open in popup or iframe)
   */
  handle3DSecure(htmlContent: string, mode: '3d' | 'popup' | 'iframe' = 'popup'): void {
    if (mode === 'popup') {
      // Open 3D Secure in popup window
      const popup = window.open('', '_blank', 'width=600,height=800,resizable=yes,scrollbars=yes');
      if (popup) {
        popup.document.write(htmlContent);
        popup.document.close();
      } else {
        toast.error('Pop-up engelleyici nedeniyle 3D Secure sayfası açılamadı');
        // Fallback to iframe
        this.handle3DSecure(htmlContent, 'iframe');
      }
    } else if (mode === 'iframe') {
      // Create fullscreen iframe overlay
      const overlay = document.createElement('div');
      overlay.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.8);
        z-index: 10000;
        display: flex;
        align-items: center;
        justify-content: center;
      `;

      const iframe = document.createElement('iframe');
      iframe.style.cssText = `
        width: 90%;
        max-width: 600px;
        height: 90%;
        max-height: 800px;
        border: none;
        border-radius: 8px;
      `;
      iframe.srcdoc = htmlContent;

      overlay.appendChild(iframe);
      document.body.appendChild(overlay);

      // Remove overlay when payment is complete
      const checkComplete = setInterval(() => {
        try {
          if (iframe.contentWindow?.location.href.includes('/payment/callback')) {
            clearInterval(checkComplete);
            document.body.removeChild(overlay);
          }
        } catch (e) {
          // Cross-origin error is expected
        }
      }, 500);
    } else {
      // Full page redirect - Extract and submit form directly
      // İyzico 3D Secure HTML'i içinde bir form var, onu çıkartıp submit ediyoruz
      
      // Create temporary container
      const tempDiv = document.createElement('div');
      tempDiv.innerHTML = htmlContent;
      
      // Find the form
      const form = tempDiv.querySelector('form');
      
      if (form) {
        // Append form to body (hidden)
        form.style.display = 'none';
        document.body.appendChild(form);
        
        // Submit form immediately (this will do full page redirect to İyzico 3D Secure)
        form.submit();
      } else {
        // Fallback: iframe method
        console.warn('Form not found in 3D Secure HTML, using iframe fallback');
        const iframe = document.createElement('iframe');
        iframe.style.cssText = `
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          border: none;
          z-index: 999999;
          background: white;
        `;
        
        document.body.appendChild(iframe);
        
        const iframeDoc = iframe.contentDocument || iframe.contentWindow?.document;
        if (iframeDoc) {
          iframeDoc.open();
          iframeDoc.write(htmlContent);
          iframeDoc.close();
        }
      }
    }
  }

  /**
   * Get client IP address (fallback to mock if not available)
   */
  private async getClientIP(): Promise<string> {
    try {
      const response = await axios.get('https://api.ipify.org?format=json', { timeout: 3000 });
      return response.data.ip;
    } catch (error) {
      console.warn('Could not fetch IP, using fallback');
      return '85.34.78.112'; // Fallback IP for testing
    }
  }

  /**
   * İyzico test kartları
   */
  getTestCards() {
    return {
      success: {
        cardNumber: '5528790000000008',
        cardHolderName: 'TEST USER',
        expireMonth: '12',
        expireYear: '2030',
        cvc: '123',
      },
      failure: {
        cardNumber: '5528790000000004',
        cardHolderName: 'TEST USER',
        expireMonth: '12',
        expireYear: '2030',
        cvc: '123',
      },
    };
  }
}

export const paymentService = new PaymentService();

