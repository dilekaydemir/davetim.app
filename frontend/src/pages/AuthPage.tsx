import React from 'react';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import { Eye, EyeOff, Mail, Lock, User, Loader2 } from 'lucide-react';
import { useAuth } from '../store/authStore';
import toast from 'react-hot-toast';

interface AuthPageProps {
  mode: 'login' | 'signup' | 'forgot';
}

const AuthPage: React.FC<AuthPageProps> = ({ mode }) => {
  const navigate = useNavigate();
  const location = useLocation();
  const { signIn, signUp, signInWithGoogle, resetPassword, isLoading } = useAuth();
  
  const [showPassword, setShowPassword] = React.useState(false);
  const [formData, setFormData] = React.useState({
    email: '',
    password: '',
    fullName: '',
    confirmPassword: ''
  });

  // Get the return URL from location state
  const from = (location.state as any)?.from?.pathname || '/dashboard';

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    console.log('🔄 Form submitted, mode:', mode, 'formData:', formData);
    
    // Prevent form submission if already loading
    if (isLoading) {
      console.log('⏳ Already loading, skipping submission');
      return;
    }

    try {
      if (mode === 'signup') {
        // Validate confirm password
        if (formData.password !== formData.confirmPassword) {
          toast.error('Şifreler eşleşmiyor', { duration: 6000 });
          return;
        }

        // Validate password length
        if (formData.password.length < 6) {
          toast.error('Şifre en az 6 karakter olmalıdır', { duration: 6000 });
          return;
        }

        // Validate email
        if (!formData.email || !formData.fullName.trim()) {
          toast.error('Lütfen tüm alanları doldurun', { duration: 6000 });
          return;
        }

        console.log('📝 Attempting signup...');
        const result = await signUp({
          email: formData.email,
          password: formData.password,
          fullName: formData.fullName,
        }) as { user: any; session: any };
        
        // Only navigate to dashboard if user has confirmed session
        // Otherwise, stay on auth page for email confirmation
        if (result.session) {
          navigate(from, { replace: true });
        }
        // If no session, user needs to confirm email first - stay on auth page
        
      } else if (mode === 'login') {
        // Validate form data
        if (!formData.email || !formData.password) {
          toast.error('Lütfen e-posta ve şifrenizi girin', { duration: 6000 });
          return;
        }
        const result = await signIn({
          email: formData.email,
          password: formData.password,
        }) as { user: any; session: any };
        
        // Navigate to dashboard on successful login
        if (result.session) {
          navigate(from, { replace: true });
        } else {
          toast.error('Lütfen önce e-postanızı doğrulayın.');
        }
        
      } else if (mode === 'forgot') {
        // Validate email
        if (!formData.email) {
          toast.error('Lütfen e-posta adresinizi girin', { duration: 6000 });
          return;
        }

        await resetPassword({ email: formData.email });
        // Don't navigate on forgot password, just show success message
      }
    } catch (error: any) {
      // Error is already handled and toast shown in authService
      // Just log for debugging - no duplicate toasts
      console.error('❌ Auth operation failed:', error.message || 'Unknown error');
    }
  };

  const handleGoogleSignIn = async () => {
    try {
      await signInWithGoogle();
      // Redirect will be handled by OAuth callback
    } catch (error) {
      console.error('Google sign in error:', error);
    }
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const getTitle = () => {
    switch (mode) {
      case 'login': return 'Giriş Yap';
      case 'signup': return 'Hesap Oluştur';
      case 'forgot': return 'Şifremi Unuttum';
      default: return 'Giriş Yap';
    }
  };

  const getSubtitle = () => {
    switch (mode) {
      case 'login': return 'Davetim hesabınıza giriş yapın';
      case 'signup': return 'Hemen ücretsiz hesap oluşturun';
      case 'forgot': return 'E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim';
      default: return '';
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        {/* Logo */}
        <Link to="/" className="flex items-center justify-center space-x-2 mb-8">
          <div className="w-10 h-10 bg-primary-500 rounded-lg flex items-center justify-center">
            <span className="text-white font-bold text-xl">D</span>
          </div>
          <span className="text-2xl font-bold text-gray-900">Davetim</span>
        </Link>

        <h2 className="text-center text-3xl font-bold text-gray-900 mb-2">
          {getTitle()}
        </h2>
        <p className="text-center text-sm text-gray-600 mb-8">
          {getSubtitle()}
        </p>
      </div>

      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <div className="bg-white py-8 px-4 shadow-lg sm:rounded-lg sm:px-10">
          <form className="space-y-6" onSubmit={handleSubmit}>
            {mode === 'signup' && (
              <div>
                <label htmlFor="fullName" className="block text-sm font-medium text-gray-700">
                  Ad Soyad
                </label>
                <div className="mt-1 relative">
                  <User className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
                  <input
                    id="fullName"
                    name="fullName"
                    type="text"
                    required={mode === 'signup'}
                    value={formData.fullName}
                    onChange={handleInputChange}
                    className="input-field pl-10"
                    placeholder="Ad Soyad"
                  />
                </div>
              </div>
            )}

            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700">
                E-posta Adresi
              </label>
              <div className="mt-1 relative">
                <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
                <input
                  id="email"
                  name="email"
                  type="email"
                  required
                  value={formData.email}
                  onChange={handleInputChange}
                  className="input-field pl-10"
                  placeholder="ornek@email.com"
                />
              </div>
            </div>

            {mode !== 'forgot' && (
              <div>
                <label htmlFor="password" className="block text-sm font-medium text-gray-700">
                  Şifre
                </label>
                <div className="mt-1 relative">
                  <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
                  <input
                    id="password"
                    name="password"
                    type={showPassword ? 'text' : 'password'}
                    required
                    value={formData.password}
                    onChange={handleInputChange}
                    className="input-field pl-10 pr-10"
                    placeholder="En az 6 karakter"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                  >
                    {showPassword ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
                  </button>
                </div>
              </div>
            )}

            {mode === 'signup' && (
              <div>
                <label htmlFor="confirmPassword" className="block text-sm font-medium text-gray-700">
                  Şifre Tekrar
                </label>
                <div className="mt-1 relative">
                  <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
                  <input
                    id="confirmPassword"
                    name="confirmPassword"
                    type={showPassword ? 'text' : 'password'}
                    required={mode === 'signup'}
                    value={formData.confirmPassword}
                    onChange={handleInputChange}
                    className="input-field pl-10"
                    placeholder="Şifrenizi tekrar girin"
                  />
                </div>
              </div>
            )}

            <div>
              <button
                type="submit"
                disabled={isLoading}
                className="w-full btn-primary disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
              >
                {isLoading && <Loader2 className="h-4 w-4 animate-spin" />}
                {mode === 'login' ? 'Giriş Yap' : mode === 'signup' ? 'Hesap Oluştur' : 'Şifre Sıfırla'}
              </button>
            </div>
          </form>

          {/* Divider */}
          <div className="mt-6">
            <div className="relative">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-gray-300" />
              </div>
              <div className="relative flex justify-center text-sm">
                <span className="px-2 bg-white text-gray-500">veya</span>
              </div>
            </div>
          </div>

          {/* Google Sign In */}
          {mode !== 'forgot' && (
            <div className="mt-6">
              <button
                type="button"
                disabled={isLoading}
                className="w-full btn-secondary flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
                onClick={handleGoogleSignIn}
              >
                <img
                  className="h-5 w-5"
                  src="https://www.google.com/favicon.ico"
                  alt="Google"
                />
                Google ile {mode === 'login' ? 'Giriş Yap' : 'Devam Et'}
              </button>
            </div>
          )}

          {/* Links */}
          <div className="mt-6 text-center text-sm">
            {mode === 'login' && (
              <div className="space-y-2">
                <div>
                  <Link
                    to="/forgot-password"
                    className="text-primary-600 hover:text-primary-500"
                  >
                    Şifremi unuttum
                  </Link>
                </div>
                <div>
                  Hesabınız yok mu?{' '}
                  <Link
                    to="/signup"
                    className="text-primary-600 hover:text-primary-500 font-medium"
                  >
                    Hesap oluşturun
                  </Link>
                </div>
              </div>
            )}

            {mode === 'signup' && (
              <div>
                Zaten hesabınız var mı?{' '}
                <Link
                  to="/login"
                  className="text-primary-600 hover:text-primary-500 font-medium"
                >
                  Giriş yapın
                </Link>
              </div>
            )}

            {mode === 'forgot' && (
              <div>
                <Link
                  to="/login"
                  className="text-primary-600 hover:text-primary-500"
                >
                  Giriş sayfasına dön
                </Link>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default AuthPage;
