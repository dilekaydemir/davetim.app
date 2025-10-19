import { supabase } from './supabase';
import toast from 'react-hot-toast';
import type { PlanTier } from '../config/plans';

export interface Subscription {
  id: string;
  userId: string;
  tier: PlanTier;
  status: 'active' | 'cancelled' | 'expired' | 'trialing';
  startDate: string;
  endDate?: string;
  cancelledAt?: string;
  invitationsCreatedThisMonth: number;
  invitationsCreatedLifetime: number;
  storageUsedMb: number;
  createdAt: string;
  updatedAt: string;
}

export interface PaymentHistory {
  id: string;
  userId: string;
  transactionId: string;
  providerTransactionId?: string;
  provider: string;
  amount: number;
  currency: string;
  status: string;
  planTier: PlanTier;
  billingPeriod: 'monthly' | 'yearly';
  description?: string;
  errorMessage?: string;
  processedAt: string;
  createdAt: string;
}

class SubscriptionService {
  /**
   * Get user's subscription
   */
  async getUserSubscription(userId: string): Promise<Subscription | null> {
    try {
      const { data, error } = await supabase
        .from('subscriptions')
        .select('*')
        .eq('user_id', userId)
        .single();

      if (error) {
        if (error.code === 'PGRST116') {
          // No subscription found - this should not happen if triggers are working
          // But create one as fallback
          console.warn('⚠️ Subscription not found, creating free tier (trigger may not be working)');
          return this.createFreeSubscription(userId);
        }
        throw error;
      }

      return data ? this.mapToSubscription(data) : null;
    } catch (error: any) {
      console.error('❌ Get subscription error:', error);
      return null;
    }
  }

  /**
   * Create free tier subscription for new users
   */
  async createFreeSubscription(userId: string): Promise<Subscription> {
    try {
      const { data, error } = await supabase
        .from('subscriptions')
        .insert({
          user_id: userId,
          tier: 'free',
          status: 'active',
          start_date: new Date().toISOString(),
        })
        .select()
        .single();

      if (error) throw error;

      toast.success('Ücretsiz hesabınız oluşturuldu!');
      return this.mapToSubscription(data);
    } catch (error: any) {
      console.error('❌ Create free subscription error:', error);
      throw error;
    }
  }

  /**
   * Upgrade subscription after successful payment
   */
  async upgradeSubscription(
    userId: string,
    tier: 'pro' | 'premium',
    billingPeriod: 'monthly' | 'yearly',
    _transactionId: string
  ): Promise<Subscription> {
    try {
      console.log('🔄 Upgrading subscription:', { userId, tier, billingPeriod });
      
      const endDate = new Date();
      if (billingPeriod === 'monthly') {
        endDate.setMonth(endDate.getMonth() + 1);
      } else {
        endDate.setFullYear(endDate.getFullYear() + 1);
      }

      const updateData = {
        tier,
        status: 'active',
        start_date: new Date().toISOString(),
        end_date: endDate.toISOString(),
        cancelled_at: null,
      };

      console.log('📝 Update data:', updateData);

      const { data, error } = await supabase
        .from('subscriptions')
        .update(updateData)
        .eq('user_id', userId)
        .select()
        .single();

      if (error) {
        console.error('❌ Supabase error:', error);
        throw error;
      }

      console.log('✅ Subscription updated:', data);
      
      // Also update auth user metadata for consistency (optional, as we don't use it)
      try {
        console.log('🔄 Updating auth user metadata...');
        const { error: metadataError } = await supabase.auth.updateUser({
          data: { subscription_tier: tier }
        });
        if (metadataError) {
          console.warn('⚠️ Could not update auth metadata:', metadataError);
        } else {
          console.log('✅ Auth metadata updated');
        }
      } catch (metadataError) {
        console.warn('⚠️ Auth metadata update failed:', metadataError);
      }
      
      toast.success(`${tier.toUpperCase()} planına yükseltildiniz! 🎉`);
      return this.mapToSubscription(data);
    } catch (error: any) {
      console.error('❌ Upgrade subscription error:', error);
      toast.error('Abonelik güncellenemedi');
      throw error;
    }
  }

  /**
   * Cancel subscription
   */
  async cancelSubscription(userId: string): Promise<Subscription> {
    try {
      const { data, error } = await supabase
        .from('subscriptions')
        .update({
          status: 'cancelled',
          cancelled_at: new Date().toISOString(),
        })
        .eq('user_id', userId)
        .select()
        .single();

      if (error) throw error;

      toast.success('Aboneliğiniz iptal edildi');
      return this.mapToSubscription(data);
    } catch (error: any) {
      console.error('❌ Cancel subscription error:', error);
      toast.error('Abonelik iptal edilemedi');
      throw error;
    }
  }

  /**
   * Reactivate cancelled subscription
   */
  async reactivateSubscription(userId: string): Promise<Subscription> {
    try {
      const { data, error } = await supabase
        .from('subscriptions')
        .update({
          status: 'active',
          cancelled_at: null,
        })
        .eq('user_id', userId)
        .select()
        .single();

      if (error) throw error;

      toast.success('Aboneliğiniz yeniden aktif edildi!');
      return this.mapToSubscription(data);
    } catch (error: any) {
      console.error('❌ Reactivate subscription error:', error);
      toast.error('Abonelik aktif edilemedi');
      throw error;
    }
  }

  /**
   * Increment invitation counter
   */
  async incrementInvitationCount(userId: string): Promise<void> {
    try {
      const { error } = await supabase.rpc('increment_invitation_count', {
        p_user_id: userId,
      });

      if (error) throw error;
    } catch (error: any) {
      console.error('❌ Increment invitation count error:', error);
    }
  }

  /**
   * Update storage usage
   */
  async updateStorageUsage(userId: string, usageMb: number): Promise<void> {
    try {
      const { error } = await supabase
        .from('subscriptions')
        .update({ storage_used_mb: usageMb })
        .eq('user_id', userId);

      if (error) throw error;
    } catch (error: any) {
      console.error('❌ Update storage usage error:', error);
    }
  }

  /**
   * Get payment history for user
   */
  async getPaymentHistory(userId: string): Promise<PaymentHistory[]> {
    try {
      const { data, error } = await supabase
        .from('payment_history')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', { ascending: false });

      if (error) throw error;

      return (data || []).map(this.mapToPaymentHistory);
    } catch (error: any) {
      console.error('❌ Get payment history error:', error);
      return [];
    }
  }

  /**
   * Save payment to history
   */
  async savePaymentHistory(
    userId: string,
    transactionId: string,
    providerTransactionId: string | undefined,
    provider: string,
    amount: number,
    currency: string,
    status: string,
    planTier: 'pro' | 'premium',
    billingPeriod: 'monthly' | 'yearly',
    description?: string,
    errorMessage?: string
  ): Promise<void> {
    try {
      const { error } = await supabase
        .from('payment_history')
        .insert({
          user_id: userId,
          transaction_id: transactionId,
          provider_transaction_id: providerTransactionId,
          provider,
          amount,
          currency,
          status,
          plan_tier: planTier,
          billing_period: billingPeriod,
          description,
          error_message: errorMessage,
          processed_at: new Date().toISOString(),
        });

      if (error) throw error;
    } catch (error: any) {
      console.error('❌ Save payment history error:', error);
    }
  }

  /**
   * Map database subscription to typed object
   */
  private mapToSubscription(data: any): Subscription {
    return {
      id: data.id,
      userId: data.user_id,
      tier: data.tier,
      status: data.status,
      startDate: data.start_date,
      endDate: data.end_date,
      cancelledAt: data.cancelled_at,
      invitationsCreatedThisMonth: data.invitations_created_this_month || 0,
      invitationsCreatedLifetime: data.invitations_created_lifetime || 0,
      storageUsedMb: data.storage_used_mb || 0,
      createdAt: data.created_at,
      updatedAt: data.updated_at,
    };
  }

  /**
   * Check if user can access a specific feature
   */
  canAccessFeature(feature: string, subscription?: Subscription | null): boolean {
    if (!subscription) return false;

    switch (feature) {
      case 'qr_media':
        return subscription.tier === 'premium';
      case 'premium_templates':
        return subscription.tier === 'pro' || subscription.tier === 'premium';
      case 'image_upload':
        return subscription.tier === 'pro' || subscription.tier === 'premium';
      case 'whatsapp_sharing':
        return subscription.tier === 'pro' || subscription.tier === 'premium';
      case 'excel_export':
        return subscription.tier === 'pro' || subscription.tier === 'premium';
      case 'unlimited_invitations':
        return subscription.tier === 'premium';
      default:
        return false;
    }
  }

  /**
   * Map database payment history to typed object
   */
  private mapToPaymentHistory(data: any): PaymentHistory {
    return {
      id: data.id,
      userId: data.user_id,
      transactionId: data.transaction_id,
      providerTransactionId: data.provider_transaction_id,
      provider: data.provider,
      amount: data.amount,
      currency: data.currency,
      status: data.status,
      planTier: data.plan_tier,
      billingPeriod: data.billing_period,
      description: data.description,
      errorMessage: data.error_message,
      processedAt: data.processed_at,
      createdAt: data.created_at,
    };
  }
}

export const subscriptionService = new SubscriptionService();
