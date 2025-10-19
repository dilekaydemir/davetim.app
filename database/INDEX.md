# 📚 Database Documentation Index

Davetim.app veritabanı kurulumu ve yönetimi için tüm dokümanlar.

## 📁 Dosya Yapısı

```
database/
├── 00-COMPLETE-CLEANUP.sql          # Tüm yapıları siler
├── 01-COMPLETE-REBUILD.sql          # Tüm yapıları yeniden oluşturur
├── 02-TROUBLESHOOTING-QUERIES.sql   # Sorun giderme sorguları
├── HIZLI-BASLANGIÇ.md              # ⚡ 5 dakikalık hızlı kurulum
├── README.md                        # 📖 Genel bakış ve açıklamalar
├── EXECUTION-GUIDE.md               # 📋 Adım adım uygulama rehberi
└── INDEX.md                         # 📚 Bu dosya
```

## 🚀 Başlangıç Noktaları

### Yeni Başlayanlar İçin
👉 **[HIZLI-BASLANGIÇ.md](./HIZLI-BASLANGIÇ.md)** - 5 dakikada kurulum

### Detaylı Bilgi İsteyenler İçin
👉 **[README.md](./README.md)** - Tam dokümentasyon

### Adım Adım İlerlemek İsteyenler İçin
👉 **[EXECUTION-GUIDE.md](./EXECUTION-GUIDE.md)** - Detaylı rehber

### Sorun Yaşayanlar İçin
👉 **[02-TROUBLESHOOTING-QUERIES.sql](./02-TROUBLESHOOTING-QUERIES.sql)** - Hata ayıklama

## 🎯 Senaryoya Göre Rehber

### Senaryo 1: İlk Kurulum (Yeni Proje)
1. **[HIZLI-BASLANGIÇ.md](./HIZLI-BASLANGIÇ.md)** okuyun
2. `00-COMPLETE-CLEANUP.sql` çalıştırın
3. `01-COMPLETE-REBUILD.sql` çalıştırın
4. Frontend'i test edin

**Süre**: ~5-10 dakika

### Senaryo 2: Auth Sorunu Giderme
1. **[EXECUTION-GUIDE.md](./EXECUTION-GUIDE.md)** → "ADIM 6: Auth Trigger Test"
2. `02-TROUBLESHOOTING-QUERIES.sql` → "2. AUTH & SUBSCRIPTION KONTROLLER"
3. Auth trigger'ı kontrol edin
4. Gerekirse trigger'ı yeniden oluşturun

**Süre**: ~5 dakika

### Senaryo 3: Tamamen Sıfırlama (Nuclear Option)
1. **YEDEKLEYİN!** (Önemli veriler varsa)
2. `00-COMPLETE-CLEANUP.sql` çalıştırın
3. `01-COMPLETE-REBUILD.sql` çalıştırın
4. Test kullanıcısı oluşturun
5. Subscription kontrol edin

**Süre**: ~10 dakika

### Senaryo 4: Production'a Alma
1. **[README.md](./README.md)** → "Production Hazırlık" okuyun
2. Test ortamında tam test yapın
3. Yedek alın
4. Bakım modu açın
5. `00-COMPLETE-CLEANUP.sql` çalıştırın
6. `01-COMPLETE-REBUILD.sql` çalıştırın
7. Doğrulama testleri yapın
8. Bakım modunu kapatın

**Süre**: ~30-60 dakika (test dahil)

### Senaryo 5: Rutin Bakım
1. `02-TROUBLESHOOTING-QUERIES.sql` → "8. PERİYODİK BAKIM"
2. Expired subscription'ları kontrol edin
3. Storage kullanımını kontrol edin
4. Log'ları inceleyin

**Süre**: ~10 dakika (haftalık)

## 📊 Veritabanı Mimarisi Özeti

### Tablolar (10 adet)

| Tablo | Açıklama | İlişkiler |
|-------|----------|-----------|
| `subscriptions` | Kullanıcı planları | → auth.users |
| `template_categories` | Şablon kategorileri | - |
| `templates` | Davetiye şablonları | → template_categories |
| `user_templates` | Kayıtlı şablonlar | → auth.users, templates |
| `invitations` | Davetiyeler | → auth.users, templates |
| `guests` | Davetliler (ana) | → invitations |
| `invitation_guests` | Davetliler (alt) | → invitations |
| `media` | QR medya | → auth.users, invitations |
| `guest_uploads` | Misafir yüklemeleri | → media |
| `payment_history` | Ödeme geçmişi | → auth.users |

### Fonksiyonlar (15 adet)

**Auth & User:**
- `handle_new_user()` - Otomatik subscription oluşturur
- `create_user_subscription()` - Manuel subscription oluşturur
- `increment_invitation_count()` - Davetiye sayacını artırır
- `get_user_stats()` - Kullanıcı istatistikleri döndürür

**Invitations:**
- `generate_invitation_slug()` - Benzersiz URL oluşturur
- `increment_invitation_views()` - Görüntüleme sayar
- `get_invitation_guest_stats()` - İstatistik döndürür

**Templates:**
- `increment_template_usage()` - Kullanım sayar

**Media:**
- `increment_media_scan_count()` - QR tarama sayar
- `increment_media_view_count()` - Görüntüleme sayar
- `inc_guest_uploads_count()` - Yükleme sayar
- `clean_expired_media()` - Süresi dolmuş medya temizler
- `update_storage_usage()` - Storage kullanımını günceller

**Maintenance:**
- `reset_monthly_counters()` - Aylık sayaçları sıfırlar

**Utility:**
- `update_updated_at_column()` - Timestamp günceller

### Storage (2 bucket)

- **qr-media**: 100MB, video/image/audio
- **invitation-images**: 10MB, images only

### Security

- ✅ RLS tüm tablolarda aktif
- ✅ User isolation (kullanıcılar sadece kendi verilerini görür)
- ✅ Public access (published invitations, templates)
- ✅ Token-based access (guests, QR codes)

## 🔧 Hızlı Komutlar

### Sistem Durumu
```sql
-- Tek sorguda tüm sistem durumu
SELECT * FROM (
    SELECT 'Tablolar' as item, COUNT(*)::text as count FROM information_schema.tables WHERE table_schema = 'public'
    UNION ALL
    SELECT 'Fonksiyonlar', COUNT(*)::text FROM information_schema.routines WHERE routine_schema = 'public'
    UNION ALL
    SELECT 'Kullanıcılar', COUNT(*)::text FROM auth.users
    UNION ALL
    SELECT 'Subscriptions', COUNT(*)::text FROM subscriptions
    UNION ALL
    SELECT 'Templates', COUNT(*)::text FROM templates
) AS system_status;
```

### Auth Trigger Kontrolü
```sql
SELECT 
    CASE WHEN COUNT(*) > 0 
    THEN '✅ Auth trigger VAR' 
    ELSE '❌ Auth trigger YOK' 
    END
FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created';
```

### RLS Kontrolü
```sql
SELECT 
    tablename,
    CASE WHEN rowsecurity THEN '✅' ELSE '❌' END as rls
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;
```

## 📖 Kavramlar

### Row Level Security (RLS)
Supabase'in güvenlik mekanizması. Her satır için kim okuyabilir/yazabilir kontrol eder.

### Trigger
Otomatik çalışan kod. Örnek: Yeni kullanıcı → subscription oluştur.

### Policy
RLS kuralları. Kim, ne yapabilir tanımlar.

### Storage Bucket
Dosya depolama alanı. Public veya private olabilir.

### Slug
URL dostu benzersiz isim. Örnek: `abc123-dugun-davetiyesi`

## ⚡ Performans İpuçları

1. **Index'ler**: Tüm foreign key'lerde index var
2. **RLS**: Optimum performans için user_id index'li
3. **JSONB**: design_config, content, settings için hızlı
4. **Counting**: `usage_count` gibi cached sayaçlar kullan
5. **Pagination**: Büyük listeler için LIMIT/OFFSET kullan

## 🔒 Güvenlik En İyi Pratikleri

1. ✅ RLS her zaman aktif
2. ✅ Service role sadece backend'de
3. ✅ Anon key frontend'de
4. ✅ Email confirmation production'da aktif
5. ✅ Password minimum 8 karakter
6. ✅ Storage buckets için size limit
7. ✅ Rate limiting aktif (Supabase otomatik)

## 📈 Ölçeklenebilirlik

### Mevcut Limitler
- **Free tier**: 500MB database, 1GB storage
- **Pro tier**: 8GB database, 100GB storage
- **Premium tier**: Unlimited

### Optimizasyon Noktaları
1. Template'leri cache'le (değişmiyorlar)
2. Media thumbnail'leri kullan
3. Old invitation'ları arşivle
4. Expired media'yı temizle
5. Log'ları periyodik temizle

## 🧪 Test Checklist

### Kurulum Sonrası Test
- [ ] 10 tablo oluştu
- [ ] 11 fonksiyon oluştu
- [ ] Auth trigger çalışıyor
- [ ] 2 storage bucket var
- [ ] RLS tüm tablolarda aktif
- [ ] Template'ler seed oldu

### Fonksiyonel Test
- [ ] Kullanıcı kaydı çalışıyor
- [ ] Otomatik subscription oluşuyor
- [ ] Login çalışıyor
- [ ] Davetiye oluşturma çalışıyor
- [ ] Şablon seçimi çalışıyor
- [ ] Davetli ekleme çalışıyor
- [ ] RSVP çalışıyor

### Security Test
- [ ] User A, User B'nin davetiyelerini göremiyor
- [ ] Public davetiyeler herkes görebiliyor
- [ ] Guest token ile RSVP update çalışıyor
- [ ] Template'leri herkes görebiliyor
- [ ] Storage upload auth gerektiriyor

## 🆘 Acil Durum Prosedürleri

### Veritabanı Çöktü
1. Supabase Dashboard → Database → Health check
2. Logs'ları incele
3. Son işlemi geri al (transaction log)
4. Restore from backup

### Auth Çalışmıyor
1. `02-TROUBLESHOOTING-QUERIES.sql` → Auth trigger kontrol
2. Trigger'ı yeniden oluştur
3. Eksik subscription'ları manuel oluştur
4. Test kullanıcısı ile test et

### Storage Dolu
1. Eski media'ları temizle
2. Thumbnail'lere geç
3. Storage plan'ı yükselt
4. Expiry policy kur

## 📞 Destek

### Dokümantasyon
- [Supabase Docs](https://supabase.com/docs)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [RLS Guide](https://supabase.com/docs/guides/auth/row-level-security)

### Hata Ayıklama
1. Browser Console
2. Network Tab
3. Supabase Logs
4. Database Logs

### Topluluk
- [Supabase Discord](https://discord.supabase.com)
- [GitHub Discussions](https://github.com/supabase/supabase/discussions)

---

## 🎓 Sıradaki Adımlar

1. ✅ Database kurulumu yap
2. ⏭️ Frontend test et
3. ⏭️ Email templates düzenle
4. ⏭️ Production'a al
5. ⏭️ Monitoring kur
6. ⏭️ Backup strategy belirle

**Başarılar!** 🚀

