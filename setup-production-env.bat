@echo off
REM ===============================================
REM PRODUCTION ENVIRONMENT SETUP (Windows)
REM ===============================================
REM This script creates production .env files
REM WARNING: ONLY USE FOR PRODUCTION DEPLOYMENT!
REM ===============================================

echo.
echo ================================================
echo   PRODUCTION ENVIRONMENT SETUP
echo ================================================
echo.
echo WARNING: This will create production .env files!
echo Make sure you're deploying to production server.
echo.
set /p confirm="Continue? (yes/no): "

if not "%confirm%"=="yes" (
    echo.
    echo Cancelled.
    exit /b 1
)

echo.
echo Creating frontend/.env...
echo.

REM Create frontend/.env
(
echo # ===============================================
echo # PRODUCTION ENVIRONMENT VARIABLES
echo # ===============================================
echo # WARNING: PRODUCTION ONLY - DO NOT USE IN DEVELOPMENT
echo # ===============================================
echo.
echo # Supabase Configuration ^(Production^)
echo # Get from: https://app.supabase.com/project/_/settings/api
echo VITE_SUPABASE_URL=https://your-project-id.supabase.co
echo VITE_SUPABASE_ANON_KEY=your-production-anon-key-here
echo.
echo # Payment API Configuration ^(Production^)
echo VITE_PAYMENT_API_URL=https://payment.dilcomsys.com/api/payment
echo.
echo # App Configuration ^(Production^)
echo VITE_APP_NAME=Davetim
echo VITE_APP_URL=https://davetim.app
echo VITE_APP_ENV=production
echo.
echo # Feature Flags ^(Production^)
echo VITE_ENABLE_ANALYTICS=true
echo VITE_ENABLE_QR_MEDIA=true
echo VITE_ENABLE_PAYMENT=true
echo VITE_ENABLE_GOOGLE_OAUTH=true
echo.
echo # Optional Services ^(Production^)
echo VITE_SENTRY_DSN=
echo VITE_GA_MEASUREMENT_ID=
) > frontend\.env

echo.
echo ================================================
echo   SETUP COMPLETE
echo ================================================
echo.
echo Next steps:
echo.
echo 1. Edit frontend\.env and fill in your PRODUCTION values:
echo    - VITE_SUPABASE_URL
echo    - VITE_SUPABASE_ANON_KEY
echo.
echo 2. Verify payment API URL:
echo    - VITE_PAYMENT_API_URL=https://payment.dilcomsys.com/api/payment
echo.
echo 3. Build frontend:
echo    cd frontend
echo    npm run build
echo.
echo 4. Deploy:
echo    docker-compose up -d
echo.
echo 5. Test payment flow:
echo    https://davetim.app/pricing
echo.
echo Full checklist: docs\PAYMENT-PRODUCTION-CHECKLIST.md
echo.
echo ================================================
echo.
pause

