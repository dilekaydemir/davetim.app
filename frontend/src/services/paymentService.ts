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
   * Handle 3D Secure HTML rendering
   * ✅ DOĞRU YAKLAŞIM: HTML'i frontend'te direkt render et
   * Backend'den gelen threeDSecureHtmlContent'i modal içinde göster
   */
  handle3DSecure(htmlContent: string): void {
    console.log('🔐 Rendering 3D Secure HTML...');
    console.log('📄 HTML length:', htmlContent.length);
    
    // Save state
    sessionStorage.setItem('payment_3d_in_progress', 'true');
    sessionStorage.setItem('payment_3d_timestamp', Date.now().toString());
    
    // ✅ MODAL İÇİNDE IFRAME RENDER ET (ÖNERİLEN)
    this.render3DSecureModal(htmlContent);
  }

  /**
   * Render 3D Secure HTML in a modal with iframe
   * Modern, responsive, minimal design
   */
  private render3DSecureModal(htmlContent: string): void {
    // Remove existing modal if any
    const existingModal = document.getElementById('threeds-modal');
    if (existingModal) {
      existingModal.remove();
    }

    // Create modal overlay
    const modal = document.createElement('div');
    modal.id = 'threeds-modal';
    modal.style.cssText = `
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.85);
      backdrop-filter: blur(4px);
      z-index: 99999;
      display: flex;
      justify-content: center;
      align-items: center;
      animation: fadeIn 0.3s ease-in-out;
      padding: 20px;
    `;

    // Create modal container
    const container = document.createElement('div');
    container.style.cssText = `
      width: 100%;
      max-width: 500px;
      height: 90vh;
      max-height: 700px;
      background: white;
      border-radius: 16px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      overflow: hidden;
      display: flex;
      flex-direction: column;
      position: relative;
      animation: slideUp 0.3s ease-out;
    `;

    // Create header
    const header = document.createElement('div');
    header.style.cssText = `
      padding: 20px;
      background: linear-gradient(135deg, #f5702a 0%, #e85d1f 100%);
      color: white;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    `;

    const title = document.createElement('h3');
    title.textContent = '🔐 3D Secure Doğrulama';
    title.style.cssText = `
      margin: 0;
      font-size: 18px;
      font-weight: 600;
    `;

    const closeBtn = document.createElement('button');
    closeBtn.innerHTML = '×';
    closeBtn.style.cssText = `
      background: rgba(255, 255, 255, 0.2);
      border: none;
      color: white;
      font-size: 32px;
      width: 40px;
      height: 40px;
      border-radius: 50%;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.2s;
      line-height: 1;
      padding: 0;
    `;
    closeBtn.onmouseover = () => {
      closeBtn.style.background = 'rgba(255, 255, 255, 0.3)';
      closeBtn.style.transform = 'rotate(90deg)';
    };
    closeBtn.onmouseout = () => {
      closeBtn.style.background = 'rgba(255, 255, 255, 0.2)';
      closeBtn.style.transform = 'rotate(0deg)';
    };
    closeBtn.onclick = () => {
      console.log('⚠️ 3D Secure modal kapatıldı (kullanıcı iptal etti)');
      document.body.removeChild(modal);
      sessionStorage.removeItem('payment_3d_in_progress');
      toast.error('3D Secure doğrulaması iptal edildi');
    };

    header.appendChild(title);
    header.appendChild(closeBtn);

    // Create iframe container
    const iframeContainer = document.createElement('div');
    iframeContainer.style.cssText = `
      flex: 1;
      display: flex;
      flex-direction: column;
      overflow: hidden;
      position: relative;
    `;

    // Create loading spinner
    const spinner = document.createElement('div');
    spinner.innerHTML = `
      <div style="text-align: center; padding: 40px;">
        <div style="
          border: 4px solid #f3f4f6;
          border-top: 4px solid #f5702a;
          border-radius: 50%;
          width: 50px;
          height: 50px;
          animation: spin 1s linear infinite;
          margin: 0 auto 20px;
        "></div>
        <p style="color: #6b7280; font-size: 14px; margin: 0;">3D Secure yükleniyor...</p>
      </div>
    `;
    spinner.style.cssText = `
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      z-index: 1;
    `;

    // Create iframe
    const iframe = document.createElement('iframe');
    iframe.style.cssText = `
      width: 100%;
      height: 100%;
      border: none;
      background: white;
    `;
    iframe.setAttribute('sandbox', 'allow-forms allow-scripts allow-same-origin allow-top-navigation');
    
    // Hide spinner when iframe loads
    iframe.onload = () => {
      spinner.style.display = 'none';
      console.log('✅ 3D Secure iframe yüklendi');
    };

    // ✅ RENDER HTML IN IFRAME
    iframe.srcdoc = htmlContent;

    iframeContainer.appendChild(spinner);
    iframeContainer.appendChild(iframe);

    // Create footer with info
    const footer = document.createElement('div');
    footer.style.cssText = `
      padding: 16px 20px;
      background: #f9fafb;
      border-top: 1px solid #e5e7eb;
      display: flex;
      align-items: center;
      gap: 12px;
    `;

    footer.innerHTML = `
      <svg width="20" height="20" viewBox="0 0 20 20" fill="none" style="flex-shrink: 0;">
        <path d="M10 2C5.58 2 2 5.58 2 10C2 14.42 5.58 18 10 18C14.42 18 18 14.42 18 10C18 5.58 14.42 2 10 2ZM10 13C9.45 13 9 12.55 9 12V10C9 9.45 9.45 9 10 9C10.55 9 11 9.45 11 10V12C11 12.55 10.55 13 10 13ZM11 7H9V5H11V7Z" fill="#6b7280"/>
      </svg>
      <p style="margin: 0; font-size: 13px; color: #6b7280; line-height: 1.5;">
        Bankanızdan gelen SMS kodunu girerek ödemenizi tamamlayın
      </p>
    `;

    container.appendChild(header);
    container.appendChild(iframeContainer);
    container.appendChild(footer);
    modal.appendChild(container);

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
          transform: translateY(30px);
        }
        to { 
          opacity: 1;
          transform: translateY(0);
        }
      }
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
      
      /* Mobile responsive */
      @media (max-width: 640px) {
        #threeds-modal > div {
          max-width: 100% !important;
          height: 100vh !important;
          max-height: 100vh !important;
          border-radius: 0 !important;
        }
      }
    `;
    document.head.appendChild(style);

    // Append to body
    document.body.appendChild(modal);
    
    console.log('✅ 3D Secure modal açıldı. Kullanıcı SMS kodunu girecek.');
    toast.success('3D Secure doğrulama ekranı açıldı');
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
