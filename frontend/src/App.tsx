import { Routes, Route } from 'react-router-dom'
import { Suspense } from 'react'

// Layout Components
import Layout from './components/Layout/Layout'
import LoadingSpinner from './components/UI/LoadingSpinner'

// Pages
import HomePage from './pages/HomePage'
import TemplatesPage from './pages/TemplatesPage'
import EditorPage from './pages/EditorPage'
import DashboardPage from './pages/DashboardPage'
import AuthPage from './pages/AuthPage'
import ResetPasswordPage from './pages/ResetPasswordPage'
import PricingPage from './pages/PricingPage'
import AccountPage from './pages/AccountPage'

// Protected Route Component
import ProtectedRoute from './components/Auth/ProtectedRoute'

function App() {
  return (
    <div className="App">
      <Suspense fallback={<LoadingSpinner />}>
        <Routes>
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
  )
}

export default App
