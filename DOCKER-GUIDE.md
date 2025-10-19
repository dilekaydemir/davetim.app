# 🐳 Docker Deployment Guide

## Ortam Yapısı

Projede 2 farklı Docker yapılandırması var:

| Dosya | Ortam | Port | Kullanım |
|-------|-------|------|----------|
| `docker-compose.local.yml` | Development | 5173 | Local geliştirme |
| `docker-compose.yml` | Production | 80 | Production deploy |

---

## 🔧 Local Development (Önerilen: npm run dev)

### Yöntem 1: Native (Önerilen) ⭐

```bash
# 1. Environment ayarla
./setup-env.sh  # Linux/Mac
setup-env.bat   # Windows

# 2. Dependencies yükle
cd frontend
npm install

# 3. Çalıştır
npm run dev
```

**Avantajları:**
- ✅ En hızlı
- ✅ HMR sorunsuz
- ✅ WebSocket çalışır
- ✅ Debug kolay

### Yöntem 2: Docker (Opsiyonel)

```bash
# 1. Environment ayarla
./setup-env.sh

# 2. Docker ile çalıştır
docker-compose -f docker-compose.local.yml up

# Veya detached mode:
docker-compose -f docker-compose.local.yml up -d

# Log'ları görmek için:
docker-compose -f docker-compose.local.yml logs -f

# Durdurmak için:
docker-compose -f docker-compose.local.yml down
```

**URL:** http://localhost:5173

---

## 🚀 Production Deployment

### Option 1: Vercel/Netlify (Önerilen) ⭐

```bash
# 1. GitHub'a push
git push origin main

# 2. Vercel/Netlify'da import
# 3. Environment variables ayarla (.env içeriği)
# 4. Deploy
```

**Vercel environment variables:**
```
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...
VITE_PAYMENT_API_URL=https://api.davetim.app
VITE_APP_NAME=Davetim
VITE_APP_URL=https://davetim.app
VITE_APP_ENV=production
VITE_ENABLE_ANALYTICS=true
VITE_ENABLE_QR_MEDIA=true
VITE_ENABLE_PAYMENT=true
```

### Option 2: Docker Production

```bash
# 1. Environment ayarla
# frontend/.env dosyasını oluştur ve değerleri doldur

# 2. Build ve çalıştır
docker-compose up -d

# Log'ları kontrol et
docker-compose logs -f

# Durdurmak için
docker-compose down
```

**URL:** http://localhost (port 80)

**Features:**
- ✅ Multi-stage build
- ✅ Nginx ile serve
- ✅ Gzip compression
- ✅ Security headers
- ✅ SPA routing
- ✅ Static asset caching

---

## 📁 Docker Dosyaları

### 1. docker-compose.local.yml (Development)

```yaml
services:
  frontend:
    build:
      dockerfile: Dockerfile.dev
    ports:
      - "5173:5173"
    volumes:
      - ./frontend:/app      # Hot reload
    env_file:
      - ./frontend/.env.local
    command: npm run dev
```

### 2. docker-compose.yml (Production)

```yaml
services:
  frontend:
    build:
      dockerfile: Dockerfile
      target: production
    ports:
      - "80:80"
    env_file:
      - ./frontend/.env
    restart: unless-stopped
```

### 3. Dockerfile.dev (Development)

- Node.js 18 Alpine
- npm install (tüm dependencies)
- Vite dev server
- Hot reload aktif

### 4. Dockerfile (Production)

**Stage 1: Build**
- Node.js 18 Alpine
- npm ci --only=production
- npm run build
- Optimized production build

**Stage 2: Serve**
- Nginx Alpine
- Static files serve
- Security headers
- Gzip compression
- SPA routing

---

## 🔧 Troubleshooting

### "Cannot connect to Docker daemon"

```bash
# Docker running mi kontrol et
docker ps

# Değilse başlat
# Windows: Docker Desktop aç
# Linux: sudo systemctl start docker
```

### "Port already in use"

```bash
# Port 5173 kullanımda (development)
# Başka bir şey çalışıyor mu?
lsof -i :5173  # Mac/Linux
netstat -ano | findstr :5173  # Windows

# Veya docker-compose.local.yml'de port değiştir:
ports:
  - "5174:5173"
```

### "npm install" takes forever

```bash
# Volume cache'i temizle
docker-compose -f docker-compose.local.yml down -v

# Yeniden build
docker-compose -f docker-compose.local.yml up --build
```

### Production build fails

```bash
# Environment variables kontrol et
cat frontend/.env

# Manuel build test
cd frontend
npm run build

# Docker log'ları kontrol et
docker-compose logs frontend
```

---

## 🎯 Hangi Ortamı Kullanmalıyım?

### Development → Native npm run dev ⭐
- En hızlı
- En kolay
- HMR sorunsuz

### Testing → Docker Local
- Production-like ortam test
- Nginx configuration test

### Production → Vercel/Netlify ⭐
- Otomatik deploy
- CDN
- SSL
- Zero config

### Self-hosting → Docker Production
- Kendi sunucun
- Tam kontrol
- Custom infrastructure

---

## 📝 Quick Commands

```bash
# === DEVELOPMENT ===

# Native (Önerilen)
npm run dev

# Docker
docker-compose -f docker-compose.local.yml up

# === PRODUCTION ===

# Vercel (Önerilen)
vercel --prod

# Docker
docker-compose up -d

# === MAINTENANCE ===

# Stop all
docker-compose down
docker-compose -f docker-compose.local.yml down

# Clean up
docker system prune -a

# Logs
docker-compose logs -f
docker-compose -f docker-compose.local.yml logs -f
```

---

## ✅ Checklist

### Development Setup
- [ ] `./setup-env.sh` çalıştırdım
- [ ] `frontend/.env.local` oluşturuldu
- [ ] Supabase credentials eklendi
- [ ] `npm run dev` çalışıyor

### Production Setup
- [ ] `frontend/.env` production values ile dolduruldu
- [ ] Build test edildi (`npm run build`)
- [ ] Docker test edildi (opsiyonel)
- [ ] Vercel/Netlify deploy edildi

---

**Önerilen Workflow:**

1. **Development:** `npm run dev` (native)
2. **Testing:** Docker Local
3. **Production:** Vercel/Netlify
4. **Self-hosting:** Docker Production

---

**Son Güncelleme:** 2024
**Versiyon:** 2.0.0

