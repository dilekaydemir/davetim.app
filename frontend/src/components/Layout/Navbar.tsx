import React, { useEffect, useRef } from 'react';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import { Menu, X, User, LogOut, Settings, LayoutDashboard, Crown } from 'lucide-react';
import { useAuth } from '../../store/authStore';
import { useSubscription } from '../../hooks/useSubscription';

const Navbar: React.FC = () => {
  const [isMenuOpen, setIsMenuOpen] = React.useState(false);
  const [isDropdownOpen, setIsDropdownOpen] = React.useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const navigate = useNavigate();
  const location = useLocation();
  const { isAuthenticated, user, signOut } = useAuth();
  const subscription = useSubscription();

  // Helper to check if link is active
  const isActive = (path: string) => {
    if (path === '/') {
      return location.pathname === '/';
    }
    return location.pathname.startsWith(path);
  };

  const handleLogin = () => {
    navigate('/login');
  };

  const handleSignup = () => {
    navigate('/signup');
  };

  const handleSignOut = async () => {
    try {
      await signOut();
      navigate('/');
    } catch (error) {
      console.error('Sign out error:', error);
    }
  };

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsDropdownOpen(false);
      }
    };

    if (isDropdownOpen) {
      document.addEventListener('mousedown', handleClickOutside);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [isDropdownOpen]);

  // Close mobile menu when route changes
  useEffect(() => {
    setIsMenuOpen(false);
  }, [navigate]);

  return (
    <nav className="bg-white/95 backdrop-blur-md shadow-sm border-b border-gray-100 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-14">
          {/* Logo */}
          <div className="flex items-center">
            <Link to="/" className="flex items-center gap-2 group">
              <div className="w-9 h-9 bg-gradient-to-br from-primary-500 to-primary-600 rounded-xl flex items-center justify-center shadow-sm group-hover:shadow-md transition-all">
                <span className="text-white font-bold text-lg">D</span>
              </div>
              <span className="text-xl font-bold bg-gradient-to-r from-gray-900 to-gray-700 bg-clip-text text-transparent">
                Davetim
              </span>
            </Link>
          </div>

          {/* Desktop Menu */}
          <div className="hidden md:flex items-center gap-1">
            <Link
              to="/templates"
              className={`relative px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                isActive('/templates')
                  ? 'text-primary-600 bg-primary-50'
                  : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
              }`}
            >
              Şablonlar
              {isActive('/templates') && (
                <span className="absolute bottom-0 left-1/2 -translate-x-1/2 w-8 h-0.5 bg-primary-600 rounded-full" />
              )}
            </Link>
            <Link
              to="/pricing"
              className={`relative px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                isActive('/pricing')
                  ? 'text-primary-600 bg-primary-50'
                  : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
              }`}
            >
              Fiyatlar
              {isActive('/pricing') && (
                <span className="absolute bottom-0 left-1/2 -translate-x-1/2 w-8 h-0.5 bg-primary-600 rounded-full" />
              )}
            </Link>
            <Link
              to="/about"
              className={`relative px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                isActive('/about')
                  ? 'text-primary-600 bg-primary-50'
                  : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
              }`}
            >
              Hakkımızda
              {isActive('/about') && (
                <span className="absolute bottom-0 left-1/2 -translate-x-1/2 w-8 h-0.5 bg-primary-600 rounded-full" />
              )}
            </Link>
            <Link
              to="/contact"
              className={`relative px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                isActive('/contact')
                  ? 'text-primary-600 bg-primary-50'
                  : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
              }`}
            >
              İletişim
              {isActive('/contact') && (
                <span className="absolute bottom-0 left-1/2 -translate-x-1/2 w-8 h-0.5 bg-primary-600 rounded-full" />
              )}
            </Link>

            {isAuthenticated ? (
              <div className="flex items-center gap-2 ml-4">
                <Link
                  to="/dashboard"
                  className={`relative px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                    isActive('/dashboard')
                      ? 'text-primary-600 bg-primary-50'
                      : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                  }`}
                >
                  Panel
                  {isActive('/dashboard') && (
                    <span className="absolute bottom-0 left-1/2 -translate-x-1/2 w-8 h-0.5 bg-primary-600 rounded-full" />
                  )}
                </Link>
                
                {/* User Dropdown */}
                <div className="relative ml-2" ref={dropdownRef}>
                  <button 
                    onClick={() => setIsDropdownOpen(!isDropdownOpen)}
                    className={`flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium transition-all touch-target ${
                      isActive('/account')
                        ? 'text-primary-600 bg-primary-50'
                        : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                    }`}
                  >
                    <div className="w-7 h-7 bg-gradient-to-br from-primary-500 to-primary-600 rounded-lg flex items-center justify-center">
                      <User className="h-4 w-4 text-white" />
                    </div>
                    <span className="max-w-[100px] truncate">{user?.fullName || 'Kullanıcı'}</span>
                  </button>
                  
                  {/* Modern Dropdown menu */}
                  {isDropdownOpen && (
                    <div className="absolute right-0 mt-2 w-64 bg-white border border-gray-100 rounded-xl shadow-xl z-50 animate-fade-in overflow-hidden">
                      {/* User Info */}
                      <div className="px-4 py-3 bg-gradient-to-br from-primary-50 to-blue-50 border-b border-gray-100">
                        <p className="text-sm font-semibold text-gray-900 truncate">{user?.fullName}</p>
                        <p className="text-xs text-gray-600 truncate">{user?.email}</p>
                        <div className="flex items-center gap-2 mt-2">
                          {subscription.isPremiumPlan && (
                            <span className="inline-flex items-center gap-1 px-2 py-1 rounded-md text-xs font-medium bg-gradient-to-r from-purple-100 to-pink-100 text-purple-700">
                              <Crown className="h-3 w-3" />
                              {subscription.planName.toUpperCase()}
                            </span>
                          )}
                          {subscription.isProPlan && (
                            <span className="inline-flex items-center px-2 py-1 rounded-md text-xs font-medium bg-primary-100 text-primary-700">
                              {subscription.planName.toUpperCase()}
                            </span>
                          )}
                          {subscription.isFreePlan && (
                            <span className="inline-flex items-center px-2 py-1 rounded-md text-xs font-medium bg-gray-100 text-gray-700">
                              {subscription.planName.toUpperCase()}
                            </span>
                          )}
                        </div>
                      </div>
                      
                      {/* Menu Items */}
                      <div className="py-2">
                        <Link
                          to="/account"
                          onClick={() => setIsDropdownOpen(false)}
                          className="flex items-center gap-3 px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-50 transition-colors"
                        >
                          <Settings className="h-4 w-4 text-gray-400" />
                          <span>Hesap Ayarları</span>
                        </Link>
                        <button
                          onClick={handleSignOut}
                          className="w-full text-left flex items-center gap-3 px-4 py-2.5 text-sm text-red-600 hover:bg-red-50 transition-colors"
                        >
                          <LogOut className="h-4 w-4" />
                          <span>Çıkış Yap</span>
                        </button>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            ) : (
              <div className="flex items-center gap-2 ml-4">
                <button
                  onClick={handleLogin}
                  className="px-4 py-2 rounded-lg text-sm font-medium text-gray-600 hover:text-gray-900 hover:bg-gray-50 transition-all"
                >
                  Giriş
                </button>
                <button
                  onClick={handleSignup}
                  className="px-5 py-2 rounded-lg text-sm font-medium bg-gradient-to-r from-primary-600 to-primary-700 text-white hover:from-primary-700 hover:to-primary-800 shadow-sm hover:shadow-md transition-all"
                >
                  Ücretsiz Başla
                </button>
              </div>
            )}
          </div>

          {/* Mobile menu button */}
          <div className="md:hidden flex items-center">
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="p-2 rounded-lg text-gray-600 hover:text-gray-900 hover:bg-gray-50 transition-all"
              aria-label="Menu"
            >
              {isMenuOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
            </button>
          </div>
        </div>

        {/* Mobile Menu */}
        {isMenuOpen && (
          <div className="md:hidden border-t border-gray-100 animate-fade-in">
            <div className="px-3 py-3 space-y-1 bg-white">
              <Link
                to="/templates"
                className={`block px-4 py-2.5 rounded-lg text-sm font-medium transition-all touch-target ${
                  isActive('/templates')
                    ? 'text-primary-600 bg-primary-50'
                    : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                }`}
                onClick={() => setIsMenuOpen(false)}
              >
                Şablonlar
              </Link>
              <Link
                to="/pricing"
                className={`block px-4 py-2.5 rounded-lg text-sm font-medium transition-all touch-target ${
                  isActive('/pricing')
                    ? 'text-primary-600 bg-primary-50'
                    : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                }`}
                onClick={() => setIsMenuOpen(false)}
              >
                Fiyatlar
              </Link>
              <Link
                to="/about"
                className={`block px-4 py-2.5 rounded-lg text-sm font-medium transition-all touch-target ${
                  isActive('/about')
                    ? 'text-primary-600 bg-primary-50'
                    : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                }`}
                onClick={() => setIsMenuOpen(false)}
              >
                Hakkımızda
              </Link>
              <Link
                to="/contact"
                className={`block px-4 py-2.5 rounded-lg text-sm font-medium transition-all touch-target ${
                  isActive('/contact')
                    ? 'text-primary-600 bg-primary-50'
                    : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                }`}
                onClick={() => setIsMenuOpen(false)}
              >
                İletişim
              </Link>
              
              {!isAuthenticated ? (
                <div className="pt-3 border-t border-gray-100 space-y-2">
                  <button
                    onClick={handleLogin}
                    className="w-full px-4 py-2.5 rounded-lg text-sm font-medium text-gray-600 hover:text-gray-900 hover:bg-gray-50 transition-all text-center"
                  >
                    Giriş
                  </button>
                  <button
                    onClick={handleSignup}
                    className="w-full px-4 py-2.5 rounded-lg text-sm font-medium bg-gradient-to-r from-primary-600 to-primary-700 text-white hover:from-primary-700 hover:to-primary-800 shadow-sm transition-all text-center"
                  >
                    Ücretsiz Başla
                  </button>
                </div>
              ) : (
                <div className="pt-3 border-t border-gray-100">
                  {/* User Info Card */}
                  <div className="px-1 mb-3">
                    <div className="bg-gradient-to-br from-primary-50 to-blue-50 rounded-xl p-3">
                      <div className="flex items-center gap-3">
                        <div className="flex-shrink-0">
                          <div className="w-10 h-10 bg-gradient-to-br from-primary-500 to-primary-600 rounded-xl flex items-center justify-center shadow-sm">
                            <User className="h-5 w-5 text-white" />
                          </div>
                        </div>
                        <div className="flex-1 min-w-0">
                          <div className="text-sm font-semibold text-gray-900 truncate">{user?.fullName}</div>
                          <div className="text-xs text-gray-600 truncate">{user?.email}</div>
                          <div className="mt-1.5">
                            {subscription.isPremiumPlan && (
                              <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-xs font-medium bg-gradient-to-r from-purple-100 to-pink-100 text-purple-700">
                                <Crown className="h-3 w-3" />
                                {subscription.planName.toUpperCase()}
                              </span>
                            )}
                            {subscription.isProPlan && (
                              <span className="inline-flex items-center px-2 py-0.5 rounded-md text-xs font-medium bg-white/50 text-primary-700">
                                {subscription.planName.toUpperCase()}
                              </span>
                            )}
                            {subscription.isFreePlan && (
                              <span className="inline-flex items-center px-2 py-0.5 rounded-md text-xs font-medium bg-white/50 text-gray-700">
                                {subscription.planName.toUpperCase()}
                              </span>
                            )}
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  {/* Menu Items */}
                  <div className="space-y-1">
                    <Link
                      to="/dashboard"
                      className={`flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium transition-all touch-target ${
                        isActive('/dashboard')
                          ? 'text-primary-600 bg-primary-50'
                          : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                      }`}
                      onClick={() => setIsMenuOpen(false)}
                    >
                      <LayoutDashboard className="h-4 w-4" />
                      Panel
                    </Link>
                    <Link
                      to="/account"
                      className={`flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium transition-all touch-target ${
                        isActive('/account')
                          ? 'text-primary-600 bg-primary-50'
                          : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                      }`}
                      onClick={() => setIsMenuOpen(false)}
                    >
                      <Settings className="h-4 w-4" />
                      Hesap Ayarları
                    </Link>
                    <button
                      onClick={() => {
                        handleSignOut();
                        setIsMenuOpen(false);
                      }}
                      className="w-full text-left flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium text-red-600 hover:bg-red-50 transition-all touch-target"
                    >
                      <LogOut className="h-4 w-4" />
                      Çıkış Yap
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </nav>
  );
};

export default Navbar;
