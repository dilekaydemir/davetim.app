-- =====================================================
-- SUBSCRIPTION EXPIRATION CHECK & AUTO-DOWNGRADE
-- =====================================================
-- Bu sorgu, süresi dolmuş abonelikleri otomatik olarak FREE plana düşürür
-- Günlük olarak çalıştırılmalıdır (Cron job veya manuel)

-- =====================================================
-- 1. EXPIRED SUBSCRIPTION'LARI TESPİT ET
-- =====================================================
SELECT 
    u.email,
    s.tier,
    s.status,
    s.end_date,
    NOW() as current_time,
    CASE 
        WHEN s.end_date < NOW() THEN '❌ Expired - Needs Downgrade'
        WHEN s.end_date < NOW() + INTERVAL '7 days' THEN '⚠️ Expiring Soon (7 days)'
        WHEN s.end_date < NOW() + INTERVAL '3 days' THEN '🔴 Expiring Very Soon (3 days)'
        ELSE '✅ Active'
    END as status_check
FROM public.subscriptions s
JOIN auth.users u ON u.id = s.user_id
WHERE s.end_date IS NOT NULL
  AND s.tier != 'free'
ORDER BY s.end_date ASC;

-- =====================================================
-- 2. EXPIRED SUBSCRIPTION'LARI FREE'YE DÜŞÜR
-- =====================================================
-- ⚠️ DİKKAT: Bu sorgu gerçek verileri değiştirir!
-- Test ortamında önce kontrol edin

UPDATE public.subscriptions
SET 
    tier = 'free',
    status = 'expired',
    cancelled_at = NOW()
WHERE end_date < NOW()
  AND tier != 'free'
  AND status = 'active';

-- Kaç kayıt güncellendi?
SELECT 
    COUNT(*) as downgraded_count,
    'Subscription''lar FREE plana düşürüldü' as message
FROM public.subscriptions
WHERE status = 'expired'
  AND cancelled_at::date = CURRENT_DATE;

-- =====================================================
-- 3. YAKINDA SONA ERECEK ABONELİKLER (BİLDİRİM İÇİN)
-- =====================================================
-- Bu kullanıcılara e-posta bildirimi gönderilebilir

SELECT 
    u.email,
    u.raw_user_meta_data->>'full_name' as full_name,
    s.tier,
    s.end_date,
    EXTRACT(DAY FROM s.end_date - NOW()) as days_remaining
FROM public.subscriptions s
JOIN auth.users u ON u.id = s.user_id
WHERE s.end_date IS NOT NULL
  AND s.end_date > NOW()
  AND s.end_date < NOW() + INTERVAL '7 days'
  AND s.tier != 'free'
  AND s.status = 'active'
ORDER BY s.end_date ASC;

-- =====================================================
-- 4. CRON JOB KURULUMU (SUPABASE DASHBOARD)
-- =====================================================
/*
Supabase Dashboard > Database > Cron Jobs > Create New Job

Job Name: daily_subscription_expiration_check
Schedule: 0 2 * * * (Her gün saat 02:00'de)
Command:

UPDATE public.subscriptions
SET 
    tier = 'free',
    status = 'expired',
    cancelled_at = NOW()
WHERE end_date < NOW()
  AND tier != 'free'
  AND status = 'active';

*/

-- =====================================================
-- 5. MANUEL TEST (GÜVENLİ)
-- =====================================================
-- Gerçek güncelleme yapmadan önce test edin

BEGIN;

-- Test: Hangi kayıtlar etkilenecek?
SELECT 
    u.email,
    s.tier,
    s.end_date,
    'Will be downgraded to FREE' as action
FROM public.subscriptions s
JOIN auth.users u ON u.id = s.user_id
WHERE end_date < NOW()
  AND tier != 'free'
  AND status = 'active';

-- Eğer sonuç doğruysa, COMMIT; değilse ROLLBACK;
ROLLBACK; -- veya COMMIT;

