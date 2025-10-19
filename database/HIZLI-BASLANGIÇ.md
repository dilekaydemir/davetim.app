# ⚡ Hızlı Başlangıç Kılavuzu

**Auth sorunlarını çözmek ve veritabanını temiz bir şekilde kurmak için 5 dakikalık kılavuz.**

## 🎯 Amaç

Bu kılavuz, Supabase veritabanınızı sıfırdan kurmanız ve auth sorunlarını çözmeniz için gereken minimum adımları içerir.

## ⏱️ Tahmini Süre: 5-10 dakika

## 📝 İhtiyacınız Olanlar

- ✅ Supabase hesabı ve proje erişimi
- ✅ Bu klasördeki SQL dosyaları
- ✅ 10 dakika zaman

## 🚀 3 Adımda Kurulum

### ADIM 1: Temizlik (2 dakika)

1. https://app.supabase.com → Projenize girin
2. Sol menü → **SQL Editor** → "+ New query"
3. `00-COMPLETE-CLEANUP.sql` dosyasını açın
4. İçeriği kopyala-yapıştır → **RUN**
5. "Database cleanup completed successfully!" mesajını bekleyin

### ADIM 2: Kurulum (3 dakika)

1. SQL Editor'de "+ New query" (veya query'yi temizle)
2. `01-COMPLETE-REBUILD.sql` dosyasını açın
3. İçeriği kopyala-yapıştır → **RUN**
4. "Database rebuild completed successfully! 🎉" mesajını bekleyin

### ADIM 3: Test (2 dakika)

**Kolay test:**
```sql
-- Bu sorguyu SQL Editor'de çalıştırın
SELECT 
    'Tablolar' as kontrol, 
    COUNT(*)::text || ' ✅' as sonuc
FROM information_schema.tables 
WHERE table_schema = 'public';
```

Sonuç: `10 ✅` görmelisiniz.

**Auth trigger testi:**
```sql
-- Auth trigger'ı kontrol et
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ Auth trigger TAMAM'
        ELSE '❌ Auth trigger YOK'
    END as durum
FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created';
```

## ✅ İşlem Tamamlandı!

Şimdi ne yapmalısınız?

### Frontend'den Test Edin

```bash
cd frontend
npm run dev
```

1. **Yeni kullanıcı oluşturun**: http://localhost:5173
2. Kayıt olun (email + şifre)
3. Giriş yapın
4. Dashboard'da subscription bilginizi kontrol edin

### Subscription Kontrolü

SQL Editor'de:
```sql
SELECT 
    u.email,
    s.tier as plan,
    s.status as durum,
    CASE 
        WHEN s.id IS NOT NULL THEN '✅ VAR'
        ELSE '❌ YOK'
    END as subscription
FROM auth.users u
LEFT JOIN subscriptions s ON s.user_id = u.id
ORDER BY u.created_at DESC
LIMIT 5;
```

## 🐛 Sorun mu Var?

### Problem 1: "Auth trigger çalışmıyor"

**Belirtiler:**
- Yeni kullanıcı oluşturuluyor ama subscription oluşmuyor
- `subscriptions` tablosu boş

**Çözüm:**
```sql
-- 1. Trigger'ı manuel oluştur
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- 2. Mevcut kullanıcılar için subscription oluştur
INSERT INTO public.subscriptions (user_id, tier, status, start_date)
SELECT id, 'free', 'active', NOW()
FROM auth.users
WHERE id NOT IN (SELECT user_id FROM subscriptions)
ON CONFLICT (user_id) DO NOTHING;
```

### Problem 2: "RLS hataları alıyorum"

**Belirtiler:**
- "new row violates row-level security policy"
- Frontend'den veri çekemiyorum

**Çözüm:**
```sql
-- RLS durumunu kontrol et
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';

-- Tüm tablolarda RLS aktif olmalı (rowsecurity = true)
-- Eğer false olanlar varsa:
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;
-- ... diğer tablolar
```

### Problem 3: "Storage bucket'lar yok"

**Çözüm:**

Supabase Dashboard:
1. Sol menü → **Storage**
2. "New bucket" → `qr-media` oluştur
   - Public: ✓
   - File size limit: 100000000 (100MB)
3. "New bucket" → `invitation-images` oluştur
   - Public: ✓
   - File size limit: 10000000 (10MB)

### Problem 4: "Template'ler görünmüyor"

**Çözüm:**
```sql
-- Template'lerin var olduğunu kontrol et
SELECT COUNT(*) FROM templates;

-- Eğer 0 ise, seed data'yı yeniden çalıştır
-- (01-COMPLETE-REBUILD.sql dosyasının PART 9 bölümü)
```

## 📊 Hızlı Sistem Durumu Kontrolü

Tek bir sorgu ile her şeyi kontrol edin:

```sql
-- SİSTEM DURUMU RAPORU
SELECT 
    '📊 TABLO SAYISI' as metric,
    COUNT(*)::text as value
FROM information_schema.tables 
WHERE table_schema = 'public'

UNION ALL

SELECT 
    '🔧 FONKSİYON SAYISI',
    COUNT(*)::text
FROM information_schema.routines 
WHERE routine_schema = 'public'

UNION ALL

SELECT 
    '👥 KULLANICI SAYISI',
    COUNT(*)::text
FROM auth.users

UNION ALL

SELECT 
    '💳 SUBSCRİPTİON SAYISI',
    COUNT(*)::text
FROM subscriptions

UNION ALL

SELECT 
    '📧 DAVETİYE SAYISI',
    COUNT(*)::text
FROM invitations

UNION ALL

SELECT 
    '📝 TEMPLATE SAYISI',
    COUNT(*)::text
FROM templates

UNION ALL

SELECT 
    '🔒 RLS AKTİF TABLOLAR',
    COUNT(*)::text
FROM pg_tables 
WHERE schemaname = 'public' 
AND rowsecurity = true

UNION ALL

SELECT 
    '📦 STORAGE BUCKET',
    COUNT(*)::text
FROM storage.buckets;
```

**Beklenen Değerler:**
- Tablo: 10
- Fonksiyon: 15+
- RLS aktif: 10
- Storage: 2

## 🎓 İleri Seviye

### Test Kullanıcısına Premium Ver

```sql
UPDATE subscriptions
SET 
    tier = 'premium',
    status = 'active',
    end_date = NOW() + INTERVAL '1 month'
WHERE user_id = (
    SELECT id FROM auth.users 
    WHERE email = 'test@davetim.app'
);
```

### Tüm İstatistikleri Göster

```sql
SELECT 
    u.email,
    s.tier,
    s.invitations_created_lifetime as total_invitations,
    s.storage_used_mb as storage_mb,
    COUNT(i.id) as active_invitations
FROM auth.users u
LEFT JOIN subscriptions s ON s.user_id = u.id
LEFT JOIN invitations i ON i.user_id = u.id
GROUP BY u.id, u.email, s.tier, s.invitations_created_lifetime, s.storage_used_mb
ORDER BY u.created_at DESC;
```

## 📚 Diğer Dosyalar

- `README.md` - Detaylı açıklamalar
- `EXECUTION-GUIDE.md` - Adım adım rehber
- `02-TROUBLESHOOTING-QUERIES.sql` - Sorun giderme sorguları

## 💡 Pro İpuçları

1. **Yedek alın**: Production'da her zaman önce yedek alın
2. **Test edin**: Önce development'ta test edin
3. **Log'ları izleyin**: Supabase Dashboard → Logs
4. **Email onayı**: Development'ta email confirmation'ı kapatabilirsiniz
5. **RLS test**: Her zaman bir test kullanıcısı ile RLS'i test edin

## 🆘 Acil Destek

Hiçbir şey çalışmıyorsa:

```sql
-- NÜKLEER SEÇENEK: Her şeyi sıfırla
-- ⚠️ SADECE DEVELOPMENT İÇİN!

-- 1. Tüm kullanıcıları sil (Authentication > Users > Delete)
-- 2. Cleanup script'i çalıştır
-- 3. Rebuild script'i çalıştır
-- 4. Yeni kullanıcı oluştur
-- 5. Test et
```

---

**Başarılar! Sorularınız için dokümantasyona göz atın.** 🚀

