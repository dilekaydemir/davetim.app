-- Refresh Supabase schema cache
-- Run this in Supabase SQL Editor after any schema changes

-- Notify PostgREST to reload schema cache
SELECT pg_notify('pgrst', 'reload schema');

-- Also ensure the column exists (idempotent)
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
      AND table_name = 'guest_uploads' 
      AND column_name = 'storage_path'
  ) THEN
    ALTER TABLE guest_uploads ADD COLUMN storage_path TEXT;
  END IF;
END $$;

-- Refresh again after potential change
SELECT pg_notify('pgrst', 'reload schema');

