import React, { useState, useEffect } from 'react';
import { UserPlus, Mail, Phone, Trash2, Edit2, Link2, Check, X, Loader2, FileSpreadsheet, Download, Lock } from 'lucide-react';
import { guestService, type Guest, type CreateGuestData, type GuestStats } from '../../services/guestService';
import { excelService } from '../../services/excelService';
import { useSubscription } from '../../hooks/useSubscription';
import toast from 'react-hot-toast';
import { validateName, validateEmail, validatePhone, formatPhoneNumber } from '../../utils/validation';
import ConfirmDialog from '../Common/ConfirmDialog';

interface GuestListProps {
  invitationId: string;
  invitationTitle?: string;
}

const GuestList: React.FC<GuestListProps> = ({ invitationId, invitationTitle = 'Davetiye' }) => {
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
      const [guestsData, statsData] = await Promise.all([
        guestService.getInvitationGuests(invitationId),
        guestService.getGuestStats(invitationId)
      ]);
      setGuests(guestsData);
      setStats(statsData);
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
      {/* Statistics */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="bg-blue-50 rounded-lg p-4">
          <div className="text-2xl font-bold text-blue-700">{stats.total}</div>
          <div className="text-sm text-blue-600">Toplam Davetli</div>
        </div>
        <div className="bg-green-50 rounded-lg p-4">
          <div className="text-2xl font-bold text-green-700">{stats.attending}</div>
          <div className="text-sm text-green-600">Gelecek</div>
        </div>
        <div className="bg-yellow-50 rounded-lg p-4">
          <div className="text-2xl font-bold text-yellow-700">{stats.pending}</div>
          <div className="text-sm text-yellow-600">Bekliyor</div>
        </div>
        <div className="bg-red-50 rounded-lg p-4">
          <div className="text-2xl font-bold text-red-700">{stats.declined}</div>
          <div className="text-sm text-red-600">Gelemeyecek</div>
        </div>
      </div>

      {/* Total Attending with Companions */}
      <div className="bg-purple-50 rounded-lg p-4 text-center">
        <div className="text-3xl font-bold text-purple-700">{stats.total_attending}</div>
        <div className="text-sm text-purple-600">
          Toplam Katılımcı (Davetli + Refakatçi)
        </div>
      </div>

      {/* Action Buttons */}
      <div className="flex flex-wrap gap-3">
        {!isAddingGuest && !editingGuestId && (
          <>
            <button
              onClick={() => setIsAddingGuest(true)}
              className="btn-primary flex items-center gap-2"
            >
              <UserPlus className="h-4 w-4" />
              Yeni Davetli Ekle
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
                  className={`btn-secondary flex items-center gap-2 ${
                    !subscription.planConfig?.limits.excelExport ? 'opacity-50 cursor-not-allowed' : ''
                  }`}
                  title={
                    subscription.planConfig?.limits.excelExport 
                      ? "Basit Excel listesi indir"
                      : "PRO plana yükseltin"
                  }
                >
                  {!subscription.planConfig?.limits.excelExport && <Lock className="h-4 w-4" />}
                  <Download className="h-4 w-4" />
                  Excel İndir
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
                  className={`btn-outline flex items-center gap-2 ${
                    !subscription.planConfig?.limits.excelExport ? 'opacity-50 cursor-not-allowed' : ''
                  }`}
                  title={
                    subscription.planConfig?.limits.excelExport
                      ? "İstatistiklerle birlikte detaylı rapor indir"
                      : "PRO plana yükseltin"
                  }
                >
                  {!subscription.planConfig?.limits.excelExport && <Lock className="h-4 w-4" />}
                  <FileSpreadsheet className="h-4 w-4" />
                  Detaylı Rapor
                </button>
              </>
            )}
          </>
        )}
      </div>

      {/* Add/Edit Guest Form */}
      {(isAddingGuest || editingGuestId) && (
        <div className="bg-gray-50 rounded-lg p-4 border-2 border-primary-200">
          <h3 className="text-lg font-semibold mb-4">
            {editingGuestId ? 'Davetli Düzenle' : 'Yeni Davetli'}
          </h3>
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
                💡 Bu notlar sadece sizin görebilirsiniz, davetli göremez. Davetlinin RSVP'de yazdığı notlar ayrı gösterilir.
              </p>
            </div>

            <div className="flex gap-2">
              <button type="submit" className="btn-primary flex items-center gap-2">
                <Check className="h-4 w-4" />
                {editingGuestId ? 'Güncelle' : 'Ekle'}
              </button>
              <button
                type="button"
                onClick={handleCancelEdit}
                className="btn-secondary flex items-center gap-2"
              >
                <X className="h-4 w-4" />
                İptal
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Guest List */}
      <div className="space-y-3">
        {guests.length === 0 ? (
          <div className="text-center py-12 text-gray-500">
            <UserPlus className="h-12 w-12 mx-auto mb-3 opacity-50" />
            <p>Henüz davetli eklenmemiş</p>
            <p className="text-sm mt-1">Başlamak için "Yeni Davetli Ekle" butonuna tıklayın</p>
          </div>
        ) : (
          guests.map((guest) => (
            <div
              key={guest.id}
              className="bg-white rounded-lg border border-gray-200 p-4 hover:shadow-md transition-shadow"
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
                    onClick={() => guestService.copyRSVPLink(guest.guest_token)}
                    className="p-2 text-blue-600 hover:bg-blue-50 rounded transition-colors"
                    title="RSVP linkini kopyala"
                  >
                    <Link2 className="h-4 w-4" />
                  </button>
                  <button
                    onClick={() => handleEditClick(guest)}
                    className="p-2 text-gray-600 hover:bg-gray-100 rounded transition-colors"
                    title="Düzenle"
                  >
                    <Edit2 className="h-4 w-4" />
                  </button>
                  <button
                    onClick={() => handleDeleteClick(guest)}
                    className="p-2 text-red-600 hover:bg-red-50 rounded transition-colors"
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

