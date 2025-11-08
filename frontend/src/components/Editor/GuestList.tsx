import React, { useState, useEffect } from 'react';
import { UserPlus, Mail, Phone, Trash2, Edit2, Link2, Check, X, Loader2, FileSpreadsheet, Download, Lock, Users } from 'lucide-react';
import { guestService, type Guest, type CreateGuestData, type GuestStats } from '../../services/guestService';
import { excelService } from '../../services/excelService';
import { useSubscription } from '../../hooks/useSubscription';
import toast from 'react-hot-toast';
import { validateName, validateEmail, validatePhone, formatPhoneNumber } from '../../utils/validation';
import ConfirmDialog from '../Common/ConfirmDialog';

interface GuestListProps {
  invitationId: string;
  invitationTitle?: string;
  invitationStatus?: 'draft' | 'published' | 'archived';
}

const GuestList: React.FC<GuestListProps> = ({ invitationId, invitationTitle = 'Davetiye', invitationStatus = 'draft' }) => {
  const subscription = useSubscription();
  
  const [guests, setGuests] = useState<Guest[]>([]);
  const [stats, setStats] = useState<GuestStats>({
    total: 0,
    pending: 0,
    attending: 0,
    declined: 0,
    total_companions: 0,
    total_attending: 0
  });
  const [isLoading, setIsLoading] = useState(true);
  const [isAddingGuest, setIsAddingGuest] = useState(false);
  const [editingGuestId, setEditingGuestId] = useState<string | null>(null);

  // Form state
  const [formData, setFormData] = useState<CreateGuestData>({
    invitation_id: invitationId,
    full_name: '',
    email: '',
    phone: '',
    companion_count: 0,
    notes: ''
  });

  // Form validation errors
  const [errors, setErrors] = useState({
    full_name: '',
    email: '',
    phone: ''
  });

  // Confirm dialog state
  const [showDeleteDialog, setShowDeleteDialog] = useState(false);
  const [guestToDelete, setGuestToDelete] = useState<{ id: string; name: string } | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);

  // Load guests
  useEffect(() => {
    loadGuests();
  }, [invitationId]);

  const loadGuests = async () => {
    try {
      setIsLoading(true);
      const guestsData = await guestService.getInvitationGuests(invitationId);
      setGuests(guestsData);
      
      // Calculate stats from guests data
      const calculatedStats: GuestStats = {
        total: guestsData.length,
        pending: guestsData.filter(g => g.rsvp_status === 'pending').length,
        attending: guestsData.filter(g => g.rsvp_status === 'attending').length,
        declined: guestsData.filter(g => g.rsvp_status === 'declined').length,
        total_companions: guestsData.reduce((sum, g) => sum + (g.companion_count || 0), 0),
        total_attending: guestsData
          .filter(g => g.rsvp_status === 'attending')
          .reduce((sum, g) => sum + 1 + (g.companion_count || 0), 0)
      };
      
      setStats(calculatedStats);
    } catch (error) {
      console.error('Error loading guests:', error);
    } finally {
      setIsLoading(false);
    }
  };

  // Validate guest form
  const validateGuestForm = (): boolean => {
    const newErrors = {
      full_name: '',
      email: '',
      phone: ''
    };

    // Name validation (required)
    const nameResult = validateName(formData.full_name, 'Ad Soyad');
    if (!nameResult.isValid) {
      newErrors.full_name = nameResult.error!;
    }

    // Email validation (optional)
    if (formData.email && formData.email.trim() !== '') {
      const emailResult = validateEmail(formData.email);
      if (!emailResult.isValid) {
        newErrors.email = emailResult.error!;
      }
    }

    // Phone validation (optional)
    if (formData.phone && formData.phone.trim() !== '') {
      const phoneResult = validatePhone(formData.phone);
      if (!phoneResult.isValid) {
        newErrors.phone = phoneResult.error!;
      }
    }

    setErrors(newErrors);

    // Check if there are any errors
    const hasErrors = Object.values(newErrors).some(error => error !== '');
    
    if (hasErrors) {
      const firstError = Object.values(newErrors).find(error => error !== '');
      toast.error(firstError || 'Lütfen formu kontrol edin', { duration: 5000 });
    }

    return !hasErrors;
  };

  const handleAddGuest = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate form
    if (!validateGuestForm()) {
      return;
    }

    // Guest limit kontrolü
    const guestCheck = await subscription.canAddGuest(invitationId, guests.length);
    if (!guestCheck.allowed) {
      toast.error(guestCheck.reason || 'Davetli limitine ulaştınız!');
      return;
    }

    try {
      await guestService.createGuest(formData);
      await loadGuests();
      
      // Reset form
      setFormData({
        invitation_id: invitationId,
        full_name: '',
        email: '',
        phone: '',
        companion_count: 0,
        notes: ''
      });
      setIsAddingGuest(false);
    } catch (error) {
      console.error('Error adding guest:', error);
    }
  };

  const handleUpdateGuest = async (guestId: string) => {
    // Validate form
    if (!validateGuestForm()) {
      return;
    }

    try{
      await guestService.updateGuest(guestId, {
        full_name: formData.full_name,
        email: formData.email,
        phone: formData.phone,
        companion_count: formData.companion_count,
        notes: formData.notes
      });
      await loadGuests();
      setEditingGuestId(null);
      setFormData({
        invitation_id: invitationId,
        full_name: '',
        email: '',
        phone: '',
        companion_count: 0,
        notes: ''
      });
    } catch (error) {
      console.error('Error updating guest:', error);
    }
  };

  const handleDeleteClick = (guest: Guest) => {
    setGuestToDelete({ id: guest.id, name: guest.full_name });
    setShowDeleteDialog(true);
  };

  const handleDeleteConfirm = async () => {
    if (!guestToDelete) return;

    setIsDeleting(true);
    try {
      await guestService.deleteGuest(guestToDelete.id);
      await loadGuests();
      setShowDeleteDialog(false);
      setGuestToDelete(null);
    } catch (error) {
      console.error('Error deleting guest:', error);
    } finally {
      setIsDeleting(false);
    }
  };

  const handleEditClick = (guest: Guest) => {
    setEditingGuestId(guest.id);
    setFormData({
      invitation_id: invitationId,
      full_name: guest.full_name,
      email: guest.email || '',
      phone: guest.phone || '',
      companion_count: guest.companion_count,
      notes: guest.notes || ''
    });
    setIsAddingGuest(false);
  };

  const handleCancelEdit = () => {
    setEditingGuestId(null);
    setIsAddingGuest(false);
    setFormData({
      invitation_id: invitationId,
      full_name: '',
      email: '',
      phone: '',
      companion_count: 0,
      notes: ''
    });
  };

  const getRSVPBadge = (status: string) => {
    switch (status) {
      case 'attending':
        return <span className="px-2 py-1 text-xs rounded-full bg-green-100 text-green-700">✓ Gelecek</span>;
      case 'declined':
        return <span className="px-2 py-1 text-xs rounded-full bg-red-100 text-red-700">✗ Gelemeyecek</span>;
      default:
        return <span className="px-2 py-1 text-xs rounded-full bg-gray-100 text-gray-700">⏳ Bekliyor</span>;
    }
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-12">
        <Loader2 className="h-8 w-8 animate-spin text-primary-500" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Statistics - Modern Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        <div className="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-4 border-2 border-blue-200 hover:shadow-md transition-all">
          <div className="flex items-center justify-between mb-2">
            <div className="bg-blue-200 rounded-lg p-2">
              <Users className="h-4 w-4 text-blue-700" />
            </div>
            <div className="text-3xl font-bold text-blue-700">{stats.total}</div>
          </div>
          <div className="text-xs font-semibold text-blue-600">Toplam Davetli</div>
        </div>
        <div className="bg-gradient-to-br from-green-50 to-emerald-100 rounded-xl p-4 border-2 border-green-200 hover:shadow-md transition-all">
          <div className="flex items-center justify-between mb-2">
            <div className="bg-green-200 rounded-lg p-2">
              <span className="text-green-700 text-sm">✓</span>
            </div>
            <div className="text-3xl font-bold text-green-700">{stats.attending}</div>
          </div>
          <div className="text-xs font-semibold text-green-600">Gelecek</div>
        </div>
        <div className="bg-gradient-to-br from-yellow-50 to-amber-100 rounded-xl p-4 border-2 border-yellow-200 hover:shadow-md transition-all">
          <div className="flex items-center justify-between mb-2">
            <div className="bg-yellow-200 rounded-lg p-2">
              <span className="text-yellow-700 text-sm">⏳</span>
            </div>
            <div className="text-3xl font-bold text-yellow-700">{stats.pending}</div>
          </div>
          <div className="text-xs font-semibold text-yellow-600">Bekliyor</div>
        </div>
        <div className="bg-gradient-to-br from-red-50 to-rose-100 rounded-xl p-4 border-2 border-red-200 hover:shadow-md transition-all">
          <div className="flex items-center justify-between mb-2">
            <div className="bg-red-200 rounded-lg p-2">
              <span className="text-red-700 text-sm">✗</span>
            </div>
            <div className="text-3xl font-bold text-red-700">{stats.declined}</div>
          </div>
          <div className="text-xs font-semibold text-red-600">Gelemeyecek</div>
        </div>
      </div>

      {/* Total Attending with Companions - Prominent Card */}
      <div className="bg-gradient-to-br from-purple-50 via-purple-100 to-pink-50 rounded-2xl p-6 border-2 border-purple-300 shadow-sm hover:shadow-md transition-all">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4">
            <div className="bg-purple-200 rounded-xl p-3">
              <Users className="h-6 w-6 text-purple-700" />
            </div>
            <div>
              <div className="text-4xl font-bold text-purple-700">{stats.total_attending}</div>
              <div className="text-sm font-semibold text-purple-600">
                Toplam Katılımcı (Davetli + Refakatçi)
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Action Buttons - Modern */}
      <div className="flex flex-wrap gap-2">
        {!isAddingGuest && !editingGuestId && (
          <>
            <button
              onClick={() => setIsAddingGuest(true)}
              className="flex items-center gap-2 px-4 py-2.5 bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white rounded-xl font-medium shadow-md hover:shadow-lg transition-all"
            >
              <UserPlus className="h-4 w-4" />
              <span className="hidden sm:inline">Yeni Davetli Ekle</span>
              <span className="sm:hidden">Ekle</span>
            </button>
            
            {guests.length > 0 && (
              <>
                <button
                  onClick={async () => {
                    const access = await subscription.canExportExcel();
                    if (!access.allowed) {
                      toast.error(access.reason || 'Excel export için PRO plana yükseltin!');
                      return;
                    }
                    excelService.exportGuestsToExcel(guests, invitationTitle);
                  }}
                  className={`flex items-center gap-2 px-4 py-2.5 rounded-xl font-medium transition-all ${
                    subscription.planConfig?.limits.excelExport
                      ? 'bg-white border-2 border-gray-200 text-gray-700 hover:border-green-500 hover:text-green-600 shadow-sm hover:shadow-md'
                      : 'bg-gray-100 text-gray-400 cursor-not-allowed'
                  }`}
                  title={
                    subscription.planConfig?.limits.excelExport 
                      ? "Basit Excel listesi indir"
                      : "PRO plana yükseltin"
                  }
                  disabled={!subscription.planConfig?.limits.excelExport}
                >
                  {!subscription.planConfig?.limits.excelExport && <Lock className="h-4 w-4" />}
                  <Download className="h-4 w-4" />
                  <span className="hidden sm:inline">Excel</span>
                </button>
                
                <button
                  onClick={async () => {
                    const access = await subscription.canExportExcel();
                    if (!access.allowed) {
                      toast.error(access.reason || 'Excel export için PRO plana yükseltin!');
                      return;
                    }
                    excelService.exportGuestsWithStats(guests, invitationTitle, stats);
                  }}
                  className={`flex items-center gap-2 px-4 py-2.5 rounded-xl font-medium transition-all ${
                    subscription.planConfig?.limits.excelExport
                      ? 'bg-white border-2 border-gray-200 text-gray-700 hover:border-blue-500 hover:text-blue-600 shadow-sm hover:shadow-md'
                      : 'bg-gray-100 text-gray-400 cursor-not-allowed'
                  }`}
                  title={
                    subscription.planConfig?.limits.excelExport
                      ? "İstatistiklerle birlikte detaylı rapor indir"
                      : "PRO plana yükseltin"
                  }
                  disabled={!subscription.planConfig?.limits.excelExport}
                >
                  {!subscription.planConfig?.limits.excelExport && <Lock className="h-4 w-4" />}
                  <FileSpreadsheet className="h-4 w-4" />
                  <span className="hidden sm:inline">Detaylı Rapor</span>
                </button>
              </>
            )}
          </>
        )}
      </div>

      {/* Add/Edit Guest Form - Modern */}
      {(isAddingGuest || editingGuestId) && (
        <div className="bg-gradient-to-br from-primary-50 to-blue-50 rounded-2xl p-6 border-2 border-primary-300 shadow-sm">
          <div className="flex items-center gap-3 mb-6">
            <div className="bg-primary-600 rounded-xl p-2.5">
              <UserPlus className="h-5 w-5 text-white" />
            </div>
            <h3 className="text-xl font-bold text-gray-900">
              {editingGuestId ? 'Davetli Düzenle' : 'Yeni Davetli Ekle'}
            </h3>
          </div>
          <form onSubmit={editingGuestId ? (e) => { e.preventDefault(); handleUpdateGuest(editingGuestId); } : handleAddGuest} className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Ad Soyad <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  value={formData.full_name}
                  onChange={(e) => {
                    setFormData({ ...formData, full_name: e.target.value });
                    if (errors.full_name) setErrors({ ...errors, full_name: '' });
                  }}
                  onBlur={(e) => {
                    const result = validateName(e.target.value, 'Ad Soyad');
                    setErrors({ ...errors, full_name: result.isValid ? '' : result.error! });
                  }}
                  className={`input-field ${errors.full_name ? 'input-error' : ''}`}
                  placeholder="Örn: Ahmet Yılmaz"
                  required
                />
                {errors.full_name && (
                  <p className="text-xs text-red-600 mt-1">{errors.full_name}</p>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  E-posta
                </label>
                <input
                  type="email"
                  value={formData.email}
                  onChange={(e) => {
                    setFormData({ ...formData, email: e.target.value });
                    if (errors.email) setErrors({ ...errors, email: '' });
                  }}
                  onBlur={(e) => {
                    if (e.target.value.trim()) {
                      const result = validateEmail(e.target.value);
                      setErrors({ ...errors, email: result.isValid ? '' : result.error! });
                    }
                  }}
                  className={`input-field ${errors.email ? 'input-error' : ''}`}
                  placeholder="ahmet@example.com"
                />
                {errors.email && (
                  <p className="text-xs text-red-600 mt-1">{errors.email}</p>
                )}
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Telefon
                </label>
                <input
                  type="tel"
                  value={formData.phone}
                  onChange={(e) => {
                    const formatted = formatPhoneNumber(e.target.value);
                    setFormData({ ...formData, phone: formatted });
                    if (errors.phone) setErrors({ ...errors, phone: '' });
                  }}
                  onBlur={(e) => {
                    if (e.target.value.trim()) {
                      const result = validatePhone(e.target.value);
                      setErrors({ ...errors, phone: result.isValid ? '' : result.error! });
                    }
                  }}
                  className={`input-field ${errors.phone ? 'input-error' : ''}`}
                  placeholder="05XX XXX XX XX"
                  maxLength={15}
                />
                {errors.phone && (
                  <p className="text-xs text-red-600 mt-1">{errors.phone}</p>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Refakatçi Sayısı (+1, +2, vb.)
                </label>
                <input
                  type="number"
                  value={formData.companion_count}
                  onChange={(e) => setFormData({ ...formData, companion_count: parseInt(e.target.value) || 0 })}
                  className="input-field"
                  min="0"
                  max="10"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Notlarınız (Sadece siz görür)
              </label>
              <textarea
                value={formData.notes}
                onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                className="input-field resize-none"
                rows={2}
                placeholder="Örn: VIP masaya oturacak, anne tarafından akraba..."
              />
              <p className="text-xs text-gray-500 mt-1">
                💡 Bu notları sadece siz görebilirsiniz, davetli göremez. Davetlinin RSVP'de yazdığı notlar ayrı gösterilir.
              </p>
            </div>

            <div className="flex gap-3 pt-2">
              <button type="submit" className="flex-1 flex items-center justify-center gap-2 px-6 py-3 bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white rounded-xl font-semibold shadow-md hover:shadow-lg transition-all">
                <Check className="h-5 w-5" />
                {editingGuestId ? 'Güncelle' : 'Ekle'}
              </button>
              <button
                type="button"
                onClick={handleCancelEdit}
                className="px-6 py-3 bg-white border-2 border-gray-300 text-gray-700 hover:bg-gray-50 rounded-xl font-semibold transition-all flex items-center gap-2"
              >
                <X className="h-5 w-5" />
                İptal
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Guest List - Modern Cards */}
      <div className="space-y-3">
        {guests.length === 0 ? (
          <div className="text-center py-16 bg-gradient-to-br from-gray-50 to-gray-100 rounded-2xl border-2 border-dashed border-gray-300">
            <div className="bg-gray-200 rounded-full p-4 w-20 h-20 mx-auto mb-4 flex items-center justify-center">
              <UserPlus className="h-10 w-10 text-gray-500" />
            </div>
            <p className="text-lg font-semibold text-gray-900 mb-1">Henüz davetli eklenmemiş</p>
            <p className="text-sm text-gray-600">Başlamak için "Yeni Davetli Ekle" butonuna tıklayın</p>
          </div>
        ) : (
          guests.map((guest) => (
            <div
              key={guest.id}
              className="bg-white rounded-xl border-2 border-gray-200 p-5 hover:border-primary-300 hover:shadow-md transition-all"
            >
              <div className="flex items-start justify-between">
                <div className="flex-1">
                  <div className="flex items-center gap-3 mb-2">
                    <h4 className="font-semibold text-gray-900">{guest.full_name}</h4>
                    {getRSVPBadge(guest.rsvp_status)}
                    {guest.companion_count > 0 && (
                      <span className="text-xs text-gray-600 bg-gray-100 px-2 py-1 rounded">
                        +{guest.companion_count}
                      </span>
                    )}
                  </div>
                  
                  <div className="space-y-1 text-sm text-gray-600">
                    {guest.email && (
                      <div className="flex items-center gap-2">
                        <Mail className="h-3 w-3" />
                        {guest.email}
                      </div>
                    )}
                    {guest.phone && (
                      <div className="flex items-center gap-2">
                        <Phone className="h-3 w-3" />
                        {guest.phone}
                      </div>
                    )}
                    
                    {/* RSVP Response Details */}
                    {guest.rsvp_status !== 'pending' && guest.rsvp_responded_at && (
                      <div className="mt-3 pt-3 border-t border-gray-100">
                        <p className="text-xs font-semibold text-gray-700 mb-2">📋 RSVP Yanıtı:</p>
                        
                        {guest.dietary_restrictions && (
                          <div className="text-xs text-blue-600 bg-blue-50 px-2 py-1 rounded mb-1">
                            🍽️ Diyet: {guest.dietary_restrictions}
                          </div>
                        )}
                        
                        {guest.notes && (
                          <div className="text-xs text-purple-600 bg-purple-50 px-2 py-1 rounded">
                            💬 Not: "{guest.notes}"
                          </div>
                        )}
                        
                        <p className="text-xs text-gray-400 mt-2">
                          Yanıt tarihi: {new Date(guest.rsvp_responded_at).toLocaleDateString('tr-TR')}
                        </p>
                      </div>
                    )}
                  </div>
                </div>

                <div className="flex items-center gap-2">
                  <button
                    onClick={invitationStatus === 'published' ? () => guestService.copyRSVPLink(guest.guest_token) : undefined}
                    disabled={invitationStatus !== 'published'}
                    className={`p-2.5 rounded-xl transition-all ${
                      invitationStatus === 'published'
                        ? 'text-blue-600 hover:bg-blue-50 hover:scale-110 cursor-pointer'
                        : 'text-gray-400 bg-gray-100 cursor-not-allowed'
                    }`}
                    title={invitationStatus === 'published' ? 'RSVP linkini kopyala' : 'Yayınlamadan RSVP linki paylaşılamaz'}
                  >
                    <Link2 className="h-4 w-4" />
                  </button>
                  <button
                    onClick={() => handleEditClick(guest)}
                    className="p-2.5 text-gray-600 hover:bg-gray-100 rounded-xl transition-all hover:scale-110"
                    title="Düzenle"
                  >
                    <Edit2 className="h-4 w-4" />
                  </button>
                  <button
                    onClick={() => handleDeleteClick(guest)}
                    className="p-2.5 text-red-600 hover:bg-red-50 rounded-xl transition-all hover:scale-110"
                    title="Sil"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                </div>
              </div>
            </div>
          ))
        )}
      </div>

      {/* Delete Confirmation Dialog */}
      <ConfirmDialog
        isOpen={showDeleteDialog}
        onClose={() => {
          setShowDeleteDialog(false);
          setGuestToDelete(null);
        }}
        onConfirm={handleDeleteConfirm}
        title="Davetliyi Sil"
        message={`"${guestToDelete?.name}" isimli davetliyi silmek istediğinize emin misiniz? Bu işlem geri alınamaz.`}
        confirmText="Evet, Sil"
        cancelText="İptal"
        type="danger"
        isLoading={isDeleting}
      />
    </div>
  );
};

export default GuestList;

