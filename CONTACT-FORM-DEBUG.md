# 🔍 İletişim Formu Debug Rehberi

## ❌ Aldığınız Hata

```
Failed to load resource: the server responded with a status of 500
Contact form error: Error: Failed to send email
```

---

## 🎯 Yapmanız Gerekenler

### 1️⃣ Edge Function'ı Yeniden Deploy Edin

Güncellenmiş kodu deploy etmeniz gerekiyor (debug logları eklendi):

**Supabase Dashboard:**
1. Edge Functions → `contact-form` seçin
2. Kodu güncelleyin (aşağıdaki kodu kopyalayın)
3. **Deploy** butonuna tıklayın

**Güncel Kod:** `supabase/functions/contact-form/index.ts` dosyasını açın ve tüm içeriği kopyalayın.

---

### 2️⃣ Supabase Logs'u Kontrol Edin

**Adımlar:**

1. **Supabase Dashboard** → **Edge Functions** → **contact-form**
2. **Logs** tab'ına tıklayın
3. **Formu tekrar gönderin**
4. **Logs'da şunları arayın:**

#### ✅ Başarılı Durum:
```
📧 SMTP Configuration:
- Host: smtp.gmail.com
- Port: 587
- User: your-email@gmail.com
- Pass: ***SET***
✅ Email sent successfully from test@example.com
```

#### ❌ Hata Durumları:

**A) Environment Variables Eksik:**
```
SMTP credentials not configured
SMTP_USER: NOT SET
SMTP_PASS: NOT SET
```
**Çözüm:** Environment variables'ı kontrol edin (Adım 3)

**B) SMTP Authentication Failed:**
```
Error: Authentication failed
```
**Çözüm:** App Password yanlış (Adım 4)

**C) SMTP Connection Failed:**
```
Error: Connection timeout
Error: ECONNREFUSED
```
**Çözüm:** SMTP_HOST veya SMTP_PORT yanlış (Adım 5)

---

### 3️⃣ Environment Variables'ı Kontrol Edin

**Supabase Dashboard:**

1. **Project Settings** → **Edge Functions** → **Secrets**
2. Şu 4 değişkenin olduğundan emin olun:

| Name | Doğru Değer | Kontrol |
|------|-------------|---------|
| `SMTP_HOST` | `smtp.gmail.com` | ✅ Tam olarak bu |
| `SMTP_PORT` | `587` | ✅ Sayı olarak |
| `SMTP_USER` | `your-email@gmail.com` | ✅ Gmail adresiniz |
| `SMTP_PASS` | `abcdefghijklmnop` | ✅ 16 hane, BOŞLUKSUZ |

**⚠️ ÇOK ÖNEMLİ:**
- `SMTP_PASS` değerini girerken **boşlukları kaldırın**
- Gmail'den aldığınız: `abcd efgh ijkl mnop`
- Girmeniz gereken: `abcdefghijklmnop`

---

### 4️⃣ Gmail App Password'ü Yeniden Oluşturun

Bazen App Password geçersiz olabilir:

1. https://myaccount.google.com/security
2. **App passwords** bölümüne gidin
3. **Eski password'ü silin** (varsa)
4. **Yeni bir tane oluşturun:**
   - App: Mail
   - Device: Other (Custom name) → "Davetim"
   - Generate
5. **16 haneli yeni şifreyi kopyalayın**
6. **Boşlukları kaldırın**
7. **Supabase'de SMTP_PASS'ı güncelleyin**

---

### 5️⃣ SMTP Ayarlarını Doğrulayın

**Gmail için doğru ayarlar:**

```
SMTP_HOST = smtp.gmail.com
SMTP_PORT = 587
```

**Alternatif (SSL):**
```
SMTP_HOST = smtp.gmail.com
SMTP_PORT = 465
```

**Not:** 587 (TLS) önerilir, 465 (SSL) de çalışır.

---

### 6️⃣ Gmail Güvenlik Ayarlarını Kontrol Edin

1. https://myaccount.google.com/security
2. **"2-Step Verification"** aktif olmalı
3. **"Less secure app access"** kapalı olmalı (App Password kullanıyoruz)
4. **"Allow less secure apps"** AÇIK olmalı (eski hesaplarda)

---

## 🧪 Manuel Test

Edge Function'ı doğrudan test edin:

**Terminal'de:**

```bash
curl -X POST \
  https://YOUR_PROJECT_REF.supabase.co/functions/v1/contact-form \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "subject": "Test",
    "message": "Test message"
  }'
```

**Project Ref ve Anon Key:**
- Supabase Dashboard → Project Settings → API
- Project URL'den `YOUR_PROJECT_REF` alın
- `anon/public` key'i kopyalayın

---

## 📊 Olası Hatalar ve Çözümleri

### ❌ "Server configuration error - SMTP credentials missing"
**Sebep:** Environment variables girilmemiş
**Çözüm:** Adım 3'ü tekrarlayın

### ❌ "Authentication failed"
**Sebep:** App Password yanlış veya boşluklu girilmiş
**Çözüm:** Adım 4'ü tekrarlayın, boşlukları kaldırın

### ❌ "Connection timeout" veya "ECONNREFUSED"
**Sebep:** SMTP_HOST veya SMTP_PORT yanlış
**Çözüm:** Adım 5'i kontrol edin

### ❌ "Invalid email address"
**Sebep:** Form validasyonu başarısız
**Çözüm:** Geçerli bir email adresi girin

### ❌ "Missing required fields"
**Sebep:** Ad, email veya mesaj boş
**Çözüm:** Tüm alanları doldurun

---

## 🎯 Hızlı Kontrol Listesi

- [ ] Edge Function'ı yeniden deploy ettim (güncellenmiş kod)
- [ ] Supabase Logs'u açtım
- [ ] Formu tekrar gönderdim
- [ ] Logs'da hata mesajını gördüm
- [ ] 4 environment variable'ı kontrol ettim
- [ ] SMTP_PASS'ı boşluksuz girdim
- [ ] Gmail App Password'ü yeniden oluşturdum
- [ ] 2-Step Verification aktif
- [ ] Logs'da "✅ Email sent successfully" gördüm
- [ ] Gmail'e email geldi

---

## 📧 Bana Göndermeniz Gerekenler

Eğer hala çalışmıyorsa, şunları paylaşın:

1. **Supabase Logs'dan hata mesajı** (tam metin)
2. **Environment variables ekran görüntüsü** (SMTP_PASS'ı gizleyin)
3. **Gmail App Password ekran görüntüsü** (şifreyi gizleyin)
4. **Edge Function deploy durumu** (başarılı mı?)

---

## ✅ Başarı Durumu

Logs'da şunu görmelisiniz:

```
📧 SMTP Configuration:
- Host: smtp.gmail.com
- Port: 587
- User: your-email@gmail.com
- Pass: ***SET***
✅ Email sent successfully from test@example.com
```

Ve Gmail'e şöyle bir email gelmelidir:

```
Konu: Yeni İletişim Formu Mesajı - Davetim.app
Gönderen: your-email@gmail.com
Alıcı: info@davetim.app

[Profesyonel HTML email template]
```

---

**Başarılar! 🚀**

