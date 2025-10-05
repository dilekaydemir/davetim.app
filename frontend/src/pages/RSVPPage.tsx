import React, { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { CheckCircle, XCircle, Loader2 } from 'lucide-react';
import { guestService, type Guest, type RSVPData } from '../services/guestService';
import { invitationService, type Invitation } from '../services/invitationService';
import { RSVPPageSkeleton } from '../components/Skeleton/Skeleton';
import toast from 'react-hot-toast';

const RSVPPage: React.FC = () => {
  const { guestToken } = useParams<{ guestToken: string }>();
  const [guest, setGuest] = useState<Guest | null>(null);
  const [invitation, setInvitation] = useState<Invitation | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [hasSubmitted, setHasSubmitted] = useState(false);

  // Prevent duplicate loading in React Strict Mode
  const hasLoadedRef = React.useRef(false);

  const [formData, setFormData] = useState<RSVPData>({
    rsvp_status: 'attending',
    companion_count: 0,
    dietary_restrictions: '',
    notes: ''
  });

  useEffect(() => {
    // Skip if already loaded
    if (hasLoadedRef.current) return;
    hasLoadedRef.current = true;
    
    loadGuestAndInvitation();
  }, [guestToken]);

  const loadGuestAndInvitation = async () => {
    if (!guestToken) {
      toast.error('Geçersiz RSVP linki');
      setIsLoading(false);
      return;
    }

    try {
      setIsLoading(true);
      const guestData = await guestService.getGuestByToken(guestToken);
      
      if (!guestData) {
        toast.error('Davetli bulunamadı');
        setIsLoading(false);
        return;
      }

      setGuest(guestData);

      // Load invitation details
      const invitationData = await invitationService.getInvitationById(guestData.invitation_id);
      setInvitation(invitationData);

      // Pre-fill form if guest already responded
      if (guestData.rsvp_status !== 'pending') {
        setFormData({
          rsvp_status: guestData.rsvp_status as 'attending' | 'declined',
          companion_count: guestData.companion_count,
          dietary_restrictions: guestData.dietary_restrictions || '',
          notes: guestData.notes || ''
        });
        setHasSubmitted(true);
      }
    } catch (error) {
      console.error('Error loading RSVP:', error);
      toast.error('Veriler yüklenemedi');
    } finally {
      setIsLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!guestToken) return;

    try {
      setIsSubmitting(true);
      await guestService.submitRSVP(guestToken, formData);
      setHasSubmitted(true);
      
      // Reload guest data to show updated status
      const updatedGuest = await guestService.getGuestByToken(guestToken);
      if (updatedGuest) {
        setGuest(updatedGuest);
      }
    } catch (error) {
      console.error('Error submitting RSVP:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  if (isLoading) {
    return <RSVPPageSkeleton />;
  }

  if (!guest || !invitation) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-primary-50 to-purple-50 flex items-center justify-center p-4">
        <div className="bg-white rounded-lg shadow-xl p-8 max-w-md w-full text-center">
          <XCircle className="h-16 w-16 text-red-500 mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Davetli Bulunamadı</h2>
          <p className="text-gray-600 mb-6">
            Bu RSVP linki geçersiz veya süresi dolmuş olabilir.
          </p>
          <Link to="/" className="btn-primary inline-block">
            Ana Sayfaya Dön
          </Link>
        </div>
      </div>
    );
  }

  // Get colors from invitation
  const colors = invitation.content?.colors || {
    primary: '#667eea',
    secondary: '#764ba2',
    background: '#ffffff',
    text: '#ffffff',
    accent: '#f56565'
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-50 to-purple-50 py-12 px-4">
      <div className="max-w-2xl mx-auto">
        {/* Invitation Preview Header */}
        <div 
          className="rounded-lg shadow-xl overflow-hidden mb-8 relative"
          style={{
            backgroundImage: invitation.content?.imagePosition === 'background' && invitation.image_url
              ? `url(${invitation.image_url})`
              : `linear-gradient(135deg, ${colors.primary} 0%, ${colors.secondary} 100%)`,
            backgroundSize: 'cover',
            backgroundPosition: 'center'
          }}
        >
          {/* Gradient overlay for background image */}
          {invitation.content?.imagePosition === 'background' && invitation.image_url && (
            <div 
              className="absolute inset-0" 
              style={{ 
                background: `linear-gradient(135deg, ${colors.primary}CC 0%, ${colors.secondary}CC 100%)`
              }}
            />
          )}
          
          {/* Watermark - bottom right */}
          {invitation.content?.imagePosition === 'watermark' && invitation.image_url && (
            <img
              src={invitation.image_url}
              alt="Logo"
              className="absolute bottom-4 right-4 w-16 h-16 object-contain opacity-60"
            />
          )}
          
          <div className="p-8 md:p-12 text-center relative z-10">
            <div 
              className="space-y-4 max-w-sm mx-auto"
              style={{ color: colors.text }}
            >
              {/* Banner Image - top */}
              {invitation.content?.imagePosition === 'banner' && invitation.image_url && (
                <div className="mb-6 -mx-8 -mt-8 mb-8">
                  <img
                    src={invitation.image_url}
                    alt="Banner"
                    className="w-full h-32 object-cover"
                  />
                </div>
              )}
              
              {/* Profile Image - circular */}
              {invitation.content?.imagePosition === 'profile' && invitation.image_url && (
                <div className="mb-6">
                  <img
                    src={invitation.image_url}
                    alt="Profil"
                    className="w-32 h-32 md:w-40 md:h-40 object-cover rounded-full mx-auto border-4"
                    style={{ borderColor: colors.accent }}
                  />
                </div>
              )}

              {/* Title */}
              <h1 className="text-3xl md:text-4xl font-serif font-bold">
                {invitation.title}
              </h1>

              {/* Accent Divider */}
              <div 
                className="w-24 h-1 mx-auto rounded-full"
                style={{ backgroundColor: colors.accent }}
              />

              {/* Date & Time */}
              {invitation.event_date && (
                <div 
                  className="p-4 rounded-lg"
                  style={{ 
                    backgroundColor: colors.background,
                    color: colors.primary
                  }}
                >
                  <div className="font-medium">
                    {new Date(invitation.event_date).toLocaleDateString('tr-TR', {
                      weekday: 'long',
                      year: 'numeric',
                      month: 'long',
                      day: 'numeric'
                    })}
                  </div>
                  {invitation.event_time && (
                    <div className="mt-1">{invitation.event_time}</div>
                  )}
                </div>
              )}

              {/* Accent Divider */}
              <div 
                className="w-24 h-1 mx-auto rounded-full"
                style={{ backgroundColor: colors.accent }}
              />

              {/* Location */}
              {invitation.event_location_name && (
                <div style={{ opacity: 0.95 }}>
                  {invitation.event_location_name}
                </div>
              )}

              {/* Custom Message */}
              {invitation.content?.message && (
                <>
                  <div 
                    className="w-16 h-1 mx-auto rounded-full"
                    style={{ backgroundColor: colors.accent }}
                  />
                  <div 
                    className="text-sm italic p-4 rounded-lg"
                    style={{ 
                      backgroundColor: colors.background,
                      color: colors.primary,
                      border: `2px solid ${colors.accent}`
                    }}
                  >
                    "{invitation.content.message}"
                  </div>
                </>
              )}
            </div>
          </div>
        </div>

        {/* RSVP Form */}
        <div className="bg-white rounded-lg shadow-xl p-6 md:p-8">
          {hasSubmitted ? (
            // Thank you message
            <div className="text-center py-8">
              <CheckCircle className="h-16 w-16 text-green-500 mx-auto mb-4" />
              <h2 className="text-2xl font-bold text-gray-900 mb-2">
                Teşekkür Ederiz!
              </h2>
              <p className="text-gray-600 mb-1">
                Merhaba <strong>{guest.full_name}</strong>,
              </p>
              <p className="text-gray-600 mb-6">
                Yanıtınız başarıyla kaydedildi.
              </p>
              
              <div className="bg-gray-50 rounded-lg p-4 mb-6">
                <div className="text-sm text-gray-600 space-y-2">
                  <div>
                    <strong>Durumunuz:</strong>{' '}
                    {guest.rsvp_status === 'attending' ? (
                      <span className="text-green-600 font-semibold">✓ Katılacağım</span>
                    ) : (
                      <span className="text-red-600 font-semibold">✗ Katılamayacağım</span>
                    )}
                  </div>
                  {guest.rsvp_status === 'attending' && guest.companion_count > 0 && (
                    <div>
                      <strong>Refakatçi:</strong> +{guest.companion_count}
                    </div>
                  )}
                  {guest.dietary_restrictions && (
                    <div>
                      <strong>Diyet Kısıtlamaları:</strong> {guest.dietary_restrictions}
                    </div>
                  )}
                  {guest.notes && (
                    <div>
                      <strong>Notlar:</strong> {guest.notes}
                    </div>
                  )}
                </div>
              </div>

              <button
                onClick={() => setHasSubmitted(false)}
                className="px-6 py-3 rounded-lg font-medium transition-all hover:shadow-lg"
                style={{
                  backgroundColor: colors.background,
                  color: colors.primary,
                  border: `2px solid ${colors.primary}`
                }}
              >
                Yanıtımı Güncelle
              </button>
            </div>
          ) : (
            // RSVP Form
            <>
              <div className="mb-6">
                <h2 className="text-xl font-semibold text-gray-900 mb-2">
                  Merhaba {guest.full_name}!
                </h2>
                <p className="text-gray-600">
                  Etkinliğimize katılıp katılmayacağınızı lütfen bize bildirin.
                </p>
              </div>

              <form onSubmit={handleSubmit} className="space-y-6">
                {/* RSVP Status */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-3">
                    Katılım Durumu *
                  </label>
                  <div className="grid grid-cols-2 gap-4">
                    <button
                      type="button"
                      onClick={() => setFormData({ ...formData, rsvp_status: 'attending' })}
                      className={`p-4 rounded-lg border-2 transition-all ${
                        formData.rsvp_status === 'attending'
                          ? 'border-green-500 bg-green-50 text-green-700'
                          : 'border-gray-200 hover:border-green-200'
                      }`}
                    >
                      <CheckCircle className={`h-8 w-8 mx-auto mb-2 ${
                        formData.rsvp_status === 'attending' ? 'text-green-500' : 'text-gray-400'
                      }`} />
                      <div className="font-semibold">Katılacağım</div>
                    </button>
                    <button
                      type="button"
                      onClick={() => setFormData({ ...formData, rsvp_status: 'declined', companion_count: 0 })}
                      className={`p-4 rounded-lg border-2 transition-all ${
                        formData.rsvp_status === 'declined'
                          ? 'border-red-500 bg-red-50 text-red-700'
                          : 'border-gray-200 hover:border-red-200'
                      }`}
                    >
                      <XCircle className={`h-8 w-8 mx-auto mb-2 ${
                        formData.rsvp_status === 'declined' ? 'text-red-500' : 'text-gray-400'
                      }`} />
                      <div className="font-semibold">Katılamayacağım</div>
                    </button>
                  </div>
                </div>

                {/* Companion Count (only if attending) */}
                {formData.rsvp_status === 'attending' && (
                  <>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        Yanınızda Kaç Kişi Gelecek? (Refakatçi)
                      </label>
                      <select
                        value={formData.companion_count}
                        onChange={(e) => setFormData({ ...formData, companion_count: parseInt(e.target.value) })}
                        className="input-field"
                      >
                        <option value="0">Sadece ben</option>
                        <option value="1">+1 (İki kişi)</option>
                        <option value="2">+2 (Üç kişi)</option>
                        <option value="3">+3 (Dört kişi)</option>
                        <option value="4">+4 (Beş kişi)</option>
                      </select>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-2">
                        Diyet Kısıtlamaları veya Alerjiler
                      </label>
                      <input
                        type="text"
                        value={formData.dietary_restrictions}
                        onChange={(e) => setFormData({ ...formData, dietary_restrictions: e.target.value })}
                        className="input-field"
                        placeholder="Örn: Vejetaryen, glutensiz, vb."
                      />
                    </div>
                  </>
                )}

                {/* Notes */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Ek Notlar veya İletmek İstedikleriniz
                  </label>
                  <textarea
                    value={formData.notes}
                    onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                    className="input-field resize-none"
                    rows={3}
                    placeholder="İsteğe bağlı..."
                  />
                </div>

                {/* Submit Button */}
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="w-full flex items-center justify-center gap-2 disabled:opacity-50 px-6 py-3 rounded-lg font-medium text-white transition-all hover:shadow-lg"
                  style={{
                    backgroundColor: colors.primary,
                    borderColor: colors.accent,
                    borderWidth: '2px'
                  }}
                >
                  {isSubmitting ? (
                    <>
                      <Loader2 className="h-5 w-5 animate-spin" />
                      Gönderiliyor...
                    </>
                  ) : (
                    <>
                      <CheckCircle className="h-5 w-5" />
                      Yanıtı Gönder
                    </>
                  )}
                </button>
              </form>
            </>
          )}
        </div>

        {/* Footer */}
        <div className="text-center mt-8 text-sm text-gray-600">
          <Link to="/" className="hover:text-primary-600 transition-colors">
            Davetim ile oluşturuldu
          </Link>
        </div>
      </div>
    </div>
  );
};

export default RSVPPage;

