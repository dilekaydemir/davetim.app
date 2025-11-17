-- =====================================================
-- TEST: user_templates tablosu ve ilişkileri
-- =====================================================

-- 1. Tablo var mı?
SELECT 'Table exists:' as check_type, EXISTS (
  SELECT FROM information_schema.tables 
  WHERE table_schema = 'public' 
  AND table_name = 'user_templates'
) as result;

-- 2. Kolonlar doğru mu?
SELECT 'Columns:' as check_type, column_name, data_type 
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'user_templates'
ORDER BY ordinal_position;

-- 3. Foreign key constraints var mı?
SELECT 'Foreign Keys:' as check_type, 
  conname as constraint_name,
  conrelid::regclass as table_name,
  confrelid::regclass as referenced_table
FROM pg_constraint
WHERE contype = 'f'
AND conrelid = 'public.user_templates'::regclass;

-- 4. templates tablosuna foreign key var mı?
SELECT 'FK to templates:' as check_type,
  tc.constraint_name,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'user_templates'
  AND ccu.table_name = 'templates';

-- 5. Basit bir SELECT testi
SELECT 'Simple SELECT test:' as check_type, COUNT(*) as row_count 
FROM user_templates;

-- 6. JOIN testi (manuel)
SELECT 'JOIN test:' as check_type, 
  ut.id,
  ut.template_id,
  t.name as template_name
FROM user_templates ut
LEFT JOIN templates t ON ut.template_id = t.id
LIMIT 1;

-- =====================================================
-- SONUÇLAR
-- =====================================================
-- Yukarıdaki sorguların sonuçlarını kontrol edin
-- Özellikle "FK to templates" sonucu önemli
-- =====================================================

