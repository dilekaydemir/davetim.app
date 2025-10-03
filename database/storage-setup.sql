-- ============================================
-- Supabase Storage Setup for Invitation Images
-- ============================================
-- This script creates the storage bucket and policies for invitation images

-- 1. Create storage bucket (run this in Supabase Dashboard > Storage)
-- Bucket name: invitation-images
-- Public: false (users must be authenticated to upload)
-- File size limit: 5MB
-- Allowed MIME types: image/jpeg, image/png, image/webp, image/gif

-- You can create the bucket via SQL or Dashboard
-- If using Dashboard: Storage > Create Bucket > Name: "invitation-images"

-- 2. Storage Policies
-- Allow authenticated users to upload their own images
INSERT INTO storage.buckets (id, name, public)
VALUES ('invitation-images', 'invitation-images', true)
ON CONFLICT (id) DO NOTHING;

-- Policy: Users can upload images
CREATE POLICY "Users can upload invitation images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'invitation-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Policy: Users can view their own images
CREATE POLICY "Users can view their own images"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'invitation-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Policy: Public can view images (for public invitation pages)
CREATE POLICY "Public can view images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'invitation-images');

-- Policy: Users can update their own images
CREATE POLICY "Users can update their own images"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'invitation-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
)
WITH CHECK (
  bucket_id = 'invitation-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Policy: Users can delete their own images
CREATE POLICY "Users can delete their own images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'invitation-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- ============================================
-- Add image_url column to invitations table
-- ============================================
ALTER TABLE invitations
ADD COLUMN IF NOT EXISTS image_url TEXT;

COMMENT ON COLUMN invitations.image_url IS 'URL to uploaded image in Supabase Storage';

