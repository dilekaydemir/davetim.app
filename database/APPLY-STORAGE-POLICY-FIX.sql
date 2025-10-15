-- Fix: Allow authenticated users to upload to guest folder
-- Run this in Supabase SQL Editor

-- Allow authenticated users to insert to guest folder (for owner additional uploads)
DO $$ BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'qr-media: authenticated insert to guest folder'
  ) THEN
    EXECUTE 'DROP POLICY "qr-media: authenticated insert to guest folder" ON storage.objects';
  END IF;
END $$;

CREATE POLICY "qr-media: authenticated insert to guest folder"
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'qr-media'
    AND (left(name, 6) = 'guest/')
  );

