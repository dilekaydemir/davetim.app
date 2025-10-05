/**
 * Subscription Service
 * 
 * Kullanıcı abonelik ve plan yönetimi için servis.
 * Database'den plan bilgilerini okur, günceller ve kullanım limitlerini kontrol eder.
 */

import { supabase } from './supabase';
import { PlanTier, getPlanConfig, DEFAULT_PLAN } from '../config/plans';
import toast from 'react-hot-toast';

export interface UserSubscription {
  userId: string;
  planId: PlanTier;
  billingPeriod: 'monthly' | 'yearly' | 'lifetime';
  startDate: string;
  endDate: string | null;
  status: 'active' | 'cancelled' | 'expired' | 'trial';
  autoRenew: boolean;
  
  // Kullanım istatistikleri
  invitationsCreatedThisMonth: number;
  invitationsCreatedLifetime: number;
  storageUsedMB: number;
  
  // Ödeme bilgisi (opsiyonel)
  lastPaymentDate?: string;
  nextBillingDate?: string;
}

export interface UsageStats {
  invitationsThisMonth: number;
  invitationsLifetime: number;
  storageUsedMB: number;
  guestsTotal: number;
}

class SubscriptionService {
  /**
   * Kullanıcının mevcut abonelik bilgisini getir
   */
  async getUserSubscription(userId: string): Promise<UserSubscription | null> {
    try {
      // Önce auth.users tablosundan user_metadata'yı kontrol et
      const { data: { user }, error: userError } = await supabase.auth.getUser();
      
      if (userError || !user) {
        console.error('❌ User not found:', userError);
        return null;
      }
      
      // user_metadata'dan plan bilgisini al
      const planId = (user.user_metadata?.subscription_tier as PlanTier) || DEFAULT_PLAN;
      const billingPeriod = user.user_metadata?.billing_period || 'monthly';
      const subscriptionStatus = user.user_metadata?.subscription_status || 'active';
      
      // Kullanım istatistiklerini al
      const stats = await this.getUserUsageStats(userId);
      
      // Abonelik bilgisini oluştur
      const subscription: UserSubscription = {
        userId: user.id,
        planId: planId,
        billingPeriod: billingPeriod,
        startDate: user.user_metadata?.subscription_start_date || user.created_at,
        endDate: user.user_metadata?.subscription_end_date || null,
        status: subscriptionStatus,
        autoRenew: user.user_metadata?.auto_renew !== false,
        invitationsCreatedThisMonth: stats.invitationsThisMonth,
        invitationsCreatedLifetime: stats.invitationsLifetime,
        storageUsedMB: stats.storageUsedMB,
        lastPaymentDate: user.user_metadata?.last_payment_date,
        nextBillingDate: user.user_metadata?.next_billing_date,
      };
      
      return subscription;
    } catch (error: any) {
      console.error('❌ Get subscription error:', error);
      return null;
    }
  }
  
  /**
   * Kullanıcının kullanım istatistiklerini getir
   */
  async getUserUsageStats(userId: string): Promise<UsageStats> {
    try {
      // Bu ay oluşturulan davetiye sayısı
      const startOfMonth = new Date();
      startOfMonth.setDate(1);
      startOfMonth.setHours(0, 0, 0, 0);
      
      const { count: monthlyCount } = await supabase
        .from('invitations')
        .select('*', { count: 'exact', head: true })
        .eq('user_id', userId)
        .gte('created_at', startOfMonth.toISOString());
      
      // Toplam davetiye sayısı
      const { count: lifetimeCount } = await supabase
        .from('invitations')
        .select('*', { count: 'exact', head: true })
        .eq('user_id', userId);
      
      // Toplam davetli sayısı
      const { data: invitations } = await supabase
        .from('invitations')
        .select('id')
        .eq('user_id', userId);
      
      let totalGuests = 0;
      if (invitations && invitations.length > 0) {
        const invitationIds = invitations.map(inv => inv.id);
        const { count: guestCount } = await supabase
          .from('guests')
          .select('*', { count: 'exact', head: true })
          .in('invitation_id', invitationIds);
        
        totalGuests = guestCount || 0;
      }
      
      // Kullanılan depolama (yaklaşık - görsel dosya boyutları)
      // TODO: Gerçek depolama hesabı için Supabase Storage API kullanılabilir
      const storageUsedMB = 0; // Şimdilik 0, ileride implement edilecek
      
      return {
        invitationsThisMonth: monthlyCount || 0,
        invitationsLifetime: lifetimeCount || 0,
        storageUsedMB: storageUsedMB,
        guestsTotal: totalGuests,
      };
    } catch (error: any) {
      console.error('❌ Get usage stats error:', error);
      return {
        invitationsThisMonth: 0,
        invitationsLifetime: 0,
        storageUsedMB: 0,
        guestsTotal: 0,
      };
    }
  }
  
  /**
   * Kullanıcının planını güncelle
   */
  async updateUserPlan(
    userId: string,
    newPlan: PlanTier,
    billingPeriod: 'monthly' | 'yearly' | 'lifetime'
  ): Promise<boolean> {
    try {
      const now = new Date();
      const endDate = new Date();
      
      // Bitiş tarihini hesapla
      if (billingPeriod === 'monthly') {
        endDate.setMonth(endDate.getMonth() + 1);
      } else if (billingPeriod === 'yearly') {
        endDate.setFullYear(endDate.getFullYear() + 1);
      } else {
        // lifetime - bitiş tarihi yok
        endDate.setFullYear(endDate.getFullYear() + 100);
      }
      
      // user_metadata'yı güncelle
      const { error } = await supabase.auth.updateUser({
        data: {
          subscription_tier: newPlan,
          billing_period: billingPeriod,
          subscription_status: 'active',
          subscription_start_date: now.toISOString(),
          subscription_end_date: endDate.toISOString(),
          last_payment_date: now.toISOString(),
          next_billing_date: endDate.toISOString(),
          auto_renew: true,
        }
      });
      
      if (error) {
        console.error('❌ Update plan error:', error);
        toast.error('Plan güncellenirken hata oluştu');
        return false;
      }
      
      const planConfig = getPlanConfig(newPlan);
      toast.success(`${planConfig.name} planına yükseltildiniz! 🎉`);
      return true;
    } catch (error: any) {
      console.error('❌ Update plan error:', error);
      toast.error('Plan güncellenirken hata oluştu');
      return false;
    }
  }
  
  /**
   * Kullanıcının belirli bir özelliğe erişimi var mı?
   */
  async canAccessFeature(
    userId: string,
    feature: string
  ): Promise<{ allowed: boolean; reason?: string }> {
    try {
      const subscription = await this.getUserSubscription(userId);
      if (!subscription) {
        return { allowed: false, reason: 'Abonelik bilgisi bulunamadı' };
      }
      
      const planConfig = getPlanConfig(subscription.planId);
      const limits = planConfig.limits;
      
      // Özellik kontrolü
      switch (feature) {
        case 'create_invitation': {
          // Davetiye oluşturma kontrolü
          const limit = limits.invitationsPerMonth;
          
          if (limit === 'unlimited') {
            return { allowed: true };
          }
          
          if (limit === 0 && limits.invitationsLifetime) {
            // Free plan - lifetime kontrolü
            if (subscription.invitationsCreatedLifetime >= limits.invitationsLifetime) {
              return { 
                allowed: false, 
                reason: `Ücretsiz planda sadece ${limits.invitationsLifetime} davetiye hakkınız var. Yükseltme yapın!` 
              };
            }
            return { allowed: true };
          }
          
          if (typeof limit === 'number' && subscription.invitationsCreatedThisMonth >= limit) {
            return { 
              allowed: false, 
              reason: `Bu ay ${limit} davetiye limitine ulaştınız. Yükseltme yapın veya gelecek ay için bekleyin!` 
            };
          }
          
          return { allowed: true };
        }
        
        case 'premium_templates':
          if (!limits.premiumTemplates) {
            return { allowed: false, reason: 'Premium şablonlar için yükseltme yapın!' };
          }
          return { allowed: true };
        
        case 'image_upload':
          if (!limits.imageUpload) {
            return { allowed: false, reason: 'Görsel yükleme için PRO plana yükseltin!' };
          }
          return { allowed: true };
        
        case 'whatsapp_sharing':
          if (!limits.whatsappSharing) {
            return { allowed: false, reason: 'WhatsApp paylaşım için PRO plana yükseltin!' };
          }
          return { allowed: true };
        
        case 'excel_export':
          if (!limits.excelExport) {
            return { allowed: false, reason: 'Excel export için PRO plana yükseltin!' };
          }
          return { allowed: true };
        
        case 'qr_media':
          if (!limits.qrMediaUpload) {
            return { allowed: false, reason: 'QR medya yükleme için PREMIUM plana yükseltin!' };
          }
          return { allowed: true };
        
        case 'ai_design':
          if (!limits.aiDesign) {
            return { allowed: false, reason: 'AI tasarım için PREMIUM plana yükseltin!' };
          }
          return { allowed: true };
        
        default:
          return { allowed: true };
      }
    } catch (error: any) {
      console.error('❌ Feature access check error:', error);
      return { allowed: false, reason: 'Kontrol hatası' };
    }
  }
  
  /**
   * Planı iptal et
   */
  async cancelSubscription(userId: string): Promise<boolean> {
    try {
      const { error } = await supabase.auth.updateUser({
        data: {
          subscription_status: 'cancelled',
          auto_renew: false,
        }
      });
      
      if (error) {
        console.error('❌ Cancel subscription error:', error);
        toast.error('Abonelik iptal edilirken hata oluştu');
        return false;
      }
      
      toast.success('Abonelik iptal edildi. Mevcut dönem sonuna kadar erişiminiz devam edecek.');
      return true;
    } catch (error: any) {
      console.error('❌ Cancel subscription error:', error);
      toast.error('Abonelik iptal edilirken hata oluştu');
      return false;
    }
  }
  
  /**
   * Deneme süresi başlat (7 gün)
   */
  async startTrial(userId: string, planId: PlanTier): Promise<boolean> {
    try {
      const now = new Date();
      const trialEndDate = new Date();
      trialEndDate.setDate(trialEndDate.getDate() + 7);
      
      const { error } = await supabase.auth.updateUser({
        data: {
          subscription_tier: planId,
          billing_period: 'monthly',
          subscription_status: 'trial',
          subscription_start_date: now.toISOString(),
          subscription_end_date: trialEndDate.toISOString(),
          auto_renew: false,
        }
      });
      
      if (error) {
        console.error('❌ Start trial error:', error);
        toast.error('Deneme süresi başlatılırken hata oluştu');
        return false;
      }
      
      const planConfig = getPlanConfig(planId);
      toast.success(`${planConfig.name} için 7 günlük deneme başladı! 🎉`);
      return true;
    } catch (error: any) {
      console.error('❌ Start trial error:', error);
      toast.error('Deneme süresi başlatılırken hata oluştu');
      return false;
    }
  }
}

export const subscriptionService = new SubscriptionService();

