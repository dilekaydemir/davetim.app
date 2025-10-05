import React, { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Plus, Calendar, Download, Share2, Edit, Trash2, Eye, Loader2, Crown, Zap } from 'lucide-react';
import { invitationService, type Invitation } from '../services/invitationService';
import { guestService, type GuestStats } from '../services/guestService';
import { useAuth } from '../store/authStore';
import { useSubscription } from '../hooks/useSubscription';
import UpgradeModal from '../components/Subscription/UpgradeModal';
import { DashboardSkeleton } from '../components/Skeleton/Skeleton';

const DashboardPage: React.FC = () => {
  const navigate = useNavigate();
  const { user: authUser } = useAuth();
  const subscription = useSubscription();

  // State
  const [invitations, setInvitations] = useState<Invitation[]>([]);
  const [guestStats, setGuestStats] = useState<Record<string, GuestStats>>({});
  const [isLoading, setIsLoading] = useState(true);
  const [showUpgradeModal, setShowUpgradeModal] = useState(false);
  const [upgradeFeature, setUpgradeFeature] = useState({ feature: '', description: '' });

  // Load invitations
  useEffect(() => {
    loadInvitations();
  }, []);

  const loadInvitations = async () => {
    setIsLoading(true);
    try {
      const data = await invitationService.getUserInvitations();
      setInvitations(data);
      
      // Load guest stats for each invitation
      const statsPromises = data.map(async (invitation) => {
        const stats = await guestService.getGuestStats(invitation.id);
        return { invitationId: invitation.id, stats };
      });
      
      const statsResults = await Promise.all(statsPromises);
      const statsMap: Record<string, GuestStats> = {};
      statsResults.forEach(({ invitationId, stats }) => {
        statsMap[invitationId] = stats;
      });
      setGuestStats(statsMap);
    } catch (error) {
      console.error('Error loading invitations:', error);
    } finally {
      setIsLoading(false);
    }
  };

  // User stats
  const totalGuests = Object.values(guestStats).reduce((sum, stats) => sum + stats.total, 0);
  const totalAttending = Object.values(guestStats).reduce((sum, stats) => sum + stats.total_attending, 0);
  
  const userStats = {
    totalInvitations: invitations.length,
    draftInvitations: invitations.filter(i => i.status === 'draft').length,
    publishedInvitations: invitations.filter(i => i.status === 'published').length,
    totalViews: invitations.reduce((sum, i) => sum + i.view_count, 0),
    totalGuests,
    totalAttending,
  };

  const handleCreateNew = () => {
    navigate('/templates');
  };

  const handleNewInvitation = async () => {
    // Plan limitini kontrol et
    const access = await subscription.canCreateInvitation();
    
    if (!access.allowed) {
      // Limit aşıldı - upgrade modal göster
      setUpgradeFeature({
        feature: 'create_invitation',
        description: access.reason || 'Yeni davetiye oluşturabilmek için planınızı yükseltin!'
      });
      setShowUpgradeModal(true);
      return;
    }
    
    // Limit OK - editor'a git
    navigate('/editor');
  };

  const handleEditInvitation = (id: string) => {
    navigate(`/editor/${id}`);
  };

  const handleDeleteInvitation = async (id: string) => {
    if (confirm('Bu davetiyeyi silmek istediğinizden emin misiniz?')) {
      const success = await invitationService.deleteInvitation(id);
      if (success) {
        // Reload invitations
        loadInvitations();
      }
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'published':
        return <span className="px-2 py-1 text-xs font-medium bg-green-100 text-green-800 rounded-full">✓ Yayında</span>;
      case 'draft':
        return <span className="px-2 py-1 text-xs font-medium bg-yellow-100 text-yellow-800 rounded-full">📝 Taslak</span>;
      case 'archived':
        return <span className="px-2 py-1 text-xs font-medium bg-gray-100 text-gray-800 rounded-full">🗄️ Arşivlendi</span>;
      default:
        return <span className="px-2 py-1 text-xs font-medium bg-gray-100 text-gray-800 rounded-full">Bilinmiyor</span>;
    }
  };

  // Show skeleton while loading
  if (isLoading) {
    return <DashboardSkeleton />;
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">
            Hoş geldiniz, {authUser?.fullName || 'Kullanıcı'}!
          </h1>
          <p className="text-gray-600 mt-2">
            Davetiyelerinizi yönetin ve yenilerini oluşturun
          </p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6 mb-8">
          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Toplam Davetiye</p>
                <p className="text-2xl font-bold text-gray-900">{userStats.totalInvitations}</p>
              </div>
              <div className="bg-primary-100 p-3 rounded-full">
                <Calendar className="h-6 w-6 text-primary-600" />
              </div>
            </div>
            <p className="text-xs text-gray-500 mt-2">
              {userStats.draftInvitations} taslak, {userStats.publishedInvitations} yayında
            </p>
          </div>

          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Toplam Görüntüleme</p>
                <p className="text-2xl font-bold text-gray-900">
                  {userStats.totalViews}
                </p>
              </div>
              <div className="bg-blue-100 p-3 rounded-full">
                <Eye className="h-6 w-6 text-blue-600" />
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Toplam Davetli</p>
                <p className="text-2xl font-bold text-gray-900">{userStats.totalGuests}</p>
              </div>
              <div className="bg-purple-100 p-3 rounded-full">
                <Plus className="h-6 w-6 text-purple-600" />
              </div>
            </div>
            <p className="text-xs text-gray-500 mt-2">
              Tüm davetiyelerinizde
            </p>
          </div>

          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Katılımcı</p>
                <p className="text-2xl font-bold text-gray-900">{userStats.totalAttending}</p>
              </div>
              <div className="bg-green-100 p-3 rounded-full">
                <Share2 className="h-6 w-6 text-green-600" />
              </div>
            </div>
            <p className="text-xs text-gray-500 mt-2">
              Davetli + Refakatçi
            </p>
          </div>

          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Aktif Plan</p>
                <p className="text-2xl font-bold text-gray-900 capitalize">
                  {authUser?.subscriptionTier === 'free' ? 'Ücretsiz' : authUser?.subscriptionTier.toUpperCase()}
                </p>
              </div>
              <div className="bg-orange-100 p-3 rounded-full">
                <Calendar className="h-6 w-6 text-orange-600" />
              </div>
            </div>
            {authUser?.subscriptionTier === 'free' && (
              <Link
                to="/pricing"
                className="text-sm text-primary-600 hover:text-primary-700 font-medium mt-2 inline-block"
              >
                Yükselt →
              </Link>
            )}
          </div>
        </div>

        {/* Action Bar */}
        <div className="flex flex-col sm:flex-row justify-between items-center mb-6">
          <h2 className="text-xl font-semibold text-gray-900 mb-4 sm:mb-0">
            Davetiyelerim
          </h2>
          <button
            onClick={handleCreateNew}
            className="btn-primary flex items-center gap-2"
          >
            <Plus className="h-5 w-5" />
            Yeni Davetiye
          </button>
        </div>

        {/* Invitations List */}
        {invitations.length > 0 && (
          <div className="bg-white shadow rounded-lg overflow-hidden animate-fade-in">
            <div className="px-6 py-4 border-b border-gray-200">
              <h3 className="text-lg font-medium text-gray-900">Son Davetiyeler</h3>
            </div>
            <div className="divide-y divide-gray-200">
              {invitations.map((invitation, index) => (
                <div 
                  key={invitation.id} 
                  className="px-6 py-4 hover:bg-gray-50 transition-colors"
                  style={{ animationDelay: `${index * 50}ms` }}
                >
                  <div className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="flex items-center space-x-4">
                        <div className="flex-1">
                          <h4 className="text-lg font-medium text-gray-900">
                            {invitation.title}
                          </h4>
                          <div className="flex items-center space-x-4 mt-1">
                            <span className="text-sm text-gray-500">
                              Şablon: {invitation.template?.name || 'Bilinmiyor'}
                            </span>
                            {invitation.event_date && (
                              <span className="text-sm text-gray-500">
                                Tarih: {new Date(invitation.event_date).toLocaleDateString('tr-TR')}
                              </span>
                            )}
                            <span className="text-sm text-gray-500">
                              {invitation.view_count} görüntülenme
                            </span>
                          </div>
                          
                          {/* Guest Stats */}
                          {guestStats[invitation.id] && guestStats[invitation.id].total > 0 && (
                            <div className="flex items-center gap-2 mt-2">
                              <span className="inline-flex items-center px-2 py-1 text-xs font-medium rounded-full bg-blue-100 text-blue-700">
                                👥 {guestStats[invitation.id].total} davetli
                              </span>
                              {guestStats[invitation.id].attending > 0 && (
                                <span className="inline-flex items-center px-2 py-1 text-xs font-medium rounded-full bg-green-100 text-green-700">
                                  ✓ {guestStats[invitation.id].attending} gelecek
                                </span>
                              )}
                              {guestStats[invitation.id].pending > 0 && (
                                <span className="inline-flex items-center px-2 py-1 text-xs font-medium rounded-full bg-yellow-100 text-yellow-700">
                                  ⏳ {guestStats[invitation.id].pending} bekliyor
                                </span>
                              )}
                              {guestStats[invitation.id].total_attending > guestStats[invitation.id].attending && (
                                <span className="inline-flex items-center px-2 py-1 text-xs font-medium rounded-full bg-purple-100 text-purple-700">
                                  🎉 {guestStats[invitation.id].total_attending} katılımcı
                                </span>
                              )}
                            </div>
                          )}
                        </div>
                        <div className="flex items-center space-x-3">
                          {getStatusBadge(invitation.status)}
                        </div>
                      </div>
                    </div>
                    <div className="flex items-center space-x-2 ml-4">
                      <button
                        onClick={() => handleEditInvitation(invitation.id)}
                        className="p-2 text-gray-400 hover:text-primary-600 rounded-lg hover:bg-primary-50 transition-colors"
                        title="Düzenle"
                      >
                        <Edit className="h-5 w-5" />
                      </button>
                      <button
                        className="p-2 text-gray-400 hover:text-blue-600 rounded-lg hover:bg-blue-50 transition-colors"
                        title="Önizle"
                      >
                        <Eye className="h-5 w-5" />
                      </button>
                      <button
                        className="p-2 text-gray-400 hover:text-green-600 rounded-lg hover:bg-green-50 transition-colors"
                        title="İndir"
                      >
                        <Download className="h-5 w-5" />
                      </button>
                      <button
                        onClick={() => handleDeleteInvitation(invitation.id)}
                        className="p-2 text-gray-400 hover:text-red-600 rounded-lg hover:bg-red-50 transition-colors"
                        title="Sil"
                      >
                        <Trash2 className="h-5 w-5" />
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Empty State */}
        {!isLoading && invitations.length === 0 && (
          <div className="bg-white shadow rounded-lg p-12 text-center animate-fade-in">
            <div className="max-w-md mx-auto">
              <div className="bg-primary-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6">
                <Calendar className="h-10 w-10 text-primary-600" />
              </div>
              <h3 className="text-2xl font-bold text-gray-900 mb-3">
                Henüz davetiye oluşturmadınız
              </h3>
              <p className="text-gray-600 mb-8">
                İlk davetiyenizi oluşturmak için şablonlarımıza göz atın ve sevdiklerinizi etkinliğinize davet edin!
              </p>
              <button
                onClick={handleCreateNew}
                className="btn-primary inline-flex items-center gap-2"
              >
                <Plus className="h-5 w-5" />
                İlk Davetiyemi Oluştur
              </button>
            </div>
          </div>
        )}

        {/* Quick Actions */}
        <div className="mt-8 grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="bg-primary-50 rounded-lg p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              Hızlı Başlangıç
            </h3>
            <p className="text-gray-600 mb-4">
              Popüler şablonlarımızla hemen davetiye oluşturmaya başlayın
            </p>
            <Link to="/templates" className="text-primary-600 hover:text-primary-700 font-medium">
              Şablonları İncele →
            </Link>
          </div>

          <div className="bg-green-50 rounded-lg p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              Premium'a Geçin
            </h3>
            <p className="text-gray-600 mb-4">
              Sınırsız indirme ve özel şablonlar için premium planı inceleyin
            </p>
            <Link to="/pricing" className="text-green-600 hover:text-green-700 font-medium">
              Planları Karşılaştır →
            </Link>
          </div>
        </div>
      </div>
      
      {/* Upgrade Modal */}
      <UpgradeModal
        isOpen={showUpgradeModal}
        onClose={() => setShowUpgradeModal(false)}
        feature={upgradeFeature.feature}
        featureDescription={upgradeFeature.description}
        currentPlan={subscription.currentPlan}
      />
    </div>
  );
};

export default DashboardPage;
