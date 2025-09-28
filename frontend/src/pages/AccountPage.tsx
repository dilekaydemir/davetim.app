import React from 'react';
import { User, Mail, Phone, CreditCard, Download, Calendar, Settings, Shield, Bell } from 'lucide-react';

const AccountPage: React.FC = () => {
  const [activeTab, setActiveTab] = React.useState('profile');

  // Mock user data
  const user = {
    fullName: 'Demo Kullanıcı',
    email: 'demo@davetim.com',
    phone: '+90 555 123 4567',
    avatar: null,
    plan: 'pro',
    subscriptionEnd: '2025-03-15',
    joinDate: '2025-01-15'
  };

  const tabs = [
    { id: 'profile', name: 'Profil', icon: <User className="h-5 w-5" /> },
    { id: 'subscription', name: 'Abonelik', icon: <CreditCard className="h-5 w-5" /> },
    { id: 'usage', name: 'Kullanım', icon: <Download className="h-5 w-5" /> },
    { id: 'settings', name: 'Ayarlar', icon: <Settings className="h-5 w-5" /> },
  ];

  const renderTabContent = () => {
    switch (activeTab) {
      case 'profile':
        return (
          <div className="space-y-6">
            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Profil Bilgileri
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Ad Soyad
                  </label>
                  <div className="relative">
                    <User className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
                    <input
                      type="text"
                      defaultValue={user.fullName}
                      className="input-field pl-10"
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
                      defaultValue={user.email}
                      className="input-field pl-10"
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
                      defaultValue={user.phone}
                      className="input-field pl-10"
                    />
                  </div>
                </div>
              </div>
              <div className="mt-6">
                <button className="btn-primary">
                  Değişiklikleri Kaydet
                </button>
              </div>
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
                      <p className="text-sm text-gray-600">Son güncelleme: 2 ay önce</p>
                    </div>
                  </div>
                  <button className="btn-secondary">
                    Şifre Değiştir
                  </button>
                </div>
                <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
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
          <div className="space-y-6">
            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Mevcut Plan
              </h3>
              <div className="bg-primary-50 border border-primary-200 rounded-lg p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <h4 className="text-xl font-semibold text-gray-900 mb-2">
                      PRO Plan
                    </h4>
                    <p className="text-gray-600 mb-4">
                      Tüm premium şablonlar ve sınırsız indirme
                    </p>
                    <div className="flex items-center space-x-4 text-sm text-gray-600">
                      <span>
                        <Calendar className="h-4 w-4 inline mr-1" />
                        Bitiş: {new Date(user.subscriptionEnd).toLocaleDateString('tr-TR')}
                      </span>
                      <span className="bg-green-100 text-green-800 px-2 py-1 rounded-full">
                        Aktif
                      </span>
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="text-2xl font-bold text-gray-900">₺29</div>
                    <div className="text-gray-600">/ ay</div>
                  </div>
                </div>
              </div>
            </div>

            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Plan Değiştir
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="border border-gray-200 rounded-lg p-4">
                  <h4 className="font-medium text-gray-900 mb-2">Ücretsiz</h4>
                  <p className="text-gray-600 text-sm mb-3">Temel özellikler</p>
                  <p className="text-lg font-semibold">₺0/ay</p>
                  <button className="btn-outline w-full mt-3">
                    Düşür
                  </button>
                </div>
                <div className="border border-purple-200 bg-purple-50 rounded-lg p-4">
                  <h4 className="font-medium text-gray-900 mb-2">PREMIUM</h4>
                  <p className="text-gray-600 text-sm mb-3">Gelişmiş özellikler</p>
                  <p className="text-lg font-semibold">₺49/ay</p>
                  <button className="w-full bg-gradient-to-r from-purple-600 to-pink-600 text-white font-medium px-4 py-2 rounded-lg mt-3">
                    Yükselt
                  </button>
                </div>
              </div>
            </div>

            <div className="border-t pt-6">
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Faturalama Geçmişi
              </h3>
              <div className="space-y-3">
                {[
                  { date: '2025-01-15', amount: 29, status: 'Ödendi' },
                  { date: '2025-02-15', amount: 29, status: 'Ödendi' },
                  { date: '2025-03-15', amount: 29, status: 'Bekliyor' },
                ].map((invoice, index) => (
                  <div key={index} className="flex items-center justify-between py-3 border-b last:border-b-0">
                    <div>
                      <p className="font-medium">{new Date(invoice.date).toLocaleDateString('tr-TR')}</p>
                      <p className="text-sm text-gray-600">PRO Plan - Aylık</p>
                    </div>
                    <div className="text-right">
                      <p className="font-medium">₺{invoice.amount}</p>
                      <p className={`text-sm ${
                        invoice.status === 'Ödendi' ? 'text-green-600' : 'text-yellow-600'
                      }`}>
                        {invoice.status}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            <div className="bg-red-50 border border-red-200 rounded-lg p-4">
              <h4 className="font-medium text-red-900 mb-2">Hesabı Kapat</h4>
              <p className="text-red-700 text-sm mb-3">
                Hesabınızı kapatırsanız tüm verileriniz kalıcı olarak silinir.
              </p>
              <button className="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg text-sm">
                Hesabı Kapat
              </button>
            </div>
          </div>
        );

      case 'usage':
        return (
          <div className="space-y-6">
            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Bu Ay Kullanım
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-6">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-blue-800 font-medium">İndirmeler</p>
                      <p className="text-2xl font-bold text-blue-900">12</p>
                    </div>
                    <Download className="h-8 w-8 text-blue-600" />
                  </div>
                  <p className="text-sm text-blue-700 mt-2">Sınırsız (PRO)</p>
                </div>
                <div className="bg-green-50 border border-green-200 rounded-lg p-6">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-green-800 font-medium">Davetiyeler</p>
                      <p className="text-2xl font-bold text-green-900">8</p>
                    </div>
                    <Calendar className="h-8 w-8 text-green-600" />
                  </div>
                  <p className="text-sm text-green-700 mt-2">Oluşturuldu</p>
                </div>
                <div className="bg-purple-50 border border-purple-200 rounded-lg p-6">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-purple-800 font-medium">Şablonlar</p>
                      <p className="text-2xl font-bold text-purple-900">5</p>
                    </div>
                    <User className="h-8 w-8 text-purple-600" />
                  </div>
                  <p className="text-sm text-purple-700 mt-2">Kullanıldı</p>
                </div>
              </div>
            </div>

            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Son Aktiviteler
              </h3>
              <div className="space-y-3">
                {[
                  { action: 'PDF İndirildi', detail: 'Sevgi & Ahmet Düğünü', time: '2 saat önce' },
                  { action: 'Davetiye Oluşturuldu', detail: 'Baby Shower Partisi', time: '1 gün önce' },
                  { action: 'Şablon Kullanıldı', detail: 'Renkli Parti', time: '3 gün önce' },
                  { action: 'PDF İndirildi', detail: 'Elif\'in Doğum Günü', time: '5 gün önce' },
                ].map((activity, index) => (
                  <div key={index} className="flex items-center justify-between py-3 border-b last:border-b-0">
                    <div>
                      <p className="font-medium">{activity.action}</p>
                      <p className="text-sm text-gray-600">{activity.detail}</p>
                    </div>
                    <p className="text-sm text-gray-500">{activity.time}</p>
                  </div>
                ))}
              </div>
            </div>
          </div>
        );

      case 'settings':
        return (
          <div className="space-y-6">
            <div>
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Bildirim Tercihleri
              </h3>
              <div className="space-y-4">
                {[
                  { id: 'email_updates', label: 'E-posta güncellemeleri', description: 'Yeni şablonlar ve özellikler hakkında bilgi al', enabled: true },
                  { id: 'marketing', label: 'Pazarlama e-postaları', description: 'Özel teklifler ve kampanyalar', enabled: false },
                  { id: 'monthly_summary', label: 'Aylık özet', description: 'Kullanım istatistiklerin ve başarıların özeti', enabled: true },
                  { id: 'plan_changes', label: 'Plan değişiklikleri', description: 'Abonelik ve fatura değişiklikleri', enabled: true }
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

            <div className="border-t pt-6">
              <button className="btn-primary">
                Ayarları Kaydet
              </button>
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
            <nav className="space-y-2">
              {tabs.map((tab) => (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`w-full flex items-center space-x-3 px-4 py-3 text-left rounded-lg transition-colors ${
                    activeTab === tab.id
                      ? 'bg-primary-100 text-primary-700 border-r-2 border-primary-500'
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
            <div className="bg-white rounded-lg shadow p-8">
              {renderTabContent()}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AccountPage;
