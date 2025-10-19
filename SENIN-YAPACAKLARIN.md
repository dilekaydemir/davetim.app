# 👨‍💻 SENİN YAPMAN GEREKENLER - Adım Adım Rehber

## 🎯 Özet

Proje %95 hazır! Sadece şu adımları tamamlaman gerekiyor:

1. ⏱️ **Hızlı Başlangıç** (30 dakika) - Yerel geliştirme ortamı
2. ⏱️ **Database Kurulumu** (20 dakika) - Supabase'i hazırla
3. ⏱️ **Production Deploy** (45 dakika) - Canlıya al

**TOPLAM SÜRE: ~2 saat**

---

## 📋 PHASE 1: HIZLI BAŞLANGIÇ (30 dakika)

### Adım 1.1: Projeyi Klonla (Zaten yapılmış ✅)

### Adım 1.2: Environment Variables Ayarla

```bash
# 1. Frontend dizinine git
cd frontend

# 2. .env.local dosyası oluştur
# Windows:
copy nul .env.local

# Mac/Linux:
touch .env.local

# 3. .env.local dosyasını aç ve şu içeriği yapıştır:
```

```.env
VITE_SUPABASE_URL=buraya-supabase-url-gelecek
VITE_SUPABASE_ANON_KEY=buraya-supabase-key-gelecek
VITE_PAYMENT_API_URL=http://localhost:5000/api/payment
VITE_APP_NAME=Davetim
VITE_APP_URL=http://localhost:5173
VITE_APP_ENV=development
VITE_ENABLE_ANALYTICS=false
VITE_ENABLE_QR_MEDIA=true
VITE_ENABLE_PAYMENT=true
VITE_ENABLE_GOOGLE_OAUTH=false
```

⚠️ **ÖNEMLİ:** `VITE_SUPABASE_URL` ve `VITE_SUPABASE_ANON_KEY` değerlerini sonraki adımda alacaksın!

### Adım 1.3: Dependencies Yükle

```bash
# Frontend dependencies
cd frontend
npm install

# Proje root'a dön
cd ..
```

**Beklenen çıktı:**
```
added 234 packages in 45s
```

---

## 📋 PHASE 2: DATABASE KURULUMU (20 dakika)

### Adım 2.1: Supabase Hesabı Oluştur

1. **https://supabase.com** adresine git
2. "Start your project" tıkla
3. GitHub hesabınla giriş yap
4. "New Project" tıkla

### Adım 2.2: Proje Oluştur

Aşağıdaki bilgileri gir:

- **Organization:** (Otomatik oluşur veya mevcut olanı seç)
- **Project Name:** `davetim-app`
- **Database Password:** Güçlü bir şifre seç ve KAYDET! (örn: `MyStr0ngP@ssw0rd2024`)
- **Region:** `Europe West (eu-west-1)` - Frankfurt (En yakın)
- **Pricing Plan:** `Free` (başlangıç için yeterli)

"Create new project" tıkla ve **2-3 dakika bekle**.

### Adım 2.3: API Credentials Al

Proje oluştuktan sonra:

1. Sol menüden **Settings** (⚙️) > **API** tıkla
2. Şu değerleri kopyala:

**Project URL:**
```
https://xxxxxxxxxxxxx.supabase.co
```

**anon/public key:**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6...
```

### Adım 2.4: Environment Variables Güncelle

1. `frontend/.env.local` dosyasını aç
2. Şu satırları güncelle:

```env
VITE_SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**KAYDET!**

### Adım 2.5: Database Migration Çalıştır

1. Supabase Dashboard'da **SQL Editor** aç (sol menüden)

2. **İLK SCRIPT:** Cleanup
   - `database/00-COMPLETE-CLEANUP.sql` dosyasını aç
   - **TÜM İÇERİĞİ** kopyala (Ctrl+A, Ctrl+C)
   - SQL Editor'a yapıştır (Ctrl+V)
   - **RUN** butonuna tıkla (sağ üstte)
   - "Database cleanup completed successfully!" mesajını gör

3. **İKİNCİ SCRIPT:** Rebuild
   - "+ New query" tıkla (yeni query aç)
   - `database/01-COMPLETE-REBUILD.sql` dosyasını aç
   - **TÜM İÇERİĞİ** kopyala
   - SQL Editor'a yapıştır
   - **RUN** butonuna tıkla
   - "Database rebuild completed successfully! 🎉" mesajını gör
   - "Tables created: 10" görmelisin
   - "Functions created: 15" görmelisin

### Adım 2.6: Doğrulama (Opsiyonel ama önerilen)

SQL Editor'de şu sorguyu çalıştır:

```sql
-- Tablo sayısı
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
```

**Beklenen sonuç:** 10

---

## 📋 PHASE 3: YEREL TEST (15 dakika)

### Adım 3.1: Dev Server Başlat

```bash
cd frontend
npm run dev
```

**Beklenen çıktı:**
```
  VITE v4.4.5  ready in 1234 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: http://192.168.1.x:5173/
```

### Adım 3.2: Tarayıcıda Aç

1. **http://localhost:5173** aç
2. Homepage görmelisin
3. Console'da hata olmamalı (F12 > Console)

### Adım 3.3: Temel Test

1. **Kayıt Ol:**
   - Sağ üstten "Kayıt Ol" tıkla
   - Email, şifre, isim gir
   - "Kayıt Ol" tıkla
   - Email doğrulama mesajı göreceksin (Supabase auth ayarlarına bağlı)

2. **Giriş Yap:**
   - Email ve şifreyle giriş yap
   - Dashboard'a yönlendirilmelisin

3. **Davetiye Oluştur:**
   - "Yeni Davetiye" tıkla
   - Bir template seç
   - Başlık, tarih, yer gir
   - "Oluştur" tıkla

**Herşey çalışıyorsa ✅ BAŞARILI!**

---

## 📋 PHASE 4: PRODUCTION DEPLOY (45 dakika)

### Adım 4.1: GitHub'a Push

```bash
# Eğer git repository henüz oluşturmadıysan:
git init
git add .
git commit -m "Initial commit - Production ready"

# GitHub'da yeni repo oluştur (davetim-app)
# Sonra:
git remote add origin https://github.com/YOUR_USERNAME/davetim-app.git
git branch -M main
git push -u origin main
```

### Adım 4.2: Vercel'e Deploy

1. **https://vercel.com** git
2. "Sign Up" > "Continue with GitHub" tıkla
3. GitHub'a yetki ver

4. **"Add New Project"** tıkla
5. `davetim-app` repository'sini seç
6. **"Import"** tıkla

7. **Configure Project:**
   - **Framework Preset:** Vite
   - **Root Directory:** `frontend`
   - **Build Command:** `npm run build`
   - **Output Directory:** `dist`

8. **Environment Variables Ekle:**

"Environment Variables" bölümünde **ADD** tıkla:

```
VITE_SUPABASE_URL = https://xxxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
VITE_PAYMENT_API_URL = https://your-payment-api.vercel.app/api/payment
VITE_APP_NAME = Davetim
VITE_APP_URL = https://davetim-app.vercel.app
VITE_APP_ENV = production
VITE_ENABLE_ANALYTICS = true
VITE_ENABLE_QR_MEDIA = true
VITE_ENABLE_PAYMENT = true
VITE_ENABLE_GOOGLE_OAUTH = false
```

9. **Deploy** tıkla

10. **2-3 dakika bekle**

11. Deployment tamamlanınca "Visit" tıkla

### Adım 4.3: Production Test

1. **Vercel URL'i aç** (örn: `https://davetim-app.vercel.app`)
2. Signup/Login test et
3. Davetiye oluşturmayı test et
4. Her şey çalışıyor mu kontrol et

**Çalışıyorsa ✅ PRODUCTION'DA!**

---

## 🎨 BONUS: CUSTOM DOMAIN (Opsiyonel, 30 dakika)

### Adım B.1: Domain Satın Al

- **Namecheap:** https://www.namecheap.com
- **GoDaddy:** https://www.godaddy.com
- **Hostinger:** https://www.hostinger.com.tr

Örnek: `davetim.app` (~$10/yıl)

### Adım B.2: Vercel'de Domain Ekle

1. Vercel Dashboard > **davetim-app** project
2. **Settings** > **Domains**
3. **Add** tıkla
4. Domain gir: `davetim.app`
5. **Add** tıkla

### Adım B.3: DNS Ayarları

Domain provider'ında (Namecheap, GoDaddy vs):

1. **DNS Management** / **DNS Settings** bul
2. Şu kayıtları ekle:

```
Type: A
Name: @
Value: 76.76.21.21
TTL: Automatic

Type: CNAME
Name: www
Value: cname.vercel-dns.com
TTL: Automatic
```

3. **Save** tıkla
4. **24-48 saat bekle** (DNS propagation)

### Adım B.4: SSL Sertifikası

- Vercel otomatik Let's Encrypt sertifikası oluşturur
- Domain aktif olunca otomatik HTTPS açılır

---

## ✅ TAMAMLANMA CHECKLİSTİ

### Yerel Geliştirme
- [ ] `.env.local` oluşturuldu
- [ ] Supabase credentials eklendi
- [ ] Dependencies yüklendi
- [ ] Dev server çalışıyor
- [ ] Signup/Login çalışıyor
- [ ] Davetiye oluşturma çalışıyor

### Database
- [ ] Supabase projesi oluşturuldu
- [ ] Cleanup script çalıştırıldı
- [ ] Rebuild script çalıştırıldı
- [ ] 10 tablo oluştu
- [ ] 15 function oluştu

### Production
- [ ] GitHub'a push edildi
- [ ] Vercel'e deploy edildi
- [ ] Environment variables ayarlandı
- [ ] Production URL çalışıyor
- [ ] Tüm özellikler test edildi

### Bonus (Opsiyonel)
- [ ] Custom domain satın alındı
- [ ] DNS ayarları yapıldı
- [ ] SSL aktif

---

## 🆘 SORUN YAŞARSAN

### "Cannot find module" Hatası
```bash
cd frontend
rm -rf node_modules
npm install
```

### "Supabase not defined" Hatası
- `.env.local` dosyası var mı?
- `VITE_` prefix doğru mu?
- Dev server restart et

### Database Migration Hatası
- SQL script'i tamamen kopyalandı mı?
- Syntax error var mı?
- `02-TROUBLESHOOTING-QUERIES.sql` kullan

### Build Hatası
```bash
cd frontend
rm -rf node_modules/.vite dist
npm install
npm run build
```

### Vercel Deploy Hatası
- Environment variables doğru mu?
- Root directory `frontend` mi?
- Build logs'u kontrol et

---

## 📚 YARDIMCI DÖKÜMANLAR

Daha detaylı bilgi için:

- **PRODUCTION-READINESS-CHECKLIST.md** - Tam production checklist
- **DEPLOYMENT-GUIDE.md** - Detaylı deployment rehberi
- **ENV-SETUP-GUIDE.md** - Environment variables detayı
- **database/README.md** - Database dokümantasyonu
- **database/HIZLI-BASLANGIÇ.md** - Database hızlı başlangıç

---

## 🎉 BAŞARILAR!

Herşey hazır! Sorun yaşarsan:

1. İlgili dökümanı kontrol et
2. Error mesajını Google'da ara
3. Console log'ları incele
4. Supabase/Vercel log'larına bak

**Başarılar! Harika bir uygulama olacak! 🚀**

---

**Not:** Bu adımları sırayla takip et. Atlama yapmadan git. Her adım bir sonraki için gerekli!

