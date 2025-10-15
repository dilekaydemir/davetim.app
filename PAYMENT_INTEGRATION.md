# 💳 İyzico Payment Integration - Davetim.app

## 📋 Genel Bakış

Davetim.app, ayrı bir payment servisi (localhost:5000) üzerinden İyzico ödeme entegrasyonu kullanır. Bu mimari, payment servisinin diğer projelerde de kullanılabilmesini sağlar.

## 🏗️ Mimari

```
┌─────────────────┐
│  Davetim.app    │
│   (Frontend)    │
│   localhost:3000│
└────────┬────────┘
         │
         ▼
┌─────────────────┐      ┌──────────────┐
│  Payment API    │ ───> │   İyzico     │
│  localhost:5000 │      │   (3D Secure)│
└─────────────────┘      └──────────────┘
         │
         ▼
┌─────────────────┐
│  Supabase DB    │
│  - subscriptions│
│  - payments     │
└─────────────────┘
```

## 📁 Dosya Yapısı

### Frontend

```
frontend/src/
├── types/
│   └── payment.ts                    # Payment type definitions
├── services/
│   ├── paymentService.ts             # Payment API client
│   └── subscriptionService.ts        # Subscription management
├── components/
│   └── Payment/
│       └── PaymentModal.tsx          # Payment form modal
└── pages/
    ├── PricingPage.tsx               # Plan selection + payment
    ├── PaymentCallbackPage.tsx       # 3D Secure callback
    └── AccountPage.tsx               # Payment history
```

### Database

```
database/
├── subscriptions-table.sql           # Subscriptions schema
└── payment-history-schema.sql        # Payment history schema
```

## 🚀 Kurulum

### 1. Environment Variables

`.env` dosyasına ekleyin:

```bash
# Payment Service
VITE_PAYMENT_API_URL=http://localhost:5000/api/payment
```

### 2. Database Setup

Supabase SQL Editor'da sırasıyla çalıştırın:

```sql
-- 1. Subscriptions table
\i database/subscriptions-table.sql

-- 2. Payment history table
\i database/payment-history-schema.sql
```

### 3. Payment Service

Payment servisi Docker'da çalışıyor olmalı:

```bash
docker ps | grep payment
# payment-service çalışıyor olmalı: localhost:5000
```

## 📊 Database Schema

### `subscriptions` Tablosu

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| user_id | UUID | Foreign key to auth.users |
| tier | VARCHAR(20) | 'free', 'pro', 'premium' |
| status | VARCHAR(20) | 'active', 'cancelled', 'expired', 'trialing' |
| start_date | TIMESTAMPTZ | Subscription start date |
| end_date | TIMESTAMPTZ | Subscription end date |
| cancelled_at | TIMESTAMPTZ | Cancellation date |
| invitations_created_this_month | INTEGER | Monthly counter |
| invitations_created_lifetime | INTEGER | Lifetime counter |
| storage_used_mb | DECIMAL(10,2) | Storage usage in MB |

### `payment_history` Tablosu

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| user_id | UUID | Foreign key to auth.users |
| transaction_id | VARCHAR(255) | Unique transaction ID |
| provider_transaction_id | VARCHAR(255) | İyzico transaction ID |
| provider | VARCHAR(50) | 'iyzico' |
| amount | DECIMAL(10,2) | Payment amount |
| currency | VARCHAR(3) | 'TRY' |
| status | VARCHAR(20) | Payment status |
| plan_tier | VARCHAR(20) | 'pro', 'premium' |
| billing_period | VARCHAR(10) | 'monthly', 'yearly' |
| description | TEXT | Payment description |
| error_message | TEXT | Error message (if failed) |
| processed_at | TIMESTAMPTZ | Processing timestamp |

## 🔄 Payment Flow

### 1. Plan Selection (`/pricing`)

```typescript
// User selects a plan
handlePlanSelect('pro', 'monthly') 
  ↓
// Opens PaymentModal with:
- planTier: 'pro' | 'premium'
- billingPeriod: 'monthly' | 'yearly'
- amount: calculated price
```

### 2. Payment Processing

```typescript
// paymentService.processSubscriptionPayment()
{
  transactionId: 'SUB-{timestamp}-{userId}',
  amount: 99.00,
  currency: 'TRY',
  customer: { ... },
  billingAddress: { ... },
  cardInfo: { ... },
  use3DSecure: true,
  callbackUrl: '/payment/callback'
}
  ↓
// POST localhost:5000/api/payment/iyzico/process
  ↓
// Response: WAITING_3D
{
  success: true,
  status: 'WAITING_3D',
  threeDSecureHtmlContent: '<html>...</html>'
}
```

### 3. 3D Secure

```typescript
// Open popup with 3D Secure HTML
window.open('', '3DSecure', 'width=600,height=800')
popup.document.write(response.threeDSecureHtmlContent)
  ↓
// User completes 3D Secure
  ↓
// Redirect to: /payment/callback?transactionId=SUB-xxx
```

### 4. Callback & Verification

```typescript
// PaymentCallbackPage.tsx
const txId = searchParams.get('transactionId')
  ↓
// Check payment status
paymentService.checkPaymentStatus(txId)
  ↓
// If SUCCESS:
subscriptionService.upgradeSubscription(userId, tier, period, txId)
subscriptionService.savePaymentHistory(...)
  ↓
// Redirect to /dashboard
```

## 🧪 Test Kartları

### Başarılı Ödeme

```javascript
{
  cardNumber: '5528790000000008',
  cardHolderName: 'TEST USER',
  expireMonth: '12',
  expireYear: '2030',
  cvc: '123'
}
```

### Başarısız Ödeme

```javascript
{
  cardNumber: '5528790000000004',
  cardHolderName: 'TEST USER',
  expireMonth: '12',
  expireYear: '2030',
  cvc: '123'
}
```

## 🔐 Güvenlik

### RLS Policies

```sql
-- Users can only view/modify their own subscriptions
CREATE POLICY "Users can view own subscription"
  ON subscriptions FOR SELECT
  USING (auth.uid() = user_id);

-- Users can only view their own payment history
CREATE POLICY "Users can view own payment history"
  ON payment_history FOR SELECT
  USING (auth.uid() = user_id);
```

### Payment Data

- **Kart bilgileri asla saklanmaz** - direkt İyzico'ya gönderilir
- **3D Secure zorunlu** - tüm ödemelerde `use3DSecure: true`
- **HTTPS** - tüm API çağrıları SSL ile korunur
- **Transaction ID** - her ödeme için unique ID

## 📱 Kullanım Örnekleri

### Fiyatlandırma Sayfasından Ödeme

```typescript
// PricingPage.tsx
<button onClick={() => handlePlanSelect('pro', 'monthly')}>
  PRO'ya Başla
</button>
  ↓
// PaymentModal açılır
<PaymentModal
  isOpen={true}
  planTier="pro"
  billingPeriod="monthly"
  amount={99}
/>
```

### Ödeme Geçmişi Görüntüleme

```typescript
// AccountPage.tsx > Ödemeler Tab
const history = await subscriptionService.getPaymentHistory(userId);

// Render payment table
{history.map(payment => (
  <tr>
    <td>{payment.processedAt}</td>
    <td>{payment.planTier}</td>
    <td>₺{payment.amount}</td>
    <td>{payment.status}</td>
  </tr>
))}
```

### Subscription Upgrade

```typescript
// After successful payment
await subscriptionService.upgradeSubscription(
  userId,
  'premium',
  'yearly',
  transactionId
);

// User's subscription updated to premium
// End date set to +1 year
```

## 🐛 Hata Yönetimi

### Payment Service Errors

```typescript
try {
  await paymentService.processPayment(...)
} catch (error) {
  // User-friendly error messages
  toast.error('Ödeme işlemi sırasında bir hata oluştu');
  
  // Log error for debugging
  console.error('Payment error:', error);
}
```

### 3D Secure Popup Blocked

```typescript
const popup = window.open(...);
if (!popup) {
  toast.error('Popup engellendi. Lütfen popup engelleyicisini kapatın.');
}
```

### Payment Status Check Failed

```typescript
if (result.status === 'FAILURE') {
  // Save failed payment to history
  await subscriptionService.savePaymentHistory(
    userId,
    transactionId,
    ...,
    'FAILURE',
    ...,
    result.errorMessage
  );
  
  // Redirect to pricing
  navigate('/pricing');
}
```

## 📈 Monitoring & Analytics

### Payment Statistics

```sql
-- Successful payments count
SELECT COUNT(*) FROM payment_history 
WHERE status = 'SUCCESS';

-- Total revenue
SELECT SUM(amount) FROM payment_history 
WHERE status = 'SUCCESS';

-- Average transaction value
SELECT AVG(amount) FROM payment_history 
WHERE status = 'SUCCESS';
```

### Subscription Metrics

```sql
-- Active subscriptions by tier
SELECT tier, COUNT(*) FROM subscriptions 
WHERE status = 'active' 
GROUP BY tier;

-- Monthly revenue (recurring)
SELECT tier, COUNT(*) * price as mrr
FROM subscriptions 
WHERE status = 'active' 
GROUP BY tier;
```

## 🚧 TODO

- [ ] Webhook handler for automatic subscription renewal
- [ ] Failed payment retry logic
- [ ] Subscription downgrade handling
- [ ] Invoice generation (PDF)
- [ ] Email notifications for payments
- [ ] Admin panel for payment management

## 📞 Destek

- Payment service issues: Check `localhost:5000/api/payment/providers`
- Database issues: Verify RLS policies and triggers
- 3D Secure issues: Check callback URL configuration
- Transaction verification: Use İyzico dashboard

## 🔗 Kaynaklar

- [İyzico API Documentation](https://dev.iyzipay.com/)
- [Payment Service Repo](#) (link eklenecek)
- [Supabase RLS Guide](https://supabase.com/docs/guides/auth/row-level-security)

