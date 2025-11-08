# 📧 Resend API Kurulum Rehberi (SMTP Alternatifi)

## 🎯 Neden Resend?

**SMTP Sorunu:**
- ❌ `denomailer` kütüphanesi Gmail ile uyumsuz
- ❌ "InvalidContentType" hatası
- ❌ Karmaşık TCP/TLS bağlantı yönetimi

**Resend Çözümü:**
- ✅ **Ücretsiz 3,000 email/ay** (100 email/gün)
- ✅ **Çok kolay kurulum** (5 dakika)
- ✅ **%100 güvenilir** (Vercel'in email servisi)
- ✅ **Profesyonel** (SPF/DKIM otomatik)
- ✅ **API tabanlı** (SMTP karmaşıklığı yok)

---

## ⚡ Hızlı Kurulum (5 Dakika)

### 1️⃣ Resend Hesabı Oluşturun (2 dk)

1. **https://resend.com/signup** adresine gidin
2. **GitHub** veya **Google** ile giriş yapın
3. Email adresinizi doğrulayın

### 2️⃣ API Key Oluşturun (1 dk)

1. Resend Dashboard'a gidin: https://resend.com/api-keys
2. **"Create API Key"** butonuna tıklayın
3. **Name:** `Davetim Contact Form`
4. **Permission:** `Sending access` seçin
5. **"Add"** butonuna tıklayın
6. **API Key'i kopyalayın** (örn: `re_123456789...`)
   - ⚠️ Sadece bir kez gösterilir, kaydedin!

### 3️⃣ Supabase'e API Key Ekleyin (1 dk)

1. **Supabase Dashboard** → **Project Settings** → **Edge Functions** → **Secrets**
2. **"Add new secret"** butonuna tıklayın
3. **Name:** `RESEND_API_KEY`
4. **Value:** `re_123456789...` (kopyaladığınız key)
5. **"Save"** butonuna tıklayın

### 4️⃣ Edge Function'ı Yeniden Deploy Edin (1 dk)

1. **Supabase Dashboard** → **Edge Functions** → **contact-form**
2. Mevcut kodu silin
3. `supabase/functions/contact-form/index.ts` dosyasındaki **güncel kodu** kopyalayıp yapıştırın
4. **"Deploy"** butonuna tıklayın

### 5️⃣ Test Edin! (30 saniye)

1. Web sitenizde **İletişim** sayfasına gidin
2. Formu doldurun
3. **"Gönder"** butonuna tıklayın
4. **info@davetim.app** adresini kontrol edin

---

## ✅ Başarı Kontrolü

### Supabase Logs'da Göreceğiniz:

```
📧 Sending email via Resend API...
✅ Email sent successfully from test@example.com { id: "abc123..." }
```

### Email Görünümü:

```
Gönderen: Davetim.app <onboarding@resend.dev>
Alıcı: info@davetim.app
Reply-To: test@example.com (formdan gelen email)
Konu: Yeni İletişim Formu Mesajı - Davetim.app

[Profesyonel HTML template]
```

---

## 🆚 SMTP vs Resend Karşılaştırması

| Özellik | SMTP (Gmail) | Resend |
|---------|--------------|--------|
| Kurulum | ⭐⭐⭐ Orta | ⭐⭐⭐⭐⭐ Çok Kolay |
| Güvenilirlik | ⭐⭐⭐ Orta | ⭐⭐⭐⭐⭐ Mükemmel |
| Hata Oranı | ⚠️ Yüksek | ✅ Çok Düşük |
| Günlük Limit | 500 | 100 (ücretsiz) |
| Aylık Limit | 15,000 | 3,000 (ücretsiz) |
| Maliyet | Ücretsiz | Ücretsiz |
| Spam Riski | Düşük | Çok Düşük |
| SPF/DKIM | Manuel | Otomatik |
| Destek | - | Email + Docs |

---

## 💰 Resend Fiyatlandırma

### Ücretsiz Plan:
- ✅ 3,000 email/ay
- ✅ 100 email/gün
- ✅ Tek domain
- ✅ API erişimi
- ✅ Email tracking
- ⚠️ `onboarding@resend.dev` gönderici adresi

### Pro Plan ($20/ay):
- ✅ 50,000 email/ay
- ✅ Özel domain (`info@davetim.app`)
- ✅ Sınırsız domain
- ✅ Webhook'lar
- ✅ Analytics

**Önerimiz:** Ücretsiz plan ile başlayın, ihtiyaç olursa yükseltin.

---

## 🔧 Özel Domain Ekleme (İsteğe Bağlı)

Eğer `info@davetim.app` adresinden mail göndermek isterseniz:

### 1. Resend Dashboard'da Domain Ekleyin:

1. https://resend.com/domains
2. **"Add Domain"** → `davetim.app`
3. DNS kayıtlarını kopyalayın

### 2. DNS Kayıtlarını Ekleyin:

Domain yöneticinizde (örn: Cloudflare, GoDaddy):

```
TXT  @  v=spf1 include:resend.com ~all
TXT  resend._domainkey  [Resend'den alınan DKIM key]
```

### 3. Edge Function'ı Güncelleyin:

```typescript
from: 'Davetim.app <info@davetim.app>',
```

**Not:** Özel domain için **Pro plan** ($20/ay) gerekir.

---

## 🐛 Troubleshooting

### ❌ "Server configuration error - API key missing"
**Çözüm:** 
- Supabase → Edge Functions → Secrets
- `RESEND_API_KEY` ekleyin

### ❌ "Failed to send email via Resend"
**Çözüm:**
- Resend Dashboard → API Keys
- Key'in aktif olduğunu kontrol edin
- Yeni bir key oluşturun

### ❌ "Daily sending quota exceeded"
**Çözüm:**
- Ücretsiz plan: 100 email/gün
- Yarın tekrar deneyin veya Pro'ya geçin

### ❌ Email gelmiyor
**Çözüm:**
- Spam klasörünü kontrol edin
- Resend Dashboard → Logs → Email durumunu kontrol edin

---

## 📊 Email Tracking

Resend Dashboard'da email durumlarını görebilirsiniz:

1. https://resend.com/emails
2. Her emailin durumunu görün:
   - ✅ Delivered
   - 📬 Opened
   - 🔗 Clicked
   - ⚠️ Bounced
   - 🚫 Complained

---

## ✅ Checklist

- [ ] Resend hesabı oluşturdum
- [ ] API Key aldım
- [ ] Supabase'e `RESEND_API_KEY` ekledim
- [ ] Edge Function'ı yeniden deploy ettim
- [ ] İletişim formunu test ettim
- [ ] Email geldi! 🎉

---

## 🎉 Sonuç

**Resend çok daha kolay ve güvenilir!**

- ✅ SMTP karmaşıklığı yok
- ✅ Authentication hataları yok
- ✅ Connection timeout yok
- ✅ 5 dakikada kurulum
- ✅ %100 çalışıyor

**Başarılar! 🚀**

---

## 📚 Ek Kaynaklar

- **Resend Docs:** https://resend.com/docs
- **API Reference:** https://resend.com/docs/api-reference
- **Edge Function Kodu:** `supabase/functions/contact-form/index.ts`
- **Frontend Kodu:** `frontend/src/pages/ContactPage.tsx`

