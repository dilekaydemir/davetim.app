import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import { authService, type AuthUser, type SignUpData, type SignInData } from '../services/authService'
import type { Session } from '@supabase/supabase-js'

interface AuthState {
  // State
  user: AuthUser | null
  session: Session | null
  isLoading: boolean
  isInitialized: boolean

  // Actions
  initialize: () => Promise<void>
  signUp: (data: SignUpData) => Promise<{ user: any; session: any }>
  signIn: (data: SignInData) => Promise<{ user: any; session: any }>
  signInWithGoogle: () => Promise<void>
  signOut: () => Promise<void>
  resetPassword: (data: { email: string }) => Promise<void>
  updateProfile: (data: { fullName?: string; phone?: string; avatarUrl?: string }) => Promise<void>
  clearError: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      // Initial state
      user: null,
      session: null,
      isLoading: false,
      isInitialized: false,

      // Initialize auth state
      initialize: async () => {
        if (get().isInitialized) return
        
        set({ isLoading: true })

        try {
          // Get current session and user
          const session = await authService.getCurrentSession()
          const user = await authService.getCurrentUser()

          set({
            session,
            user,
            isInitialized: true,
            isLoading: false
          })

          // Listen to auth state changes
          authService.onAuthStateChange(async (event, session) => {
            console.log('Auth state changed:', event, session);

            if (event === 'SIGNED_IN' && session) {
              const user = await authService.getCurrentUser()
              set({ session, user })
            } else if (event === 'SIGNED_OUT') {
              set({ session: null, user: null })
            } else if (event === 'TOKEN_REFRESHED' && session) {
              set({ session })
            }
          })
        } catch (error) {
          console.error('Auth initialization error:', error)
          set({
            session: null,
            user: null,
            isInitialized: true,
            isLoading: false
          })
        }
      },

      // Sign up
      signUp: async (data: SignUpData) => {
        set({ isLoading: true })

        try {
          const result = await authService.signUp(data)
          
          if (result.user && result.session) {
            const user = await authService.getCurrentUser()
            set({
              session: result.session,
              user,
              isLoading: false
            })
          } else {
            set({ isLoading: false })
          }
          
          return result
        } catch (error) {
          set({ isLoading: false })
          throw error
        }
      },

      // Sign in
      signIn: async (data: SignInData) => {
        set({ isLoading: true })

        try {
          const result = await authService.signIn(data)
          
          if (result.user && result.session) {
            const user = await authService.getCurrentUser()
            set({
              session: result.session,
              user,
              isLoading: false
            })
          } else {
            set({ isLoading: false })
          }
          
          return result
        } catch (error) {
          set({ isLoading: false })
          throw error
        }
      },

      // Google sign in
      signInWithGoogle: async () => {
        set({ isLoading: true })

        try {
          await authService.signInWithGoogle()
          // Auth state will be updated by the onAuthStateChange listener
          set({ isLoading: false })
        } catch (error) {
          set({ isLoading: false })
          throw error
        }
      },

      // Sign out
      signOut: async () => {
        set({ isLoading: true })

        try {
          await authService.signOut()
          set({
            user: null,
            session: null,
            isLoading: false
          })
        } catch (error) {
          set({ isLoading: false })
          throw error
        }
      },

      // Reset password
      resetPassword: async (data: { email: string }) => {
        set({ isLoading: true })

        try {
          await authService.resetPassword(data)
          set({ isLoading: false })
        } catch (error) {
          set({ isLoading: false })
          throw error
        }
      },

      // Update profile
      updateProfile: async (data: { fullName?: string; phone?: string; avatarUrl?: string }) => {
        set({ isLoading: true })

        try {
          await authService.updateProfile(data)
          
          // Refresh user data
          const user = await authService.getCurrentUser()
          set({
            user,
            isLoading: false
          })
        } catch (error) {
          set({ isLoading: false })
          throw error
        }
      },

      // Clear any errors (if needed for UI feedback)
      clearError: () => {
        // This can be used for clearing UI error states
      },
    }),
    {
      name: 'auth-store',
      partialize: (state) => ({
        // Only persist user and session, not loading states
        user: state.user,
        session: state.session,
        isInitialized: state.isInitialized
      }),
    }
  )
)

// Helper hooks for easier usage
export const useAuth = () => {
  const store = useAuthStore()
  
  return {
    // State
    user: store.user,
    session: store.session,
    isLoading: store.isLoading,
    isAuthenticated: !!store.user,
    isInitialized: store.isInitialized,

    // Actions
    initialize: store.initialize,
    signUp: store.signUp as (data: SignUpData) => Promise<{ user: any; session: any }>,
    signIn: store.signIn as (data: SignInData) => Promise<{ user: any; session: any }>,
    signInWithGoogle: store.signInWithGoogle,
    signOut: store.signOut,
    resetPassword: store.resetPassword,
    updateProfile: store.updateProfile,
  }
}
