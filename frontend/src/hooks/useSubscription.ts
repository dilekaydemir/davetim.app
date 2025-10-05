/**
 * useSubscription Hook
 * 
 * Kullanıcının abonelik bilgilerini ve plan kontrollerini
 * kolayca kullanmak için React hook.
 */

import { useState, useEffect } from 'react';
import { useAuth } from '../store/authStore';
import { subscriptionService, UserSubscription } from '../services/subscriptionService';
import { PlanTier, getPlanConfig, DEFAULT_PLAN, PlanConfig, needsUpgrade } from '../config/plans';

export interface UseSubscriptionReturn {
  // Abonelik bilgileri
  subscription: UserSubscription | null;
  planConfig: PlanConfig | null;
  isLoading: boolean;
  
  // Plan bilgileri
  currentPlan: PlanTier;
  planName: string;
  isFreePlan: boolean;
  isProPlan: boolean;
  isPremiumPlan: boolean;
  isBusinessPlan: boolean;
  
  // Özellik kontrolleri
  canCreateInvitation: () => Promise<{ allowed: boolean; reason?: string }>;
  canAccessPremiumTemplates: () => Promise<{ allowed: boolean; reason?: string }>;
  canUploadImage: () => Promise<{ allowed: boolean; reason?: string }>;
  canShareWhatsApp: () => Promise<{ allowed: boolean; reason?: string }>;
  canExportExcel: () => Promise<{ allowed: boolean; reason?: string }>;
  canUseQRMedia: () => Promise<{ allowed: boolean; reason?: string }>;
  canUseAIDesign: () => Promise<{ allowed: boolean; reason?: string }>;
  canUploadImageWithSize: (fileSizeMB: number) => Promise<{ allowed: boolean; reason?: string }>;
  canAddGuest: (invitationId: string, currentGuestCount: number) => Promise<{ allowed: boolean; reason?: string }>;
  
  // Genel kontrol fonksiyonu
  checkFeatureAccess: (feature: string) => Promise<{ allowed: boolean; reason?: string }>;
  
  // Yardımcı fonksiyonlar
  needsUpgradeFor: (feature: string) => boolean;
  getRemainingInvitations: () => number | 'unlimited';
  getStorageUsagePercentage: () => number;
  getRemainingStorageMB: () => number;
  
  // Refresh
  refreshSubscription: () => Promise<void>;
}

export function useSubscription(): UseSubscriptionReturn {
  const { user } = useAuth();
  const [subscription, setSubscription] = useState<UserSubscription | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  
  // Abonelik bilgilerini yükle
  const loadSubscription = async () => {
    if (!user?.id) {
      setSubscription(null);
      setIsLoading(false);
      return;
    }
    
    setIsLoading(true);
    try {
      const sub = await subscriptionService.getUserSubscription(user.id);
      setSubscription(sub);
    } catch (error) {
      console.error('❌ Load subscription error:', error);
      setSubscription(null);
    } finally {
      setIsLoading(false);
    }
  };
  
  // İlk yüklemede ve user değiştiğinde
  useEffect(() => {
    loadSubscription();
  }, [user?.id]);
  
  // Plan bilgileri
  const currentPlan = subscription?.planId || DEFAULT_PLAN;
  const planConfig = getPlanConfig(currentPlan);
  const planName = planConfig.name;
  
  // Plan tipleri
  const isFreePlan = currentPlan === 'free';
  const isProPlan = currentPlan === 'pro';
  const isPremiumPlan = currentPlan === 'premium';
  const isBusinessPlan = false; // Kurumsal planlar kaldırıldı
  
  // Özellik kontrol fonksiyonları
  const checkFeatureAccess = async (feature: string) => {
    if (!user?.id) {
      return { allowed: false, reason: 'Lütfen giriş yapın' };
    }
    
    return await subscriptionService.canAccessFeature(user.id, feature);
  };
  
  const canCreateInvitation = () => checkFeatureAccess('create_invitation');
  const canAccessPremiumTemplates = () => checkFeatureAccess('premium_templates');
  const canUploadImage = () => checkFeatureAccess('image_upload');
  const canShareWhatsApp = () => checkFeatureAccess('whatsapp_sharing');
  const canExportExcel = () => checkFeatureAccess('excel_export');
  const canUseQRMedia = () => checkFeatureAccess('qr_media');
  const canUseAIDesign = () => checkFeatureAccess('ai_design');
  
  // Storage kontrolü
  const canUploadImageWithSize = async (fileSizeMB: number): Promise<{ allowed: boolean; reason?: string }> => {
    if (!subscription) {
      return { allowed: false, reason: 'Abonelik bilgisi bulunamadı' };
    }
    
    // Önce image upload yetkisi var mı kontrol et
    const imageAccess = await canUploadImage();
    if (!imageAccess.allowed) {
      return imageAccess;
    }
    
    // Storage limitini kontrol et
    const remainingStorage = planConfig.limits.storageMB - subscription.storageUsedMB;
    
    if (fileSizeMB > remainingStorage) {
      return {
        allowed: false,
        reason: `Yetersiz depolama alanı. Kalan: ${remainingStorage.toFixed(2)}MB, Gereken: ${fileSizeMB.toFixed(2)}MB. Daha büyük bir plana yükseltin!`
      };
    }
    
    return { allowed: true };
  };
  
  // Guest sayısı kontrolü
  const canAddGuest = async (invitationId: string, currentGuestCount: number): Promise<{ allowed: boolean; reason?: string }> => {
    if (!subscription) {
      return { allowed: false, reason: 'Abonelik bilgisi bulunamadı' };
    }
    
    const maxGuests = planConfig.limits.maxGuestsPerInvitation;
    
    // Unlimited kontrolü
    if (maxGuests === 'unlimited') {
      return { allowed: true };
    }
    
    // Limit kontrolü
    if (currentGuestCount >= maxGuests) {
      return {
        allowed: false,
        reason: `Bu davetiyeye maksimum ${maxGuests} davetli ekleyebilirsiniz. Daha fazla davetli için planınızı yükseltin!`
      };
    }
    
    return { allowed: true };
  };
  
  // Yardımcı fonksiyonlar
  const needsUpgradeFor = (feature: string): boolean => {
    return needsUpgrade(currentPlan, feature as any);
  };
  
  const getRemainingInvitations = (): number | 'unlimited' => {
    if (!subscription) return 0;
    
    const limit = planConfig.limits.invitationsPerMonth;
    
    if (limit === 'unlimited') {
      return 'unlimited';
    }
    
    // Free plan - lifetime limit
    if (limit === 0 && planConfig.limits.invitationsLifetime) {
      const remaining = planConfig.limits.invitationsLifetime - subscription.invitationsCreatedLifetime;
      return Math.max(0, remaining);
    }
    
    // Aylık limit
    if (typeof limit === 'number') {
      const remaining = limit - subscription.invitationsCreatedThisMonth;
      return Math.max(0, remaining);
    }
    
    return 0;
  };
  
  const getStorageUsagePercentage = (): number => {
    if (!subscription) return 0;
    
    const used = subscription.storageUsedMB;
    const total = planConfig.limits.storageMB;
    
    return Math.min(100, Math.round((used / total) * 100));
  };
  
  const getRemainingStorageMB = (): number => {
    if (!subscription) return 0;
    
    const used = subscription.storageUsedMB;
    const total = planConfig.limits.storageMB;
    
    return Math.max(0, total - used);
  };
  
  const refreshSubscription = async () => {
    await loadSubscription();
  };
  
  return {
    // Abonelik bilgileri
    subscription,
    planConfig,
    isLoading,
    
    // Plan bilgileri
    currentPlan,
    planName,
    isFreePlan,
    isProPlan,
    isPremiumPlan,
    isBusinessPlan,
    
    // Özellik kontrolleri
    canCreateInvitation,
    canAccessPremiumTemplates,
    canUploadImage,
    canShareWhatsApp,
    canExportExcel,
    canUseQRMedia,
    canUseAIDesign,
    canUploadImageWithSize,
    canAddGuest,
    
    // Genel kontrol
    checkFeatureAccess,
    
    // Yardımcılar
    needsUpgradeFor,
    getRemainingInvitations,
    getStorageUsagePercentage,
    getRemainingStorageMB,
    
    // Refresh
    refreshSubscription,
  };
}

