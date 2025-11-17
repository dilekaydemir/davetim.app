-- =====================================================
-- FIX: invitations Foreign Key İlişkileri
-- =====================================================
-- PostgREST'in embedded resources özelliği için
-- foreign key constraint'lerin doğru şekilde tanımlanması
-- =====================================================

-- Önce mevcut foreign key'leri kontrol et
SELECT 
  conname as constraint_name,
  conrelid::regclass as table_name,
  confrelid::regclass as referenced_table,
  a.attname as column_name
FROM pg_constraint c
JOIN pg_attribute a ON a.attnum = ANY(c.conkey) AND a.attrelid = c.conrelid
WHERE contype = 'f'
AND conrelid = 'public.invitations'::regclass
ORDER BY conname;

-- Mevcut foreign key'leri kaldır (varsa)
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT constraint_name
        FROM information_schema.table_constraints
        WHERE table_name = 'invitations'
        AND constraint_type = 'FOREIGN KEY'
        AND constraint_name LIKE '%template%'
    ) LOOP
        EXECUTE 'ALTER TABLE invitations DROP CONSTRAINT IF EXISTS ' || r.constraint_name || ' CASCADE';
    END LOOP;
END $$;

-- Yeni foreign key'i ekle (PostgREST uyumlu)
ALTER TABLE invitations
  ADD CONSTRAINT invitations_template_id_fkey 
  FOREIGN KEY (template_id) 
  REFERENCES templates(id) 
  ON DELETE SET NULL;

-- Schema cache'i yenile
NOTIFY pgrst, 'reload schema';

-- Kontrol: Foreign key doğru mu?
SELECT 
  conname as constraint_name,
  conrelid::regclass as table_name,
  confrelid::regclass as referenced_table,
  a.attname as column_name
FROM pg_constraint c
JOIN pg_attribute a ON a.attnum = ANY(c.conkey) AND a.attrelid = c.conrelid
WHERE contype = 'f'
AND conrelid = 'public.invitations'::regclass
AND conname LIKE '%template%'
ORDER BY conname;

-- =====================================================
-- BAŞARILI!
-- =====================================================
-- Foreign key düzeltildi
-- PostgREST embedded resources artık çalışmalı
-- =====================================================

