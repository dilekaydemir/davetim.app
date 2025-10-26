import React, { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { CheckCircle, XCircle, Loader2 } from 'lucide-react';
import { guestService, type Guest, type RSVPData } from '../services/guestService';
import { invitationService, type Invitation } from '../services/invitationService';
import toast from 'react-hot-toast';

const RSVPPage: React.FC = () => {
  const { guestToken } = useParams<{ guestToken: string }>();
  const [guest, setGuest] = useState<Guest | null>(null);
  const [invitation, setInvitation] = useState<Invitation | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [hasSubmitted, setHasSubmitted] = useState(false);
  const [scrollProgress, setScrollProgress] = useState(0);
  const [hasStartedScrolling, setHasStartedScrolling] = useState(false);

  const hasLoadedRef = React.useRef(false);

  const [formData, setFormData] = useState<RSVPData>({
    rsvp_status: 'attending',
    companion_count: 0,
    dietary_restrictions: '',
    notes: ''
  });

  useEffect(() => {
    if (hasLoadedRef.current) return;
    hasLoadedRef.current = true;
    
    loadGuestAndInvitation();
  }, [guestToken]);

  // Scroll handler for envelope animation
  useEffect(() => {
    // Ensure page starts at top
    window.scrollTo(0, 0);
    
    const handleScroll = () => {
      const scrollTop = window.scrollY;
      const windowHeight = window.innerHeight;
      
      // Detect if user has started scrolling
      if (scrollTop > 10 && !hasStartedScrolling) {
        setHasStartedScrolling(true);
      }
      
      // Animation completes when scrolled to 100vh (one full screen)
      const progress = Math.min(scrollTop / windowHeight, 1);
      setScrollProgress(progress);
    };

    window.addEventListener('scroll', handleScroll);
    handleScroll(); // Initial call to set progress
    return () => window.removeEventListener('scroll', handleScroll);
  }, [hasStartedScrolling]);

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
        // If already responded, start with envelope open
        setScrollProgress(1);
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

  // Show error state if data loading failed
  if (!isLoading && (!guest || !invitation)) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-primary-50 to-purple-50 flex items-center justify-center p-4">
        <div className="bg-white rounded-xl shadow-xl p-6 max-w-md w-full text-center border border-gray-200">
          <div className="bg-red-100 rounded-full p-3 w-16 h-16 mx-auto mb-3 flex items-center justify-center">
            <XCircle className="h-10 w-10 text-red-500" />
          </div>
          <h2 className="text-xl font-bold text-gray-900 mb-2">Davetli Bulunamadı</h2>
          <p className="text-sm text-gray-600 mb-4">
            Bu RSVP linki geçersiz veya süresi dolmuş olabilir.
          </p>
          <Link to="/" className="inline-flex items-center justify-center px-5 py-2.5 bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white rounded-lg font-semibold shadow-md hover:shadow-lg transition-all text-sm">
            Ana Sayfaya Dön
          </Link>
        </div>
      </div>
    );
  }

  const colors = invitation?.content?.colors || {
    primary: '#667eea',
    secondary: '#764ba2',
    background: '#ffffff',
    text: '#ffffff',
    accent: '#f56565'
  };

  // Calculate animation states based on scroll progress
  // Keep envelope static until user starts scrolling
  const animProgress = hasStartedScrolling ? scrollProgress : 0;
  
  const envelopeScale = 1 - animProgress * 0.4;
  const envelopeY = animProgress * 200;
  const envelopeRotate = animProgress * -8;
  const flapRotation = animProgress * -180;
  const sealScale = Math.max(0, 1 - animProgress * 1.5);
  const sealOpacity = Math.max(0, 1 - animProgress * 2.5);
  const cardTranslateY = -100 + (animProgress * 120);
  const cardScale = 0.7 + (animProgress * 0.3);
  const cardOpacity = Math.min(animProgress * 2, 1);
  const contentOpacity = animProgress > 0.6 ? Math.min((animProgress - 0.6) / 0.4, 1) : 0;

  return (
    <div className="min-h-[200vh] bg-gradient-to-br from-slate-50 via-blue-50 to-purple-50 relative overflow-hidden">
      {/* Fixed Envelope Container */}
      <div className="fixed inset-0 flex items-center justify-center pointer-events-none z-20">
        <div 
          className="transition-all duration-300 ease-out"
          style={{
            transform: `scale(${envelopeScale}) translateY(${envelopeY}px) rotate(${envelopeRotate}deg)`,
            opacity: animProgress < 0.95 ? 1 : 0,
            visibility: animProgress < 0.95 ? 'visible' : 'hidden'
          }}
        >
          <div 
            className="relative"
            style={{ 
              width: '500px', 
              height: '320px',
              perspective: '2000px',
              transformStyle: 'preserve-3d'
            }}
          >
            {/* Envelope Body */}
            <div 
              className="absolute inset-0 rounded-lg shadow-2xl overflow-hidden"
              style={{
                background: `linear-gradient(135deg, ${colors.primary} 0%, ${colors.secondary} 100%)`,
                transform: 'translateZ(0px)'
              }}
            >
              {/* Decorative Pattern */}
              <div className="absolute inset-0 opacity-10">
                <svg width="100%" height="100%">
                  <defs>
                    <pattern id="dots" x="0" y="0" width="30" height="30" patternUnits="userSpaceOnUse">
                      <circle cx="15" cy="15" r="2" fill="white" />
                    </pattern>
                  </defs>
                  <rect width="100%" height="100%" fill="url(#dots)" />
                </svg>
              </div>

              {/* Address Section */}
              <div className="absolute inset-0 flex flex-col items-center justify-center p-8">
                <div className="text-center space-y-3">
                  {isLoading ? (
                    <div className="space-y-3">
                      <div className="h-8 w-48 bg-white/20 rounded-lg animate-pulse mx-auto" />
                      <div className="h-5 w-32 bg-white/20 rounded-lg animate-pulse mx-auto" />
                    </div>
                  ) : (
                    <>
                      <div 
                        className="font-serif text-3xl font-bold tracking-wide relative"
                        style={{ 
                          color: colors.text,
                          top: '55px'
                        }}
                      >
                        {guest?.full_name || 'Davetli'}
                      </div>
                    </>
                  )}
                </div>
              </div>

              {/* Envelope Opening Shadow */}
              <div 
                className="absolute inset-x-0 top-0 h-1/2"
                style={{
                  background: `linear-gradient(to bottom, rgba(0,0,0,${scrollProgress * 0.3}), transparent)`,
                  pointerEvents: 'none'
                }}
              />
            </div>

            {/* Envelope Flap */}
            <div 
              className="absolute top-0 left-0 right-0 h-[50%] origin-top"
              style={{
                background: `linear-gradient(180deg, ${colors.secondary} 0%, ${colors.primary} 100%)`,
                clipPath: 'polygon(0 0, 50% 100%, 100% 0)',
                transformStyle: 'preserve-3d',
                transform: `perspective(2000px) rotateX(${flapRotation}deg)`,
                boxShadow: '0 15px 40px rgba(0,0,0,0.4)',
                transition: 'transform 0.3s ease-out'
              }}
            >
              {/* Flap Inner Side */}
              <div 
                className="absolute inset-0"
                style={{
                  background: 'linear-gradient(180deg, #fafafa 0%, #e0e0e0 100%)',
                  clipPath: 'polygon(0 0, 50% 100%, 100% 0)',
                  transform: 'rotateX(180deg)',
                  backfaceVisibility: 'hidden'
                }}
              >
                {/* Decorative Pattern on Inner Flap */}
                <div className="absolute inset-0 opacity-20">
                  <svg width="100%" height="100%">
                    <pattern id="inner-pattern" x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse">
                      <line x1="0" y1="0" x2="20" y2="20" stroke="#999" strokeWidth="1" />
                      <line x1="20" y1="0" x2="0" y2="20" stroke="#999" strokeWidth="1" />
                    </pattern>
                    <rect width="100%" height="100%" fill="url(#inner-pattern)" />
                  </svg>
                </div>
              </div>
            </div>

            {/* Wax Seal */}
            <div 
              className="absolute top-[35%] left-1/2 -translate-x-1/2 rounded-full flex items-center justify-center shadow-2xl z-30"
              style={{ 
                width: '80px',
                height: '70px',
                background: `radial-gradient(circle at 30% 30%, ${colors.accent}66 0%, ${colors.accent}77 100%)`,
                boxShadow: `0 10px 35px ${colors.accent}99, inset 0 -3px 15px rgba(0,0,0,0.4)`,
                transform: `scale(${sealScale}) translateX(-50%)`,
                opacity: sealOpacity,
                transition: 'all 0.3s ease-out'
              }}
            >
              <div className="text-4xl">🎀</div>
            </div>

            {/* Invitation Card - Emerging from envelope */}
            {!isLoading && invitation && (
              <div 
                className="absolute left-1/2 pointer-events-none"
                style={{
                  width: '450px',
                  height: '600px',
                  transform: `translateX(-50%) translateY(${cardTranslateY}px) scale(${cardScale})`,
                  opacity: cardOpacity,
                  transition: 'all 0.3s ease-out',
                  zIndex: 10
                }}
              >
                <div 
                  className="w-full h-full rounded-2xl shadow-2xl overflow-hidden border-2 border-white relative"
                  style={{
                    backgroundImage: invitation.image_url && invitation.content?.imagePosition === 'background'
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
                      background: `linear-gradient(135deg, ${colors.primary}dd 0%, ${colors.secondary}dd 100%)`
              }}
            />
          )}
          
                {/* Watermark */}
          {invitation.content?.imagePosition === 'watermark' && invitation.image_url && (
            <img
              src={invitation.image_url}
              alt="Logo"
              className="absolute bottom-4 right-4 w-16 h-16 object-contain opacity-60"
            />
          )}
          
                <div className="p-10 text-center relative z-10 flex flex-col justify-center h-full">
            <div 
                    className="space-y-4"
              style={{ color: colors.text }}
            >
                    {/* Banner Image */}
              {invitation.content?.imagePosition === 'banner' && invitation.image_url && (
                      <div className="mb-5 -mx-10 -mt-10">
                  <img
                    src={invitation.image_url}
                    alt="Banner"
                    className="w-full h-32 object-cover"
                  />
                </div>
              )}
              
                    {/* Profile Image */}
              {invitation.content?.imagePosition === 'profile' && invitation.image_url && (
                      <div className="mb-5">
                  <img
                    src={invitation.image_url}
                    alt="Profil"
                          className="w-28 h-28 object-cover rounded-full mx-auto border-4 shadow-xl"
                    style={{ borderColor: colors.accent }}
                  />
                </div>
              )}

              {/* Title */}
                    <h1 className="text-3xl md:text-4xl font-serif font-bold leading-tight">
                {invitation.title}
              </h1>

                    {/* Divider */}
              <div 
                      className="w-24 h-1 mx-auto rounded-full shadow-sm"
                style={{ backgroundColor: colors.accent }}
              />

              {/* Date & Time */}
              {invitation.event_date && (
                <div 
                        className="p-4 rounded-xl shadow-lg text-sm"
                  style={{ 
                    backgroundColor: colors.background,
                    color: colors.primary
                  }}
                >
                        <div className="font-semibold">
                          📅 {new Date(invitation.event_date).toLocaleDateString('tr-TR', {
                      weekday: 'long',
                      year: 'numeric',
                      month: 'long',
                      day: 'numeric'
                    })}
                  </div>
                  {invitation.event_time && (
                          <div className="mt-1.5 font-medium">🕐 {invitation.event_time}</div>
                  )}
                </div>
              )}

              {/* Location */}
              {invitation.event_location_name && (
                      <>
                        <div 
                          className="w-16 h-0.5 mx-auto rounded-full"
                          style={{ backgroundColor: colors.accent, opacity: 0.5 }}
                        />
                        <div 
                          className="p-3 rounded-xl shadow-lg font-medium text-sm"
                          style={{ 
                            backgroundColor: colors.background,
                            color: colors.primary
                          }}
                        >
                          📍 {invitation.event_location_name}
                </div>
                      </>
              )}

              {/* Custom Message */}
              {invitation.content?.message && (
                <>
                  <div 
                          className="w-16 h-0.5 mx-auto rounded-full"
                          style={{ backgroundColor: colors.accent, opacity: 0.5 }}
                  />
                  <div 
                          className="text-sm italic p-4 rounded-xl shadow-lg"
                    style={{ 
                      backgroundColor: colors.background,
                      color: colors.primary,
                      border: `2px solid ${colors.accent}`
                    }}
                  >
                          💌 {invitation.content.message}
                  </div>
                </>
              )}
                  </div>
                </div>
              </div>
              </div>
            )}

            {/* Ambient Glow */}
            <div 
              className="absolute -inset-12 rounded-full blur-3xl"
              style={{ 
                background: `radial-gradient(circle, ${colors.primary}40 0%, transparent 70%)`,
                opacity: 1 - animProgress,
                animation: 'pulse 3s infinite'
              }}
            />
          </div>
        </div>
      </div>

      {/* Scroll Instruction - Only visible at start */}
      {!hasStartedScrolling && !isLoading && (
        <div 
          className="fixed bottom-12 left-1/2 z-30"
          style={{
            transform: 'translateX(-50%)',
            animation: 'bounce 2s infinite'
          }}
        >
          <div className="bg-white/90 backdrop-blur-sm rounded-full px-6 py-3 shadow-xl border border-gray-200">
            <div className="flex items-center gap-3">
              <span className="text-2xl">👇</span>
              <span className="font-semibold text-gray-800">Aşağı kaydırın</span>
            </div>
          </div>
        </div>
      )}

      {/* Content Section - Appears as envelope opens */}
      {!isLoading && guest && invitation && (
        <div 
          className="relative z-10 min-h-screen flex items-center justify-center px-4 py-12"
          style={{
            opacity: contentOpacity,
            transform: `translateY(${(1 - contentOpacity) * 30}px)`,
            transition: 'all 0.5s ease-out',
            marginTop: '100vh'
          }}
        >
          <div className="max-w-6xl mx-auto w-full">
            <div className="grid lg:grid-cols-5 gap-6 items-center">
              
              {/* Left: Full Invitation Card - 3 columns */}
              <div className="lg:col-span-3">
                <div 
                  className="rounded-2xl shadow-2xl overflow-hidden border-2 border-white/80 backdrop-blur-sm min-h-[600px] relative"
                  style={{
                    backgroundImage: invitation.image_url && invitation.content?.imagePosition === 'background'
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
                      background: `linear-gradient(135deg, ${colors.primary}dd 0%, ${colors.secondary}dd 100%)`
                    }}
                  />
                )}
                
                {/* Watermark */}
                {invitation.content?.imagePosition === 'watermark' && invitation.image_url && (
                  <img
                    src={invitation.image_url}
                    alt="Logo"
                    className="absolute bottom-4 right-4 w-16 h-16 object-contain opacity-60"
                  />
                )}
                
                <div className="p-10 md:p-12 text-center relative z-10 flex flex-col justify-center min-h-[600px]">
                  <div 
                    className="space-y-5"
                    style={{ color: colors.text }}
                  >
                    {/* Banner Image */}
                    {invitation.content?.imagePosition === 'banner' && invitation.image_url && (
                      <div className="mb-6 -mx-10 -mt-10 md:-mx-12 md:-mt-12">
                        <img
                          src={invitation.image_url}
                          alt="Banner"
                          className="w-full h-40 object-cover"
                        />
                      </div>
                    )}
                    
                    {/* Profile Image */}
                    {invitation.content?.imagePosition === 'profile' && invitation.image_url && (
                      <div className="mb-6">
                        <img
                          src={invitation.image_url}
                          alt="Profil"
                          className="w-36 h-36 object-cover rounded-full mx-auto border-4 shadow-xl"
                          style={{ borderColor: colors.accent }}
                        />
                    </div>
                  )}

                    {/* Title */}
                    <h1 className="text-4xl md:text-5xl font-serif font-bold leading-tight">
                      {invitation.title}
                    </h1>

                    {/* Divider */}
                    <div 
                      className="w-32 h-1 mx-auto rounded-full shadow-sm"
                      style={{ backgroundColor: colors.accent }}
                    />

                    {/* Date & Time */}
                    {invitation.event_date && (
                      <div 
                        className="p-5 rounded-xl shadow-lg"
                        style={{ 
                          backgroundColor: colors.background,
                          color: colors.primary
                        }}
                      >
                        <div className="font-semibold text-lg">
                          📅 {new Date(invitation.event_date).toLocaleDateString('tr-TR', {
                            weekday: 'long',
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric'
                          })}
                    </div>
                        {invitation.event_time && (
                          <div className="mt-2 font-medium text-base">🕐 {invitation.event_time}</div>
                  )}
                    </div>
                  )}

                    {/* Location */}
                    {invitation.event_location_name && (
                      <>
                        <div 
                          className="w-20 h-0.5 mx-auto rounded-full"
                          style={{ backgroundColor: colors.accent, opacity: 0.5 }}
                        />
                        <div 
                          className="p-4 rounded-xl shadow-lg font-medium text-base"
                          style={{ 
                            backgroundColor: colors.background,
                            color: colors.primary
                          }}
                        >
                          📍 {invitation.event_location_name}
                </div>
                      </>
                    )}

                    {/* Custom Message */}
                    {invitation.content?.message && (
                      <>
                        <div 
                          className="w-20 h-0.5 mx-auto rounded-full"
                          style={{ backgroundColor: colors.accent, opacity: 0.5 }}
                        />
                        <div 
                          className="text-base italic p-5 rounded-xl shadow-lg"
                style={{
                  backgroundColor: colors.background,
                  color: colors.primary,
                            border: `2px solid ${colors.accent}`
                          }}
                        >
                          💌 {invitation.content.message}
                        </div>
                      </>
                    )}
                  </div>
                </div>
              </div>
            </div>

            {/* Right: RSVP Form - 2 columns */}
            <div className="lg:col-span-2">
              {!hasSubmitted ? (
                <form onSubmit={handleSubmit} 
                  className="rounded-2xl shadow-2xl overflow-hidden border-2 border-white/80 backdrop-blur-sm bg-white min-h-[600px] flex flex-col"
                >
                  <div className="p-5 md:p-6 space-y-4 flex-1 flex flex-col">
                    {/* Welcome Header - Compact */}
                    <div className="text-center pb-3 border-b border-gray-200">
                      <div className="inline-flex items-center justify-center w-12 h-12 bg-gradient-to-br from-primary-500 to-primary-600 rounded-xl shadow-md mb-2">
                        <span className="text-xl">👋</span>
                      </div>
                      <h2 className="text-lg font-bold text-gray-900">
                        {guest.full_name}
                </h2>
                      <p className="text-xs text-gray-600 mt-0.5">
                        Katılım durumunuzu bildirin
                </p>
              </div>

                    {/* RSVP Status Selection - Compact */}
                    <div className="flex-1">
                      <div className="grid grid-cols-2 gap-2.5">
                    <button
                      type="button"
                      onClick={() => setFormData({ ...formData, rsvp_status: 'attending' })}
                          className={`p-3 rounded-lg border-2 transition-all ${
                        formData.rsvp_status === 'attending'
                              ? 'border-green-500 bg-gradient-to-br from-green-50 to-emerald-50 shadow-md'
                              : 'border-gray-200 hover:border-green-300'
                          }`}
                        >
                          <CheckCircle className={`h-6 w-6 mx-auto mb-1 ${formData.rsvp_status === 'attending' ? 'text-green-500' : 'text-gray-400'}`} />
                          <div className="font-bold text-xs">Katılacağım</div>
                    </button>
                    <button
                      type="button"
                          onClick={() => setFormData({ ...formData, rsvp_status: 'declined' })}
                          className={`p-3 rounded-lg border-2 transition-all ${
                        formData.rsvp_status === 'declined'
                              ? 'border-red-500 bg-gradient-to-br from-red-50 to-rose-50 shadow-md'
                              : 'border-gray-200 hover:border-red-300'
                          }`}
                        >
                          <XCircle className={`h-6 w-6 mx-auto mb-1 ${formData.rsvp_status === 'declined' ? 'text-red-500' : 'text-gray-400'}`} />
                          <div className="font-bold text-xs">Katılamayacağım</div>
                    </button>
                  </div>
                </div>

                    {/* Attending Details - Ultra Compact */}
                {formData.rsvp_status === 'attending' && (
                      <div className="space-y-2.5 p-3 bg-gradient-to-br from-green-50/50 to-emerald-50/50 rounded-lg border border-green-200/50">
                    <div>
                          <label className="block text-xs font-semibold text-gray-900 mb-1">
                            👥 Yanınızdakiler
                      </label>
                      <select
                        value={formData.companion_count}
                        onChange={(e) => setFormData({ ...formData, companion_count: parseInt(e.target.value) })}
                            className="w-full px-2.5 py-1.5 border border-gray-300 rounded-lg focus:ring-1 focus:ring-green-500 focus:border-transparent transition-all bg-white text-xs"
                          >
                            <option value={0}>Sadece ben</option>
                            <option value={1}>+1 kişi</option>
                            <option value={2}>+2 kişi</option>
                            <option value={3}>+3 kişi</option>
                            <option value={4}>+4 kişi</option>
                            <option value={5}>+5 kişi</option>
                      </select>
                    </div>
                    <div>
                          <label className="block text-xs font-semibold text-gray-900 mb-1">
                            🍽️ Diyet
                      </label>
                      <input
                        type="text"
                        value={formData.dietary_restrictions}
                        onChange={(e) => setFormData({ ...formData, dietary_restrictions: e.target.value })}
                            className="w-full px-2.5 py-1.5 border border-gray-300 rounded-lg focus:ring-1 focus:ring-green-500 focus:border-transparent transition-all bg-white text-xs"
                            placeholder="Örn: Vejetaryen"
                      />
                    </div>
                      </div>
                )}

                    {/* Notes - Compact */}
                <div>
                      <label className="block text-xs font-semibold text-gray-900 mb-1">
                        💬 Notlar
                  </label>
                  <textarea
                    value={formData.notes}
                    onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                        className="w-full px-2.5 py-1.5 border border-gray-300 rounded-lg focus:ring-primary-500 focus:border-transparent transition-all resize-none bg-white text-xs"
                        rows={2}
                    placeholder="İsteğe bağlı..."
                  />
                </div>

                    {/* Submit Button - Compact */}
                <button
                  type="submit"
                  disabled={isSubmitting}
                      className="w-full flex items-center justify-center gap-2 px-5 py-3 rounded-xl font-bold text-white transition-all shadow-lg hover:shadow-xl hover:scale-105 disabled:opacity-50 disabled:scale-100 mt-auto text-sm"
                  style={{
                        background: `linear-gradient(135deg, ${colors.primary} 0%, ${colors.secondary} 100%)`,
                        border: `2px solid ${colors.accent}`
                  }}
                >
                  {isSubmitting ? (
                    <>
                          <Loader2 className="h-4 w-4 animate-spin" />
                          <span>Gönderiliyor...</span>
                    </>
                  ) : (
                    <>
                          <CheckCircle className="h-4 w-4" />
                          <span>Yanıtımı Gönder</span>
                    </>
                  )}
                </button>
                  </div>
              </form>
              ) : (
                /* Thank You Message */
                <div className="rounded-2xl shadow-2xl overflow-hidden border-2 border-white/80 backdrop-blur-sm bg-white min-h-[600px] flex flex-col">
                  <div className="p-5 md:p-6 space-y-4 flex-1 flex flex-col justify-center">
                    {/* Success Header - Compact */}
                    <div className="text-center pb-4 border-b border-gray-200">
                      <div className="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-green-500 to-emerald-600 rounded-full shadow-lg mb-3">
                        <CheckCircle className="h-10 w-10 text-white" />
                      </div>
                      <h2 className="text-2xl font-bold text-gray-900 mb-1">Teşekkür Ederiz!</h2>
                      <p className="text-sm text-gray-600">
                        <strong className="text-gray-900">{guest.full_name}</strong>, yanıtınız kaydedildi
                      </p>
                    </div>

                    {/* Response Summary - Compact */}
                    <div className="bg-gradient-to-br from-gray-50 to-gray-100 rounded-lg border border-gray-200 p-4 text-left">
                      <h3 className="font-bold text-gray-900 mb-3 text-center text-sm">Yanıt Özeti</h3>
                      <div className="space-y-2">
                        <div className="flex items-center justify-between p-2.5 bg-white rounded-lg text-sm">
                          <span className="font-semibold text-gray-700">Durum:</span>
                          {guest.rsvp_status === 'attending' ? (
                            <span className="flex items-center gap-1.5 text-green-600 font-bold text-xs">
                              <CheckCircle className="h-4 w-4" />
                              Katılacağım
                            </span>
                          ) : (
                            <span className="flex items-center gap-1.5 text-red-600 font-bold text-xs">
                              <XCircle className="h-4 w-4" />
                              Katılamayacağım
                            </span>
                          )}
                        </div>
                        {guest.rsvp_status === 'attending' && (
                          <>
                            {guest.companion_count > 0 && (
                              <div className="flex items-center justify-between p-2.5 bg-white rounded-lg text-sm">
                                <span className="font-semibold text-gray-700">Yanınızdakiler:</span>
                                <span className="font-bold text-gray-900 text-xs">+{guest.companion_count}</span>
                              </div>
                            )}
                            {guest.dietary_restrictions && (
                              <div className="p-2.5 bg-white rounded-lg text-sm">
                                <span className="font-semibold text-gray-700 block mb-1 text-xs">Diyet:</span>
                                <span className="text-gray-900 text-xs">{guest.dietary_restrictions}</span>
                              </div>
                            )}
            </>
          )}
                        {guest.notes && (
                          <div className="p-2.5 bg-white rounded-lg text-sm">
                            <span className="font-semibold text-gray-700 block mb-1 text-xs">Notunuz:</span>
                            <span className="text-gray-900 italic text-xs">"{guest.notes}"</span>
                          </div>
                        )}
                      </div>
                    </div>

                    {/* Update Button - Compact */}
                    <button
                      onClick={() => setHasSubmitted(false)}
                      className="w-full px-6 py-3 rounded-xl font-bold transition-all shadow-md hover:shadow-lg hover:scale-105 text-sm"
                      style={{ 
                        backgroundColor: colors.background,
                        color: colors.primary,
                        border: `2px solid ${colors.primary}`
                      }}
                    >
                      Yanıtımı Güncelle
                    </button>
                  </div>
                </div>
              )}
            </div>
        </div>

        {/* Footer */}
          <div className="mt-8 bg-white/80 backdrop-blur-sm rounded-xl border border-gray-200/50 p-4 shadow-sm">
            <div className="flex items-center justify-center">
              <Link to="/" className="flex items-center gap-2 group">
                <div className="w-8 h-8 bg-gradient-to-br from-primary-500 to-primary-600 rounded-lg flex items-center justify-center shadow-sm group-hover:shadow-md transition-all">
                  <span className="text-white font-bold text-base">D</span>
                </div>
                <span className="text-base font-bold bg-gradient-to-r from-gray-900 to-gray-700 bg-clip-text text-transparent">
                  Davetim
                </span>
              </Link>
            </div>
          </div>
        </div>
          </div>
        )}

      {/* Custom Animations */}
      <style>{`
        @keyframes bounce {
          0%, 100% { 
            transform: translateX(-50%) translateY(0); 
          }
          50% { 
            transform: translateX(-50%) translateY(-10px); 
          }
        }
        
        @keyframes pulse {
          0%, 100% { 
            opacity: 1; 
          }
          50% { 
            opacity: 0.6; 
          }
        }
      `}</style>
    </div>
  );
};

export default RSVPPage;