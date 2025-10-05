# 🎉 Davetim - Digital Invitation Platform

Modern, fast, and beautiful digital invitation platform built for the Turkish market.

## 🚀 Tech Stack

- **Frontend**: React 18 + TypeScript + Vite
- **Styling**: Tailwind CSS + Headless UI
- **Backend**: Supabase (Auth + Database + Storage)
- **State Management**: Zustand
- **Forms**: React Hook Form + Zod
- **Notifications**: React Hot Toast
- **PDF Generation**: jsPDF + html2canvas
- **Icons**: Lucide React
- **Animation**: Framer Motion

## 🏁 Quick Start

### Prerequisites
- Node.js 18+
- Docker & Docker Compose
- Supabase Account

### 1. Clone Repository
```bash
git clone <repository-url>
cd davetim.app
```

### 2. Setup Supabase
1. Create a new project at [supabase.com](https://supabase.com)
2. Get your Project URL and API Key from Settings > API
3. Run the database migrations in your Supabase SQL Editor (in order):
   - **Step 1:** Run `database/supabase-migration.sql` (User auth & invitation schema)
   - **Step 2:** Run `database/templates-migration.sql` (Template system)
   - **Step 3:** Run `database/increment-views-function.sql` (View counter function)

### 3. Environment Setup
Create `frontend/.env.local`:
```bash
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

### 4. Start Development
```bash
# Start with Docker
docker-compose up

# Or start frontend locally
cd frontend
npm install
npm run dev
```

Visit: http://localhost:3000

## 📱 Features

### ✅ Completed
- **Authentication System** (Supabase Auth)
  - Email/Password signup & login
  - Google OAuth integration
  - Password reset functionality
  - Protected routes & state management

- **Template System**
  - 8 categorized invitation templates
  - Category filtering (Düğün, Nişan, Doğum Günü, Baby Shower, etc.)
  - Search functionality
  - Save/favorite templates (authenticated users)
  - Featured & popular templates
  - Template cards with preview images
  - Tier badges (Free/Pro/Premium)

- **Invitation Editor** (Phase 1 & 2)
  - Template-based invitation creation
  - Real-time text editing (title, date, time, location, message)
  - Live preview panel
  - Auto-save functionality
  - **PDF Export** (html2canvas + jsPDF)
  - **PNG/Image Export**
  - **Public sharing links** (`/i/:id`)
  - **Download functionality**
  - View count tracking

- **Dashboard**
  - User invitation list
  - Statistics (total invitations, views, plan info)
  - Edit, preview, share, delete actions
  - Status badges (draft/published)

- **Modern UI/UX**
  - Responsive design with Tailwind CSS
  - Clean, professional interface
  - Loading states and error handling
  - Toast notifications
  - Modal dialogs

### 🚧 In Development
- **Advanced Editor Features**
  - Color customization
  - Image upload (Supabase Storage)
  - Font selection
  - Advanced layout options

- **Payment Integration**
  - In-App Purchase (Coming Soon)
  - Subscription tiers (Free/Pro/Premium)

## 🏗️ Project Structure

```
davetim.app/
├── frontend/              # React Frontend
│   ├── src/
│   │   ├── components/    # Reusable components
│   │   │   ├── Auth/      # Authentication components
│   │   │   ├── Templates/ # Template components
│   │   │   ├── Layout/    # Layout components
│   │   │   └── UI/        # Shared UI components
│   │   ├── pages/         # Route pages
│   │   ├── services/      # API & Supabase services
│   │   ├── store/         # Zustand state management
│   │   └── utils/         # Helper functions
│   └── ...
├── database/             # SQL migrations
│   ├── supabase-migration.sql          # Auth & user schema
│   ├── templates-migration.sql         # Template system schema
│   └── increment-views-function.sql    # View counter function
├── docker-compose.yml    # Docker setup
└── README.md
```

## 🔧 Supabase Database Schema

The database includes tables for:
- **users** - Extended user profiles
- **templates** - Invitation templates
- **invitations** - User-created invitations  
- **guests** - Guest list & RSVP management
- **usage_tracking** - Analytics (Coming Soon)

## 🎯 MVP Goals

**Target**: ₺500+ Monthly Revenue in 4 weeks

**Key Metrics**:
- 100+ registered users
- 20+ premium subscriptions
- 5+ templates available
- Mobile-responsive design

## 🚀 Deployment

### Frontend (Vercel)
```bash
# Build production
npm run build

# Deploy to Vercel
vercel --prod
```

### Environment Variables
- `VITE_SUPABASE_URL`: Your Supabase project URL
- `VITE_SUPABASE_ANON_KEY`: Your Supabase anonymous key

## 📖 Documentation

- [Supabase Auth Guide](https://supabase.com/docs/guides/auth)
- [React Router v6](https://reactrouter.com)
- [Tailwind CSS](https://tailwindcss.com)
- [Zustand State Management](https://github.com/pmndrs/zustand)

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

## 📄 License

This project is private and proprietary.

---

**Built with ❤️ for the Turkish market**