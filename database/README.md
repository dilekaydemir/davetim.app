# Database Setup Guide - Davetim.app

Bu klasör, Davetim.app projesinin Supabase veritabanı yapılandırmasını içerir.

## 🚨 Önemli Uyarı

Bu scriptler veritabanınızdaki **TÜM VERİLERİ SİLER**. Production ortamında kullanmadan önce **mutlaka yedek alın**!

## 📋 İçerik

### Ana Scriptler

1. **00-COMPLETE-CLEANUP.sql** - Tüm veritabanı yapılarını siler
2. **01-COMPLETE-REBUILD.sql** - Tüm veritabanı yapılarını yeniden oluşturur

## 🔧 Kullanım Adımları

### Adım 1: Supabase Dashboard'a Giriş

1. [Supabase Dashboard](https://app.supabase.com) adresine gidin
2. Projenizi seçin
3. Sol menüden **SQL Editor** seçeneğine tıklayın

### Adım 2: Cleanup (Temizlik)

1. `00-COMPLETE-CLEANUP.sql` dosyasını açın
2. Tüm içeriği kopyalayın
3. Supabase SQL Editor'a yapıştırın
4. **RUN** butonuna tıklayın
5. Script tamamlanana kadar bekleyin (yaklaşık 10-30 saniye)

### Adım 3: Rebuild (Yeniden Oluşturma)

1. `01-COMPLETE-REBUILD.sql` dosyasını açın
2. Tüm içeriği kopyalayın
3. Supabase SQL Editor'a yapıştırın
4. **RUN** butonuna tıklayın
5. Script tamamlanana kadar bekleyin (yaklaşık 30-60 saniye)

### Adım 4: Doğrulama

Script başarıyla çalıştıysa, şu mesajları görmelisiniz:
```
Database rebuild completed successfully! 🎉
Tables created: 10
Functions created: 11
```

## 📊 Oluşturulan Yapılar

### Tablolar

| Tablo | Açıklama |
|-------|----------|
| `subscriptions` | Kullanıcı abonelikleri ve kullanım limitleri |
| `template_categories` | Şablon kategorileri |
| `templates` | Davetiye şablonları |
| `user_templates` | Kullanıcıların kaydettiği şablonlar |
| `invitations` | Kullanıcı davetiyeleri |
| `guests` | Davetli listesi (ana tablo) |
| `invitation_guests` | Davetli listesi (alternatif) |
| `media` | QR medya sistemi (Premium özellik) |
| `guest_uploads` | Misafir yüklemeleri |
| `payment_history` | Ödeme geçmişi |

### Fonksiyonlar

- `handle_new_user()` - Yeni kullanıcı kaydında otomatik abonelik oluşturur
- `generate_invitation_slug()` - Davetiye için benzersiz URL slug'ı oluşturur
- `increment_invitation_views()` - Davetiye görüntüleme sayısını artırır
- `increment_invitation_count()` - Kullanıcının davetiye sayacını artırır
- `get_invitation_guest_stats()` - Davetli istatistiklerini döndürür
- `increment_template_usage()` - Şablon kullanım sayacını artırır
- `increment_media_scan_count()` - QR tarama sayacını artırır
- `increment_media_view_count()` - Medya görüntüleme sayacını artırır
- `inc_guest_uploads_count()` - Misafir yükleme sayacını artırır
- `update_updated_at_column()` - Otomatik `updated_at` günceller

### Storage Buckets

- `qr-media` - QR medya dosyaları (video, resim, ses)
- `invitation-images` - Davetiye görselleri

### Trigger'lar

- **Auth Trigger**: Yeni kullanıcı kaydında otomatik ücretsiz abonelik oluşturur
- **Updated At Triggers**: Tüm tablolarda `updated_at` alanını otomatik günceller

### Row Level Security (RLS)

Tüm tablolarda RLS aktiftir ve şu kurallar uygulanır:

- Kullanıcılar sadece kendi verilerini görebilir/düzenleyebilir
- Yayınlanmış davetiyeler herkese açıktır
- Şablonlar herkese açıktır (okuma)
- QR medya herkese açıktır (aktif olanlar)
- Misafirler token ile kendi verilerini güncelleyebilir

## 🔍 Sorun Giderme

### Hata: "permission denied for schema public"

**Çözüm**: Supabase projenizdeki user'a gerekli izinleri verin:
```sql
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres;
```

### Hata: "function already exists"

**Çözüm**: Önce cleanup script'ini çalıştırın, sonra rebuild script'ini tekrar çalıştırın.

### Hata: "trigger does not exist"

**Çözüm**: Normal bir uyarıdır, rebuild script'i çalıştırdığınızda düzelir.

### Hata: "bucket already exists"

**Çözüm**: Storage buckets manuel olarak silin:
1. Supabase Dashboard > Storage
2. Her bucket'ı seçin ve sağ üstten "Delete bucket" seçin
3. Cleanup script'ini tekrar çalıştırın

## 🎯 Auth Sorunları İçin

Eğer auth sorunları yaşıyorsanız:

1. Supabase Dashboard > Authentication > Policies
2. Tüm custom policy'leri kontrol edin
3. Email confirmation ayarlarını kontrol edin:
   - Dashboard > Authentication > Settings
   - "Enable email confirmations" ayarını kontrol edin

## 📝 Önemli Notlar

1. **Trigger Kontrolü**: Auth trigger'ı test etmek için:
   ```sql
   -- Yeni bir test kullanıcısı oluşturun
   -- Sonra subscriptions tablosunu kontrol edin
   SELECT * FROM subscriptions WHERE user_id = 'test-user-id';
   ```

2. **RLS Test**: RLS politikalarını test etmek için:
   ```sql
   -- Authenticated user olarak test
   SELECT * FROM invitations; -- Sadece kendi davetiyelerinizi görmeli
   ```

3. **Storage Test**: Storage bucket'larını test etmek için:
   ```sql
   SELECT * FROM storage.buckets;
   SELECT * FROM storage.objects LIMIT 5;
   ```

## 🚀 Sonraki Adımlar

1. Frontend'den test kullanıcısı oluşturun
2. Bir davetiye oluşturmayı deneyin
3. Şablon seçimi yapın
4. QR medya yüklemeyi test edin (Premium users)
5. RSVP flow'unu test edin

## 📞 Destek

Sorun yaşarsanız:
1. Supabase logs'ları kontrol edin
2. Browser console'u kontrol edin
3. Network tab'ında API çağrılarını inceleyin

## 🔄 Güncelleme Geçmişi

- **v1.0.0** (2024) - İlk sürüm
  - Tüm tablolar, fonksiyonlar ve politikalar oluşturuldu
  - Auth trigger sistemi eklendi
  - QR medya sistemi entegrasyonu

---

**Not**: Bu scriptler production-ready'dir ancak production'da kullanmadan önce mutlaka test ortamında deneyin!

