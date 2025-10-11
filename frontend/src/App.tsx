import { Routes, Route } from 'react-router-dom'
import { Suspense } from 'react'

// Layout Components
import Layout from './components/Layout/Layout'
import LoadingSpinner from './components/UI/LoadingSpinner'
import ErrorBoundary from './components/Common/ErrorBoundary'
import { NetworkStatus } from './components/Common/NetworkStatus'

// Pages
import HomePage from './pages/HomePage'
import TemplatesPage from './pages/TemplatesPage'
import EditorPage from './pages/EditorPage'
import DashboardPage from './pages/DashboardPage'
import AuthPage from './pages/AuthPage'
import ResetPasswordPage from './pages/ResetPasswordPage'
import PricingPage from './pages/PricingPage'
import AccountPage from './pages/AccountPage'
import PublicInvitationPage from './pages/PublicInvitationPage'
import RSVPPage from './pages/RSVPPage'

// Protected Route Component
import ProtectedRoute from './components/Auth/ProtectedRoute'

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
