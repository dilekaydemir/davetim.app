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
      
      // ✅ ZORUNLU: Client redirect URL (Backend başarı/hata sonrası kullanıcıyı buraya yönlendirir)
      clientRedirectUrl: `${window.location.origin}/payment/callback`,
    };

    return this.processPayment(paymentRequest);
  }

  /**
   * Handle 3D Secure HTML content
   * ✅ DOĞRU YAKLAŞIM: HTML içeriğini direkt frontend'de render et
   * Backend'den HTML serve etmeye GEREK YOK (zaten response'da var)
   */
  handle3DSecure(htmlContent: string): void {
    // Save current state before 3D Secure
    sessionStorage.setItem('payment_3d_in_progress', 'true');
    sessionStorage.setItem('payment_3d_timestamp', Date.now().toString());
    
    console.log('🔐 Rendering 3D Secure HTML content (length:', htmlContent.length, ')');
    
    // ✅ Modal içinde iframe (ÖNERİLEN)
    this.render3DSecureModal(htmlContent);
  }

  /**
   * Render 3D Secure HTML in modal with iframe
   */
  private render3DSecureModal(htmlContent: string): void {
    // Remove existing modal if any
    const existingModal = document.getElementById('3ds-modal');
    if (existingModal) {
      existingModal.remove();
    }

    // Create modal overlay
    const modal = document.createElement('div');
    modal.id = '3ds-modal';
    modal.style.cssText = `
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.8);
      z-index: 99999;
      display: flex;
      justify-content: center;
      align-items: center;
    `;

    // Create container
    const container = document.createElement('div');
    container.style.cssText = `
      width: 90%;
      max-width: 600px;
      height: 85vh;
      max-height: 800px;
      background: white;
      border-radius: 12px;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
      display: flex;
      flex-direction: column;
      overflow: hidden;
    `;

    // Create header
    const header = document.createElement('div');
    header.style.cssText = `
      padding: 20px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      display: flex;
      justify-content: space-between;
      align-items: center;
    `;

    // Create title
    const titleDiv = document.createElement('div');
    const title = document.createElement('h3');
    title.textContent = '🔐 Güvenli Ödeme';
    title.style.cssText = 'margin: 0; font-size: 18px; font-weight: 600;';
    
    const subtitle = document.createElement('p');
    subtitle.textContent = '3D Secure ile ödemenizi tamamlayın';
    subtitle.style.cssText = 'margin: 4px 0 0 0; font-size: 12px; opacity: 0.9;';
    
    titleDiv.appendChild(title);
    titleDiv.appendChild(subtitle);

    // Create close button
    const closeBtn = document.createElement('button');
    closeBtn.textContent = '×';
    closeBtn.style.cssText = `
      background: rgba(255,255,255,0.2);
      border: none;
      color: white;
      font-size: 24px;
      width: 32px;
      height: 32px;
      border-radius: 50%;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: background 0.2s;
    `;

    // Close button handlers
    closeBtn.addEventListener('click', () => {
      if (confirm('3D Secure işlemini iptal etmek istediğinize emin misiniz?')) {
        modal.remove();
        sessionStorage.removeItem('payment_3d_in_progress');
        toast.error('Ödeme işlemi iptal edildi');
      }
    });

    closeBtn.addEventListener('mouseenter', () => {
      closeBtn.style.background = 'rgba(255,255,255,0.3)';
    });
    
    closeBtn.addEventListener('mouseleave', () => {
      closeBtn.style.background = 'rgba(255,255,255,0.2)';
    });

    header.appendChild(titleDiv);
    header.appendChild(closeBtn);

    // Create iframe
    const iframe = document.createElement('iframe');
    iframe.id = '3ds-iframe';
    iframe.style.cssText = `
      flex: 1;
      width: 100%;
      border: none;
      background: white;
    `;
    iframe.srcdoc = htmlContent;

    // Listen for iframe navigation (3D Secure completion)
    // When İyzico redirects to callback URL, we'll detect it
    let checkInterval: number;
    
    iframe.addEventListener('load', () => {
      console.log('🔄 3D Secure iframe loaded');
      
      // Check if iframe navigated to callback URL
      checkInterval = window.setInterval(() => {
        try {
          // Try to access iframe location (will fail due to CORS, but we can detect navigation)
          const iframeWindow = iframe.contentWindow;
          if (iframeWindow) {
            // If we can access it, check if it's our callback URL
            const iframeLocation = iframeWindow.location.href;
            console.log('🔍 Checking iframe location:', iframeLocation);
            
            if (iframeLocation.includes('/payment/callback')) {
              console.log('✅ 3D Secure completed, redirecting...');
              clearInterval(checkInterval);
              
              // Redirect main window to callback URL
              window.location.href = iframeLocation;
            }
          }
        } catch (e) {
          // CORS error is expected, ignore
          // We'll rely on backend redirect instead
        }
      }, 1000);
    });

    // Cleanup interval on modal close
    const originalRemove = modal.remove.bind(modal);
    modal.remove = () => {
      if (checkInterval) {
        clearInterval(checkInterval);
      }
      originalRemove();
    };

    // Assemble modal
    container.appendChild(header);
    container.appendChild(iframe);
    modal.appendChild(container);
    document.body.appendChild(modal);

    console.log('✅ 3D Secure modal rendered. User can now complete payment.');
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
