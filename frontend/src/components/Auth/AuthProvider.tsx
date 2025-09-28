import React, { useEffect } from 'react';
import { useAuth } from '../../store/authStore';
import { supabase } from '../../services/supabase';
import toast from 'react-hot-toast';
import LoadingSpinner from '../UI/LoadingSpinner';

interface AuthProviderProps {
  children: React.ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const { isInitialized, isLoading, initialize } = useAuth();

  useEffect(() => {
    // Initialize auth on app start
    if (!isInitialized) {
      initialize();
    }

    // Listen for auth changes (like email confirmation)
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        // Only log important auth events
        if (event !== 'INITIAL_SESSION') {
          console.log('🔔 Auth event:', event, session?.user?.email);
        }
        
        if (event === 'SIGNED_IN' && session) {
          // Don't show toast for initial page load or for programmatic sign-ins
          // The authService already shows success toasts
          return;
        } else if (event === 'SIGNED_OUT') {
          console.log('👋 User signed out');
        } else if (event === 'PASSWORD_RECOVERY') {
          toast.success('Şifre sıfırlama e-postası gönderildi!');
        }
      }
    );

    return () => {
      subscription.unsubscribe();
    };
  }, [isInitialized, initialize]);

  // Show loading spinner while initializing auth
  if (!isInitialized || isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="mb-4">
            <div className="w-10 h-10 bg-primary-500 rounded-lg flex items-center justify-center mx-auto">
              <span className="text-white font-bold text-xl">D</span>
            </div>
          </div>
          <LoadingSpinner size="lg" message="Davetim yükleniyor..." />
        </div>
      </div>
    );
  }

  return <>{children}</>;
};
