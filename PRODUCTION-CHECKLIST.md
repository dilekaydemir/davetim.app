# 🚀 Production Hazırlık Kontrol Listesi

## ✅ TAMAMLANAN İŞLEMLER

### 1. Temel Geliştirme
- ✅ Frontend geliştirme tamamlandı
- ✅ Backend (Supabase) entegrasyonu yapıldı
- ✅ Database schema oluşturuldu
- ✅ Authentication sistemi çalışıyor
- ✅ Payment entegrasyonu (Iyzico) yapıldı
- ✅ Email sistemi (Resend) çalışıyor

### 2. Özellikler
- ✅ Davetiye editörü
- ✅ Şablon sistemi
- ✅ Misafir yönetimi
- ✅ RSVP sistemi
- ✅ QR medya yükleme
- ✅ Abonelik sistemi (FREE/PRO/PREMIUM)
- ✅ PDF/PNG export
- ✅ İletişim formu

### 3. Yasal Dokümantasyon
- ✅ Kullanım Koşulları
- ✅ Gizlilik Politikası
- ✅ KVKK Aydınlatma Metni
- ✅ Mesafeli Satış Sözleşmesi
- ✅ İptal ve İade Koşulları
- ✅ Ticari Elektronik İleti Onayı
- ✅ Şirket bilgileri güncellendi (Diligent Computer System & Digital Commerce)
- ✅ İletişim bilgileri güncellendi (info@davetim.app, +905359216894)

### 4. SEO & Meta
- ✅ SEO meta tags
- ✅ Open Graph tags
- ✅ Canonical URLs
- ✅ Sitemap (otomatik)
- ✅ Robots.txt

### 5. Email Sistemi
- ✅ Resend API entegrasyonu
- ✅ Domain doğrulaması (davetim.app)
- ✅ İletişim formu emaili
- ✅ HTML email template

---

## ⚠️ KALAN KRITIK İŞLEMLER

### 1. Environment Variables (Production)

**Kontrol Edilmesi Gerekenler:**

#### Frontend (.env.production)
```bash
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
VITE_IYZICO_API_KEY=your-production-key
VITE_IYZICO_SECRET_KEY=your-production-secret
VITE_IYZICO_BASE_URL=https://api.iyzipay.com
```

#### Supabase Edge Functions
```bash
RESEND_API_KEY=re_xxxxx
IYZICO_API_KEY=your-production-key
IYZICO_SECRET_KEY=your-production-secret
```

**Yapılması Gereken:**
- [ ] Production Iyzico hesabı oluştur
- [ ] Production API keys al
- [ ] Supabase'de production keys'leri güncelle

---

### 2. Iyzico Production Geçişi

**Mevcut Durum:** Sandbox (test) modu

**Yapılması Gerekenler:**

1. **Iyzico Production Hesabı:**
   - https://merchant.iyzipay.com/auth/register
   - Şirket bilgilerini gir
   - Banka hesabı ekle
   - Kimlik doğrulama

2. **Production API Keys:**
   - Merchant Panel → Ayarlar → API Anahtarları
   - Production keys'leri al
   - Sandbox keys'leri değiştir

3. **Webhook URL'i Güncelle:**
   ```
   https://your-domain.com/api/payment-webhook
   ```

4. **Test Ödemeleri:**
   - Gerçek kart ile test et
   - 1 TL test ödemesi yap
   - İade testi yap

**Durum:** ⚠️ **YAPILMASI GEREKIYOR**

---

### 3. Domain & Hosting

**Yapılması Gerekenler:**

1. **Domain DNS Ayarları:**
   ```
   A     @           [Hosting IP]
   CNAME www         @
   TXT   @           v=spf1 include:resend.com ~all
   TXT   resend._domainkey  [Resend DKIM key]
   ```

2. **SSL Sertifikası:**
   - Let's Encrypt (ücretsiz)
   - Cloudflare SSL (önerilen)

3. **Frontend Deploy:**
   - Vercel (önerilen) veya Netlify
   - Build command: `npm run build`
   - Output directory: `dist`

4. **Environment Variables:**
   - Hosting platformunda production env'leri ekle

**Durum:** ⚠️ **YAPILMASI GEREKIYOR**

---

### 4. Database Production Setup

**Kontrol Edilmesi Gerekenler:**

1. **RLS Policies:**
   - [ ] Tüm tablolarda RLS aktif mi?
   - [ ] Guest erişimi doğru mu?
   - [ ] Public erişim sadece gerekli yerlerde mi?

2. **Indexes:**
   - [ ] `invitations.user_id` index var mı?
   - [ ] `guests.invitation_id` index var mı?
   - [ ] `qr_media.invitation_id` index var mı?

3. **Triggers:**
   - [ ] `handle_new_user` trigger çalışıyor mu?
   - [ ] `check_subscription_expiration` çalışıyor mu?

4. **Storage Policies:**
   - [ ] `qr-media` bucket policies doğru mu?
   - [ ] File size limitleri ayarlı mı?

**Yapılması Gereken:**
```sql
-- Indexes kontrol
SELECT tablename, indexname 
FROM pg_indexes 
WHERE schemaname = 'public';

-- RLS kontrol
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

**Durum:** ⚠️ **KONTROL EDİLMELİ**

---

### 5. Supabase Subscription Expiration Cron

**Mevcut Durum:** Edge Function var (`06-subscription-expiration-check.sql`)

**Yapılması Gerekenler:**

1. **Cron Job Kurulumu:**
   - Supabase Dashboard → Database → Cron Jobs
   - Schedule: `0 2 * * *` (her gün saat 02:00)
   - Function: `check_and_expire_subscriptions()`

2. **Test:**
   ```sql
   SELECT check_and_expire_subscriptions();
   ```

**Durum:** ⚠️ **KURULMASI GEREKIYOR**

---

### 6. Monitoring & Analytics

**Yapılması Gerekenler:**

1. **Google Analytics:**
   - [ ] GA4 property oluştur
   - [ ] Tracking code ekle
   - [ ] Conversion tracking ayarla

2. **Sentry (Error Tracking):**
   - [ ] Sentry hesabı oluştur
   - [ ] Frontend entegrasyonu
   - [ ] Backend entegrasyonu

3. **Uptime Monitoring:**
   - [ ] UptimeRobot (ücretsiz)
   - [ ] Ping URL: `https://davetim.app`
   - [ ] Email alerts

4. **Performance Monitoring:**
   - [ ] Lighthouse CI
   - [ ] Core Web Vitals

**Durum:** ⚠️ **KURULMASI GEREKIYOR**

---

### 7. Backup & Recovery

**Yapılması Gerekenler:**

1. **Supabase Backup:**
   - Otomatik daily backup (Supabase Pro)
   - Manuel backup script

2. **Database Dump:**
   ```bash
   # Weekly backup script
   pg_dump -h db.xxx.supabase.co -U postgres > backup_$(date +%Y%m%d).sql
   ```

3. **Storage Backup:**
   - QR media files
   - User uploads

**Durum:** ⚠️ **KURULMASI GEREKIYOR**

---

### 8. Security Hardening

**Kontrol Edilmesi Gerekenler:**

1. **API Keys:**
   - [ ] Tüm keys production'da mı?
   - [ ] Sandbox keys kaldırıldı mı?
   - [ ] Keys rotate edildi mi?

2. **CORS:**
   - [ ] Sadece davetim.app allowed mı?
   - [ ] Wildcard (*) yok mu?

3. **Rate Limiting:**
   - [ ] Supabase rate limits ayarlı mı?
   - [ ] Edge Functions rate limits var mı?

4. **Input Validation:**
   - [ ] SQL injection koruması
   - [ ] XSS koruması
   - [ ] File upload validation

**Durum:** ⚠️ **KONTROL EDİLMELİ**

---

### 9. Performance Optimization

**Yapılması Gerekenler:**

1. **Frontend:**
   - [ ] Code splitting
   - [ ] Lazy loading
   - [ ] Image optimization
   - [ ] Bundle size < 500KB

2. **Database:**
   - [ ] Query optimization
   - [ ] Index optimization
   - [ ] Connection pooling

3. **CDN:**
   - [ ] Cloudflare setup
   - [ ] Static assets CDN
   - [ ] Image CDN

**Durum:** ⚠️ **OPTİMİZE EDİLMELİ**

---

### 10. Testing

**Yapılması Gerekenler:**

1. **User Flow Testing:**
   - [ ] Kayıt → Davetiye oluştur → Yayınla
   - [ ] Misafir ekle → RSVP gönder → Yanıt al
   - [ ] Ücretsiz → PRO upgrade → Ödeme
   - [ ] QR medya oluştur → Yükle → Görüntüle

2. **Payment Testing:**
   - [ ] Gerçek kart ile test
   - [ ] 3D Secure test
   - [ ] İade testi
   - [ ] Webhook testi

3. **Email Testing:**
   - [ ] İletişim formu
   - [ ] Subscription expiration (manuel trigger)
   - [ ] Spam klasörü kontrolü

4. **Mobile Testing:**
   - [ ] iOS Safari
   - [ ] Android Chrome
   - [ ] Responsive design

5. **Browser Testing:**
   - [ ] Chrome
   - [ ] Firefox
   - [ ] Safari
   - [ ] Edge

**Durum:** ⚠️ **TEST EDİLMELİ**

---

### 11. Legal & Compliance

**Kontrol Edilmesi Gerekenler:**

1. **KVKK:**
   - [ ] Aydınlatma metni görünür mü?
   - [ ] Açık rıza alınıyor mu?
   - [ ] Veri saklama süreleri belirtilmiş mi?

2. **E-Ticaret:**
   - [ ] Ön bilgilendirme formu var mı?
   - [ ] Mesafeli satış sözleşmesi onaylanıyor mu?
   - [ ] İptal ve iade koşulları açık mı?

3. **Ticari İletişim:**
   - [ ] İleti izni alınıyor mu?
   - [ ] Ret linki var mı?

4. **Çerezler:**
   - [ ] Cookie banner var mı?
   - [ ] Cookie policy var mı?

**Durum:** ✅ **TAMAMLANDI** (Cookie banner hariç)

---

### 12. Documentation

**Yapılması Gerekenler:**

1. **Kullanıcı Dokümantasyonu:**
   - [ ] Nasıl kullanılır? (FAQ)
   - [ ] Video tutorials
   - [ ] Yardım merkezi

2. **API Dokümantasyonu:**
   - [ ] Endpoint listesi
   - [ ] Authentication
   - [ ] Rate limits

3. **Deployment Dokümantasyonu:**
   - [ ] Deployment guide
   - [ ] Rollback procedure
   - [ ] Troubleshooting

**Durum:** ⚠️ **OLUŞTURULMALI**

---

## 📊 ÖNCELIK SIRASI

### 🔴 Kritik (Hemen Yapılmalı)
1. **Iyzico Production Geçişi** - Ödeme sistemi çalışmalı
2. **Domain & Hosting Setup** - Site yayına alınmalı
3. **Production Environment Variables** - Güvenlik
4. **Database RLS & Security** - Veri güvenliği

### 🟡 Önemli (1 Hafta İçinde)
5. **Subscription Expiration Cron** - Otomatik abonelik kontrolü
6. **Monitoring & Analytics** - Hata takibi
7. **Testing (Full Flow)** - Tüm akışlar test edilmeli
8. **Backup Setup** - Veri kaybı önleme

### 🟢 İsteğe Bağlı (1 Ay İçinde)
9. **Performance Optimization** - Hız iyileştirme
10. **User Documentation** - Kullanıcı yardımı
11. **Cookie Banner** - KVKK compliance
12. **Advanced Analytics** - Detaylı raporlama

---

## ✅ PRODUCTION CHECKLIST

### Minimum Viable Product (MVP)
- [ ] Iyzico production keys
- [ ] Domain yayında
- [ ] SSL aktif
- [ ] Database RLS kontrol edildi
- [ ] Tüm user flow'lar test edildi
- [ ] Payment test edildi
- [ ] Email sistemi çalışıyor
- [ ] Error tracking (Sentry)
- [ ] Uptime monitoring

### Full Production Ready
- [ ] Yukarıdaki tüm MVP items
- [ ] Cron jobs kuruldu
- [ ] Backup sistemi aktif
- [ ] Performance optimize edildi
- [ ] Tüm tarayıcılarda test edildi
- [ ] Mobile responsive test edildi
- [ ] Analytics kuruldu
- [ ] User documentation hazır

---

## 🚀 DEPLOYMENT ADIMLARI

### 1. Pre-Deployment
```bash
# 1. Production branch oluştur
git checkout -b production

# 2. Build test et
npm run build

# 3. Linter kontrol
npm run lint

# 4. Type check
npm run type-check
```

### 2. Deployment
```bash
# Vercel (önerilen)
vercel --prod

# Veya Netlify
netlify deploy --prod
```

### 3. Post-Deployment
```bash
# 1. Health check
curl https://davetim.app/api/health

# 2. Database migration
# Supabase Dashboard'da migration'ları çalıştır

# 3. Smoke test
# Tüm kritik flow'ları manuel test et
```

---

## 📞 DESTEK

**Sorularınız için:**
- Email: info@davetim.app
- Phone: +905359216894

**Acil Durum:**
- Supabase Dashboard → Support
- Iyzico Merchant Panel → Destek
- Resend Dashboard → Support

---

## 🎯 SONUÇ

**Mevcut Durum:** 🟡 **%70 Hazır**

**Kritik Eksikler:**
1. Iyzico Production
2. Domain/Hosting
3. Full Testing

**Tahmini Süre:** 2-3 gün (kritik işlemler için)

**Başarılar! 🚀**

