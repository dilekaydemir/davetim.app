-- =====================================================
-- TROUBLESHOOTING QUERIES - DAVETIM.APP
-- =====================================================
-- Bu dosya sorun giderme için kullanışlı sorgular içerir
-- =====================================================

-- =====================================================
-- 1. GENEL KONTROLLER
-- =====================================================

-- 1.1 Tüm tabloları listele
SELECT 
    table_name,
    CASE 
        WHEN table_name IN (
            'subscriptions', 'template_categories', 'templates', 
            'user_templates', 'invitations', 'guests', 
            'invitation_guests', 'media', 'guest_uploads', 'payment_history'
        ) THEN '✅'
        ELSE '❌'
    END as expected
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 1.2 Tüm fonksiyonları listele
SELECT 
    routine_name,
    routine_type,
    data_type as return_type,
    CASE 
        WHEN routine_name IN (
            'handle_new_user', 'create_user_subscription', 'generate_invitation_slug',
            'increment_invitation_views', 'increment_invitation_count', 'get_invitation_guest_stats',
            'increment_template_usage', 'increment_media_scan_count', 'increment_media_view_count',
            'inc_guest_uploads_count', 'update_updated_at_column', 'reset_monthly_counters',
            'get_user_stats', 'clean_expired_media', 'update_storage_usage'
        ) THEN '✅'
        ELSE '❌'
    END as expected
FROM information_schema.routines 
WHERE routine_schema = 'public'
ORDER BY routine_name;

-- 1.3 RLS durumunu kontrol et
SELECT 
    schemaname, 
    tablename, 
    CASE 
        WHEN rowsecurity THEN 'Enabled ✅' 
        ELSE 'Disabled ❌' 
    END as rls_status
FROM pg_tables
WHERE schemaname = 'public'
AND tablename NOT LIKE 'pg_%'
ORDER BY tablename;

-- 1.4 Tüm trigger'ları listele
SELECT 
    trigger_schema,
    trigger_name, 
    event_object_table,
    action_timing,
    event_manipulation
FROM information_schema.triggers
WHERE trigger_schema IN ('public', 'auth')
ORDER BY event_object_table, trigger_name;

-- =====================================================
-- 2. AUTH & SUBSCRIPTION KONTROLLER
-- =====================================================

-- 2.1 Tüm kullanıcıları ve subscription'larını listele
SELECT 
    u.id,
    u.email,
    u.created_at as user_created,
    s.tier,
    s.status,
    s.invitations_created_this_month,
    s.invitations_created_lifetime,
    s.start_date as subscription_start,
    CASE 
        WHEN s.id IS NULL THEN '❌ Subscription YOK'
        ELSE '✅ Subscription VAR'
    END as subscription_status
FROM auth.users u
LEFT JOIN public.subscriptions s ON s.user_id = u.id
ORDER BY u.created_at DESC;

-- 2.2 Subscription olmayan kullanıcıları bul
SELECT 
    u.id,
    u.email,
    u.created_at,
    '❌ Missing Subscription' as issue
FROM auth.users u
LEFT JOIN public.subscriptions s ON s.user_id = u.id
WHERE s.id IS NULL;

-- 2.3 Auth trigger'ın çalışıp çalışmadığını kontrol et
SELECT 
    trigger_name,
    event_object_table,
    action_statement,
    CASE 
        WHEN trigger_name = 'on_auth_user_created' THEN '✅ Bulundu'
        ELSE '❌ Bulunamadı'
    END as status
FROM information_schema.triggers
WHERE trigger_schema = 'auth'
AND trigger_name = 'on_auth_user_created';

-- =====================================================
-- 3. RLS POLİTİKA KONTROLLER
-- =====================================================

-- 3.1 Her tablo için politika sayısını göster
SELECT 
    tablename,
    COUNT(*) as policy_count,
    string_agg(policyname, ', ') as policies
FROM pg_policies 
WHERE schemaname = 'public'
GROUP BY tablename
ORDER BY tablename;

-- 3.2 Subscriptions tablosu politikalarını detaylı göster
SELECT 
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'subscriptions';

-- 3.3 Invitations tablosu politikalarını detaylı göster
SELECT 
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'invitations';

-- =====================================================
-- 4. STORAGE KONTROLLER
-- =====================================================

-- 4.1 Storage bucket'ları listele
SELECT 
    id,
    name,
    public,
    file_size_limit,
    allowed_mime_types
FROM storage.buckets
ORDER BY name;

-- 4.2 Storage politikalarını listele (Supabase Dashboard'dan kontrol edin)
-- Not: storage.bucket_policies tablosu yeni Supabase versiyonlarında mevcut değil
-- Storage policies Supabase Dashboard > Storage > Policies'den yönetilir
SELECT 
    'Storage policies are managed via Supabase Dashboard' as note,
    'Go to Storage > Policies to view bucket policies' as instruction;

-- 4.3 Bucket'lardaki dosya sayısını göster
SELECT 
    bucket_id,
    COUNT(*) as file_count,
    -- Note: File size is stored in metadata JSONB column in Supabase
    'File sizes are stored in metadata JSONB column' as size_note
FROM storage.objects
GROUP BY bucket_id
ORDER BY bucket_id;

-- 4.4 Alternative: Try to extract file sizes from metadata (if available)
SELECT 
    bucket_id,
    COUNT(*) as file_count,
    COALESCE(
        SUM((metadata->>'size')::bigint), 
        0
    ) as total_size_bytes,
    ROUND(
        COALESCE(
            SUM((metadata->>'size')::bigint), 
            0
        )::numeric / 1024 / 1024, 
        2
    ) as total_size_mb
FROM storage.objects
WHERE metadata ? 'size'  -- Only if size is available in metadata
GROUP BY bucket_id
ORDER BY bucket_id;

-- =====================================================
-- 5. VERİ İSTATİSTİKLERİ
-- =====================================================

-- 5.1 Her tablodaki kayıt sayısı
SELECT 
    'subscriptions' as table_name,
    COUNT(*) as row_count
FROM public.subscriptions
UNION ALL
SELECT 'templates', COUNT(*) FROM public.templates
UNION ALL
SELECT 'template_categories', COUNT(*) FROM public.template_categories
UNION ALL
SELECT 'invitations', COUNT(*) FROM public.invitations
UNION ALL
SELECT 'guests', COUNT(*) FROM public.guests
UNION ALL
SELECT 'invitation_guests', COUNT(*) FROM public.invitation_guests
UNION ALL
SELECT 'media', COUNT(*) FROM public.media
UNION ALL
SELECT 'guest_uploads', COUNT(*) FROM public.guest_uploads
UNION ALL
SELECT 'payment_history', COUNT(*) FROM public.payment_history
ORDER BY table_name;

-- 5.2 Kullanıcı başına davetiye sayısı
SELECT 
    u.email,
    COUNT(i.id) as invitation_count,
    COUNT(CASE WHEN i.status = 'published' THEN 1 END) as published_count,
    COUNT(CASE WHEN i.status = 'draft' THEN 1 END) as draft_count
FROM auth.users u
LEFT JOIN public.invitations i ON i.user_id = u.id
GROUP BY u.id, u.email
ORDER BY invitation_count DESC;

-- 5.3 Template kullanım istatistikleri
SELECT 
    t.name,
    t.tier,
    t.usage_count,
    t.is_featured,
    t.is_popular,
    COUNT(DISTINCT i.id) as invitation_count
FROM public.templates t
LEFT JOIN public.invitations i ON i.template_id = t.id
GROUP BY t.id, t.name, t.tier, t.usage_count, t.is_featured, t.is_popular
ORDER BY t.usage_count DESC;

-- =====================================================
-- 6. FİKS SCRIPTLERI (Sorun varsa çalıştırın)
-- =====================================================

-- 6.1 Auth trigger'ı yeniden oluştur
/*
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

SELECT '✅ Auth trigger yeniden oluşturuldu' as result;
*/

-- 6.2 Subscription olmayan kullanıcılara subscription oluştur
/*
INSERT INTO public.subscriptions (user_id, tier, status, start_date)
SELECT 
    u.id, 
    'free', 
    'active', 
    NOW()
FROM auth.users u
LEFT JOIN public.subscriptions s ON s.user_id = u.id
WHERE s.id IS NULL
ON CONFLICT (user_id) DO NOTHING;

SELECT '✅ Eksik subscription''lar oluşturuldu' as result;
*/

-- 6.2a Manuel subscription oluştur (function kullanarak)
/*
SELECT public.create_user_subscription(u.id)
FROM auth.users u
LEFT JOIN public.subscriptions s ON s.user_id = u.id
WHERE s.id IS NULL;

SELECT '✅ Eksik subscription''lar function ile oluşturuldu' as result;
*/

-- 6.3 Tüm subscription'ları free tier'a sıfırla (TEST AMAÇLI)
/*
UPDATE public.subscriptions
SET 
    tier = 'free',
    status = 'active',
    end_date = NULL,
    cancelled_at = NULL,
    invitations_created_this_month = 0
WHERE tier != 'free';

SELECT '✅ Tüm subscription''lar free tier''a sıfırlandı' as result;
*/

-- 6.4 Invitation counter'larını düzelt
/*
UPDATE public.subscriptions s
SET 
    invitations_created_lifetime = (
        SELECT COUNT(*) 
        FROM public.invitations i 
        WHERE i.user_id = s.user_id
    ),
    invitations_created_this_month = (
        SELECT COUNT(*) 
        FROM public.invitations i 
        WHERE i.user_id = s.user_id
        AND i.created_at >= date_trunc('month', CURRENT_DATE)
    );

SELECT '✅ Invitation counter''ları güncellendi' as result;
*/

-- 6.5 Tüm template usage count'larını düzelt
/*
UPDATE public.templates t
SET usage_count = (
    SELECT COUNT(*) 
    FROM public.invitations i 
    WHERE i.template_id = t.id
);

SELECT '✅ Template usage count''ları güncellendi' as result;
*/

-- =====================================================
-- 7. TEST VERILERI (İsteğe bağlı)
-- =====================================================

-- 7.1 Test kullanıcısı oluştur (Dashboard'dan da yapılabilir)
/*
-- Not: Bu sorgu çalışmaz çünkü auth.users tablosuna INSERT yapamayız
-- Bunun yerine Supabase Dashboard > Authentication > Add User kullanın
*/

-- 7.2 Mevcut test kullanıcısına pro subscription ver
/*
UPDATE public.subscriptions
SET 
    tier = 'pro',
    status = 'active',
    start_date = NOW(),
    end_date = NOW() + INTERVAL '1 month'
WHERE user_id = (
    SELECT id FROM auth.users WHERE email = 'test@davetim.app'
);

SELECT '✅ Test kullanıcısına pro subscription verildi' as result;
*/

-- =====================================================
-- 8. PERİYODİK BAKIM
-- =====================================================

-- 8.1 Expired subscription'ları tespit et
SELECT 
    u.email,
    s.tier,
    s.status,
    s.end_date,
    CASE 
        WHEN s.end_date < NOW() THEN '❌ Expired'
        ELSE '✅ Active'
    END as validity
FROM public.subscriptions s
JOIN auth.users u ON u.id = s.user_id
WHERE s.end_date IS NOT NULL
ORDER BY s.end_date ASC;

-- 8.2 Expired subscription'ları güncelle
/*
UPDATE public.subscriptions
SET 
    status = 'expired',
    tier = 'free'
WHERE end_date < NOW()
AND status != 'expired';

SELECT '✅ Expired subscription''lar güncellendi' as result;
*/

-- 8.3 Bu ayki en aktif kullanıcılar
SELECT 
    u.email,
    s.tier,
    s.invitations_created_this_month,
    s.storage_used_mb
FROM public.subscriptions s
JOIN auth.users u ON u.id = s.user_id
ORDER BY s.invitations_created_this_month DESC
LIMIT 10;

-- 8.4 Yeni functions test et
-- 8.4a User stats function test
/*
SELECT * FROM public.get_user_stats(
    (SELECT id FROM auth.users LIMIT 1)
);
*/

-- 8.4b Storage usage update test
/*
SELECT public.update_storage_usage(
    (SELECT id FROM auth.users LIMIT 1)
);
*/

-- 8.4c Expired media cleanup test
/*
SELECT public.clean_expired_media() as expired_count;
*/

-- 8.4d Monthly counters reset test (dikkatli kullanın!)
/*
SELECT public.reset_monthly_counters();
SELECT '✅ Monthly counters sıfırlandı' as result;
*/

-- =====================================================
-- 9. PERFORMANS KONTROLLER
-- =====================================================

-- 9.1 En büyük tabloları bul
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- 9.2 Index'leri listele
SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- =====================================================
-- 10. YEDEKLEME VE RESTORE
-- =====================================================

-- 10.1 Tüm template'leri JSON olarak export et
/*
COPY (
    SELECT json_agg(t.*)
    FROM public.templates t
) TO '/tmp/templates_backup.json';
*/

-- 10.2 Critical data yedekleme (subscription'lar)
SELECT 
    json_agg(
        json_build_object(
            'user_email', u.email,
            'tier', s.tier,
            'status', s.status,
            'start_date', s.start_date,
            'end_date', s.end_date
        )
    )
FROM public.subscriptions s
JOIN auth.users u ON u.id = s.user_id;

-- =====================================================
-- NOTLAR
-- =====================================================
-- 
-- * Comment (/*...*/) içindeki sorgular varsayılan olarak çalıştırılmaz
-- * Bunları kullanmak için comment'leri kaldırın
-- * Production'da dikkatli olun!
-- * Her zaman önce test ortamında deneyin
--
-- =====================================================

