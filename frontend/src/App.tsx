import { Routes, Route } from 'react-router-dom'
import { Suspense, lazy } from 'react'

// Layout Components (keep these eager loaded - small and always needed)
import Layout from './components/Layout/Layout'
import LoadingSpinner from './components/UI/LoadingSpinner'
import ErrorBoundary from './components/Common/ErrorBoundary'
import { NetworkStatus } from './components/Common/NetworkStatus'
import ProtectedRoute from './components/Auth/ProtectedRoute'

// Lazy load pages for code splitting
const HomePage = lazy(() => import('./pages/HomePage'))
const TemplatesPage = lazy(() => import('./pages/TemplatesPage'))
const EditorPage = lazy(() => import('./pages/EditorPage'))
const DashboardPage = lazy(() => import('./pages/DashboardPage'))
const AuthPage = lazy(() => import('./pages/AuthPage'))
const ResetPasswordPage = lazy(() => import('./pages/ResetPasswordPage'))
const PricingPage = lazy(() => import('./pages/PricingPage'))
const AccountPage = lazy(() => import('./pages/AccountPage'))
const PublicInvitationPage = lazy(() => import('./pages/PublicInvitationPage'))
const RSVPPage = lazy(() => import('./pages/RSVPPage'))

function App() {
  return (
    <ErrorBoundary>
      <div className="App">
        <NetworkStatus />
        <Suspense fallback={<LoadingSpinner />}>
          <Routes>
          {/* Public Invitation View (No Layout) */}
          <Route path="/i/:invitationId" element={<PublicInvitationPage />} />
          
          {/* Public RSVP Page (No Layout) */}
          <Route path="/rsvp/:guestToken" element={<RSVPPage />} />

          {/* Public Routes */}
          <Route path="/" element={<Layout />}>
            <Route index element={<HomePage />} />
            <Route path="templates" element={<TemplatesPage />} />
            <Route path="pricing" element={<PricingPage />} />
            <Route path="auth" element={<AuthPage mode="login" />} />
            <Route path="login" element={<AuthPage mode="login" />} />
            <Route path="signup" element={<AuthPage mode="signup" />} />
            <Route path="forgot-password" element={<AuthPage mode="forgot" />} />
            <Route path="reset-password" element={<ResetPasswordPage />} />
            
            {/* Protected Routes */}
            <Route path="dashboard" element={
              <ProtectedRoute>
                <DashboardPage />
              </ProtectedRoute>
            } />
            <Route path="editor/:templateId?" element={
              <ProtectedRoute>
                <EditorPage />
              </ProtectedRoute>
            } />
            <Route path="account" element={
              <ProtectedRoute>
                <AccountPage />
              </ProtectedRoute>
            } />
          </Route>
          </Routes>
        </Suspense>
      </div>
    </ErrorBoundary>
  )
}

export default App
