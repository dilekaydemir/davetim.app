#!/bin/bash

# Environment Setup Script
# Creates .env.local for development

echo "🔧 Setting up environment files..."
echo ""

# Check if .env.local already exists
if [ -f "frontend/.env.local" ]; then
    echo "⚠️  frontend/.env.local already exists!"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Cancelled. Existing .env.local kept."
        exit 0
    fi
fi

# Create .env.local from template
cat > frontend/.env.local << 'EOF'
# ===============================================
# LOCAL DEVELOPMENT ENVIRONMENT VARIABLES
# ===============================================
# Fill in your actual values below
# ===============================================

# Supabase Configuration
# Get from: https://app.supabase.com/project/_/settings/api
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here

# Payment API Configuration
VITE_PAYMENT_API_URL=http://localhost:5000/api/payment

# App Configuration
VITE_APP_NAME=Davetim
VITE_APP_URL=http://localhost:5173
VITE_APP_ENV=development

# Feature Flags
VITE_ENABLE_ANALYTICS=false
VITE_ENABLE_QR_MEDIA=true
VITE_ENABLE_PAYMENT=false
VITE_ENABLE_GOOGLE_OAUTH=false

# Optional Services
VITE_SENTRY_DSN=
VITE_GA_MEASUREMENT_ID=
EOF

echo "✅ Created frontend/.env.local"
echo ""
echo "📝 Next steps:"
echo "1. Edit frontend/.env.local"
echo "2. Add your Supabase URL and anon key"
echo "3. Run: cd frontend && npm install && npm run dev"
echo ""
echo "🔗 Get Supabase credentials:"
echo "   https://app.supabase.com/project/_/settings/api"

