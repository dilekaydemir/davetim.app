-- Invitations System Migration for Supabase
-- Run this in Supabase SQL Editor after templates-migration.sql

-- =====================================================
-- 1. Create invitations table
-- =====================================================
CREATE TABLE IF NOT EXISTS public.invitations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  template_id UUID NOT NULL REFERENCES public.templates(id) ON DELETE RESTRICT,
  
  -- Basic Info
  title VARCHAR(200) NOT NULL,
  slug VARCHAR(200) UNIQUE NOT NULL, -- URL-friendly unique identifier
  
  -- Event Details
  event_type VARCHAR(50), -- e.g., 'wedding', 'birthday', 'baby-shower'
  event_date TIMESTAMP WITH TIME ZONE,
  event_time VARCHAR(50), -- e.g., '14:00' or '2:00 PM'
  event_location_name VARCHAR(200),
  event_location_address TEXT,
  event_location_coordinates JSONB, -- {lat, lng}
  
  -- Customization (merged with template design_config)
  custom_design JSONB NOT NULL DEFAULT '{}', -- User's customizations
  
  -- Content Fields (customizable per template)
  content JSONB NOT NULL DEFAULT '{}', -- {brideName, groomName, message, etc.}
  
  -- Settings
  settings JSONB DEFAULT '{
    "rsvp_enabled": true,
    "rsvp_deadline": null,
    "guest_limit": null,
    "allow_plus_one": false,
    "comments_enabled": true,
    "require_full_name": true
  }'::jsonb,
  
  -- Status & Visibility
  status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  is_public BOOLEAN DEFAULT false,
  password_protected BOOLEAN DEFAULT false,
  password_hash VARCHAR(255),
  
  -- Stats
  view_count INTEGER DEFAULT 0,
  rsvp_count INTEGER DEFAULT 0,
  
  -- Publishing
  published_at TIMESTAMP WITH TIME ZONE,
  expires_at TIMESTAMP WITH TIME ZONE, -- Optional expiration date
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 2. Create invitation_guests table (RSVP & Guest List)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.invitation_guests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  invitation_id UUID NOT NULL REFERENCES public.invitations(id) ON DELETE CASCADE,
  
  -- Guest Info
  full_name VARCHAR(200) NOT NULL,
  email VARCHAR(255),
  phone VARCHAR(50),
  
  -- RSVP
  rsvp_status VARCHAR(20) DEFAULT 'pending' CHECK (rsvp_status IN ('pending', 'attending', 'not_attending', 'maybe')),
  rsvp_date TIMESTAMP WITH TIME ZONE,
  plus_one_count INTEGER DEFAULT 0,
  
  -- Additional Info
  dietary_requirements TEXT,
  special_requests TEXT,
  message TEXT, -- Guest's message to host
  
  -- Metadata
  invite_sent_at TIMESTAMP WITH TIME ZONE,
  viewed_at TIMESTAMP WITH TIME ZONE,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 3. Create invitation_views table (Analytics)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.invitation_views (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  invitation_id UUID NOT NULL REFERENCES public.invitations(id) ON DELETE CASCADE,
  
  -- Visitor Info
  ip_address INET,
  user_agent TEXT,
  referrer TEXT,
  country VARCHAR(100),
  city VARCHAR(100),
  
  -- Timestamps
  viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 4. Create indexes
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_invitations_user_id ON public.invitations(user_id);
CREATE INDEX IF NOT EXISTS idx_invitations_template_id ON public.invitations(template_id);
CREATE INDEX IF NOT EXISTS idx_invitations_slug ON public.invitations(slug);
CREATE INDEX IF NOT EXISTS idx_invitations_status ON public.invitations(status);
CREATE INDEX IF NOT EXISTS idx_invitations_published_at ON public.invitations(published_at);
CREATE INDEX IF NOT EXISTS idx_invitation_guests_invitation_id ON public.invitation_guests(invitation_id);
CREATE INDEX IF NOT EXISTS idx_invitation_guests_email ON public.invitation_guests(email);
CREATE INDEX IF NOT EXISTS idx_invitation_guests_rsvp_status ON public.invitation_guests(rsvp_status);
CREATE INDEX IF NOT EXISTS idx_invitation_views_invitation_id ON public.invitation_views(invitation_id);

-- =====================================================
-- 5. Enable Row Level Security (RLS)
-- =====================================================
ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitation_guests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitation_views ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 6. Create RLS Policies
-- =====================================================

-- Invitations: Users can only see and manage their own invitations
CREATE POLICY "Users can view their own invitations"
  ON public.invitations
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own invitations"
  ON public.invitations
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own invitations"
  ON public.invitations
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own invitations"
  ON public.invitations
  FOR DELETE
  USING (auth.uid() = user_id);

-- Public invitations: Anyone can view published public invitations by slug
CREATE POLICY "Anyone can view published public invitations"
  ON public.invitations
  FOR SELECT
  USING (status = 'published' AND is_public = true);

-- Invitation Guests: Only invitation owner can manage
CREATE POLICY "Invitation owners can view their guests"
  ON public.invitation_guests
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.invitations
      WHERE invitations.id = invitation_guests.invitation_id
      AND invitations.user_id = auth.uid()
    )
  );

CREATE POLICY "Invitation owners can add guests"
  ON public.invitation_guests
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.invitations
      WHERE invitations.id = invitation_guests.invitation_id
      AND invitations.user_id = auth.uid()
    )
  );

CREATE POLICY "Invitation owners can update guests"
  ON public.invitation_guests
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.invitations
      WHERE invitations.id = invitation_guests.invitation_id
      AND invitations.user_id = auth.uid()
    )
  );

CREATE POLICY "Invitation owners can delete guests"
  ON public.invitation_guests
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.invitations
      WHERE invitations.id = invitation_guests.invitation_id
      AND invitations.user_id = auth.uid()
    )
  );

-- Guests can update their own RSVP via email/id
CREATE POLICY "Guests can update their own RSVP"
  ON public.invitation_guests
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- Invitation Views: Anyone can insert (for analytics)
CREATE POLICY "Anyone can record invitation views"
  ON public.invitation_views
  FOR INSERT
  WITH CHECK (true);

-- Only owners can see their invitation views
CREATE POLICY "Invitation owners can view analytics"
  ON public.invitation_views
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.invitations
      WHERE invitations.id = invitation_views.invitation_id
      AND invitations.user_id = auth.uid()
    )
  );

-- =====================================================
-- 7. Create triggers for updated_at
-- =====================================================
CREATE TRIGGER update_invitations_updated_at
    BEFORE UPDATE ON public.invitations
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_invitation_guests_updated_at
    BEFORE UPDATE ON public.invitation_guests
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 8. Create functions for slug generation
-- =====================================================
CREATE OR REPLACE FUNCTION generate_invitation_slug(invitation_title TEXT, user_uuid UUID)
RETURNS TEXT AS $$
DECLARE
  base_slug TEXT;
  final_slug TEXT;
  counter INTEGER := 0;
BEGIN
  -- Convert title to slug format
  base_slug := lower(regexp_replace(invitation_title, '[^a-zA-Z0-9\s-]', '', 'g'));
  base_slug := regexp_replace(base_slug, '\s+', '-', 'g');
  base_slug := regexp_replace(base_slug, '-+', '-', 'g');
  base_slug := trim(both '-' from base_slug);
  
  -- Limit length
  base_slug := substring(base_slug from 1 for 50);
  
  -- Add random string for uniqueness
  final_slug := base_slug || '-' || substring(md5(random()::text || user_uuid::text) from 1 for 8);
  
  RETURN final_slug;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 9. Create function to increment view count
-- =====================================================
CREATE OR REPLACE FUNCTION increment_invitation_views(invitation_uuid UUID, visitor_ip INET DEFAULT NULL, visitor_ua TEXT DEFAULT NULL)
RETURNS void AS $$
BEGIN
  -- Insert view record
  INSERT INTO public.invitation_views (invitation_id, ip_address, user_agent)
  VALUES (invitation_uuid, visitor_ip, visitor_ua);
  
  -- Increment view count
  UPDATE public.invitations
  SET view_count = view_count + 1
  WHERE id = invitation_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 10. Create function to update RSVP count
-- =====================================================
CREATE OR REPLACE FUNCTION update_invitation_rsvp_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.invitations
  SET rsvp_count = (
    SELECT COUNT(*)
    FROM public.invitation_guests
    WHERE invitation_id = NEW.invitation_id
    AND rsvp_status = 'attending'
  )
  WHERE id = NEW.invitation_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_rsvp_count_trigger
  AFTER INSERT OR UPDATE OF rsvp_status ON public.invitation_guests
  FOR EACH ROW
  EXECUTE FUNCTION update_invitation_rsvp_count();

-- =====================================================
-- Done! 🎉
-- =====================================================
-- Next: Test by creating an invitation from the editor!
