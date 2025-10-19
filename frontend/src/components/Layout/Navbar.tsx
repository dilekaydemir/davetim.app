import React, { useEffect, useRef } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Menu, X, User, LogOut, Settings, LayoutDashboard } from 'lucide-react';
import { useAuth } from '../../store/authStore';
import { useSubscription } from '../../hooks/useSubscription';

const Navbar: React.FC = () => {
  const [isMenuOpen, setIsMenuOpen] = React.useState(false);
  const [isDropdownOpen, setIsDropdownOpen] = React.useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const navigate = useNavigate();
  const { isAuthenticated, user, signOut } = useAuth();
  const subscription = useSubscription();

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
    <nav className="bg-white shadow-lg border-b sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          {/* Logo */}
          <div className="flex items-center">
            <Link to="/" className="flex items-center space-x-2">
              <div className="w-8 h-8 bg-primary-500 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-lg">D</span>
              </div>
              <span className="text-xl font-bold text-gray-900">Davetim</span>
            </Link>
          </div>

          {/* Desktop Menu */}
          <div className="hidden md:flex items-center space-x-8">
            <Link
              to="/templates"
              className="text-gray-700 hover:text-primary-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
            >
              Şablonlar
            </Link>
            <Link
              to="/pricing"
              className="text-gray-700 hover:text-primary-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
            >
              Fiyatlar
            </Link>

            {isAuthenticated ? (
              <div className="flex items-center space-x-4">
                <Link
                  to="/dashboard"
                  className="text-gray-700 hover:text-primary-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                >
                  Panel
                </Link>
                <div className="relative" ref={dropdownRef}>
                  <button 
                    onClick={() => setIsDropdownOpen(!isDropdownOpen)}
                    className="flex items-center space-x-2 text-gray-700 hover:text-primary-600 px-3 py-2 rounded-md text-sm font-medium transition-colors touch-target"
                  >
                    <User className="h-4 w-4" />
                    <span>{user?.fullName || 'Kullanıcı'}</span>
                  </button>
                  
                  {/* Dropdown menu */}
                  {isDropdownOpen && (
                    <div className="absolute right-0 mt-2 w-56 bg-white border border-gray-200 rounded-md shadow-lg z-50 animate-fade-in">
                      <div className="px-4 py-3 border-b border-gray-200">
                        <p className="text-sm font-medium text-gray-900">{user?.fullName}</p>
                        <p className="text-sm text-gray-500">{user?.email}</p>
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800 mt-1">
                          {subscription.planName.toUpperCase()}
                        </span>
                      </div>
                      <div className="py-1">
                        <Link
                          to="/account"
                          onClick={() => setIsDropdownOpen(false)}
                          className="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                        >
                          <Settings className="h-4 w-4 mr-2" />
                          Hesap Ayarları
                        </Link>
                        <button
                          onClick={handleSignOut}
                          className="w-full text-left flex items-center px-4 py-2 text-sm text-red-700 hover:bg-red-50"
                        >
                          <LogOut className="h-4 w-4 mr-2" />
                          Çıkış Yap
                        </button>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            ) : (
              <div className="flex items-center space-x-4">
                <button
                  onClick={handleLogin}
                  className="text-gray-700 hover:text-primary-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
                >
                  Giriş
                </button>
                <button
                  onClick={handleSignup}
                  className="btn-primary"
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
              className="text-gray-700 hover:text-primary-600 p-2 rounded-md transition-colors"
            >
              {isMenuOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
            </button>
          </div>
        </div>

        {/* Mobile Menu */}
        {isMenuOpen && (
          <div className="md:hidden border-t border-gray-200">
            <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3 bg-white">
              <Link
                to="/templates"
                className="block px-3 py-2 rounded-md text-base font-medium text-gray-700 hover:text-primary-600 hover:bg-gray-50 transition-colors"
                onClick={() => setIsMenuOpen(false)}
              >
                Şablonlar
              </Link>
              <Link
                to="/pricing"
                className="block px-3 py-2 rounded-md text-base font-medium text-gray-700 hover:text-primary-600 hover:bg-gray-50 transition-colors"
                onClick={() => setIsMenuOpen(false)}
              >
                Fiyatlar
              </Link>
              
              {!isAuthenticated ? (
                <div className="pt-4 pb-3 border-t border-gray-200">
                  <div className="flex items-center px-3 space-y-2 flex-col">
                    <button
                      onClick={handleLogin}
                      className="w-full btn-secondary text-center"
                    >
                      Giriş
                    </button>
                    <button
                      onClick={handleSignup}
                      className="w-full btn-primary text-center"
                    >
                      Ücretsiz Başla
                    </button>
                  </div>
                </div>
              ) : (
                <div className="pt-4 pb-3 border-t border-gray-200">
                  <div className="flex items-center px-3 mb-3">
                    <div className="flex-shrink-0">
                      <div className="w-8 h-8 bg-primary-100 rounded-full flex items-center justify-center">
                        <User className="h-4 w-4 text-primary-600" />
                      </div>
                    </div>
                    <div className="ml-3">
                      <div className="text-base font-medium text-gray-800">{user?.fullName}</div>
                      <div className="text-sm text-gray-500">{user?.email}</div>
                      <span className="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800 mt-1">
                        {subscription.planName.toUpperCase()}
                      </span>
                    </div>
                  </div>
                  <div className="space-y-1 px-3">
                    <Link
                      to="/dashboard"
                      className="flex items-center px-3 py-2 rounded-md text-base font-medium text-gray-700 hover:text-primary-600 hover:bg-gray-50 transition-colors touch-target"
                      onClick={() => setIsMenuOpen(false)}
                    >
                      <LayoutDashboard className="h-4 w-4 mr-2" />
                      Panel
                    </Link>
                    <Link
                      to="/account"
                      className="flex items-center px-3 py-2 rounded-md text-base font-medium text-gray-700 hover:text-primary-600 hover:bg-gray-50 transition-colors touch-target"
                      onClick={() => setIsMenuOpen(false)}
                    >
                      <Settings className="h-4 w-4 mr-2" />
                      Hesap Ayarları
                    </Link>
                    <button
                      onClick={() => {
                        handleSignOut();
                        setIsMenuOpen(false);
                      }}
                      className="w-full text-left flex items-center px-3 py-2 rounded-md text-base font-medium text-red-700 hover:bg-red-50 transition-colors touch-target"
                    >
                      <LogOut className="h-4 w-4 mr-2" />
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
