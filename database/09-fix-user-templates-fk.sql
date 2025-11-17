-- =====================================================
-- FIX: user_templates Foreign Key İlişkileri
-- =====================================================
-- PostgREST'in embedded resources özelliği için
-- foreign key constraint'lerin doğru şekilde tanımlanması
-- =====================================================

-- Önce mevcut foreign key'leri kaldır (varsa)
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT constraint_name
        FROM information_schema.table_constraints
        WHERE table_name = 'user_templates'
        AND constraint_type = 'FOREIGN KEY'
    ) LOOP
        EXECUTE 'ALTER TABLE user_templates DROP CONSTRAINT IF EXISTS ' || r.constraint_name || ' CASCADE';
    END LOOP;
END $$;

-- Yeni foreign key'leri ekle (PostgREST uyumlu)
ALTER TABLE user_templates
  ADD CONSTRAINT user_templates_template_id_fkey 
  FOREIGN KEY (template_id) 
  REFERENCES templates(id) 
  ON DELETE CASCADE;

ALTER TABLE user_templates
  ADD CONSTRAINT user_templates_user_id_fkey 
  FOREIGN KEY (user_id) 
  REFERENCES auth.users(id) 
  ON DELETE CASCADE;

-- Schema cache'i yenile
NOTIFY pgrst, 'reload schema';

-- Kontrol: Foreign key'ler doğru mu?
SELECT 
  conname as constraint_name,
  conrelid::regclass as table_name,
  confrelid::regclass as referenced_table,
  a.attname as column_name
FROM pg_constraint c
JOIN pg_attribute a ON a.attnum = ANY(c.conkey) AND a.attrelid = c.conrelid
WHERE contype = 'f'
AND conrelid = 'public.user_templates'::regclass
ORDER BY conname;

-- =====================================================
-- BAŞARILI!
-- =====================================================
-- Foreign key'ler düzeltildi
-- PostgREST embedded resources artık çalışmalı
-- =====================================================

