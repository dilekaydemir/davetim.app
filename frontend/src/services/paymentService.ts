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
   * Handle 3D Secure redirect with modern iframe overlay
   */
  handle3DSecure(htmlContent: string): void {
    // Create modern overlay container
    const overlay = document.createElement('div');
    overlay.id = 'payment-3d-secure-overlay';
    overlay.style.cssText = `
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      width: 100%;
      height: 100%;
      background: rgba(15, 23, 42, 0.95);
      backdrop-filter: blur(8px);
      z-index: 999999;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
      animation: fadeIn 0.3s ease-in-out;
    `;

    // Create iframe container with modern design
    const container = document.createElement('div');
    container.style.cssText = `
      position: relative;
      width: 100%;
      max-width: 600px;
      height: 90vh;
      max-height: 800px;
      background: white;
      border-radius: 24px;
      box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
      overflow: hidden;
      animation: slideUp 0.4s ease-out;
      display: flex;
      flex-direction: column;
    `;

    // Create header
    const header = document.createElement('div');
    header.style.cssText = `
      background: linear-gradient(135deg, #f5702a 0%, #e6571d 100%);
      padding: 20px 24px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    `;

    const headerTitle = document.createElement('div');
    headerTitle.style.cssText = `
      display: flex;
      align-items: center;
      gap: 12px;
    `;

    const lockIcon = document.createElement('div');
    lockIcon.innerHTML = `
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
      </svg>
    `;
    lockIcon.style.cssText = `display: flex; align-items: center;`;

    const title = document.createElement('span');
    title.textContent = 'Güvenli Ödeme';
    title.style.cssText = `
      color: white;
      font-size: 18px;
      font-weight: 600;
      letter-spacing: -0.02em;
    `;

    headerTitle.appendChild(lockIcon);
    headerTitle.appendChild(title);

    const closeButton = document.createElement('button');
    closeButton.innerHTML = `
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
        <line x1="18" y1="6" x2="6" y2="18"></line>
        <line x1="6" y1="6" x2="18" y2="18"></line>
      </svg>
    `;
    closeButton.style.cssText = `
      background: rgba(255, 255, 255, 0.2);
      border: none;
      width: 40px;
      height: 40px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.2s;
      opacity: 0.8;
    `;
    closeButton.onmouseover = () => {
      closeButton.style.background = 'rgba(255, 255, 255, 0.3)';
      closeButton.style.opacity = '1';
    };
    closeButton.onmouseout = () => {
      closeButton.style.background = 'rgba(255, 255, 255, 0.2)';
      closeButton.style.opacity = '0.8';
    };
    closeButton.onclick = () => {
      document.body.removeChild(overlay);
      toast.error('3D Secure doğrulaması iptal edildi');
    };

    header.appendChild(headerTitle);
    header.appendChild(closeButton);

    // Create iframe
    const iframe = document.createElement('iframe');
    iframe.style.cssText = `
      flex: 1;
      width: 100%;
      border: none;
      background: white;
    `;
    iframe.srcdoc = htmlContent;

    // Create footer with info
    const footer = document.createElement('div');
    footer.style.cssText = `
      background: #f8fafc;
      padding: 16px 24px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      border-top: 1px solid #e2e8f0;
    `;

    const infoIcon = document.createElement('div');
    infoIcon.innerHTML = `
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2">
        <circle cx="12" cy="12" r="10"></circle>
        <line x1="12" y1="16" x2="12" y2="12"></line>
        <line x1="12" y1="8" x2="12.01" y2="8"></line>
      </svg>
    `;
    infoIcon.style.cssText = `display: flex; align-items: center;`;

    const infoText = document.createElement('span');
    infoText.textContent = 'Bankanızdan gelen doğrulama kodunu girin';
    infoText.style.cssText = `
      color: #64748b;
      font-size: 13px;
      font-weight: 500;
    `;

    footer.appendChild(infoIcon);
    footer.appendChild(infoText);

    // Assemble components
    container.appendChild(header);
    container.appendChild(iframe);
    container.appendChild(footer);
    overlay.appendChild(container);

    // Add animations
    const style = document.createElement('style');
    style.textContent = `
      @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
      }
      @keyframes slideUp {
        from {
          opacity: 0;
          transform: translateY(30px) scale(0.95);
        }
        to {
          opacity: 1;
          transform: translateY(0) scale(1);
        }
      }
      @media (max-width: 640px) {
        #payment-3d-secure-overlay > div {
          max-width: 100% !important;
          height: 100vh !important;
          max-height: 100vh !important;
          border-radius: 0 !important;
        }
      }
    `;
    document.head.appendChild(style);

    // Add to DOM
    document.body.appendChild(overlay);

    // Listen for payment completion
    const checkInterval = setInterval(() => {
      try {
        // Check if iframe navigated to callback URL
        const iframeUrl = iframe.contentWindow?.location.href || '';
        if (iframeUrl.includes('/payment/callback')) {
          clearInterval(checkInterval);
          document.body.removeChild(overlay);
          // Reload page to show callback result
          window.location.reload();
        }
      } catch (e) {
        // Cross-origin error is expected during 3D Secure
      }
    }, 500);

    // Auto-cleanup after 10 minutes (timeout)
    setTimeout(() => {
      if (document.body.contains(overlay)) {
        clearInterval(checkInterval);
        document.body.removeChild(overlay);
        toast.error('3D Secure doğrulaması zaman aşımına uğradı');
      }
    }, 10 * 60 * 1000);
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

