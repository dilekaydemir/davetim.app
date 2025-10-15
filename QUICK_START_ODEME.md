# ⚡ Hızlı Başlangıç - Ödeme Testi

## 🚀 3 Adımda Test Et!

### 1️⃣ Database Setup (5 dakika)

**Supabase SQL Editor'da çalıştırın:**

```sql
-- ADIM 1: Subscriptions tablosu
CREATE TABLE IF NOT EXISTS subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  tier VARCHAR(20) DEFAULT 'free' CHECK (tier IN ('free', 'pro', 'premium')),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'cancelled', 'expired', 'trialing')),
  start_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  end_date TIMESTAMP WITH TIME ZONE,
  cancelled_at TIMESTAMP WITH TIME ZONE,
  invitations_created_this_month INTEGER DEFAULT 0,
  invitations_created_lifetime INTEGER DEFAULT 0,
  storage_used_mb DECIMAL(10, 2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON subscriptions(user_id);
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own subscription" ON subscriptions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own subscription" ON subscriptions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own subscription" ON subscriptions FOR UPDATE USING (auth.uid() = user_id);

-- ADIM 2: Payment history tablosu
CREATE TABLE IF NOT EXISTS payment_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  transaction_id VARCHAR(255) NOT NULL UNIQUE,
  provider_transaction_id VARCHAR(255),
  provider VARCHAR(50) DEFAULT 'iyzico',
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'TRY',
  status VARCHAR(20) NOT NULL,
  plan_tier VARCHAR(20) NOT NULL CHECK (plan_tier IN ('pro', 'premium')),
  billing_period VARCHAR(10) NOT NULL CHECK (billing_period IN ('monthly', 'yearly')),
  description TEXT,
  error_message TEXT,
  processed_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_payment_history_user_id ON payment_history(user_id);
ALTER TABLE payment_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own payment history" ON payment_history FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own payment history" ON payment_history FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ADIM 3: Helper function
CREATE OR REPLACE FUNCTION increment_invitation_count(p_user_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE subscriptions SET 
    invitations_created_this_month = invitations_created_this_month + 1,
    invitations_created_lifetime = invitations_created_lifetime + 1
  WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

✅ **Success:** `Query completed successfully`

---

### 2️⃣ Payment Service Kontrolü (1 dakika)

**Tarayıcıda açın:**

```
http://localhost:5000/api/payment/providers
```

✅ **Beklenen çıktı:** `["iyzico"]`

❌ **Hata alırsanız:**
```bash
# Payment service'i başlatın
docker ps | grep payment
# Yoksa docker-compose up -d payment-service
```

---

### 3️⃣ Test Ödemesi (2 dakika)

#### a) Plan Seç
1. `http://localhost:3000/pricing` adresine git
2. **Login yap** (zorunlu)
3. **PRO** veya **PREMIUM** planından birini seç
4. Butona tıkla

#### b) Ödeme Formu
**Test kartı kullan (dev mode):**
- Modal içinde **"🧪 Test kartı kullan"** butonuna tıkla
- Kart bilgileri otomatik doldurulur

**Veya manuel gir:**
```
Kart No:    5528 7900 0000 0008
Ad Soyad:   TEST USER
Ay/Yıl:     12/2030
CVV:        123

Fatura Adresi:
Ad Soyad:   Test User
Şehir:      Istanbul
Adres:      Test Address 123
```

#### c) Ödeme Yap
1. **"Öde"** butonuna tıkla
2. **Popup** açılacak (3D Secure)
3. **"Başarılı"** seçeneğini seç
4. Otomatik yönlendirme:
   - `/payment/callback` (işlem kontrolü)
   - `/dashboard` (başarılı)

#### d) Doğrula
1. Dashboard'da planınız güncellenmiş olmalı
2. `/account` > **Ödemeler** tab'ına git
3. Ödeme kaydını görmelisiniz

---

## 🎯 Hızlı Kontrol Listesi

- [ ] Subscriptions tablosu oluşturuldu
- [ ] Payment history tablosu oluşturuldu
- [ ] Payment service çalışıyor (localhost:5000)
- [ ] .env dosyasında `VITE_PAYMENT_API_URL` var
- [ ] Kullanıcı login yapmış
- [ ] Test kartı çalışıyor
- [ ] 3D Secure popup açılıyor
- [ ] Ödeme başarılı, plan güncellendi
- [ ] Ödeme geçmişinde kayıt var

---

## 🐛 Sorun mu Var?

### ❌ "Payment service bağlanamıyor"
```bash
# Kontrol et:
curl http://localhost:5000/api/payment/providers

# Başlat:
docker-compose up -d payment-service
```

### ❌ "Popup blocked"
- Tarayıcı popup engelleyicisini kapat
- F12 > Console'da hata var mı kontrol et

### ❌ "Subscription güncellenmiyor"
```sql
-- Supabase'de kontrol et:
SELECT * FROM subscriptions WHERE user_id = 'your-user-id';
SELECT * FROM payment_history ORDER BY created_at DESC LIMIT 5;
```

### ❌ "Test kartı çalışmıyor"
- Başarılı: `5528790000000008`
- Başarısız: `5528790000000004`
- CVV: `123`, Tarih: `12/2030`

---

## 📞 Destek

Detaylı dokümantasyon:
- [PAYMENT_INTEGRATION.md](./PAYMENT_INTEGRATION.md) - Teknik detaylar
- [ODEME_ENTEGRASYONU_OZET.md](./ODEME_ENTEGRASYONU_OZET.md) - Genel bakış

---

**İyi testler! 🚀**

