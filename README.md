# 🎉 Davetim.app - Digital Invitation Platform

> Modern, fast, and beautiful digital invitation platform for Turkish market

[![Production Ready](https://img.shields.io/badge/status-production%20ready-success)](https://github.com/yourusername/davetim.app)
[![Version](https://img.shields.io/badge/version-2.0.0-blue)](https://github.com/yourusername/davetim.app)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 🌟 Features

- ✨ **Beautiful Templates** - 50+ professional invitation templates
- 🎨 **Custom Design** - Full customization (colors, fonts, layouts)
- 📱 **Responsive** - Works perfectly on all devices
- 🔐 **Secure** - Enterprise-grade security with Supabase
- 📊 **Analytics** - Track views, RSVPs, and engagement
- 💳 **Payment** - İyzico integration for subscriptions
- 🎯 **QR Media** - Premium feature for video invitations
- 📤 **Easy Sharing** - WhatsApp, Instagram, direct links
- 📥 **Export** - PDF, PNG, Excel guest lists

## 🚀 Quick Start

### ⭐ **Start Here:** [BASLA-BURADAN-V2.md](./BASLA-BURADAN-V2.md)

Complete step-by-step guide (in Turkish).

**Time needed:** ~30 minutes for development setup

### Prerequisites

- Node.js 18+ (https://nodejs.org/)
- Supabase Account (https://supabase.com)

### Installation (3 Steps)

```bash
# 1. Setup environment
./setup-env.sh          # Linux/Mac
setup-env.bat           # Windows

# 2. Install dependencies
cd frontend
npm install

# 3. Start development server
npm run dev
```

Visit: http://localhost:5173

## 📁 Project Structure

### Environment Files

```
frontend/
├── .env                → ❌ Production template (not committed)
├── .env.local          → ❌ Development (YOU CREATE THIS)
└── .env.example        → ✅ Template (committed)
```

### Docker Files

```
├── docker-compose.yml          → Production (port 80)
├── docker-compose.local.yml    → Development (port 5173)
├── Dockerfile                  → Production (nginx + multi-stage)
└── Dockerfile.dev              → Development (vite dev server)
```

## 🗄️ Database Setup

### Quick Setup (20 minutes)

```bash
# 1. Create Supabase project at https://supabase.com
# 2. Get API credentials (Settings > API)
# 3. Add to frontend/.env.local
# 4. Run migrations in SQL Editor:
```

- `database/00-COMPLETE-CLEANUP.sql`
- `database/01-COMPLETE-REBUILD.sql`

**Detailed guide:** [database/HIZLI-BASLANGIÇ.md](./database/HIZLI-BASLANGIÇ.md)

## 📚 Documentation

### Essential Guides

| Document | Description | Time |
|----------|-------------|------|
| **[BASLA-BURADAN-V2.md](./BASLA-BURADAN-V2.md)** | Quick start guide ⭐ | 5 min |
| **[ENV-SETUP-GUIDE.md](./frontend/ENV-SETUP-GUIDE.md)** | Environment setup | 10 min |
| **[DOCKER-GUIDE.md](./DOCKER-GUIDE.md)** | Docker usage | 10 min |
| **[DEPLOYMENT-GUIDE.md](./DEPLOYMENT-GUIDE.md)** | Production deployment | 45 min |
| **[PROJECT-SUMMARY.md](./PROJECT-SUMMARY.md)** | Project overview | 5 min |

### Database

| Document | Description |
|----------|-------------|
| **[database/README.md](./database/README.md)** | Database documentation |
| **[database/HIZLI-BASLANGIÇ.md](./database/HIZLI-BASLANGIÇ.md)** | Quick start (Turkish) |

## 🏗️ Tech Stack

### Frontend
- **React 18.2** - UI library
- **TypeScript 5.0** - Type safety
- **Vite 4.4** - Build tool
- **Tailwind CSS 3.3** - Styling
- **Zustand 4.4** - State management
- **React Router 6** - Routing

### Backend
- **Supabase** - BaaS platform
  - PostgreSQL database
  - Authentication
  - Storage
  - Real-time subscriptions

### Payment
- **İyzico** - Payment gateway

## 🔧 Development

### Available Scripts

```bash
# Development
npm run dev              # Start dev server (port 5173)
npm run build            # Build for production
npm run build:prod       # Build with production mode
npm run preview          # Preview build locally
npm run preview:prod     # Preview on port 4173
npm run lint             # Run ESLint
npm run type-check       # TypeScript check
npm run clean            # Clean dist and cache

# Docker
npm run docker:dev       # Run with Docker (development)
npm run docker:prod      # Run with Docker (production)
```

### Environment Variables

**Development:** `frontend/.env.local`

```env
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=your-key
VITE_APP_ENV=development
```

**Production:** Set in Vercel/Netlify dashboard

See [ENV-SETUP-GUIDE.md](./frontend/ENV-SETUP-GUIDE.md) for details.

## 🚀 Deployment

### Option 1: Vercel/Netlify (Recommended) ⭐

```bash
# 1. Push to GitHub
git push origin main

# 2. Import to Vercel/Netlify
# 3. Set environment variables
# 4. Deploy
```

### Option 2: Docker

```bash
# Production
docker-compose up -d

# Development
docker-compose -f docker-compose.local.yml up
```

**Detailed guide:** [DEPLOYMENT-GUIDE.md](./DEPLOYMENT-GUIDE.md)

## 🧪 Testing

### Manual Testing
- Browser: Chrome, Firefox, Safari, Edge
- Devices: iPhone, iPad, Android, Desktop
- Features: Auth, Invitations, RSVP, Payment

### Performance
- Lighthouse Score: > 90
- Bundle Size: < 500KB (gzipped)
- Load Time: < 2s

## 🔒 Security

- ✅ HTTPS only
- ✅ Row Level Security (RLS)
- ✅ Environment variables
- ✅ XSS protection
- ✅ SQL injection protection
- ✅ Secure headers (nginx)

## 📊 Project Status

- **Development:** ✅ Complete
- **Testing:** ✅ Complete
- **Documentation:** ✅ Complete
- **Production:** ✅ Ready
- **Environment Setup:** ✅ Separated (v2.0.0)

## 🎯 Recommended Workflow

```
1. DEVELOPMENT
   └─→ ./setup-env.sh
   └─→ npm run dev
   └─→ http://localhost:5173

2. TEST
   └─→ npm run build
   └─→ npm run preview

3. PRODUCTION
   └─→ git push
   └─→ Vercel auto deploy
   └─→ https://davetim.app
```

## 🤝 Contributing

This is a private project. For feature requests or bugs, please contact the project owner.

## 📝 License

This project is proprietary. All rights reserved.

## 📞 Support

- **Quick Start:** [BASLA-BURADAN-V2.md](./BASLA-BURADAN-V2.md)
- **Environment:** [ENV-SETUP-GUIDE.md](./frontend/ENV-SETUP-GUIDE.md)
- **Docker:** [DOCKER-GUIDE.md](./DOCKER-GUIDE.md)
- **Database:** [database/HIZLI-BASLANGIÇ.md](./database/HIZLI-BASLANGIÇ.md)
- **Deployment:** [DEPLOYMENT-GUIDE.md](./DEPLOYMENT-GUIDE.md)

## 🎯 Roadmap

### Phase 2 (Next 3 months)
- [ ] Mobile app
- [ ] Email notifications
- [ ] SMS notifications
- [ ] Advanced analytics

### Phase 3 (Next 6 months)
- [ ] AI-powered design
- [ ] Video invitations
- [ ] Gift registry
- [ ] Vendor marketplace

## 🏆 Changelog

### v2.0.0 (Current)
- ✅ Separated production and development environments
- ✅ Multi-stage Docker build
- ✅ Nginx production server
- ✅ Automated environment setup scripts
- ✅ Improved documentation

### v1.0.0
- ✅ Initial release
- ✅ All core features

---

**Made with ❤️ for the Turkish market**

**Status:** Production Ready 🚀

**Version:** 2.0.0

**Last Updated:** 2024
