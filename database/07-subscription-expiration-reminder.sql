-- =====================================================
-- SUBSCRIPTION EXPIRATION REMINDER FUNCTION
-- =====================================================
-- Bu function, yakında sona erecek abonelikleri döndürür
-- Edge Function tarafından kullanılır (email göndermek için)

-- =====================================================
-- 1. GET EXPIRING SUBSCRIPTIONS FUNCTION
-- =====================================================

CREATE OR REPLACE FUNCTION get_expiring_subscriptions()
RETURNS TABLE (
  email TEXT,
  full_name TEXT,
  tier TEXT,
  end_date TIMESTAMP WITH TIME ZONE,
  days_remaining NUMERIC
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    u.email::TEXT,
    (u.raw_user_meta_data->>'full_name')::TEXT as full_name,
    s.tier::TEXT,
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
END;
$$;

-- =====================================================
-- 2. NOTIFICATION TRACKING TABLE
-- =====================================================
-- Aynı kullanıcıya tekrar tekrar email gönderilmemesi için

CREATE TABLE IF NOT EXISTS public.subscription_notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  subscription_id UUID NOT NULL REFERENCES public.subscriptions(id) ON DELETE CASCADE,
  notification_type TEXT NOT NULL CHECK (notification_type IN ('7_days', '3_days', '1_day', 'expired')),
  sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  email_status TEXT DEFAULT 'sent',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_subscription_notifications_user_id 
ON public.subscription_notifications(user_id);

CREATE INDEX IF NOT EXISTS idx_subscription_notifications_subscription_id 
ON public.subscription_notifications(subscription_id);

CREATE INDEX IF NOT EXISTS idx_subscription_notifications_sent_at 
ON public.subscription_notifications(sent_at);

-- RLS Policies
ALTER TABLE public.subscription_notifications ENABLE ROW LEVEL SECURITY;

-- Users can only see their own notifications
CREATE POLICY "Users can view own notifications"
ON public.subscription_notifications
FOR SELECT
USING (auth.uid() = user_id);

-- Only service role can insert notifications
CREATE POLICY "Service role can insert notifications"
ON public.subscription_notifications
FOR INSERT
WITH CHECK (true);

-- =====================================================
-- 3. IMPROVED GET EXPIRING SUBSCRIPTIONS (WITH TRACKING)
-- =====================================================
-- Sadece daha önce bildirim gönderilmemiş abonelikleri döndürür

CREATE OR REPLACE FUNCTION get_expiring_subscriptions_with_tracking()
RETURNS TABLE (
  user_id UUID,
  subscription_id UUID,
  email TEXT,
  full_name TEXT,
  tier TEXT,
  end_date TIMESTAMP WITH TIME ZONE,
  days_remaining NUMERIC,
  notification_type TEXT
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  WITH expiring_subs AS (
    SELECT 
      s.user_id,
      s.id as subscription_id,
      u.email::TEXT,
      (u.raw_user_meta_data->>'full_name')::TEXT as full_name,
      s.tier::TEXT,
      s.end_date,
      EXTRACT(DAY FROM s.end_date - NOW()) as days_remaining,
      CASE 
        WHEN EXTRACT(DAY FROM s.end_date - NOW()) <= 1 THEN '1_day'
        WHEN EXTRACT(DAY FROM s.end_date - NOW()) <= 3 THEN '3_days'
        WHEN EXTRACT(DAY FROM s.end_date - NOW()) <= 7 THEN '7_days'
      END as notification_type
    FROM public.subscriptions s
    JOIN auth.users u ON u.id = s.user_id
    WHERE s.end_date IS NOT NULL
      AND s.end_date > NOW()
      AND s.end_date < NOW() + INTERVAL '7 days'
      AND s.tier != 'free'
      AND s.status = 'active'
  )
  SELECT 
    es.user_id,
    es.subscription_id,
    es.email,
    es.full_name,
    es.tier,
    es.end_date,
    es.days_remaining,
    es.notification_type
  FROM expiring_subs es
  WHERE NOT EXISTS (
    -- Check if notification already sent in last 24 hours
    SELECT 1 
    FROM public.subscription_notifications sn
    WHERE sn.subscription_id = es.subscription_id
      AND sn.notification_type = es.notification_type
      AND sn.sent_at > NOW() - INTERVAL '24 hours'
  )
  ORDER BY es.end_date ASC;
END;
$$;

-- =====================================================
-- 4. RECORD NOTIFICATION FUNCTION
-- =====================================================
-- Edge Function'dan çağrılır (email gönderildikten sonra)

CREATE OR REPLACE FUNCTION record_subscription_notification(
  p_user_id UUID,
  p_subscription_id UUID,
  p_notification_type TEXT,
  p_email_status TEXT DEFAULT 'sent'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_notification_id UUID;
BEGIN
  INSERT INTO public.subscription_notifications (
    user_id,
    subscription_id,
    notification_type,
    email_status
  ) VALUES (
    p_user_id,
    p_subscription_id,
    p_notification_type,
    p_email_status
  )
  RETURNING id INTO v_notification_id;
  
  RETURN v_notification_id;
END;
$$;

-- =====================================================
-- 5. TEST QUERIES
-- =====================================================

-- Test 1: Yakında sona erecek abonelikleri listele
SELECT * FROM get_expiring_subscriptions();

-- Test 2: Bildirim gönderilmemiş abonelikleri listele
SELECT * FROM get_expiring_subscriptions_with_tracking();

-- Test 3: Gönderilen bildirimleri görüntüle
SELECT 
  sn.notification_type,
  sn.sent_at,
  u.email,
  s.tier,
  s.end_date
FROM public.subscription_notifications sn
JOIN auth.users u ON u.id = sn.user_id
JOIN public.subscriptions s ON s.id = sn.subscription_id
ORDER BY sn.sent_at DESC
LIMIT 10;

-- =====================================================
-- 6. CRON JOB SETUP
-- =====================================================
/*
Supabase Dashboard > Database > Cron Jobs

Job 1: Expire Subscriptions (Her gün 02:00)
Schedule: 0 2 * * *
Command:
UPDATE public.subscriptions
SET tier = 'free', status = 'expired', cancelled_at = NOW()
WHERE end_date < NOW() AND tier != 'free' AND status = 'active';

Job 2: Send Expiration Reminders (Her gün 10:00)
Schedule: 0 10 * * *
Command:
SELECT net.http_post(
  url := 'https://YOUR_PROJECT.supabase.co/functions/v1/subscription-expiration-reminder',
  headers := '{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY"}'::jsonb
);

NOT: Job 2 için Supabase'in http extension'ı gereklidir:
CREATE EXTENSION IF NOT EXISTS http;
*/

-- =====================================================
-- 7. MANUAL TEST (Email Trigger)
-- =====================================================
-- Edge Function'ı manuel tetiklemek için:
/*
curl -X POST \
  https://YOUR_PROJECT.supabase.co/functions/v1/subscription-expiration-reminder \
  -H "Authorization: Bearer YOUR_SERVICE_ROLE_KEY" \
  -H "Content-Type: application/json"
*/

-- =====================================================
-- 8. CLEANUP OLD NOTIFICATIONS (Optional)
-- =====================================================
-- 90 günden eski bildirimleri sil (opsiyonel, disk tasarrufu için)

CREATE OR REPLACE FUNCTION cleanup_old_notifications()
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_deleted_count INTEGER;
BEGIN
  DELETE FROM public.subscription_notifications
  WHERE sent_at < NOW() - INTERVAL '90 days';
  
  GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
  
  RETURN v_deleted_count;
END;
$$;

-- Test cleanup
-- SELECT cleanup_old_notifications();

-- =====================================================
-- 9. STATISTICS QUERY
-- =====================================================
-- Bildirim istatistikleri

SELECT 
  notification_type,
  COUNT(*) as total_sent,
  COUNT(DISTINCT user_id) as unique_users,
  DATE(sent_at) as sent_date
FROM public.subscription_notifications
WHERE sent_at > NOW() - INTERVAL '30 days'
GROUP BY notification_type, DATE(sent_at)
ORDER BY sent_date DESC, notification_type;

