# 🚀 Production Hazırlık Kontrol Listesi - Davetim.app

Bu dokümant projenin production'a alınması için gereken tüm adımları içerir.

## 📊 Proje Durumu Özeti

### ✅ Tamamlanmış Özellikler
- Frontend (React + TypeScript + Vite)
- Backend (Supabase)
- Authentication sistemi
- Subscription yönetimi (Free, Pro, Premium)
- Davetiye oluşturma ve yönetimi
- Template sistemi
- RSVP sistemi
- QR medya sistemi (Premium)
- Payment entegrasyonu (İyzico)
- Dashboard ve analytics
- Media upload ve yönetimi

### 🔧 Gerekli İyileştirmeler

## 📋 PHASE 1: KONFIGÜRASYON (Kritik - Hemen Yapılmalı)

### 1.1 Environment Variables Ayarları

**Yapılması Gereken:**

1. **Frontend Environment Dosyası Oluştur**
```bash
# frontend/.env.local oluştur
touch frontend/.env.local
```

2. **Environment değişkenlerini ekle:**
```env
# Supabase Configuration
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key

# Payment API (İyzico)
VITE_PAYMENT_API_URL=http://localhost:5000/api/payment

# App Configuration
VITE_APP_NAME=Davetim
VITE_APP_URL=https://davetim.app
VITE_APP_ENV=production

# Feature Flags
VITE_ENABLE_ANALYTICS=true
VITE_ENABLE_QR_MEDIA=true
VITE_ENABLE_PAYMENT=true
```

3. **.env.example dosyası oluştur** (git'e commit edilecek)
```bash
# frontend/.env.example
VITE_SUPABASE_URL=
VITE_SUPABASE_ANON_KEY=
VITE_PAYMENT_API_URL=
# ... diğer tüm değişkenler
```

### 1.2 TypeScript Environment Types

**Eksik:** `frontend/src/vite-env.d.ts` güncelle

```typescript
/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_SUPABASE_URL: string
  readonly VITE_SUPABASE_ANON_KEY: string
  readonly VITE_PAYMENT_API_URL: string
  readonly VITE_APP_NAME: string
  readonly VITE_APP_URL: string
  readonly VITE_APP_ENV: 'development' | 'production'
  readonly VITE_ENABLE_ANALYTICS: string
  readonly VITE_ENABLE_QR_MEDIA: string
  readonly VITE_ENABLE_PAYMENT: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
```

## 📋 PHASE 2: GÜVENLİK (Kritik)

### 2.1 API Keys ve Secrets

**ASLA GİT'E COMMIT ETMEYİN:**
- ✅ `.env.local` zaten `.gitignore`'da
- ✅ Supabase anon key frontend'de kullanılabilir (RLS korumalı)
- ❌ Service role key ASLA frontend'de kullanılmamalı

### 2.2 Content Security Policy (CSP)

**Eklenecek:** `index.html`'e CSP meta tag

```html
<meta http-equiv="Content-Security-Policy" 
      content="default-src 'self'; 
               script-src 'self' 'unsafe-inline' 'unsafe-eval'; 
               style-src 'self' 'unsafe-inline'; 
               img-src 'self' data: https:; 
               font-src 'self' data:; 
               connect-src 'self' https://*.supabase.co https://api.ipify.org;">
```

### 2.3 HTTPS Zorunluluğu

**Production'da:**
- ✅ Supabase zaten HTTPS
- ⚠️ Custom domain HTTPS sertifikası (Let's Encrypt)
- ⚠️ HTTP → HTTPS redirect

### 2.4 Rate Limiting

**Backend (Supabase):**
- ✅ Supabase otomatik rate limiting var
- ⚠️ Custom rate limiting gerekirse Edge Functions

**Frontend:**
- ⚠️ Excessive API call'ları önleme (debounce/throttle)

## 📋 PHASE 3: PERFORMANCE OPTİMİZASYONU

### 3.1 Code Splitting

**Durum:** ✅ Zaten yapılmış (`React.lazy` kullanılıyor)

**İyileştirmeler:**
```typescript
// Daha agresif code splitting için route-based splitting
const HomePage = lazy(() => import(/* webpackChunkName: "home" */ './pages/HomePage'))
```

### 3.2 Image Optimization

**Yapılması Gereken:**

1. **WebP formatı kullan**
2. **Lazy loading ekle**
3. **Image CDN kullan** (Supabase Storage + Transform)

```typescript
// utils/imageOptimization.ts güncellemesi gerekli
export const getOptimizedImageUrl = (url: string, width?: number) => {
  // Supabase transform API kullan
  if (url.includes('supabase')) {
    return `${url}?width=${width}&format=webp`
  }
  return url
}
```

### 3.3 Bundle Size Optimization

**Kontrol:**
```bash
npm run build
# dist/ klasörünü analiz et
```

**Hedefler:**
- Main bundle < 200KB (gzipped)
- Total initial load < 500KB

**İyileştirmeler:**
- ✅ Tree shaking (Vite otomatik)
- ⚠️ Büyük kütüphaneleri lazy load et
- ⚠️ moment.js yerine date-fns kullan (✅ zaten yapılmış)

### 3.4 Caching Strategy

**Static Assets:**
```typescript
// vite.config.ts
build: {
  rollupOptions: {
    output: {
      manualChunks: {
        vendor: ['react', 'react-dom', 'react-router-dom'],
        ui: ['@headlessui/react', '@heroicons/react'],
        utils: ['date-fns', 'clsx', 'zod']
      }
    }
  }
}
```

## 📋 PHASE 4: ERROR HANDLING

### 4.1 Global Error Boundary

**Durum:** ✅ Var (`ErrorBoundary` component)

**İyileştirme:** Sentry entegrasyonu

```bash
npm install @sentry/react
```

```typescript
// main.tsx
import * as Sentry from "@sentry/react";

if (import.meta.env.PROD) {
  Sentry.init({
    dsn: "your-sentry-dsn",
    integrations: [
      new Sentry.BrowserTracing(),
      new Sentry.Replay(),
    ],
    tracesSampleRate: 1.0,
    replaysSessionSampleRate: 0.1,
    replaysOnErrorSampleRate: 1.0,
  });
}
```

### 4.2 API Error Handling

**Kontrol edilecek:**
- ✅ `retry.ts` utilities var
- ⚠️ Network hatalarında fallback UI
- ⚠️ Offline mode desteği

### 4.3 Form Validation

**Durum:** ✅ Comprehensive validation var

**İyileştirme:** Zod schema validation

```typescript
import { z } from 'zod'

export const signupSchema = z.object({
  email: z.string().email('Geçerli email girin'),
  password: z.string().min(6, 'Minimum 6 karakter'),
  fullName: z.string().min(2, 'İsim gerekli')
})
```

## 📋 PHASE 5: SEO OPTİMİZASYONU

### 5.1 Meta Tags

**Yapılması Gereken:**

1. **index.html güncelle**
```html
<meta name="description" content="Dijital düğün ve etkinlik davetiyeleri oluşturun">
<meta name="keywords" content="dijital davetiye, düğün davetiyesi, online davetiye">
<meta property="og:title" content="Davetim - Dijital Davetiye Platformu">
<meta property="og:description" content="...">
<meta property="og:image" content="https://davetim.app/og-image.jpg">
<meta name="twitter:card" content="summary_large_image">
```

2. **SEOHead component kullanımı** (✅ var)

### 5.2 Sitemap & Robots.txt

**Durum:** ✅ `public/sitemap.xml` ve `public/robots.txt` var

**Güncelle:**
```xml
<!-- public/sitemap.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://davetim.app/</loc>
    <lastmod>2024-01-01</lastmod>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://davetim.app/templates</loc>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>https://davetim.app/pricing</loc>
    <priority>0.8</priority>
  </url>
</urlset>
```

### 5.3 Open Graph Images

**Eksik:** `/public/og-image.jpg` oluştur (1200x630px)

### 5.4 Structured Data (Schema.org)

**Eklenecek:** JSON-LD structured data

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Davetim",
  "description": "Dijital davetiye platformu",
  "url": "https://davetim.app",
  "applicationCategory": "LifestyleApplication",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "TRY"
  }
}
</script>
```

## 📋 PHASE 6: MONITORING & ANALYTICS

### 6.1 Google Analytics

**Eklenecek:**
```typescript
// utils/analytics.ts
export const initAnalytics = () => {
  if (typeof window !== 'undefined' && import.meta.env.PROD) {
    // Google Analytics 4
    const script = document.createElement('script')
    script.src = `https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX`
    script.async = true
    document.head.appendChild(script)
    
    window.dataLayer = window.dataLayer || []
    function gtag(){dataLayer.push(arguments)}
    gtag('js', new Date())
    gtag('config', 'G-XXXXXXXXXX')
  }
}

export const trackEvent = (eventName: string, params?: object) => {
  if (typeof window !== 'undefined' && window.gtag) {
    window.gtag('event', eventName, params)
  }
}
```

### 6.2 Performance Monitoring

**Durum:** ✅ `utils/performance.ts` var (development only)

**Production için:**
```typescript
// Web Vitals tracking
import { getCLS, getFID, getFCP, getLCP, getTTFB } from 'web-vitals'

const sendToAnalytics = (metric) => {
  // Send to GA4 or custom endpoint
  gtag('event', metric.name, {
    value: Math.round(metric.value),
    metric_id: metric.id,
    metric_value: metric.value,
    metric_delta: metric.delta,
  })
}

getCLS(sendToAnalytics)
getFID(sendToAnalytics)
getFCP(sendToAnalytics)
getLCP(sendToAnalytics)
getTTFB(sendToAnalytics)
```

### 6.3 Error Tracking

**Sentry entegrasyonu** (yukarıda bahsedildi)

### 6.4 User Behavior Analytics

**Opsiyonel:** Hotjar, Microsoft Clarity

## 📋 PHASE 7: DATABASE & BACKEND

### 7.1 Database Migrations

**Durum:** ✅ SQL scripts hazır

**Çalıştırılması gereken:**
1. `database/00-COMPLETE-CLEANUP.sql`
2. `database/01-COMPLETE-REBUILD.sql`

**Doğrulama:**
```sql
-- Tablo sayısı kontrolü
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public';
-- Beklenen: 10

-- Function sayısı kontrolü
SELECT COUNT(*) FROM information_schema.routines 
WHERE routine_schema = 'public';
-- Beklenen: 15
```

### 7.2 RLS Policies

**Kontrol:** ✅ Tüm tablolarda RLS aktif

```sql
-- RLS kontrolü
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

### 7.3 Indexes

**Kontrol:** ✅ Foreign key'lerde index var

**Ek performans index'leri:**
```sql
-- Sık kullanılan query'ler için
CREATE INDEX IF NOT EXISTS idx_invitations_user_status 
  ON invitations(user_id, status);
  
CREATE INDEX IF NOT EXISTS idx_guests_invitation_rsvp 
  ON guests(invitation_id, rsvp_status);
```

### 7.4 Backup Strategy

**Supabase Production:**
- ✅ Otomatik daily backups
- ⚠️ Point-in-time recovery (PITR) aktif olmalı
- ⚠️ Manual backup scripts

```bash
# Manual backup script
#!/bin/bash
DATE=$(date +%Y%m%d)
pg_dump $DATABASE_URL > backup_$DATE.sql
```

## 📋 PHASE 8: DEPLOYMENT

### 8.1 Build Process

**Test build:**
```bash
cd frontend
npm run build
npm run preview
```

**Kontrol:**
- Bundle size
- Build errors
- Console errors
- Network requests

### 8.2 Hosting Options

**Önerilen:** Vercel veya Netlify

**Vercel Deployment:**
```bash
# Vercel CLI kur
npm i -g vercel

# Deploy
cd frontend
vercel

# Production deploy
vercel --prod
```

**Environment variables Vercel'de ayarla:**
- Dashboard > Settings > Environment Variables
- Tüm `VITE_*` değişkenlerini ekle

### 8.3 Custom Domain

**DNS Ayarları:**
```
A record:    @ → Vercel IP
CNAME:       www → cname.vercel-dns.com
```

**SSL:**
- ✅ Vercel otomatik SSL (Let's Encrypt)

### 8.4 CDN Configuration

**Vercel otomatik CDN:** ✅
- Global edge network
- Automatic cache invalidation

## 📋 PHASE 9: TESTING

### 9.1 Manual Testing Checklist

**Authentication:**
- [ ] Signup
- [ ] Login
- [ ] Logout
- [ ] Password reset
- [ ] Google OAuth
- [ ] Session persistence

**Core Features:**
- [ ] Template selection
- [ ] Invitation creation
- [ ] Image upload
- [ ] Guest management
- [ ] RSVP submission
- [ ] Dashboard analytics
- [ ] Payment flow
- [ ] QR media (Premium)

**Responsive Design:**
- [ ] Mobile (320px - 767px)
- [ ] Tablet (768px - 1023px)
- [ ] Desktop (1024px+)

**Browser Compatibility:**
- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Edge (latest)
- [ ] Mobile Safari (iOS)
- [ ] Chrome Mobile (Android)

### 9.2 Performance Testing

**Tools:**
- [ ] Google PageSpeed Insights
- [ ] Lighthouse
- [ ] WebPageTest

**Targets:**
- Performance Score: > 90
- Accessibility Score: > 95
- Best Practices: > 90
- SEO: > 90

### 9.3 Load Testing

**API Endpoints:**
```bash
# Apache Bench
ab -n 1000 -c 10 https://davetim.app/

# Artillery
artillery quick --count 10 -n 20 https://davetim.app/
```

### 9.4 Security Testing

**Tools:**
- [ ] OWASP ZAP
- [ ] Security Headers check
- [ ] SSL Labs test

## 📋 PHASE 10: DOCUMENTATION

### 10.1 User Documentation

**Eklenecek:**
- `/docs/user-guide.md`
- `/docs/faq.md`
- `/docs/pricing.md`

### 10.2 Developer Documentation

**Mevcut:**
- ✅ `README.md`
- ✅ `database/` docs
- ✅ `DOCKER-FIX.md`

**Eklenecek:**
- API documentation
- Component storybook
- Deployment guide

### 10.3 Legal Documents

**Eksik - Mutlaka eklenecek:**
- Terms of Service
- Privacy Policy
- Cookie Policy
- KVKK uyumluluk

## 📋 PHASE 11: POST-LAUNCH

### 11.1 Monitoring Setup

**Günlük kontroller:**
- [ ] Error logs (Sentry)
- [ ] Performance metrics
- [ ] User analytics
- [ ] Server uptime

### 11.2 Feedback Collection

**Tools:**
- Hotjar surveys
- User interviews
- Support tickets
- Analytics data

### 11.3 Continuous Improvement

**Sprint planning:**
- Bug fixes
- Performance optimizations
- New features
- UX improvements

---

## ✅ CRITICAL PATH (Hemen Yapılması Gerekenler)

### 1. Environment Setup (30 dk)
- [ ] `.env.local` oluştur
- [ ] Supabase credentials ekle
- [ ] Environment types güncelle

### 2. Database Setup (20 dk)
- [ ] Cleanup script çalıştır
- [ ] Rebuild script çalıştır
- [ ] Doğrulama yap

### 3. Build Test (15 dk)
- [ ] Production build yap
- [ ] Preview'da test et
- [ ] Console errors kontrol et

### 4. Security Basics (30 dk)
- [ ] CSP meta tag ekle
- [ ] Security headers kontrol
- [ ] API keys güvenli mi kontrol

### 5. SEO Basics (30 dk)
- [ ] Meta tags güncelle
- [ ] OG image ekle
- [ ] Sitemap güncelle

### 6. Deployment (45 dk)
- [ ] Vercel/Netlify'a deploy
- [ ] Environment variables ayarla
- [ ] Domain bağla
- [ ] SSL aktif mi kontrol

**TOPLAM SÜRE: ~3 saat**

---

## 📞 Destek İletişim

- Supabase: https://supabase.com/dashboard/support
- Vercel: https://vercel.com/support
- İyzico: https://www.iyzico.com/iletisim

---

**Son Güncelleme:** 2024
**Versiyon:** 1.0.0
**Durum:** Production Hazırlık Aşamasında

