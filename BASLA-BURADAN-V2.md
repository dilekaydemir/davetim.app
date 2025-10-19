# 🎯 BURADAN BAŞLA! (Güncellenmiş v2)

## Hoş Geldin! 👋

Proje **production ve development ortamları ayrılmış** şekilde hazır! İşte yapman gerekenler:

---

## ⚡ 3 Adımda Başla

### 1️⃣ Environment Ayarla (5 dakika)

```bash
# Otomatik setup script çalıştır
# Windows:
setup-env.bat

# Mac/Linux:
chmod +x setup-env.sh
./setup-env.sh
```

Bu script `frontend/.env.local` dosyasını otomatik oluşturur.

**Manuel yapmak istersen:**
```bash
cd frontend
copy .env.example .env.local   # Windows
cp .env.example .env.local     # Mac/Linux
```

Sonra `frontend/.env.local` dosyasını aç ve Supabase credentials'ı ekle.

### 2️⃣ Supabase Kur (15 dakika)

1. https://supabase.com → Hesap aç
2. Yeni proje oluştur
3. Settings > API → URL ve Key'i kopyala
4. `frontend/.env.local`'e yapıştır
5. SQL Editor'de 2 script çalıştır:
   - `database/00-COMPLETE-CLEANUP.sql`
   - `database/01-COMPLETE-REBUILD.sql`

### 3️⃣ Çalıştır (5 dakika)

```bash
cd frontend
npm install
npm run dev
```

http://localhost:5173 aç ve kullan!

---

## 📁 Ortam Yapısı (ÖNEMLİ!)

### Development (Local)
- **Dosya:** `frontend/.env.local`
- **Port:** 5173
- **Çalıştır:** `npm run dev`
- **Analytics:** Kapalı
- **Debug:** Aktif

### Production
- **Dosya:** `frontend/.env` (Vercel/Netlify'da env variables)
- **Port:** 80 (veya Vercel URL)
- **Deploy:** `vercel --prod`
- **Analytics:** Aktif
- **Debug:** Kapalı

---

## 🔧 Ortamlara Göre Dosyalar

```
📦 Proje/
├── frontend/
│   ├── .env                 → ❌ Git'e commit edilmez (production template)
│   ├── .env.local          → ❌ Git'e commit edilmez (SEN OLUŞTURACAKSIN)
│   ├── .env.example        → ✅ Git'te var (template)
│   │
│   ├── Dockerfile          → Production (nginx + multi-stage)
│   └── Dockerfile.dev      → Development (vite dev server)
│
├── docker-compose.yml       → Production (port 80)
├── docker-compose.local.yml → Development (port 5173)
│
├── setup-env.sh            → Environment setup (Linux/Mac)
└── setup-env.bat           → Environment setup (Windows)
```

---

## 🚀 Hangi Yöntemi Kullanmalıyım?

### Development (Önerilen: Native)

**Yöntem 1: Native npm (En Kolay) ⭐**
```bash
./setup-env.sh           # Setup
cd frontend
npm install
npm run dev              # http://localhost:5173
```

**Yöntem 2: Docker (Opsiyonel)**
```bash
./setup-env.sh
docker-compose -f docker-compose.local.yml up
```

### Production

**Yöntem 1: Vercel/Netlify (Önerilen) ⭐**
```bash
git push origin main     # Auto deploy
# Vercel'de environment variables ayarla
```

**Yöntem 2: Docker Self-Hosting**
```bash
# frontend/.env oluştur (production values)
docker-compose up -d     # http://localhost:80
```

---

## 📚 Detaylı Rehberler

| Dosya | Ne İçin | Süre |
|-------|---------|------|
| **SENIN-YAPACAKLARIN.md** | Adım adım kurulum | 2 saat |
| **DOCKER-GUIDE.md** | Docker detayları | 10 dk |
| **DEPLOYMENT-GUIDE.md** | Production deploy | 45 dk |
| **ENV-SETUP-GUIDE.md** | Environment ayarları | 10 dk |

---

## ✅ Hızlı Checklist

### Development Setup
- [ ] `./setup-env.sh` çalıştırdım
- [ ] `frontend/.env.local` oluştu
- [ ] Supabase credentials ekledim
- [ ] Database migration çalıştırdım
- [ ] `npm run dev` çalışıyor
- [ ] http://localhost:5173 açılıyor

### Production Deploy
- [ ] `frontend/.env` production values ile dolduruldu
- [ ] GitHub'a push yaptım
- [ ] Vercel/Netlify'a deploy ettim
- [ ] Environment variables ayarlandı
- [ ] Production URL test edildi

---

## 🆘 Sorun Giderme

### "Supabase not defined"
→ `frontend/.env.local` var mı? Credentials doğru mu?

### "Port already in use"
→ Başka bir uygulama 5173 portunu kullanıyor mu?

### "npm install hatası"
→ Node.js 18+ yüklü mü? `node --version` kontrol et

### "Docker çalışmıyor"
→ **DOCKER-GUIDE.md** dosyasına bak

---

## 🎯 Önerilen Workflow

```
1. DEVELOPMENT
   └─→ ./setup-env.sh
   └─→ npm run dev
   └─→ http://localhost:5173

2. TEST
   └─→ npm run build
   └─→ npm run preview
   └─→ Docker test (opsiyonel)

3. PRODUCTION
   └─→ git push
   └─→ Vercel auto deploy
   └─→ https://davetim.app
```

---

## 🔥 En Önemli 3 Şey

1. **`.env.local` dosyasını oluştur** (development için)
2. **Database migration çalıştır** (2 SQL script)
3. **`npm run dev` ile test et** (native, docker değil!)

---

## 📞 Yardım

- **Environment:** ENV-SETUP-GUIDE.md
- **Docker:** DOCKER-GUIDE.md
- **Deploy:** DEPLOYMENT-GUIDE.md
- **Database:** database/HIZLI-BASLANGIÇ.md

---

**İLK ADIM:** `./setup-env.sh` çalıştır ve `npm run dev` ile başla!

**SÜRE:** ~30 dakika (sadece development setup)

**SONUÇ:** Çalışan bir development ortamı! 🚀

---

**Made with ❤️**

**Status:** Production Ready ✅

**Version:** 2.0.0 (Environment'lar ayrıldı)

