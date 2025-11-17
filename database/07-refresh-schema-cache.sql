-- =====================================================
-- REFRESH SCHEMA CACHE
-- =====================================================
-- Supabase'in schema cache'ini yeniler
-- Yeni tablolar veya ilişkiler eklendiğinde gereklidir
-- =====================================================

-- PostgREST schema cache'ini yenile
NOTIFY pgrst, 'reload schema';

-- Alternatif: pg_notify kullanarak
SELECT pg_notify('pgrst', 'reload schema');

-- =====================================================
-- KONTROL: user_templates tablosunu kontrol et
-- =====================================================

-- Tablo var mı?
SELECT EXISTS (
  SELECT FROM information_schema.tables 
  WHERE table_schema = 'public' 
  AND table_name = 'user_templates'
) as table_exists;

-- Foreign key ilişkileri var mı?
SELECT
  tc.constraint_name,
  tc.table_name,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'user_templates';

-- RLS politikaları var mı?
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'user_templates';

-- =====================================================
-- BAŞARILI!
-- =====================================================
-- Schema cache yenilendi
-- Kontroller tamamlandı
-- =====================================================

