# 🚀 Adım Adım Uygulama Kılavuzu

Bu kılavuz, veritabanını sıfırdan kurmak için gereken adımları detaylı olarak açıklar.

## ⚠️ BAŞLAMADAN ÖNCE

- [ ] **YEDEKLEMEYİ UNUTMAYIN!** Production verisi varsa mutlaka yedek alın
- [ ] Tüm kullanıcıları bilgilendirin (sistem kısa süre erişilemez olacak)
- [ ] Test ortamında önce deneyin

## 📋 Hazırlık

### Gerekli Bilgiler

1. Supabase Project URL: `https://[your-project].supabase.co`
2. Supabase Project API Keys (anon key ve service_role key)
3. Database direct connection (eğer gerekirse)

## 🔧 Uygulama Adımları

### ADIM 1: Supabase Dashboard'a Giriş

1. https://app.supabase.com adresine gidin
2. Gmail hesabınızla giriş yapın
3. İlgili projeyi seçin: **davetim.app**

### ADIM 2: SQL Editor'ü Açın

1. Sol menüden **SQL Editor** seçeneğine tıklayın
2. "+ New query" butonuna tıklayın
3. Boş bir query editörü açılacak

### ADIM 3: Database Cleanup (Temizlik)

#### 3.1 Cleanup Script'ini Çalıştır

1. `database/00-COMPLETE-CLEANUP.sql` dosyasını bir text editörde açın
2. **TÜM İÇERİĞİ** kopyalayın (Ctrl+A, sonra Ctrl+C)
3. Supabase SQL Editor'a yapıştırın (Ctrl+V)
4. Sağ alt köşedeki **RUN** butonuna tıklayın
5. Script çalışırken bekleyin (yaklaşık 10-30 saniye)

#### 3.2 Sonucu Kontrol Edin

Başarılı olursa göreceksiniz:
```
status: "Database cleanup completed successfully!"
```

Eğer hata alırsanız:
- Hatayı not alın
- Script'i tekrar çalıştırmayı deneyin
- Bazı objeler zaten silinmiş olabilir (bu normal)

### ADIM 4: Database Rebuild (Yeniden Oluşturma)

#### 4.1 Rebuild Script'ini Çalıştır

1. "+ New query" ile yeni bir query açın (veya mevcut query'yi temizleyin)
2. `database/01-COMPLETE-REBUILD.sql` dosyasını açın
3. **TÜM İÇERİĞİ** kopyalayın
4. Supabase SQL Editor'a yapıştırın
5. **RUN** butonuna tıklayın
6. Script çalışırken bekleyin (yaklaşık 30-60 saniye)

#### 4.2 Sonucu Kontrol Edin

Başarılı olursa göreceksiniz:
```
status: "Database rebuild completed successfully! 🎉"
table_count: "Tables created: 10"
function_count: "Functions created: 11"
```

### ADIM 5: Manuel Kontroller

#### 5.1 Tabloları Kontrol Edin

SQL Editor'de çalıştırın:
```sql
-- Tüm tabloları listele
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

Görmek istediğiniz tablolar:
- ✅ subscriptions
- ✅ template_categories
- ✅ templates
- ✅ user_templates
- ✅ invitations
- ✅ guests
- ✅ invitation_guests
- ✅ media
- ✅ guest_uploads
- ✅ payment_history

#### 5.2 Fonksiyonları Kontrol Edin

```sql
-- Tüm fonksiyonları listele
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema = 'public'
ORDER BY routine_name;
```

Görmek istediğiniz fonksiyonlar:
- ✅ handle_new_user
- ✅ generate_invitation_slug
- ✅ increment_invitation_views
- ✅ increment_invitation_count
- ✅ get_invitation_guest_stats
- ✅ increment_template_usage
- ✅ increment_media_scan_count
- ✅ increment_media_view_count
- ✅ inc_guest_uploads_count
- ✅ update_updated_at_column

#### 5.3 Trigger'ları Kontrol Edin

```sql
-- Auth trigger'ı kontrol et
SELECT trigger_name, event_object_table, action_statement
FROM information_schema.triggers
WHERE trigger_schema = 'auth'
ORDER BY trigger_name;
```

Görmek istediğiniz trigger:
- ✅ on_auth_user_created (auth.users tablosunda)

#### 5.4 Storage Bucket'ları Kontrol Edin

1. Sol menüden **Storage** seçeneğine tıklayın
2. Şu bucket'ları görmelisiniz:
   - ✅ qr-media (public, 100MB limit)
   - ✅ invitation-images (public, 10MB limit)

#### 5.5 RLS Politikalarını Kontrol Edin

```sql
-- Tüm RLS politikalarını listele
SELECT schemaname, tablename, policyname 
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
```

Her tablo için politikalar olmalı.

### ADIM 6: Auth Trigger Test

#### 6.1 Test Kullanıcısı Oluştur

Frontend'den veya Supabase Dashboard'dan bir test kullanıcısı oluşturun:

**Dashboard'dan:**
1. Authentication > Users
2. "Add user" butonuna tıklayın
3. Email: `test@davetim.app`
4. Password: `Test123456!`
5. Auto Confirm User: **Evet** (✓)
6. "Create user" tıklayın

#### 6.2 Subscription Kontrolü

SQL Editor'de kontrol edin:
```sql
-- Test kullanıcısının subscription'ını kontrol et
SELECT u.email, s.*
FROM auth.users u
LEFT JOIN public.subscriptions s ON s.user_id = u.id
WHERE u.email = 'test@davetim.app';
```

**Beklenen sonuç:**
- ✅ Subscription kaydı var
- ✅ tier = 'free'
- ✅ status = 'active'
- ✅ start_date = bugünün tarihi

Eğer subscription yoksa:
```sql
-- Manuel olarak oluştur
INSERT INTO public.subscriptions (user_id, tier, status, start_date)
SELECT id, 'free', 'active', NOW()
FROM auth.users
WHERE email = 'test@davetim.app';
```

### ADIM 7: Frontend Test

#### 7.1 Environment Variables

`frontend/.env.local` dosyasını kontrol edin:
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

#### 7.2 Uygulamayı Başlatın

```bash
cd frontend
npm install
npm run dev
```

#### 7.3 Temel İşlevleri Test Edin

1. **Kayıt Olma**
   - [ ] Yeni kullanıcı oluştur
   - [ ] Email onayı (varsa)
   - [ ] Dashboard'a yönlendirme

2. **Giriş Yapma**
   - [ ] Email/Password ile giriş
   - [ ] Google ile giriş (varsa)

3. **Subscription Kontrolü**
   - [ ] Account sayfasında subscription bilgisi görünüyor mu?
   - [ ] Tier: Free
   - [ ] Limit bilgileri doğru mu?

4. **Davetiye Oluşturma**
   - [ ] Şablonları görebiliyor musunuz?
   - [ ] Davetiye oluşturabiliyor musunuz?
   - [ ] Slug otomatik oluşuyor mu?

5. **Davetli Ekleme**
   - [ ] Davetiye detayında davetli ekleyebiliyor musunuz?
   - [ ] Guest token oluşuyor mu?

### ADIM 8: Production Hazırlık

#### 8.1 Email Settings

1. Authentication > Email Templates
2. Confirm signup template'i düzenleyin
3. Password recovery template'i düzenleyin

#### 8.2 Auth Settings

1. Authentication > Settings
2. Email confirmations: **Aktif** (Production için)
3. Email OTP length: 6
4. Minimum password length: 8

#### 8.3 RLS Final Check

```sql
-- Her tabloda RLS aktif mi?
SELECT schemaname, tablename, 
       CASE WHEN rowsecurity THEN 'Enabled ✅' ELSE 'Disabled ❌' END as rls_status
FROM pg_tables
WHERE schemaname = 'public'
AND tablename NOT LIKE 'pg_%'
ORDER BY tablename;
```

Tüm tablolarda "Enabled ✅" olmalı!

## ✅ Başarı Kriterleri

Aşağıdakilerin hepsi başarılıysa, kurulum tamamdır:

- [x] Cleanup script başarılı
- [x] Rebuild script başarılı
- [x] 10 tablo oluşturuldu
- [x] 11 fonksiyon oluşturuldu
- [x] Auth trigger çalışıyor (yeni kullanıcı = yeni subscription)
- [x] 2 storage bucket oluştu
- [x] RLS tüm tablolarda aktif
- [x] Frontend'den kayıt olma çalışıyor
- [x] Frontend'den giriş yapma çalışıyor
- [x] Davetiye oluşturma çalışıyor
- [x] Subscription bilgisi görünüyor

## 🐛 Hata Ayıklama

### "Auth trigger çalışmıyor"

**Çözüm 1: Manuel trigger oluştur**
```sql
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();
```

**Çözüm 2: Function'ı test et**
```sql
-- Function'ı manuel çağır
SELECT public.handle_new_user() FROM auth.users WHERE email = 'test@davetim.app';
```

### "RLS politikaları çalışmıyor"

```sql
-- Tüm politikaları geçici olarak devre dışı bırak (sadece test için!)
ALTER TABLE public.subscriptions DISABLE ROW LEVEL SECURITY;
-- ... diğer tablolar

-- Test sonrası tekrar aktif et
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
```

### "Storage bucket oluşturulamadı"

1. Dashboard > Storage
2. Manuel olarak bucket oluşturun:
   - Name: `qr-media`
   - Public: ✓
   - File size limit: 104857600 (100MB)
   - Allowed MIME types: video/mp4, image/jpeg, image/png, etc.

## 📚 Ek Kaynaklar

- [Supabase Documentation](https://supabase.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)

---

**Başarılar! 🎉**

