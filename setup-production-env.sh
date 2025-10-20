#!/bin/bash

# ===============================================
# PRODUCTION ENVIRONMENT SETUP
# ===============================================
# This script creates production .env files
# ⚠️ ONLY USE FOR PRODUCTION DEPLOYMENT!
# ===============================================

echo "🚀 Setting up PRODUCTION environment..."
echo ""
echo "⚠️  WARNING: This will create production .env files!"
echo "⚠️  Make sure you're deploying to production server."
echo ""
read -p "Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Cancelled."
    exit 1
fi

# Create frontend/.env
cat > frontend/.env << 'EOF'
# ===============================================
# PRODUCTION ENVIRONMENT VARIABLES
# ===============================================
# ⚠️ PRODUCTION ONLY - DO NOT USE IN DEVELOPMENT
# ===============================================

# Supabase Configuration (Production)
# Get from: https://app.supabase.com/project/_/settings/api
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-production-anon-key-here

# Payment API Configuration (Production)
VITE_PAYMENT_API_URL=https://payment.dilcomsys.com/api/payment

# App Configuration (Production)
VITE_APP_NAME=Davetim
VITE_APP_URL=https://davetim.app
VITE_APP_ENV=production

# Feature Flags (Production)
VITE_ENABLE_ANALYTICS=true
VITE_ENABLE_QR_MEDIA=true
VITE_ENABLE_PAYMENT=true
VITE_ENABLE_GOOGLE_OAUTH=true

# Optional Services (Production)
VITE_SENTRY_DSN=
VITE_GA_MEASUREMENT_ID=
EOF

echo "✅ Created: frontend/.env"
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Edit frontend/.env and fill in your PRODUCTION values:"
echo "   - VITE_SUPABASE_URL"
echo "   - VITE_SUPABASE_ANON_KEY"
echo ""
echo "2. Verify payment API URL:"
echo "   - VITE_PAYMENT_API_URL=https://payment.dilcomsys.com/api/payment"
echo ""
echo "3. Build frontend:"
echo "   cd frontend"
echo "   npm run build"
echo ""
echo "4. Deploy:"
echo "   docker-compose up -d"
echo ""
echo "5. Test payment flow:"
echo "   https://davetim.app/pricing"
echo ""
echo "📚 Full checklist: docs/PAYMENT-PRODUCTION-CHECKLIST.md"
echo ""
echo "✅ Setup complete!"

