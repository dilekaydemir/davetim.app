import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Plus, Calendar, Download, Share2, Edit, Trash2, Eye } from 'lucide-react';

const DashboardPage: React.FC = () => {
  const navigate = useNavigate();

  // Mock user data - will be replaced with real data from store
  const user = {
    name: 'Demo Kullanıcı',
    email: 'demo@davetim.com',
    plan: 'free',
    usage: {
      downloads: 2,
      maxDownloads: 3,
      invitations: 4
    }
  };

  // Mock invitations data - will be replaced with API call
  const invitations = [
    {
      id: 1,
      title: 'Sevgi & Ahmet Düğün',
      template: 'Altın Düğün',
      eventDate: '2025-06-15',
      status: 'completed',
      downloads: 15,
      lastDownload: '2025-09-20',
      createdAt: '2025-09-10'
    },
    {
      id: 2,
      title: 'Elif\'in Doğum Günü',
      template: 'Renkli Parti',
      eventDate: '2025-10-05',
      status: 'draft',
      downloads: 0,
      lastDownload: null,
      createdAt: '2025-09-25'
    },
    {
      id: 3,
      title: 'Baby Shower Partisi',
      template: 'Pastel Bebek',
      eventDate: '2025-11-12',
      status: 'completed',
      downloads: 8,
      lastDownload: '2025-09-28',
      createdAt: '2025-09-15'
    }
  ];

  const handleCreateNew = () => {
    navigate('/templates');
  };

  const handleEditInvitation = (id: number) => {
    navigate(`/editor/${id}`);
  };

  const handleDeleteInvitation = (id: number) => {
    // TODO: Implement delete functionality
    if (confirm('Bu davetiyeyi silmek istediğinizden emin misiniz?')) {
      console.log('Deleting invitation:', id);
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'completed':
        return <span className="px-2 py-1 text-xs font-medium bg-green-100 text-green-800 rounded-full">Hazır</span>;
      case 'draft':
        return <span className="px-2 py-1 text-xs font-medium bg-yellow-100 text-yellow-800 rounded-full">Taslak</span>;
      default:
        return <span className="px-2 py-1 text-xs font-medium bg-gray-100 text-gray-800 rounded-full">Bilinmiyor</span>;
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">
            Hoş geldiniz, {user.name}!
          </h1>
          <p className="text-gray-600 mt-2">
            Davetiyelerinizi yönetin ve yenilerini oluşturun
          </p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Toplam Davetiye</p>
                <p className="text-2xl font-bold text-gray-900">{user.usage.invitations}</p>
              </div>
              <div className="bg-primary-100 p-3 rounded-full">
                <Calendar className="h-6 w-6 text-primary-600" />
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Bu Ay İndirme</p>
                <p className="text-2xl font-bold text-gray-900">
                  {user.usage.downloads}/{user.usage.maxDownloads}
                </p>
              </div>
              <div className="bg-blue-100 p-3 rounded-full">
                <Download className="h-6 w-6 text-blue-600" />
              </div>
            </div>
            <div className="mt-2">
              <div className="bg-gray-200 rounded-full h-2">
                <div
                  className="bg-blue-600 rounded-full h-2"
                  style={{ width: `${(user.usage.downloads / user.usage.maxDownloads) * 100}%` }}
                />
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600">Aktif Plan</p>
                <p className="text-2xl font-bold text-gray-900 capitalize">
                  {user.plan === 'free' ? 'Ücretsiz' : user.plan.toUpperCase()}
                </p>
              </div>
              <div className="bg-green-100 p-3 rounded-full">
                <Share2 className="h-6 w-6 text-green-600" />
              </div>
            </div>
            {user.plan === 'free' && (
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
        {invitations.length > 0 ? (
          <div className="bg-white shadow rounded-lg overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-200">
              <h3 className="text-lg font-medium text-gray-900">Son Davetiyeler</h3>
            </div>
            <div className="divide-y divide-gray-200">
              {invitations.map((invitation) => (
                <div key={invitation.id} className="px-6 py-4 hover:bg-gray-50">
                  <div className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="flex items-center space-x-4">
                        <div className="flex-1">
                          <h4 className="text-lg font-medium text-gray-900">
                            {invitation.title}
                          </h4>
                          <div className="flex items-center space-x-4 mt-1">
                            <span className="text-sm text-gray-500">
                              Şablon: {invitation.template}
                            </span>
                            <span className="text-sm text-gray-500">
                              Tarih: {new Date(invitation.eventDate).toLocaleDateString('tr-TR')}
                            </span>
                            <span className="text-sm text-gray-500">
                              {invitation.downloads} indirme
                            </span>
                          </div>
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
        ) : (
          /* Empty State */
          <div className="text-center py-12">
            <Calendar className="h-24 w-24 text-gray-300 mx-auto mb-4" />
            <h3 className="text-xl font-medium text-gray-900 mb-2">
              Henüz davetiye oluşturmadınız
            </h3>
            <p className="text-gray-600 mb-6">
              İlk davetiyenizi oluşturmak için başlayın
            </p>
            <button
              onClick={handleCreateNew}
              className="btn-primary flex items-center gap-2 mx-auto"
            >
              <Plus className="h-5 w-5" />
              İlk Davetiyemi Oluştur
            </button>
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
    </div>
  );
};

export default DashboardPage;
