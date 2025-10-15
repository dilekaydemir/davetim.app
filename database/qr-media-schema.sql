-- ============================================
-- QR Media System for Premium Users
-- ============================================
-- Purpose: Store videos/photos with QR codes
-- Premium Feature: 3 months (monthly) / 1 year (yearly) storage
-- ============================================

-- Media table
CREATE TABLE IF NOT EXISTS media (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  invitation_id UUID REFERENCES invitations(id) ON DELETE CASCADE,
  
  -- Media info
  type VARCHAR(10) NOT NULL CHECK (type IN ('video', 'image')),
  file_name VARCHAR(255) NOT NULL,
  file_size BIGINT NOT NULL, -- in bytes
  mime_type VARCHAR(100) NOT NULL,
  storage_url TEXT NOT NULL, -- Supabase storage URL
  storage_path TEXT, -- Internal storage path within bucket (for signed URLs)
  thumbnail_url TEXT, -- Generated thumbnail for videos
  
  -- QR code
  qr_code TEXT NOT NULL UNIQUE, -- Unique QR identifier
  qr_image_url TEXT, -- Generated QR code image URL
  
  -- Metadata
  duration INTEGER, -- Video duration in seconds
  width INTEGER,
  height INTEGER,
  title VARCHAR(255),
  description TEXT,

  -- Owner message (voice/video/image for guests)
  owner_message_url TEXT,
  owner_message_type VARCHAR(10) CHECK (owner_message_type IN ('audio','video','image')),
  owner_message_title VARCHAR(120),
  
  -- Storage management
  expires_at TIMESTAMP WITH TIME ZONE, -- When media will be deleted
  storage_plan VARCHAR(20) CHECK (storage_plan IN ('3_months', '1_year')),
  
  -- Analytics
  view_count INTEGER DEFAULT 0,
  scan_count INTEGER DEFAULT 0, -- How many times QR was scanned
  last_viewed_at TIMESTAMP WITH TIME ZONE,
  
  -- Guest upload settings
  allow_guest_upload BOOLEAN DEFAULT false,
  guest_uploads_limit INTEGER DEFAULT 50 CHECK (guest_uploads_limit BETWEEN 0 AND 500),
  guest_uploads_count INTEGER DEFAULT 0,

  -- Status
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'deleted', 'processing')),
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Backfill columns if table already existed
ALTER TABLE media ADD COLUMN IF NOT EXISTS owner_message_url TEXT;
ALTER TABLE media ADD COLUMN IF NOT EXISTS owner_message_type VARCHAR(10) CHECK (owner_message_type IN ('audio','video','image'));
ALTER TABLE media ADD COLUMN IF NOT EXISTS owner_message_title VARCHAR(120);
ALTER TABLE media ADD COLUMN IF NOT EXISTS allow_guest_upload BOOLEAN DEFAULT false;
ALTER TABLE media ADD COLUMN IF NOT EXISTS guest_uploads_limit INTEGER DEFAULT 50;
ALTER TABLE media ADD COLUMN IF NOT EXISTS guest_uploads_count INTEGER DEFAULT 0;
ALTER TABLE media ADD COLUMN IF NOT EXISTS storage_path TEXT;

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_media_user_id ON media(user_id);
CREATE INDEX IF NOT EXISTS idx_media_invitation_id ON media(invitation_id);
-- Ensure one media (QR) per invitation
-- Use a real unique constraint to support ON CONFLICT (works better than partial index)
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE table_schema = current_schema() 
      AND table_name = 'media' 
      AND constraint_name = 'media_invitation_unique'
  ) THEN
    ALTER TABLE media ADD CONSTRAINT media_invitation_unique UNIQUE (invitation_id);
  END IF;
END $$;
CREATE INDEX IF NOT EXISTS idx_media_qr_code ON media(qr_code);
CREATE INDEX IF NOT EXISTS idx_media_status ON media(status);
CREATE INDEX IF NOT EXISTS idx_media_expires_at ON media(expires_at);
CREATE INDEX IF NOT EXISTS idx_media_created_at ON media(created_at DESC);

-- RLS Policies
ALTER TABLE media ENABLE ROW LEVEL SECURITY;

-- Users can view their own media
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'media' AND policyname = 'Users can view own media'
  ) THEN
    CREATE POLICY "Users can view own media"
      ON media FOR SELECT
      USING (auth.uid() = user_id);
  END IF;
END $$;

-- Users can insert their own media
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'media' AND policyname = 'Users can insert own media'
  ) THEN
    CREATE POLICY "Users can insert own media"
      ON media FOR INSERT
      WITH CHECK (auth.uid() = user_id);
  END IF;
END $$;

-- Users can update their own media
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'media' AND policyname = 'Users can update own media'
  ) THEN
    CREATE POLICY "Users can update own media"
      ON media FOR UPDATE
      USING (auth.uid() = user_id);
  END IF;
END $$;

-- Users can delete their own media
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'media' AND policyname = 'Users can delete own media'
  ) THEN
    CREATE POLICY "Users can delete own media"
      ON media FOR DELETE
      USING (auth.uid() = user_id);
  END IF;
END $$;

-- Public can view active media by QR code
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'media' AND policyname = 'Public can view media by QR code'
  ) THEN
    CREATE POLICY "Public can view media by QR code"
      ON media FOR SELECT
      USING (status = 'active' AND expires_at > NOW());
  END IF;
END $$;

-- Function to auto-update updated_at
CREATE OR REPLACE FUNCTION update_media_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS media_updated_at ON media;
CREATE TRIGGER media_updated_at
  BEFORE UPDATE ON media
  FOR EACH ROW
  EXECUTE FUNCTION update_media_updated_at();

-- Function to increment view count
CREATE OR REPLACE FUNCTION increment_media_view_count(media_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE media
  SET 
    view_count = view_count + 1,
    last_viewed_at = NOW()
  WHERE id = media_id;
END;
$$ LANGUAGE plpgsql;

-- Function to increment scan count
CREATE OR REPLACE FUNCTION increment_media_scan_count(qr_code_value TEXT)
RETURNS VOID AS $$
BEGIN
  UPDATE media
  SET 
    scan_count = scan_count + 1,
    last_viewed_at = NOW()
  WHERE qr_code = qr_code_value;
END;
$$ LANGUAGE plpgsql;

-- Function to clean up expired media (run via cron job)
CREATE OR REPLACE FUNCTION cleanup_expired_media()
RETURNS INTEGER AS $$
DECLARE
  deleted_count INTEGER;
BEGIN
  -- Mark expired media as deleted
  UPDATE media
  SET status = 'expired'
  WHERE status = 'active'
    AND expires_at IS NOT NULL
    AND expires_at < NOW();
  
  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  
  RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate user's total media storage
CREATE OR REPLACE FUNCTION get_user_media_storage(p_user_id UUID)
RETURNS BIGINT AS $$
DECLARE
  total_storage BIGINT;
BEGIN
  SELECT COALESCE(SUM(file_size), 0)
  INTO total_storage
  FROM media
  WHERE user_id = p_user_id
    AND status IN ('active', 'processing');
  
  RETURN total_storage;
END;
$$ LANGUAGE plpgsql;

-- Function to get user's media count
CREATE OR REPLACE FUNCTION get_user_media_count(p_user_id UUID)
RETURNS INTEGER AS $$
DECLARE
  media_count INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO media_count
  FROM media
  WHERE user_id = p_user_id
    AND status IN ('active', 'processing');
  
  RETURN media_count;
END;
$$ LANGUAGE plpgsql;

-- Comment on table
COMMENT ON TABLE media IS 'Premium feature: QR-linked media (videos/photos) with expiration dates';
COMMENT ON COLUMN media.qr_code IS 'Unique QR code identifier for public access';
COMMENT ON COLUMN media.expires_at IS '3 months for monthly plans, 1 year for yearly plans';
COMMENT ON COLUMN media.scan_count IS 'Analytics: number of times QR code was scanned';
COMMENT ON COLUMN media.allow_guest_upload IS 'If true, invitees can upload media via QR link';
COMMENT ON COLUMN media.owner_message_url IS 'Host-provided message shown to guests';

-- Storage bucket setup (run this in Supabase dashboard or via API)
-- Bucket name: 'qr-media'
-- Public: false (access via signed URLs)
-- File size limit: 100MB for videos, 10MB for images
-- Allowed MIME types: video/mp4, video/quicktime, image/jpeg, image/png, image/webp
-- ============================================
-- Guest Uploads Table (linked to QR media)
-- ============================================
CREATE TABLE IF NOT EXISTS guest_uploads (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  media_id UUID NOT NULL REFERENCES media(id) ON DELETE CASCADE,
  qr_code TEXT NOT NULL,
  guest_name VARCHAR(120),
  note TEXT,
  type VARCHAR(10) NOT NULL CHECK (type IN ('video','image')),
  file_name VARCHAR(255) NOT NULL,
  file_size BIGINT NOT NULL,
  mime_type VARCHAR(100) NOT NULL,
  storage_url TEXT NOT NULL,
  storage_path TEXT,
  thumbnail_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_guest_uploads_media_id ON guest_uploads(media_id);
CREATE INDEX IF NOT EXISTS idx_guest_uploads_qr_code ON guest_uploads(qr_code);

ALTER TABLE guest_uploads ENABLE ROW LEVEL SECURITY;

-- Public can insert guest upload if QR is valid and allows guest upload
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'guest_uploads' AND policyname = 'Public can insert guest uploads by qr'
  ) THEN
    CREATE POLICY "Public can insert guest uploads by qr"
      ON guest_uploads FOR INSERT
      WITH CHECK (
        EXISTS (
          SELECT 1 FROM media m
          WHERE m.id = media_id
            AND m.qr_code = qr_code
            AND m.allow_guest_upload = true
            AND m.status = 'active'
            AND (m.expires_at IS NULL OR m.expires_at > NOW())
            AND m.guest_uploads_count < m.guest_uploads_limit
        )
      );
  END IF;
END $$;

-- Public can view guest uploads by qr for active media
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'guest_uploads' AND policyname = 'Public can view guest uploads by qr'
  ) THEN
    CREATE POLICY "Public can view guest uploads by qr"
      ON guest_uploads FOR SELECT
      USING (
        EXISTS (
          SELECT 1 FROM media m
          WHERE m.id = media_id
            AND m.qr_code = qr_code
            AND m.status = 'active'
            AND (m.expires_at IS NULL OR m.expires_at > NOW())
        )
      );
  END IF;
END $$;

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

-- Function: increment guest uploads count atomically
CREATE OR REPLACE FUNCTION inc_guest_uploads_count(p_media_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE media
  SET guest_uploads_count = guest_uploads_count + 1
  WHERE id = p_media_id
    AND guest_uploads_count < guest_uploads_limit;
END;
$$ LANGUAGE plpgsql;

-- Helper view for public aggregation (optional)
CREATE OR REPLACE VIEW public_guest_uploads AS
  SELECT g.*, m.title as media_title
  FROM guest_uploads g
  JOIN media m ON m.id = g.media_id;


