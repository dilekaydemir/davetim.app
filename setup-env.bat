@echo off
REM Environment Setup Script for Windows
REM Creates .env.local for development

echo.
echo ============================================
echo   Environment Setup
echo ============================================
echo.

REM Check if .env.local already exists
if exist "frontend\.env.local" (
    echo WARNING: frontend\.env.local already exists!
    set /p overwrite="Do you want to overwrite it? (y/N): "
    if /i not "%overwrite%"=="y" (
        echo Cancelled. Existing .env.local kept.
        pause
        exit /b 0
    )
)

REM Create .env.local
(
echo # ===============================================
echo # LOCAL DEVELOPMENT ENVIRONMENT VARIABLES
echo # ===============================================
echo # Fill in your actual values below
echo # ===============================================
echo.
echo # Supabase Configuration
echo # Get from: https://app.supabase.com/project/_/settings/api
echo VITE_SUPABASE_URL=https://your-project-id.supabase.co
echo VITE_SUPABASE_ANON_KEY=your-anon-key-here
echo.
echo # Payment API Configuration
echo VITE_PAYMENT_API_URL=http://localhost:5000/api/payment
echo.
echo # App Configuration
echo VITE_APP_NAME=Davetim
echo VITE_APP_URL=http://localhost:5173
echo VITE_APP_ENV=development
echo.
echo # Feature Flags
echo VITE_ENABLE_ANALYTICS=false
echo VITE_ENABLE_QR_MEDIA=true
echo VITE_ENABLE_PAYMENT=false
echo VITE_ENABLE_GOOGLE_OAUTH=false
echo.
echo # Optional Services
echo VITE_SENTRY_DSN=
echo VITE_GA_MEASUREMENT_ID=
) > frontend\.env.local

echo.
echo [OK] Created frontend\.env.local
echo.
echo Next steps:
echo 1. Edit frontend\.env.local
echo 2. Add your Supabase URL and anon key
echo 3. Run: cd frontend ^&^& npm install ^&^& npm run dev
echo.
echo Get Supabase credentials:
echo    https://app.supabase.com/project/_/settings/api
echo.
pause

