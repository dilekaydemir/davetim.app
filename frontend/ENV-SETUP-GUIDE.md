# 🔧 Environment Variables Setup Guide

## Hızlı Başlangıç

### 1. `.env.local` Dosyası Oluştur

```bash
cd frontend
touch .env.local
```

### 2. Aşağıdaki İçeriği Kopyala

```env
# ===============================================
# SUPABASE CONFIGURATION (ZORUNLU)
# ===============================================
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# ===============================================
# PAYMENT API CONFIGURATION
# ===============================================
VITE_PAYMENT_API_URL=http://localhost:5000/api/payment

# ===============================================
# APP CONFIGURATION
# ===============================================
VITE_APP_NAME=Davetim
VITE_APP_URL=http://localhost:5173
VITE_APP_ENV=development

# ===============================================
# FEATURE FLAGS
# ===============================================
VITE_ENABLE_ANALYTICS=false
VITE_ENABLE_QR_MEDIA=true
VITE_ENABLE_PAYMENT=true
VITE_ENABLE_GOOGLE_OAUTH=false
```

### 3. Supabase Credentials Nasıl Alınır?

#### Adım 1: Supabase Dashboard'a Git
https://app.supabase.com

#### Adım 2: Projenizi Seçin
- Sol üstten proje seçin veya yeni proje oluşturun

#### Adım 3: API Settings'e Git
- Sol menüden **Settings** > **API**

#### Adım 4: Değerleri Kopyala
- **Project URL** → `VITE_SUPABASE_URL`
- **anon/public key** → `VITE_SUPABASE_ANON_KEY`

⚠️ **ÖNEMLİ:** Service role key'i ASLA frontend'de kullanmayın!

### 4. Payment API Setup (Opsiyonel)

Eğer payment özelliğini kullanacaksanız:

```bash
# Backend payment API'yi başlat
cd payment-service
npm install
npm start
```

### 5. Dev Server'ı Başlat

```bash
cd frontend
npm install
npm run dev
```

## Production Setup

### Vercel Deployment

1. **Vercel Dashboard'da:**
   - Settings > Environment Variables

2. **Eklenecek Variables:**
```
VITE_SUPABASE_URL = https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY = your-anon-key
VITE_PAYMENT_API_URL = https://your-payment-api.com/api/payment
VITE_APP_NAME = Davetim
VITE_APP_URL = https://davetim.app
VITE_APP_ENV = production
VITE_ENABLE_ANALYTICS = true
VITE_ENABLE_QR_MEDIA = true
VITE_ENABLE_PAYMENT = true
```

3. **Redeploy**

### Netlify Deployment

1. **Netlify Dashboard'da:**
   - Site settings > Build & deploy > Environment

2. **Same variables as Vercel**

3. **Redeploy**

## Güvenlik Notları

### ✅ GÜVENLİ
- `VITE_*` prefix'li değişkenler
- Supabase anon key (RLS korumalı)
- Public API URLs

### ❌ ASLA EKLEMEYİN
- Supabase service_role key
- Private API keys
- Database passwords
- Payment gateway private keys

## Sorun Giderme

### "Supabase not defined" Hatası
- `.env.local` dosyası var mı?
- `VITE_` prefix var mı?
- Dev server restart edildi mi?

### Environment Variables Yüklenmiyor
```bash
# Dev server'ı yeniden başlat
npm run dev

# Build'i temizle
rm -rf node_modules/.vite
npm run dev
```

### Production'da Environment Variables Çalışmıyor
- Build time'da inject edilir
- Vercel/Netlify dashboard'dan kontrol et
- Redeploy yap

## Değişken Kullanımı (Code)

```typescript
// ✅ Doğru kullanım
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL

// ✅ Type-safe kullanım
interface ImportMetaEnv {
  readonly VITE_SUPABASE_URL: string
  // ...
}

// ❌ Yanlış - process.env Node.js içindir
const url = process.env.VITE_SUPABASE_URL // Çalışmaz!
```

## Checklist

Deployment öncesi kontrol:

- [ ] `.env.local` oluşturuldu
- [ ] Supabase credentials eklendi
- [ ] Dev server çalışıyor
- [ ] Build başarılı
- [ ] Production env variables ayarlandı
- [ ] `.env.local` git'e commit edilmedi

---

**Yardım:** Bu dosya ile ilgili sorunlarınız için README.md'ye bakın.

