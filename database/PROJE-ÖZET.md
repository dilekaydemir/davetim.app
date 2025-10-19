# 🎯 Davetim.app - Proje ve Database Özeti

## 📊 Proje Genel Bakış

**Davetim.app**, kullanıcıların dijital davetiye oluşturmasına, yönetmesine ve paylaşmasına olanak sağlayan modern bir SaaS platformudur.

### Temel Özellikler

🎨 **Şablon Sistemi**
- 6 kategori, çoklu template
- Free, Pro, Premium seviyeler
- Özelleştirilebilir tasarımlar

📧 **Davetiye Yönetimi**
- Benzersiz URL slug'ları
- Public/private davetiyeler
- RSVP sistemi
- Davetli listesi yönetimi

💳 **Abonelik Sistemi**
- Free, Pro, Premium planlar
- Kullanım limitleri
- Ödeme geçmişi
- Otomatik yükseltme/düşürme

📱 **QR Medya Sistemi** (Premium)
- Video/resim yükleme
- QR kod oluşturma
- Misafir yüklemeleri
- 3 ay / 1 yıl saklama

## 🏗️ Mimari Yapı

```
┌─────────────────────────────────────────────────┐
│              FRONTEND (React + Vite)            │
│  - Authentication                               │
│  - Dashboard                                    │
│  - Invitation Editor                            │
│  - Template Gallery                             │
│  - Payment Integration                          │
└──────────────────┬──────────────────────────────┘
                   │
                   │ Supabase Client SDK
                   │
┌──────────────────▼──────────────────────────────┐
│              SUPABASE BACKEND                   │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │     Authentication (Auth.users)         │   │
│  │  - Email/Password                       │   │
│  │  - Google OAuth                         │   │
│  │  - Email Verification                   │   │
│  └────────────┬────────────────────────────┘   │
│               │                                 │
│  ┌────────────▼────────────────────────────┐   │
│  │     Database (PostgreSQL)              │   │
│  │                                         │   │
│  │  Tables:                                │   │
│  │  • subscriptions                        │   │
│  │  • templates & categories              │   │
│  │  • invitations                          │   │
│  │  • guests                               │   │
│  │  • media & guest_uploads               │   │
│  │  • payment_history                      │   │
│  │                                         │   │
│  │  Functions:                             │   │
│  │  • handle_new_user()                    │   │
│  │  • generate_invitation_slug()           │   │
│  │  • increment_* functions                │   │
│  │                                         │   │
│  │  Triggers:                              │   │
│  │  • on_auth_user_created                 │   │
│  │  • update_updated_at                    │   │
│  │                                         │   │
│  │  Security (RLS):                        │   │
│  │  • User isolation                       │   │
│  │  • Public read policies                 │   │
│  │  • Token-based access                   │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │     Storage (S3-compatible)             │   │
│  │  • qr-media (100MB/file)                │   │
│  │  • invitation-images (10MB/file)        │   │
│  └─────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
                   │
                   │ REST API
                   │
┌──────────────────▼──────────────────────────────┐
│         PAYMENT SERVICE (İyzico)                │
│  - Payment processing                           │
│  - Refunds                                      │
│  - Transaction tracking                         │
└─────────────────────────────────────────────────┘
```

## 🗄️ Database Schema

### Core Tables

```
┌─────────────────┐
│  auth.users     │ (Supabase managed)
└────────┬────────┘
         │ 1:1
         │
┌────────▼────────┐         ┌──────────────────┐
│ subscriptions   │────────►│ payment_history  │
│                 │ 1:N     │                  │
│ • tier          │         │ • transaction_id │
│ • status        │         │ • amount         │
│ • limits        │         │ • status         │
└────────┬────────┘         └──────────────────┘
         │ 1:N
         │
┌────────▼────────┐         ┌──────────────────┐
│  invitations    │────────►│     guests       │
│                 │ 1:N     │                  │
│ • title         │         │ • full_name      │
│ • slug          │         │ • rsvp_status    │
│ • status        │         │ • guest_token    │
└────────┬────────┘         └──────────────────┘
         │ N:1                      
         │                  ┌──────────────────┐
         └─────────────────►│  invitation_     │
                            │     guests       │
                            │ (alternative)    │
                            └──────────────────┘
                            
┌─────────────────┐         ┌──────────────────┐
│   templates     │◄────────│ user_templates   │
│                 │ 1:N     │ (saved)          │
│ • name          │         │ • is_favorite    │
│ • tier          │         └──────────────────┘
│ • usage_count   │                 
└────────┬────────┘         
         │ N:1
         │
┌────────▼────────┐
│ template_       │
│  categories     │
│                 │
│ • name          │
│ • slug          │
└─────────────────┘

┌─────────────────┐         ┌──────────────────┐
│     media       │────────►│  guest_uploads   │
│ (QR system)     │ 1:N     │                  │
│ • qr_code       │         │ • guest_name     │
│ • storage_url   │         │ • note           │
│ • allow_upload  │         │ • storage_url    │
└─────────────────┘         └──────────────────┘
```

## 🔐 Güvenlik Katmanları

### 1. Authentication
```
User Signup → Email Verification → JWT Token → Session
     ↓
Auto-create free subscription (trigger)
```

### 2. Row Level Security (RLS)

**User Data Isolation:**
```sql
-- Kullanıcılar sadece kendi verilerini görür
WHERE auth.uid() = user_id
```

**Public Access:**
```sql
-- Published invitations herkese açık
WHERE status = 'published' AND is_public = true
```

**Token-based Access:**
```sql
-- Guest'ler token ile erişir
WHERE guest_token = $1
```

### 3. Storage Security
- Public buckets (read-only for all)
- Authenticated upload
- User-scoped file management
- Size limits enforced

## 📈 Data Flow Examples

### 1. User Signup Flow
```
1. Frontend: signUp({email, password, fullName})
   ↓
2. Supabase Auth: Create user
   ↓
3. Trigger: on_auth_user_created
   ↓
4. Function: handle_new_user()
   ↓
5. Insert: subscriptions (tier='free', status='active')
   ↓
6. Return: User + Session + Subscription
```

### 2. Create Invitation Flow
```
1. Frontend: Select template
   ↓
2. Check subscription limits
   ↓
3. Generate slug: generate_invitation_slug()
   ↓
4. Insert invitation (RLS checks user_id)
   ↓
5. Increment: increment_invitation_count()
   ↓
6. Return: Invitation with template data
```

### 3. RSVP Flow
```
1. Guest clicks: /rsvp/{guest_token}
   ↓
2. Fetch guest by token (public policy)
   ↓
3. Show RSVP form
   ↓
4. Submit RSVP
   ↓
5. Update guest (token-based policy)
   ↓
6. Email notification (optional)
```

### 4. QR Media Flow (Premium)
```
1. User uploads video/image
   ↓
2. Check subscription (tier='premium')
   ↓
3. Upload to storage: qr-media bucket
   ↓
4. Generate QR code
   ↓
5. Insert media record
   ↓
6. Return QR image + public URL
   ↓
7. Anyone scans QR → View media
   ↓
8. increment_media_scan_count()
```

## 💰 Subscription Logic

### Tier Features

| Feature | Free | Pro | Premium |
|---------|------|-----|---------|
| Invitations/month | 5 | 50 | Unlimited |
| Templates | Basic | All | All + Custom |
| Image upload | ❌ | ✅ | ✅ |
| QR Media | ❌ | ❌ | ✅ |
| Guest uploads | ❌ | ❌ | ✅ |
| WhatsApp share | ❌ | ✅ | ✅ |
| Excel export | ❌ | ✅ | ✅ |
| Storage | 10MB | 1GB | 10GB |

### Upgrade Flow
```
1. User clicks "Upgrade to Pro"
   ↓
2. Payment Modal (İyzico)
   ↓
3. Payment processing
   ↓
4. On success:
   - Update subscription.tier
   - Update subscription.end_date
   - Insert payment_history
   - Update auth.user metadata
   ↓
5. Redirect to dashboard
   ↓
6. Show success message
```

## 🔄 Critical Operations

### Database Rebuild Process
```
STEP 1: Cleanup
  ├─ Drop all triggers
  ├─ Drop all functions
  ├─ Drop all policies
  ├─ Drop all tables
  ├─ Drop storage buckets
  └─ Drop custom types

STEP 2: Rebuild
  ├─ Create custom types
  ├─ Create tables (with FK)
  ├─ Create indexes
  ├─ Create functions
  ├─ Create triggers
  ├─ Enable RLS
  ├─ Create policies
  ├─ Create storage buckets
  ├─ Create storage policies
  └─ Seed initial data

STEP 3: Verify
  ├─ Check table count (10)
  ├─ Check function count (11)
  ├─ Check RLS status (all enabled)
  ├─ Check auth trigger
  ├─ Check storage buckets (2)
  └─ Test user signup
```

## 🎨 Frontend Architecture

```
src/
├── components/
│   ├── Auth/              # Login, Signup
│   ├── Dashboard/         # Stats, Analytics
│   ├── Editor/            # Invitation creator
│   ├── Templates/         # Template gallery
│   ├── Payment/           # Payment modal
│   └── Media/             # QR media manager
├── services/
│   ├── authService.ts     # Auth operations
│   ├── invitationService.ts
│   ├── subscriptionService.ts
│   ├── mediaService.ts
│   └── paymentService.ts
├── store/
│   └── authStore.ts       # Zustand state
└── pages/
    ├── HomePage.tsx
    ├── DashboardPage.tsx
    ├── EditorPage.tsx
    └── PublicInvitationPage.tsx
```

## 📊 Key Metrics to Monitor

### User Metrics
- Active users (daily/monthly)
- Signup conversion rate
- Subscription upgrades
- Churn rate

### System Metrics
- Database size
- Storage usage
- API response time
- Error rate

### Business Metrics
- Revenue (MRR/ARR)
- ARPU (Average Revenue Per User)
- LTV (Lifetime Value)
- CAC (Customer Acquisition Cost)

## 🚨 Known Issues & Solutions

### Issue 1: Auth Trigger Not Working
**Symptom:** New users don't get subscriptions
**Solution:** Run trigger recreation script
**Prevention:** Monitor new user signups

### Issue 2: RLS Blocking Queries
**Symptom:** "row-level security policy" errors
**Solution:** Check policy definitions
**Prevention:** Test with actual user tokens

### Issue 3: Storage Upload Fails
**Symptom:** 401/403 on upload
**Solution:** Check auth token, verify bucket policies
**Prevention:** Proper error handling in frontend

## 📚 Dokümantasyon Haritası

```
database/
├── INDEX.md                    ← 📚 Başlangıç noktası
├── HIZLI-BASLANGIÇ.md         ← ⚡ En hızlı yol
├── README.md                   ← 📖 Detaylı rehber
├── EXECUTION-GUIDE.md          ← 📋 Adım adım
├── 02-TROUBLESHOOTING-QUERIES.sql  ← 🐛 Sorun giderme
├── PROJE-ÖZET.md              ← 🎯 Bu dosya
└── SQL Files/
    ├── 00-COMPLETE-CLEANUP.sql    ← 🗑️ Temizlik
    └── 01-COMPLETE-REBUILD.sql    ← 🔨 Kurulum
```

## 🎓 Öğrenme Yolu

### Başlangıç (1. Gün)
1. **INDEX.md** oku - Genel bakış
2. **HIZLI-BASLANGIÇ.md** takip et - İlk kurulum
3. Frontend'i test et

### Orta Seviye (1. Hafta)
1. **EXECUTION-GUIDE.md** incele - Detaylı işlemler
2. **02-TROUBLESHOOTING-QUERIES.sql** öğren - Sorun giderme
3. Auth flow'u anla

### İleri Seviye (1. Ay)
1. **PROJE-ÖZET.md** (bu dosya) master et - Mimari
2. RLS policy'leri özelleştir
3. Custom feature ekle
4. Production'a al

## 🔮 Gelecek Geliştirmeler

### Planlanan Özellikler
- [ ] SMS notification
- [ ] Email templates customization
- [ ] Multi-language support
- [ ] Advanced analytics
- [ ] API for third-party integrations
- [ ] Mobile app (React Native)

### Technical Debt
- [ ] Add comprehensive tests
- [ ] Improve error handling
- [ ] Add monitoring (Sentry)
- [ ] Optimize queries
- [ ] Add caching layer (Redis)
- [ ] Database indexing optimization

## 🎯 Success Criteria

### Launch Ready Checklist
- [x] Database schema complete
- [x] Auth system working
- [x] RLS policies enforced
- [x] Storage configured
- [x] Payment integration ready
- [ ] Email templates configured
- [ ] Error monitoring setup
- [ ] Backup strategy implemented
- [ ] Load testing completed
- [ ] Security audit passed

## 📞 Önemli Linkler

- **Supabase Dashboard**: https://app.supabase.com
- **Frontend Dev**: http://localhost:5173
- **Docs**: ./INDEX.md
- **Quick Start**: ./HIZLI-BASLANGIÇ.md

---

**Son Güncelleme**: 2024
**Versiyon**: 1.0.0
**Durum**: ✅ Production Ready

🎉 **Başarılar!**

