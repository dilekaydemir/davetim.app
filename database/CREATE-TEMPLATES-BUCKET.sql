-- =====================================================
-- SUPABASE STORAGE: TEMPLATES BUCKET
-- =====================================================
-- Template görselleri için public bucket oluşturur

-- 1. Bucket oluştur (public)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'templates',
  'templates',
  true,
  10485760, -- 10MB max
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- 2. Public erişim policy
CREATE POLICY "Public can view template images"
ON storage.objects FOR SELECT
USING (bucket_id = 'templates');

-- 3. Sadece authenticated kullanıcılar yükleyebilir (admin için)
CREATE POLICY "Authenticated users can upload template images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'templates' 
  AND auth.role() = 'authenticated'
);

-- 4. Sadece authenticated kullanıcılar güncelleyebilir (admin için)
CREATE POLICY "Authenticated users can update template images"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'templates' 
  AND auth.role() = 'authenticated'
);

-- 5. Sadece authenticated kullanıcılar silebilir (admin için)
CREATE POLICY "Authenticated users can delete template images"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'templates' 
  AND auth.role() = 'authenticated'
);

-- Başarı mesajı
DO $$
BEGIN
  RAISE NOTICE '✅ Templates bucket created successfully!';
  RAISE NOTICE '📁 Bucket: templates (public)';
  RAISE NOTICE '📤 Max file size: 10MB';
  RAISE NOTICE '🖼️ Allowed types: JPG, PNG, WebP';
  RAISE NOTICE '🔒 Upload: Authenticated users only';
  RAISE NOTICE '👁️ View: Everyone';
END $$;

