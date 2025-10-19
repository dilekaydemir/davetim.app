# 🚀 Deployment Guide - Davetim.app

Bu rehber, Davetim.app projesinin production ortamına deploy edilmesi için gereken tüm adımları içerir.

## 📋 Ön Hazırlık (Checklist)

Deploy etmeden önce tamamlanması gerekenler:

- [ ] Database migrations çalıştırıldı
- [ ] Environment variables ayarlandı
- [ ] Production build test edildi
- [ ] Security kontrolleri yapıldı
- [ ] Domain satın alındı (opsiyonel)

---

## 🗄️ PART 1: DATABASE SETUP (Supabase)

### 1.1 Supabase Projesi Oluştur

1. https://supabase.com adresine git
2. "New Project" tıkla
3. Proje detaylarını gir:
   - **Name:** davetim-production
   - **Database Password:** Güçlü bir şifre (kaydet!)
   - **Region:** Europe (Frankfurt) - En yakın
   - **Pricing Plan:** Seç (Free/Pro)

4. Proje oluşturulmasını bekle (2-3 dakika)

### 1.2 Database Migrations Çalıştır

**Adım 1:** SQL Editor'ü Aç
- Supabase Dashboard > SQL Editor

**Adım 2:** Cleanup Script
- `database/00-COMPLETE-CLEANUP.sql` içeriğini kopyala
- SQL Editor'a yapıştır
- **RUN** tıkla

**Adım 3:** Rebuild Script
- `database/01-COMPLETE-REBUILD.sql` içeriğini kopyala
- SQL Editor'a yapıştır
- **RUN** tıkla

**Adım 4:** Doğrulama
```sql
-- Tablo sayısı kontrolü
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
-- Beklenen: 10

-- Function sayısı kontrolü
SELECT COUNT(*) FROM information_schema.routines 
WHERE routine_schema = 'public';
-- Beklenen: 15

-- RLS kontrolü
SELECT tablename, rowsecurity FROM pg_tables 
WHERE schemaname = 'public';
-- Hepsi true olmalı
```

### 1.3 API Credentials Al

1. **Settings > API**
2. Şu değerleri kopyala ve kaydet:
   - **Project URL:** `https://xxx.supabase.co`
   - **anon/public key:** `eyJhbGciOiJIUzI1NiIs...`

⚠️ **ÖNEMLİ:** Service role key'i ASLA frontend'de kullanma!

### 1.4 Email Templates Yapılandır

1. **Authentication > Email Templates**
2. Confirm signup template'i düzenle:
   ```html
   <h2>Davetim'e Hoş Geldiniz!</h2>
   <p>Hesabınızı aktifleştirmek için aşağıdaki linke tıklayın:</p>
   <a href="{{ .ConfirmationURL }}">Hesabımı Aktifleştir</a>
   ```

3. Reset password template'i düzenle
4. "Save" tıkla

### 1.5 Authentication Ayarları

1. **Authentication > Settings**
2. Ayarları kontrol et:
   - ✅ **Enable Email Confirmations** (Production için)
   - ✅ **Enable Email OTP** (Opsiyonel)
   - Site URL: `https://davetim.app`
   - Redirect URLs: `https://davetim.app/**`

3. **Google OAuth** (Opsiyonel)
   - Google Console'dan OAuth credentials al
   - Supabase'e ekle

---

## 🌐 PART 2: FRONTEND DEPLOYMENT (Vercel)

### 2.1 GitHub Repository

1. **GitHub'a Push Et**
```bash
git add .
git commit -m "Production ready"
git push origin main
```

### 2.2 Vercel Deployment

**Adım 1:** Vercel'e Git
- https://vercel.com
- "Sign up with GitHub"

**Adım 2:** Yeni Proje İmport Et
- "Add New" > "Project"
- GitHub repository seç: `davetim.app`
- "Import" tıkla

**Adım 3:** Build Settings
- **Framework Preset:** Vite
- **Root Directory:** `frontend`
- **Build Command:** `npm run build`
- **Output Directory:** `dist`
- **Install Command:** `npm install`

**Adım 4:** Environment Variables Ekle

```
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs...
VITE_PAYMENT_API_URL=https://payment-api.vercel.app/api/payment
VITE_APP_NAME=Davetim
VITE_APP_URL=https://davetim.app
VITE_APP_ENV=production
VITE_ENABLE_ANALYTICS=true
VITE_ENABLE_QR_MEDIA=true
VITE_ENABLE_PAYMENT=true
VITE_ENABLE_GOOGLE_OAUTH=false
```

**Adım 5:** Deploy
- "Deploy" tıkla
- İlk deploy ~2-3 dakika sürer

**Adım 6:** Preview URL'i Test Et
- `https://davetim-xxx.vercel.app`
- Signup/Login test et
- Template'leri kontrol et

### 2.3 Custom Domain Bağla

**Adım 1:** Domain Satın Al
- Namecheap, GoDaddy, vs.
- Örnek: `davetim.app`

**Adım 2:** Vercel'de Domain Ekle
- Project Settings > Domains
- "Add" tıkla
- Domain gir: `davetim.app`
- "Add" tıkla

**Adım 3:** DNS Ayarları
- Domain provider'ınızda DNS settings'e git
- Aşağıdaki kayıtları ekle:

```
Type: A
Name: @
Value: 76.76.21.21

Type: CNAME
Name: www
Value: cname.vercel-dns.com
```

**Adım 4:** SSL Sertifikası
- Vercel otomatik Let's Encrypt sertifikası oluşturur
- 24 saat içinde aktif olur

### 2.4 Vercel Configuration (Opsiyonel)

**vercel.json** oluştur:
```json
{
  "buildCommand": "cd frontend && npm run build",
  "outputDirectory": "frontend/dist",
  "framework": "vite",
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ]
}
```

---

## 💳 PART 3: PAYMENT API DEPLOYMENT (Opsiyonel)

### 3.1 Payment Service Deploy

Eğer custom payment service kullanıyorsanız:

**Option 1: Vercel Serverless Functions**
```bash
# payment-service klasörünü Vercel'e deploy et
cd payment-service
vercel
```

**Option 2: Heroku**
```bash
heroku create davetim-payment-api
git push heroku main
```

### 3.2 İyzico Credentials

1. **İyzico Dashboard**
   - https://merchant.iyzipay.com
   - API Key ve Secret Key al

2. **Environment Variables**
   - Payment service'e ekle:
   ```
   IYZICO_API_KEY=sandbox-xxx
   IYZICO_SECRET_KEY=sandbox-xxx
   IYZICO_BASE_URL=https://sandbox-api.iyzipay.com
   ```

---

## 📊 PART 4: MONITORING & ANALYTICS

### 4.1 Sentry Setup (Error Tracking)

```bash
cd frontend
npm install @sentry/react
```

**main.tsx** güncelle:
```typescript
import * as Sentry from "@sentry/react";

if (import.meta.env.PROD) {
  Sentry.init({
    dsn: "https://xxx@xxx.ingest.sentry.io/xxx",
    integrations: [new Sentry.BrowserTracing()],
    tracesSampleRate: 1.0,
  });
}
```

### 4.2 Google Analytics

**index.html** ekle:
```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

### 4.3 Vercel Analytics

```bash
npm install @vercel/analytics
```

**main.tsx** ekle:
```typescript
import { Analytics } from '@vercel/analytics/react';

// JSX içine ekle
<Analytics />
```

---

## 🔒 PART 5: SECURITY CHECKLIST

### 5.1 Environment Variables

- [ ] Tüm secrets Vercel'de environment variables olarak ayarlandı
- [ ] `.env.local` git'e commit edilmedi
- [ ] Production'da `VITE_APP_ENV=production`

### 5.2 Supabase Security

- [ ] RLS tüm tablolarda aktif
- [ ] Service role key güvenli yerde
- [ ] Auth policies doğru yapılandırılmış
- [ ] Email confirmation aktif

### 5.3 Headers & HTTPS

- [ ] HTTPS zorunlu
- [ ] Security headers ayarlandı
- [ ] CSP policy ayarlandı

---

## 📱 PART 6: POST-DEPLOYMENT TESTS

### 6.1 Functional Tests

Test edilecekler:
- [ ] Homepage yükleniyor
- [ ] Signup çalışıyor
- [ ] Email confirmation geliyor
- [ ] Login çalışıyor
- [ ] Dashboard açılıyor
- [ ] Template seçimi çalışıyor
- [ ] Davetiye oluşturma çalışıyor
- [ ] Image upload çalışıyor
- [ ] RSVP sistemi çalışıyor
- [ ] Payment flow çalışıyor
- [ ] QR media (Premium) çalışıyor

### 6.2 Performance Tests

**Google PageSpeed Insights:**
- https://pagespeed.web.dev/
- URL gir: `https://davetim.app`
- Hedef skorlar:
  - Performance: > 90
  - Accessibility: > 95
  - Best Practices: > 90
  - SEO: > 90

**Lighthouse (Chrome DevTools):**
```
F12 > Lighthouse > Generate Report
```

### 6.3 Browser Tests

Test tarayıcılar:
- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Edge (latest)
- [ ] Mobile Safari (iOS)
- [ ] Chrome Mobile (Android)

### 6.4 Responsive Tests

Test cihazlar:
- [ ] iPhone 13 (390x844)
- [ ] iPhone SE (375x667)
- [ ] iPad (768x1024)
- [ ] Desktop (1920x1080)

---

## 🔄 PART 7: CONTINUOUS DEPLOYMENT

### 7.1 Auto Deploy Setup

**Vercel otomatik deploy:**
- ✅ `main` branch'e push → production deploy
- ✅ PR açıldığında → preview deploy
- ✅ Commit hash ile versiyonlama

### 7.2 Deployment Workflow

```bash
# 1. Feature branch oluştur
git checkout -b feature/new-feature

# 2. Geliştir ve test et
npm run dev
npm run build
npm run preview

# 3. Commit ve push
git add .
git commit -m "feat: new feature"
git push origin feature/new-feature

# 4. PR aç (Vercel preview deploy oluşturur)
# 5. Review yap
# 6. Merge to main (Auto production deploy)
```

---

## 🆘 TROUBLESHOOTING

### Build Hatası

```bash
# Cache temizle
rm -rf node_modules/.vite dist
npm install
npm run build
```

### Environment Variables Yüklenmiyor

- Vercel dashboard'dan kontrol et
- `VITE_` prefix var mı?
- Redeploy yap

### Database Connection Hatası

- Supabase URL doğru mu?
- Anon key doğru mu?
- RLS policies aktif mi?

### SSL Sertifikası Hatası

- DNS propagation bekle (24-48 saat)
- Vercel dashboard'dan kontrol et

---

## 📞 SUPPORT

### Supabase
- Dashboard: https://app.supabase.com
- Docs: https://supabase.com/docs
- Discord: https://discord.supabase.com

### Vercel
- Dashboard: https://vercel.com/dashboard
- Docs: https://vercel.com/docs
- Support: https://vercel.com/support

### İyzico
- Merchant Panel: https://merchant.iyzipay.com
- Docs: https://dev.iyzipay.com
- Support: destek@iyzico.com

---

## ✅ DEPLOYMENT CHECKLIST

Son kontrol:

### Ön Hazırlık
- [ ] Database migrations çalıştırıldı
- [ ] Supabase API keys alındı
- [ ] Environment variables hazırlandı
- [ ] Production build test edildi

### Deployment
- [ ] Vercel'e deploy edildi
- [ ] Custom domain bağlandı
- [ ] SSL sertifikası aktif
- [ ] Environment variables ayarlandı

### Test
- [ ] Signup/Login çalışıyor
- [ ] Core features çalışıyor
- [ ] Performance skorları iyi
- [ ] Tüm tarayıcılarda test edildi

### Post-Deployment
- [ ] Monitoring ayarlandı (Sentry)
- [ ] Analytics ayarlandı (GA)
- [ ] Error logs izleniyor
- [ ] Backup stratejisi var

---

**🎉 TEBRİKLER! Davetim.app production'da!**

**Live URL:** https://davetim.app

**Next Steps:**
1. Marketing ve SEO
2. User feedback toplama
3. İteratif geliştirme
4. A/B testing

---

**Son Güncelleme:** 2024
**Versiyon:** 1.0.0

