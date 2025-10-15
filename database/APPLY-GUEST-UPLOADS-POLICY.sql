-- Add RLS policies for authenticated users (media owners) to insert/view guest uploads
-- Run this in Supabase SQL Editor

-- Media owner can insert guest uploads (for additional media)
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'guest_uploads' AND policyname = 'Owner can insert guest uploads'
  ) THEN
    CREATE POLICY "Owner can insert guest uploads"
      ON guest_uploads FOR INSERT TO authenticated
      WITH CHECK (
        EXISTS (
          SELECT 1 FROM media m
          WHERE m.id = media_id
            AND m.user_id = auth.uid()
            AND m.status = 'active'
        )
      );
  END IF;
END $$;

-- Media owner can view their guest uploads
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'guest_uploads' AND policyname = 'Owner can view guest uploads'
  ) THEN
    CREATE POLICY "Owner can view guest uploads"
      ON guest_uploads FOR SELECT TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM media m
          WHERE m.id = media_id
            AND m.user_id = auth.uid()
        )
      );
  END IF;
END $$;

-- Refresh schema cache
SELECT pg_notify('pgrst', 'reload schema');

