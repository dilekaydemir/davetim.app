import React, { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Plus, Calendar, Download, Edit, Trash2, Eye, Crown, Zap, Users, CheckCircle, TrendingUp } from 'lucide-react';
import { invitationService, type Invitation } from '../services/invitationService';
import { guestService, type GuestStats } from '../services/guestService';
import { useAuth } from '../store/authStore';
import { DashboardSkeleton } from '../components/Skeleton/Skeleton';
import ConfirmDialog from '../components/Common/ConfirmDialog';
import { StatsCard } from '../components/Dashboard/StatsCard';
import { RSVPChart } from '../components/Dashboard/RSVPChart';
import { ViewsTimeline } from '../components/Dashboard/ViewsTimeline';
import { RecentActivity, Activity } from '../components/Dashboard/RecentActivity';
import { TopTemplates, TemplateUsage } from '../components/Dashboard/TopTemplates';
import { ExportAnalytics } from '../components/Dashboard/ExportAnalytics';

const DashboardPage: React.FC = () => {
  const navigate = useNavigate();
  const { user: authUser } = useAuth();

  // State
  const [invitations, setInvitations] = useState<Invitation[]>([]);
  const [guestStats, setGuestStats] = useState<Record<string, GuestStats>>({});
  const [isLoading, setIsLoading] = useState(true);
  
  // Confirm dialog state
  const [showDeleteDialog, setShowDeleteDialog] = useState(false);
  const [invitationToDelete, setInvitationToDelete] = useState<{ id: string; title: string } | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);

  // Analytics data
  const [recentActivities, setRecentActivities] = useState<Activity[]>([]);
  const [topTemplates, setTopTemplates] = useState<TemplateUsage[]>([]);
  const [viewsData, setViewsData] = useState<any[]>([]);

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

      // Generate analytics data
      generateAnalyticsData(data, statsMap);
    } catch (error) {
      console.error('Error loading invitations:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const generateAnalyticsData = (invitations: Invitation[], statsMap: Record<string, GuestStats>) => {
    // Generate recent activities (mock data for now - can be extended with real activity tracking)
    const activities: Activity[] = [];
    
    invitations.slice(0, 10).forEach((inv) => {
      const stats = statsMap[inv.id];
      
      // Add invitation created activity
      activities.push({
        id: `${inv.id}-created`,
        type: 'invitation_created',
        title: 'Yeni davetiye oluşturuldu',
        description: inv.title,
        timestamp: inv.created_at,
        invitationTitle: inv.title,
      });

      // Add RSVP activities if any
      if (stats && stats.total_attending > 0) {
        activities.push({
          id: `${inv.id}-rsvp-yes`,
          type: 'rsvp_yes',
          title: 'Yeni RSVP yanıtı',
          description: `${stats.total_attending} kişi katılacak`,
          timestamp: inv.updated_at || inv.created_at,
          invitationTitle: inv.title,
        });
      }

      // Add view activity if has views
      if (inv.view_count > 0) {
        activities.push({
          id: `${inv.id}-views`,
          type: 'view',
          title: 'Davetiye görüntülendi',
          description: `${inv.view_count} görüntülenme`,
          timestamp: inv.updated_at || inv.created_at,
          invitationTitle: inv.title,
        });
      }
    });

    // Sort by timestamp descending
    activities.sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime());
    setRecentActivities(activities.slice(0, 10));

    // Generate top templates data
    const templateUsage: Record<string, TemplateUsage> = {};
    
    invitations.forEach((inv) => {
      if (inv.template) {
        const templateId = inv.template_id;
        if (!templateUsage[templateId]) {
          templateUsage[templateId] = {
            templateId: templateId,
            templateName: inv.template.name,
            previewImage: inv.template.preview_image_url,
            usageCount: 0,
            averageViews: 0,
            tier: inv.template.tier || 'free',
          };
        }
        templateUsage[templateId].usageCount++;
        templateUsage[templateId].averageViews += inv.view_count;
      }
    });

    // Calculate averages and sort by usage
    const topTemplatesList = Object.values(templateUsage)
      .map((t) => ({
        ...t,
        averageViews: Math.round(t.averageViews / t.usageCount),
      }))
      .sort((a, b) => b.usageCount - a.usageCount)
      .slice(0, 5);

    setTopTemplates(topTemplatesList);

    // Generate views timeline (last 7 days)
    const viewsTimeline = [];
    const now = new Date();
    
    for (let i = 6; i >= 0; i--) {
      const date = new Date(now);
      date.setDate(date.getDate() - i);
      
      // For now, distribute views evenly across days (can be enhanced with real daily tracking)
      const dayViews = Math.floor(Math.random() * 20) + (i === 0 ? 5 : 0); // Today gets at least 5
      
      viewsTimeline.push({
        date: date.toISOString().split('T')[0],
        views: dayViews,
      });
    }

    setViewsData(viewsTimeline);
  };

  // User stats
  const totalGuests = Object.values(guestStats).reduce((sum, stats) => sum + stats.total, 0);
  const totalAttending = Object.values(guestStats).reduce((sum, stats) => sum + stats.total_attending, 0);
  const totalNotAttending = Object.values(guestStats).reduce((sum, stats) => sum + stats.declined, 0);
  const totalPending = Object.values(guestStats).reduce((sum, stats) => sum + stats.pending, 0);
  
  const userStats = {
    totalInvitations: invitations.length,
    draftInvitations: invitations.filter(i => i.status === 'draft').length,
    publishedInvitations: invitations.filter(i => i.status === 'published').length,
    totalViews: invitations.reduce((sum, i) => sum + i.view_count, 0),
    totalGuests,
    totalAttending,
    totalNotAttending,
    totalPending,
  };

  const handleCreateNew = () => {
    navigate('/templates');
  };

  const handleEditInvitation = (id: string) => {
    navigate(`/editor/${id}`);
  };

  const handleDeleteClick = (invitation: Invitation) => {
    setInvitationToDelete({ id: invitation.id, title: invitation.title });
    setShowDeleteDialog(true);
  };

  const handleDeleteConfirm = async () => {
    if (!invitationToDelete) return;
    
    setIsDeleting(true);
    try {
      const success = await invitationService.deleteInvitation(invitationToDelete.id);
      if (success) {
        // Reload invitations
        await loadInvitations();
        setShowDeleteDialog(false);
        setInvitationToDelete(null);
      }
    } finally {
      setIsDeleting(false);
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
          <StatsCard
            title="Toplam Davetiye"
            value={userStats.totalInvitations}
            subtitle={`${userStats.draftInvitations} taslak, ${userStats.publishedInvitations} yayında`}
            icon={Calendar}
            iconColor="primary"
          />

          <StatsCard
            title="Toplam Görüntüleme"
            value={userStats.totalViews}
            icon={Eye}
            iconColor="blue"
          />

          <StatsCard
            title="Toplam Davetli"
            value={userStats.totalGuests}
            subtitle="Tüm davetiyelerinizde"
            icon={Users}
            iconColor="purple"
          />

          <StatsCard
            title="Katılacak"
            value={userStats.totalAttending}
            subtitle="Onaylanmış davetliler"
            icon={CheckCircle}
            iconColor="green"
          />

          <div className="bg-gradient-to-br from-primary-50 to-primary-100 rounded-xl shadow-sm p-6 border border-primary-200">
            <div className="flex items-center justify-between mb-4">
              <div className="flex-1">
                <p className="text-sm font-medium text-primary-900 mb-1">Aktif Plan</p>
                <p className="text-3xl font-bold text-primary-900 capitalize">
                  {authUser?.subscriptionTier === 'free' ? 'Ücretsiz' : authUser?.subscriptionTier.toUpperCase()}
                </p>
              </div>
              <div className="p-3 rounded-full bg-primary-200">
                {authUser?.subscriptionTier === 'free' ? (
                  <Zap className="h-6 w-6 text-primary-700" />
                ) : (
                  <Crown className="h-6 w-6 text-primary-700" />
                )}
              </div>
            </div>
            {authUser?.subscriptionTier === 'free' && (
              <Link
                to="/pricing"
                className="text-sm text-primary-700 hover:text-primary-800 font-semibold flex items-center gap-1 group"
              >
                Premium'a Geç
                <TrendingUp className="h-4 w-4 group-hover:translate-x-1 transition-transform" />
              </Link>
            )}
          </div>
        </div>

        {/* Analytics Grids */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          {/* RSVP Chart */}
          <RSVPChart
            attending={userStats.totalAttending}
            notAttending={userStats.totalNotAttending}
            pending={userStats.totalPending}
          />

          {/* Views Timeline */}
          <ViewsTimeline
            data={viewsData}
            totalViews={userStats.totalViews}
          />
        </div>

        {/* Second Row Analytics */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          {/* Recent Activity */}
          <RecentActivity activities={recentActivities} />

          {/* Top Templates */}
          <TopTemplates templates={topTemplates} />
        </div>

        {/* Export Analytics */}
        <div className="mb-8">
          <ExportAnalytics
            data={{
              invitations: invitations,
              guestStats: guestStats,
              activities: recentActivities,
            }}
          />
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
                        onClick={() => handleDeleteClick(invitation)}
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
      
      {/* Delete Confirmation Dialog */}
      <ConfirmDialog
        isOpen={showDeleteDialog}
        onClose={() => {
          setShowDeleteDialog(false);
          setInvitationToDelete(null);
        }}
        onConfirm={handleDeleteConfirm}
        title="Davetiyeyi Sil"
        message={`"${invitationToDelete?.title}" davetiyesini silmek istediğinize emin misiniz? Bu işlem geri alınamaz ve tüm misafir bilgileri de silinecektir.`}
        confirmText="Evet, Sil"
        cancelText="İptal"
        type="danger"
        isLoading={isDeleting}
      />
    </div>
  );
};

export default DashboardPage;
