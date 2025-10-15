-- Supabase Storage setup for qr-media bucket and RLS (run in SQL Editor)

-- 1) Create bucket (run once). If already created via Dashboard, skip.
-- select storage.create_bucket('qr-media', true, null);

-- 2) Policies on storage.objects (bucket should be private: public=false)

-- Helper: drop existing policy by name if exists (idempotent create)
DO $$ BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'qr-media: user can insert to own folder'
  ) THEN
    EXECUTE 'DROP POLICY "qr-media: user can insert to own folder" ON storage.objects';
  END IF;
END $$;

CREATE POLICY "qr-media: user can insert to own folder"
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'qr-media'
    AND (position((auth.uid())::text || '/' in name) = 1)
  );

-- Allow update (overwrite) in own folder
DO $$ BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'qr-media: user can update own folder'
  ) THEN
    EXECUTE 'DROP POLICY "qr-media: user can update own folder" ON storage.objects';
  END IF;
END $$;

CREATE POLICY "qr-media: user can update own folder"
  ON storage.objects FOR UPDATE TO authenticated
  USING (
    bucket_id = 'qr-media'
    AND (position((auth.uid())::text || '/' in name) = 1)
  )
  WITH CHECK (
    bucket_id = 'qr-media'
    AND (position((auth.uid())::text || '/' in name) = 1)
  );

-- Allow anon SELECT only for objects referenced by active media/guest_uploads (to generate signed URLs)
DO $$ BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'qr-media: anon select referenced objects'
  ) THEN
    EXECUTE 'DROP POLICY "qr-media: anon select referenced objects" ON storage.objects';
  END IF;
END $$;

CREATE POLICY "qr-media: anon select referenced objects"
  ON storage.objects FOR SELECT TO anon
  USING (
    bucket_id = 'qr-media' AND (
      EXISTS (
        SELECT 1 FROM public.media m
        WHERE m.status = 'active'
          AND m.storage_path IS NOT NULL
          AND m.storage_path = name
      )
      OR EXISTS (
        SELECT 1 FROM public.guest_uploads g
        WHERE g.storage_url IS NOT NULL -- legacy
          AND split_part(g.storage_url, '/qr-media/', 2) = name
      )
    )
  );

-- Optional: allow anonymous guest uploads under guest/ prefix for public QR uploads
DO $$ BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'qr-media: anon insert to guest folder'
  ) THEN
    EXECUTE 'DROP POLICY "qr-media: anon insert to guest folder" ON storage.objects';
  END IF;
END $$;

CREATE POLICY "qr-media: anon insert to guest folder"
  ON storage.objects FOR INSERT TO anon
  WITH CHECK (
    bucket_id = 'qr-media'
    AND (left(name, 6) = 'guest/')
  );

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


