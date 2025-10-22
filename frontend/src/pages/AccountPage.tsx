import React, { useState, useEffect } from 'react';
import { User, Mail, Phone, CreditCard, Download, Calendar, Settings, Shield, Bell, Lock, TrendingUp, HardDrive, Users, FileText, Crown, Zap, X } from 'lucide-react';
import { useAuth } from '../store/authStore';
import { useSubscription } from '../hooks/useSubscription';
import { PLAN_CONFIGS } from '../config/plans';
import { authService } from '../services/authService';
import { invitationService } from '../services/invitationService';
import { guestService } from '../services/guestService';
import { subscriptionService, type PaymentHistory } from '../services/subscriptionService';
import toast from 'react-hot-toast';
import { useNavigate } from 'react-router-dom';
import ConfirmDialog from '../components/Common/ConfirmDialog';
import { formatFileSize } from '../utils/imageOptimization';

const AccountPage: React.FC = () => {
  const navigate = useNavigate();
  const { user: authUser } = useAuth();
  const subscription = useSubscription();
  
  const [activeTab, setActiveTab] = useState('profile');
  const [isLoading, setIsLoading] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  
  // Profile form data
  const [profileData, setProfileData] = useState({
    fullName: authUser?.fullName || '',
    phone: authUser?.phone || '',
  });
  
  // Password change modal
  const [showPasswordModal, setShowPasswordModal] = useState(false);
  const [passwordData, setPasswordData] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
  });
  
  // Subscription cancellation
  const [showCancelDialog, setShowCancelDialog] = useState(false);
  const [isCancelling, setIsCancelling] = useState(false);
  
  // Usage stats
  const [usageStats, setUsageStats] = useState({
    invitationCount: 0,
    totalGuests: 0,
    storageUsed: 0,
  });

  // Payment history
  const [paymentHistory, setPaymentHistory] = useState<PaymentHistory[]>([]);
  const [loadingPayments, setLoadingPayments] = useState(false);

  const tabs = [
    { id: 'profile', name: 'Profil', icon: <User className="h-5 w-5" /> },
    { id: 'subscription', name: 'Abonelik', icon: <CreditCard className="h-5 w-5" /> },
    { id: 'payments', name: 'Ödemeler', icon: <FileText className="h-5 w-5" /> },
    { id: 'usage', name: 'Kullanım', icon: <Download className="h-5 w-5" /> },
    { id: 'settings', name: 'Ayarlar', icon: <Settings className="h-5 w-5" /> },
  ];

  // Load usage stats
  useEffect(() => {
    loadUsageStats();
  }, []);

  // Load payment history when tab is selected
  useEffect(() => {
    if (activeTab === 'payments' && authUser?.id && paymentHistory.length === 0) {
      loadPaymentHistory();
    }
  }, [activeTab, authUser?.id]);

  const loadPaymentHistory = async () => {
    if (!authUser?.id) return;
    
    setLoadingPayments(true);
    try {
      const history = await subscriptionService.getPaymentHistory(authUser.id);
      setPaymentHistory(history);
    } catch (error) {
      console.error('Error loading payment history:', error);
      toast.error('Ödeme geçmişi yüklenemedi');
    } finally {
      setLoadingPayments(false);
    }
  };

  const loadUsageStats = async () => {
    if (!authUser?.id) return;
    
    try {
      const invitations = await invitationService.getUserInvitations(authUser.id);
      
      let totalGuests = 0;
      for (const inv of invitations) {
        const guestCount = await guestService.getGuestCount(inv.id);
        totalGuests += guestCount;
      }
      
      setUsageStats({
        invitationCount: invitations.length,
        totalGuests,
        storageUsed: subscription.subscription?.storageUsedMB || 0,
      });
    } catch (error) {
      console.error('Error loading usage stats:', error);
    }
  };

  const handleProfileUpdate = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!profileData.fullName.trim()) {
      toast.error('Ad Soyad gerekli');
      return;
    }
    
    setIsSaving(true);
    try {
      await authService.updateProfile({
        fullName: profileData.fullName,
        phone: profileData.phone || undefined,
      });
      
      toast.success('Profil güncellendi!');
    } catch (error) {
      console.error('Profile update error:', error);
      toast.error('Profil güncellenemedi');
    } finally {
      setIsSaving(false);
    }
  };

  const handlePasswordChange = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!passwordData.newPassword || passwordData.newPassword.length < 6) {
      toast.error('Yeni şifre en az 6 karakter olmalı');
      return;
    }
    
    if (passwordData.newPassword !== passwordData.confirmPassword) {
      toast.error('Şifreler eşleşmiyor');
      return;
    }
    
    setIsSaving(true);
    try {
      await authService.changePassword({
        currentPassword: passwordData.currentPassword,
        newPassword: passwordData.newPassword,
      });
      
      setShowPasswordModal(false);
      setPasswordData({ currentPassword: '', newPassword: '', confirmPassword: '' });
      toast.success('Şifre başarıyla değiştirildi!');
    } catch (error: any) {
      console.error('Password change error:', error);
      toast.error(error.message || 'Şifre değiştirilemedi');
    } finally {
      setIsSaving(false);
    }
  };

  const handleCancelSubscription = async () => {
    if (!authUser?.id) return;
    
    setIsCancelling(true);
    try {
      // Check if refund is available
      const refundInfo = subscription.canCancelWithRefund();
      
      console.log('🔄 Starting cancellation:', {
        userId: authUser.id,
        shouldRefund: refundInfo.canRefund,
        daysLeft: refundInfo.daysLeft,
      });
      
      // Cancel subscription with refund flag
      const success = await subscriptionService.cancelSubscription(authUser.id, refundInfo.canRefund);
      
      if (success) {
        setShowCancelDialog(false);
        await subscription.refreshSubscription();
        
        // Toast message is shown by subscriptionService
      }
    } catch (error) {
      console.error('Cancel subscription error:', error);
      toast.error('Abonelik iptal edilemedi');
    } finally {
      setIsCancelling(false);
    }
  };

  const getPlanIcon = (tier: string) => {
    switch (tier) {
      case 'premium':
        return <Crown className="h-5 w-5 text-purple-600" />;
      case 'pro':
        return <Zap className="h-5 w-5 text-primary-600" />;
      default:
        return <User className="h-5 w-5 text-gray-600" />;
    }
  };

  const getPlanColor = (tier: string) => {
    switch (tier) {
      case 'premium':
        return 'from-purple-600 to-pink-600';
      case 'pro':
        return 'from-primary-600 to-blue-600';
      default:
        return 'from-gray-600 to-gray-700';
    }
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case 'profile':
        return (
          <div className="space-y-6 animate-fade-in">
            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Profil Bilgileri
              </h3>
              <form onSubmit={handleProfileUpdate}>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Ad Soyad *
                    </label>
                    <div className="relative">
                      <User className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
                      <input
                        type="text"
                        value={profileData.fullName}
                        onChange={(e) => setProfileData({ ...profileData, fullName: e.target.value })}
                        className="input-field pl-10"
                        required
                      />
                    </div>
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      E-posta Adresi
                    </label>
                    <div className="relative">
                      <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
                      <input
                        type="email"
                        value={authUser?.email || ''}
                        className="input-field pl-10 bg-gray-50"
                        disabled
                      />
                    </div>
                    <p className="text-xs text-gray-500 mt-1">
                      E-posta değiştirmek için destek ile iletişime geçin
                    </p>
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Telefon (İsteğe bağlı)
                    </label>
                    <div className="relative">
                      <Phone className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
                      <input
                        type="tel"
                        value={profileData.phone}
                        onChange={(e) => setProfileData({ ...profileData, phone: e.target.value })}
                        className="input-field pl-10"
                        placeholder="05XX XXX XX XX"
                      />
                    </div>
                  </div>
                  
                  <div className="flex items-end">
                    <button 
                      type="submit" 
                      className="btn-primary w-full"
                      disabled={isSaving}
                    >
                      {isSaving ? 'Kaydediliyor...' : 'Değişiklikleri Kaydet'}
                    </button>
                  </div>
                </div>
              </form>
            </div>

            <div className="border-t pt-6">
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Güvenlik
              </h3>
              <div className="space-y-4">
                <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                  <div className="flex items-center space-x-3">
                    <Shield className="h-5 w-5 text-gray-600" />
                    <div>
                      <p className="font-medium text-gray-900">Şifre</p>
                      <p className="text-sm text-gray-600">Hesap güvenliğinizi koruyun</p>
                    </div>
                  </div>
                  <button 
                    onClick={() => setShowPasswordModal(true)}
                    className="btn-secondary"
                  >
                    Şifre Değiştir
                  </button>
                </div>
                
                <div className="flex items-center justify-between p-4 bg-green-50 rounded-lg border border-green-200">
                  <div className="flex items-center space-x-3">
                    <Mail className="h-5 w-5 text-green-600" />
                    <div>
                      <p className="font-medium text-gray-900">E-posta Doğrulaması</p>
                      <p className="text-sm text-green-600">✓ Doğrulandı</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        );

      case 'subscription':
        return (
          <div className="space-y-6 animate-fade-in">
            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Mevcut Plan
              </h3>
              <div className={`bg-gradient-to-r ${getPlanColor(subscription.currentPlan)} rounded-lg p-6 text-white`}>
                <div className="flex items-start justify-between">
                  <div>
                    <div className="flex items-center gap-2 mb-2">
                      {getPlanIcon(subscription.currentPlan)}
                      <h4 className="text-2xl font-bold">
                        {subscription.planConfig?.name} Plan
                      </h4>
                    </div>
                    <p className="text-white/90 mb-4">
                      {subscription.planConfig?.description}
                    </p>
                    
                    {subscription.subscription?.subscriptionEndDate && (
                      <div className="flex items-center space-x-4 text-sm">
                        <div className="flex items-center">
                          <Calendar className="h-4 w-4 mr-1" />
                          <span>
                            Bitiş: {new Date(subscription.subscription.subscriptionEndDate).toLocaleDateString('tr-TR')}
                          </span>
                        </div>
                        {subscription.subscription?.status === 'active' && (
                          <span className="bg-white/20 px-2 py-1 rounded-full">
                            ✓ Aktif
                          </span>
                        )}
                        {subscription.subscription?.status === 'cancelled' && (
                          <span className="bg-red-500/80 px-2 py-1 rounded-full text-xs">
                            ⚠ İptal Edildi (Dönem sonuna kadar kullanılabilir)
                          </span>
                        )}
                      </div>
                    )}
                  </div>
                  
                  <div className="text-right">
                    <div className="text-3xl font-bold">
                      {subscription.planConfig?.price.monthly > 0 ? `₺${subscription.planConfig.price.monthly}` : 'Ücretsiz'}
                    </div>
                    {subscription.planConfig?.price.monthly > 0 && (
                      <div className="text-white/80 text-sm">/ ay</div>
                    )}
                  </div>
                </div>
              </div>
            </div>

            {/* Upgrade Options */}
            {subscription.currentPlan !== 'premium' && (
              <div>
                <h3 className="text-lg font-medium text-gray-900 mb-4">
                  Plan Değiştir
                </h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  {subscription.currentPlan === 'free' && (
                    <>
                      <div className="border-2 border-primary-200 bg-primary-50 rounded-lg p-4">
                        <div className="flex items-center gap-2 mb-2">
                          <Zap className="h-5 w-5 text-primary-600" />
                          <h4 className="font-medium text-gray-900">{PLAN_CONFIGS.pro.name}</h4>
                        </div>
                        <p className="text-gray-600 text-sm mb-3">
                          Aylık {PLAN_CONFIGS.pro.limits.invitationsPerMonth} davetiye, tüm PRO şablonlar
                        </p>
                        <p className="text-2xl font-bold text-gray-900 mb-3">
                          ₺{PLAN_CONFIGS.pro.price.monthly}/ay
                        </p>
                        <button 
                          onClick={() => navigate('/pricing')}
                          className="btn-primary w-full"
                        >
                          PRO'ya Yükselt
                        </button>
                      </div>
                      
                      <div className="border-2 border-purple-200 bg-purple-50 rounded-lg p-4">
                        <div className="flex items-center gap-2 mb-2">
                          <Crown className="h-5 w-5 text-purple-600" />
                          <h4 className="font-medium text-gray-900">{PLAN_CONFIGS.premium.name}</h4>
                        </div>
                        <p className="text-gray-600 text-sm mb-3">Sınırsız davetiye, QR Media, AI tasarım</p>
                        <p className="text-2xl font-bold text-gray-900 mb-3">
                          ₺{PLAN_CONFIGS.premium.price.monthly}/ay
                        </p>
                        <button 
                          onClick={() => navigate('/pricing')}
                          className="w-full bg-gradient-to-r from-purple-600 to-pink-600 text-white font-medium px-4 py-2 rounded-lg hover:opacity-90 transition-opacity"
                        >
                          PREMIUM'a Yükselt
                        </button>
                      </div>
                    </>
                  )}
                  
                  {subscription.currentPlan === 'pro' && (
                    <div className="border-2 border-purple-200 bg-purple-50 rounded-lg p-4">
                      <div className="flex items-center gap-2 mb-2">
                        <Crown className="h-5 w-5 text-purple-600" />
                        <h4 className="font-medium text-gray-900">{PLAN_CONFIGS.premium.name}</h4>
                      </div>
                      <p className="text-gray-600 text-sm mb-3">
                        Sınırsız davetiye, QR Media, AI tasarım, Gelişmiş analitik
                      </p>
                      <p className="text-2xl font-bold text-gray-900 mb-3">
                        ₺{PLAN_CONFIGS.premium.price.monthly}/ay
                      </p>
                      <button 
                        onClick={() => navigate('/pricing')}
                        className="w-full bg-gradient-to-r from-purple-600 to-pink-600 text-white font-medium px-4 py-2 rounded-lg hover:opacity-90 transition-opacity"
                      >
                        PREMIUM'a Yükselt
                      </button>
                    </div>
                  )}
                </div>
              </div>
            )}

            {/* Cancel Subscription */}
            {subscription.currentPlan !== 'free' && subscription.subscription?.status === 'active' && (
              <div className="bg-red-50 border border-red-200 rounded-lg p-4">
                <h4 className="font-medium text-red-900 mb-2">Aboneliği İptal Et</h4>
                <p className="text-red-700 text-sm mb-3">
                  {(() => {
                    const refundInfo = subscription.canCancelWithRefund();
                    return refundInfo.canRefund ? (
                      <>
                        ✅ <strong>{refundInfo.daysLeft} gün içinde</strong> iptal ederseniz <strong>ücret iadesi</strong> alırsınız. 
                        Aboneliğinizi iptal ederseniz, mevcut dönemin sonuna kadar kullanmaya devam edebilirsiniz.
                      </>
                    ) : (
                      <>
                        Aboneliğinizi iptal ederseniz, mevcut dönemin sonuna kadar kullanmaya devam edebilirsiniz. 
                        3 günlük iade süresi geçtiği için iade yapılmayacaktır.
                      </>
                    );
                  })()}
                </p>
                <button 
                  onClick={() => setShowCancelDialog(true)}
                  className="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg text-sm transition-colors"
                >
                  Aboneliği İptal Et
                </button>
              </div>
            )}
          </div>
        );

      case 'payments':
        return (
          <div className="space-y-6 animate-fade-in">
            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Ödeme Geçmişi
              </h3>
              
              {loadingPayments ? (
                <div className="flex items-center justify-center py-12">
                  <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
                </div>
              ) : paymentHistory.length === 0 ? (
                <div className="text-center py-12 bg-gray-50 rounded-lg">
                  <FileText className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                  <p className="text-gray-600 mb-2">Henüz ödeme geçmişiniz yok</p>
                  <p className="text-sm text-gray-500 mb-4">
                    Premium özelliklerden faydalanmak için bir plan seçin
                  </p>
                  <button
                    onClick={() => navigate('/pricing')}
                    className="btn-primary"
                  >
                    Planları Görüntüle
                  </button>
                </div>
              ) : (
                <div className="bg-white rounded-lg shadow overflow-hidden">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          Tarih
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          Plan
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          Tutar
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          Durum
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                          İşlem No
                        </th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {paymentHistory.map((payment) => (
                        <tr key={payment.id} className="hover:bg-gray-50">
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            {new Date(payment.processedAt).toLocaleDateString('tr-TR', {
                              year: 'numeric',
                              month: 'long',
                              day: 'numeric',
                              hour: '2-digit',
                              minute: '2-digit',
                            })}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap">
                            <div className="flex items-center">
                              {payment.planTier === 'premium' ? (
                                <Crown className="h-4 w-4 text-purple-600 mr-2" />
                              ) : (
                                <Zap className="h-4 w-4 text-primary-600 mr-2" />
                              )}
                              <span className="text-sm font-medium text-gray-900">
                                {payment.planTier.toUpperCase()}
                              </span>
                              <span className="ml-2 text-xs text-gray-500">
                                ({payment.billingPeriod === 'monthly' ? 'Aylık' : 'Yıllık'})
                              </span>
                            </div>
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                            ₺{payment.amount.toFixed(2)}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap">
                            {payment.status === 'SUCCESS' ? (
                              <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                ✓ Başarılı
                              </span>
                            ) : payment.status === 'FAILURE' ? (
                              <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                ✗ Başarısız
                              </span>
                            ) : payment.status === 'PENDING' ? (
                              <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                ⏳ Beklemede
                              </span>
                            ) : (
                              <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                {payment.status}
                              </span>
                            )}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-500 font-mono">
                            {payment.transactionId}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>

            {/* Payment Summary */}
            {paymentHistory.length > 0 && (
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="bg-white rounded-lg shadow p-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-sm text-gray-600">Toplam Ödeme</p>
                      <p className="text-2xl font-bold text-gray-900">
                        {paymentHistory.length}
                      </p>
                    </div>
                    <FileText className="h-8 w-8 text-gray-400" />
                  </div>
                </div>
                
                <div className="bg-white rounded-lg shadow p-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-sm text-gray-600">Başarılı</p>
                      <p className="text-2xl font-bold text-green-600">
                        {paymentHistory.filter((p) => p.status === 'SUCCESS').length}
                      </p>
                    </div>
                    <div className="h-8 w-8 rounded-full bg-green-100 flex items-center justify-center">
                      <span className="text-green-600 text-lg">✓</span>
                    </div>
                  </div>
                </div>
                
                <div className="bg-white rounded-lg shadow p-4">
                  <div className="flex items-center justify-center">
                    <div>
                      <p className="text-sm text-gray-600">Toplam Harcama</p>
                      <p className="text-2xl font-bold text-primary-600">
                        ₺{paymentHistory
                          .filter((p) => p.status === 'SUCCESS')
                          .reduce((sum, p) => sum + p.amount, 0)
                          .toFixed(2)}
                      </p>
                    </div>
                    <CreditCard className="h-8 w-8 text-gray-400 ml-4" />
                  </div>
                </div>
              </div>
            )}
          </div>
        );

      case 'usage':
        return (
          <div className="space-y-6 animate-fade-in">
            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Kullanım İstatistikleri
              </h3>
              
              {/* Stats Grid */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-6">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-blue-800 font-medium">Davetiyeler</p>
                      <p className="text-3xl font-bold text-blue-900 mt-2">{usageStats.invitationCount}</p>
                    </div>
                    <FileText className="h-10 w-10 text-blue-600" />
                  </div>
                  <p className="text-sm text-blue-700 mt-2">
                    {subscription.planConfig?.limits.invitationsPerMonth === 'unlimited' ? (
                      '/ ∞ sınırsız'
                    ) : subscription.planConfig?.limits.invitationsPerMonth === 0 ? (
                      // FREE plan - lifetime limit göster
                      `/ ${subscription.planConfig?.limits.invitationsLifetime || 1} limit (toplam)`
                    ) : (
                      // PRO plan - monthly limit göster
                      `/ ${subscription.planConfig?.limits.invitationsPerMonth} limit (aylık)`
                    )}
                  </p>
                </div>
                
                <div className="bg-green-50 border border-green-200 rounded-lg p-6">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-green-800 font-medium">Toplam Misafir</p>
                      <p className="text-3xl font-bold text-green-900 mt-2">{usageStats.totalGuests}</p>
                    </div>
                    <Users className="h-10 w-10 text-green-600" />
                  </div>
                  <p className="text-sm text-green-700 mt-2">
                    Tüm davetiyelerinizde
                  </p>
                </div>
                
                <div className="bg-purple-50 border border-purple-200 rounded-lg p-6">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-purple-800 font-medium">Depolama</p>
                      <p className="text-3xl font-bold text-purple-900 mt-2">
                        {formatFileSize(usageStats.storageUsed * 1024 * 1024)}
                      </p>
                    </div>
                    <HardDrive className="h-10 w-10 text-purple-600" />
                  </div>
                  <p className="text-sm text-purple-700 mt-2">
                    / {subscription.planConfig?.limits.storageMB}MB limit
                  </p>
                </div>
              </div>

              {/* Storage Progress Bar */}
              <div className="bg-white border border-gray-200 rounded-lg p-6">
                <div className="flex items-center justify-between mb-2">
                  <h4 className="font-medium text-gray-900">Depolama Kullanımı</h4>
                  <span className="text-sm text-gray-600">
                    {Math.round((usageStats.storageUsed / (subscription.planConfig?.limits.storageMB || 1)) * 100)}%
                  </span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
                  <div
                    className="bg-gradient-to-r from-primary-600 to-blue-600 h-3 rounded-full transition-all duration-500"
                    style={{
                      width: `${Math.min((usageStats.storageUsed / (subscription.planConfig?.limits.storageMB || 1)) * 100, 100)}%`
                    }}
                  />
                </div>
                <p className="text-xs text-gray-500 mt-1">
                  {formatFileSize(usageStats.storageUsed * 1024 * 1024)} / {subscription.planConfig?.limits.storageMB}MB kullanıldı
                </p>
              </div>
            </div>
          </div>
        );

      case 'settings':
        return (
          <div className="space-y-6 animate-fade-in">
            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Bildirim Tercihleri
              </h3>
              <div className="space-y-4">
                {[
                  { id: 'email_updates', label: 'E-posta güncellemeleri', description: 'Yeni şablonlar ve özellikler hakkında bilgi al', enabled: true },
                  { id: 'rsvp_notifications', label: 'RSVP bildirimleri', description: 'Yeni katılım yanıtlarında e-posta al', enabled: true },
                  { id: 'marketing', label: 'Pazarlama e-postaları', description: 'Özel teklifler ve kampanyalar', enabled: false },
                  { id: 'monthly_summary', label: 'Aylık özet', description: 'Kullanım istatistiklerin ve başarıların özeti', enabled: true },
                ].map((setting) => (
                  <div key={setting.id} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                    <div className="flex items-center space-x-3">
                      <Bell className="h-5 w-5 text-gray-600" />
                      <div>
                        <p className="font-medium text-gray-900">{setting.label}</p>
                        <p className="text-sm text-gray-600">{setting.description}</p>
                      </div>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        defaultChecked={setting.enabled}
                        className="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
                      />
                    </div>
                  </div>
                ))}
              </div>
            </div>

            <div className="border-t pt-6">
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Dil ve Bölge
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Dil
                  </label>
                  <select className="input-field">
                    <option>Türkçe</option>
                    <option>English</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Saat Dilimi
                  </label>
                  <select className="input-field">
                    <option>Turkey (GMT+3)</option>
                    <option>UTC (GMT+0)</option>
                  </select>
                </div>
              </div>
            </div>
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">
            Hesap Ayarları
          </h1>
          <p className="text-gray-600 mt-2">
            Profil bilgilerinizi ve hesap ayarlarınızı yönetin
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          {/* Sidebar */}
          <div className="lg:col-span-1">
            <nav className="space-y-2 sticky top-4">
              {tabs.map((tab) => (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`w-full flex items-center space-x-3 px-4 py-3 text-left rounded-lg transition-colors touch-target ${
                    activeTab === tab.id
                      ? 'bg-primary-100 text-primary-700 border-l-4 border-primary-500'
                      : 'text-gray-700 hover:bg-gray-100'
                  }`}
                >
                  {tab.icon}
                  <span className="font-medium">{tab.name}</span>
                </button>
              ))}
            </nav>
          </div>

          {/* Content */}
          <div className="lg:col-span-3">
            <div className="bg-white rounded-lg shadow p-6 sm:p-8">
              {renderTabContent()}
            </div>
          </div>
        </div>
      </div>

      {/* Password Change Modal */}
      {showPasswordModal && (
        <div className="fixed inset-0 z-50 overflow-y-auto">
          <div 
            className="fixed inset-0 bg-black bg-opacity-50 transition-opacity"
            onClick={() => setShowPasswordModal(false)}
          />
          <div className="flex min-h-full items-center justify-center p-4">
            <div className="relative bg-white rounded-lg shadow-xl max-w-md w-full p-6 animate-fade-in">
              <button
                onClick={() => setShowPasswordModal(false)}
                className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
              >
                <X className="h-5 w-5" />
              </button>
              
              <div className="flex items-center gap-3 mb-6">
                <div className="bg-primary-100 p-3 rounded-full">
                  <Lock className="h-6 w-6 text-primary-600" />
                </div>
                <div>
                  <h3 className="text-lg font-semibold text-gray-900">Şifre Değiştir</h3>
                  <p className="text-sm text-gray-600">Hesap güvenliğinizi koruyun</p>
                </div>
              </div>

              <form onSubmit={handlePasswordChange} className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Mevcut Şifre
                  </label>
                  <input
                    type="password"
                    value={passwordData.currentPassword}
                    onChange={(e) => setPasswordData({ ...passwordData, currentPassword: e.target.value })}
                    className="input-field"
                    required
                    autoComplete="current-password"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Yeni Şifre
                  </label>
                  <input
                    type="password"
                    value={passwordData.newPassword}
                    onChange={(e) => setPasswordData({ ...passwordData, newPassword: e.target.value })}
                    className="input-field"
                    required
                    minLength={6}
                    autoComplete="new-password"
                  />
                  <p className="text-xs text-gray-500 mt-1">En az 6 karakter</p>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Yeni Şifre (Tekrar)
                  </label>
                  <input
                    type="password"
                    value={passwordData.confirmPassword}
                    onChange={(e) => setPasswordData({ ...passwordData, confirmPassword: e.target.value })}
                    className="input-field"
                    required
                    autoComplete="new-password"
                  />
                </div>

                <div className="flex gap-3 pt-4">
                  <button
                    type="button"
                    onClick={() => setShowPasswordModal(false)}
                    className="flex-1 btn-outline"
                    disabled={isSaving}
                  >
                    İptal
                  </button>
                  <button
                    type="submit"
                    className="flex-1 btn-primary"
                    disabled={isSaving}
                  >
                    {isSaving ? 'Kaydediliyor...' : 'Şifreyi Değiştir'}
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}

      {/* Cancel Subscription Confirmation */}
      <ConfirmDialog
        isOpen={showCancelDialog}
        onClose={() => setShowCancelDialog(false)}
        onConfirm={handleCancelSubscription}
        title="Aboneliği İptal Et"
        message={(() => {
          const refundInfo = subscription.canCancelWithRefund();
          return refundInfo.canRefund
            ? `${subscription.planConfig?.name} aboneliğinizi iptal etmek istediğinize emin misiniz? ${refundInfo.daysLeft} gün içinde iptal ettiğiniz için ücret iadesi alacaksınız.`
            : `${subscription.planConfig?.name} aboneliğinizi iptal etmek istediğinize emin misiniz? Mevcut dönemin sonuna kadar kullanmaya devam edebilirsiniz. 3 günlük iade süresi geçtiği için iade yapılmayacaktır.`;
        })()}
        confirmText="Evet, İptal Et"
        cancelText="Vazgeç"
        type="warning"
        isLoading={isCancelling}
      />
    </div>
  );
};

export default AccountPage;
