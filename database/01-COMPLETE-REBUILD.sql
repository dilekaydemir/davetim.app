-- =====================================================
-- COMPLETE REBUILD SCRIPT - DAVETIM.APP
-- =====================================================
-- This script recreates ALL database structures
-- Run AFTER 00-COMPLETE-CLEANUP.sql
-- =====================================================

-- =====================================================
-- PART 1: CREATE CUSTOM TYPES
-- =====================================================

-- Subscription types
CREATE TYPE public.subscription_tier AS ENUM ('free', 'pro', 'premium');
CREATE TYPE public.subscription_status AS ENUM ('active', 'cancelled', 'expired', 'trialing');

-- Invitation types
CREATE TYPE public.invitation_status AS ENUM ('draft', 'published', 'archived');

-- RSVP types
CREATE TYPE public.rsvp_status AS ENUM ('pending', 'attending', 'not_attending', 'maybe', 'declined');

-- Template types
CREATE TYPE public.template_tier AS ENUM ('free', 'pro', 'premium');

-- Media types
CREATE TYPE public.media_type AS ENUM ('video', 'image', 'audio');
CREATE TYPE public.media_status AS ENUM ('active', 'expired', 'deleted', 'processing');
CREATE TYPE public.storage_plan AS ENUM ('3_months', '1_year');

-- =====================================================
-- PART 2: CREATE TABLES
-- =====================================================

-- -------------------------------------------------------
-- 2.1 SUBSCRIPTIONS TABLE
-- -------------------------------------------------------
CREATE TABLE public.subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    tier subscription_tier NOT NULL DEFAULT 'free',
    status subscription_status NOT NULL DEFAULT 'active',
    start_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    end_date TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    invitations_created_this_month INTEGER NOT NULL DEFAULT 0,
    invitations_created_lifetime INTEGER NOT NULL DEFAULT 0,
    storage_used_mb NUMERIC(10, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT unique_user_subscription UNIQUE (user_id),
    CONSTRAINT positive_invitations_month CHECK (invitations_created_this_month >= 0),
    CONSTRAINT positive_invitations_lifetime CHECK (invitations_created_lifetime >= 0),
    CONSTRAINT positive_storage CHECK (storage_used_mb >= 0)
);

-- Indexes
CREATE INDEX idx_subscriptions_user_id ON public.subscriptions(user_id);
CREATE INDEX idx_subscriptions_tier ON public.subscriptions(tier);
CREATE INDEX idx_subscriptions_status ON public.subscriptions(status);

-- Comments
COMMENT ON TABLE public.subscriptions IS 'User subscription and usage tracking';
COMMENT ON COLUMN public.subscriptions.tier IS 'Subscription tier: free, pro, or premium';
COMMENT ON COLUMN public.subscriptions.status IS 'Current subscription status';

-- -------------------------------------------------------
-- 2.2 TEMPLATE CATEGORIES TABLE
-- -------------------------------------------------------
CREATE TABLE public.template_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    icon TEXT,
    display_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT valid_slug CHECK (slug ~ '^[a-z0-9-]+$')
);

-- Indexes
CREATE INDEX idx_template_categories_slug ON public.template_categories(slug);
CREATE INDEX idx_template_categories_active ON public.template_categories(is_active);
CREATE INDEX idx_template_categories_order ON public.template_categories(display_order);

-- Comments
COMMENT ON TABLE public.template_categories IS 'Template categories for organizing templates';

-- -------------------------------------------------------
-- 2.3 TEMPLATES TABLE
-- -------------------------------------------------------
CREATE TABLE public.templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES public.template_categories(id) ON DELETE RESTRICT,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    preview_image_url TEXT NOT NULL,
    thumbnail_url TEXT,
    demo_url TEXT,
    design_config JSONB NOT NULL DEFAULT '{}',
    tags TEXT[] DEFAULT '{}',
    features TEXT[] DEFAULT '{}',
    tier template_tier NOT NULL DEFAULT 'free',
    is_premium BOOLEAN NOT NULL DEFAULT false,
    usage_count INTEGER NOT NULL DEFAULT 0,
    is_popular BOOLEAN NOT NULL DEFAULT false,
    is_featured BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT valid_template_slug CHECK (slug ~ '^[a-z0-9-]+$'),
    CONSTRAINT positive_usage_count CHECK (usage_count >= 0)
);

-- Indexes
CREATE INDEX idx_templates_category_id ON public.templates(category_id);
CREATE INDEX idx_templates_slug ON public.templates(slug);
CREATE INDEX idx_templates_tier ON public.templates(tier);
CREATE INDEX idx_templates_active ON public.templates(is_active);
CREATE INDEX idx_templates_featured ON public.templates(is_featured) WHERE is_featured = true;
CREATE INDEX idx_templates_popular ON public.templates(is_popular) WHERE is_popular = true;
CREATE INDEX idx_templates_tags ON public.templates USING GIN(tags);

-- Comments
COMMENT ON TABLE public.templates IS 'Invitation templates available to users';
COMMENT ON COLUMN public.templates.tier IS 'Access tier required: free, pro, or premium';

-- -------------------------------------------------------
-- 2.4 USER TEMPLATES TABLE
-- -------------------------------------------------------
CREATE TABLE public.user_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    template_id UUID NOT NULL REFERENCES public.templates(id) ON DELETE CASCADE,
    custom_name TEXT,
    custom_design_config JSONB DEFAULT '{}',
    is_favorite BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT unique_user_template UNIQUE (user_id, template_id)
);

-- Indexes
CREATE INDEX idx_user_templates_user_id ON public.user_templates(user_id);
CREATE INDEX idx_user_templates_template_id ON public.user_templates(template_id);
CREATE INDEX idx_user_templates_favorite ON public.user_templates(user_id, is_favorite) WHERE is_favorite = true;

-- Comments
COMMENT ON TABLE public.user_templates IS 'User saved/favorited templates';

-- -------------------------------------------------------
-- 2.5 INVITATIONS TABLE
-- -------------------------------------------------------
CREATE TABLE public.invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    template_id UUID NOT NULL REFERENCES public.templates(id) ON DELETE RESTRICT,
    title TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    event_type TEXT,
    event_date DATE,
    event_time TIME,
    event_location_name TEXT,
    event_location_address TEXT,
    event_location_coordinates JSONB,
    custom_design JSONB DEFAULT '{}',
    content JSONB DEFAULT '{}',
    settings JSONB DEFAULT '{}',
    status invitation_status NOT NULL DEFAULT 'draft',
    is_public BOOLEAN NOT NULL DEFAULT false,
    password_protected BOOLEAN NOT NULL DEFAULT false,
    password_hash TEXT,
    view_count INTEGER NOT NULL DEFAULT 0,
    rsvp_count INTEGER NOT NULL DEFAULT 0,
    image_url TEXT,
    published_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT valid_invitation_slug CHECK (slug ~ '^[a-z0-9-]+$'),
    CONSTRAINT positive_view_count CHECK (view_count >= 0),
    CONSTRAINT positive_rsvp_count CHECK (rsvp_count >= 0)
);

-- Indexes
CREATE INDEX idx_invitations_user_id ON public.invitations(user_id);
CREATE INDEX idx_invitations_template_id ON public.invitations(template_id);
CREATE INDEX idx_invitations_slug ON public.invitations(slug);
CREATE INDEX idx_invitations_status ON public.invitations(status);
CREATE INDEX idx_invitations_public ON public.invitations(is_public) WHERE is_public = true;
CREATE INDEX idx_invitations_published ON public.invitations(published_at) WHERE published_at IS NOT NULL;

-- Comments
COMMENT ON TABLE public.invitations IS 'User created invitations';
COMMENT ON COLUMN public.invitations.slug IS 'URL-friendly unique identifier';

-- -------------------------------------------------------
-- 2.6 GUESTS TABLE
-- -------------------------------------------------------
CREATE TABLE public.guests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invitation_id UUID NOT NULL REFERENCES public.invitations(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    rsvp_status rsvp_status NOT NULL DEFAULT 'pending',
    companion_count INTEGER NOT NULL DEFAULT 0,
    dietary_restrictions TEXT,
    notes TEXT,
    rsvp_responded_at TIMESTAMPTZ,
    guest_token TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT positive_companion_count CHECK (companion_count >= 0),
    CONSTRAINT email_or_phone_required CHECK (email IS NOT NULL OR phone IS NOT NULL)
);

-- Indexes
CREATE INDEX idx_guests_invitation_id ON public.guests(invitation_id);
CREATE INDEX idx_guests_token ON public.guests(guest_token);
CREATE INDEX idx_guests_rsvp_status ON public.guests(rsvp_status);
CREATE INDEX idx_guests_email ON public.guests(email) WHERE email IS NOT NULL;

-- Comments
COMMENT ON TABLE public.guests IS 'Invitation guests and their RSVP status';
COMMENT ON COLUMN public.guests.guest_token IS 'Unique token for guest RSVP access';

-- Alternative table name for compatibility
CREATE TABLE public.invitation_guests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invitation_id UUID NOT NULL REFERENCES public.invitations(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    rsvp_status rsvp_status NOT NULL DEFAULT 'pending',
    rsvp_date TIMESTAMPTZ,
    plus_one_count INTEGER NOT NULL DEFAULT 0,
    dietary_requirements TEXT,
    special_requests TEXT,
    message TEXT,
    invite_sent_at TIMESTAMPTZ,
    viewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT positive_plus_one_count CHECK (plus_one_count >= 0)
);

-- Indexes
CREATE INDEX idx_invitation_guests_invitation_id ON public.invitation_guests(invitation_id);
CREATE INDEX idx_invitation_guests_rsvp_status ON public.invitation_guests(rsvp_status);
CREATE INDEX idx_invitation_guests_email ON public.invitation_guests(email) WHERE email IS NOT NULL;

-- Comments
COMMENT ON TABLE public.invitation_guests IS 'Alternative guests table for compatibility';

-- -------------------------------------------------------
-- 2.7 MEDIA TABLE (QR Media System)
-- -------------------------------------------------------
CREATE TABLE public.media (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    invitation_id UUID UNIQUE REFERENCES public.invitations(id) ON DELETE SET NULL,
    type media_type NOT NULL,
    file_name TEXT NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type TEXT NOT NULL,
    storage_url TEXT NOT NULL,
    storage_path TEXT,
    thumbnail_url TEXT,
    qr_code TEXT NOT NULL UNIQUE,
    qr_image_url TEXT,
    duration INTEGER,
    width INTEGER,
    height INTEGER,
    title TEXT,
    description TEXT,
    owner_message_url TEXT,
    owner_message_type media_type,
    owner_message_title TEXT,
    expires_at TIMESTAMPTZ,
    storage_plan storage_plan,
    view_count INTEGER NOT NULL DEFAULT 0,
    scan_count INTEGER NOT NULL DEFAULT 0,
    last_viewed_at TIMESTAMPTZ,
    allow_guest_upload BOOLEAN NOT NULL DEFAULT true,
    guest_uploads_limit INTEGER DEFAULT 50,
    guest_uploads_count INTEGER NOT NULL DEFAULT 0,
    status media_status NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT positive_file_size CHECK (file_size > 0),
    CONSTRAINT positive_view_count CHECK (view_count >= 0),
    CONSTRAINT positive_scan_count CHECK (scan_count >= 0),
    CONSTRAINT positive_guest_uploads CHECK (guest_uploads_count >= 0)
);

-- Indexes
CREATE INDEX idx_media_user_id ON public.media(user_id);
CREATE INDEX idx_media_invitation_id ON public.media(invitation_id);
CREATE INDEX idx_media_qr_code ON public.media(qr_code);
CREATE INDEX idx_media_status ON public.media(status);
CREATE INDEX idx_media_type ON public.media(type);

-- Comments
COMMENT ON TABLE public.media IS 'QR media system for premium users';
COMMENT ON COLUMN public.media.qr_code IS 'Unique QR code for public access';

-- -------------------------------------------------------
-- 2.8 GUEST UPLOADS TABLE
-- -------------------------------------------------------
CREATE TABLE public.guest_uploads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    media_id UUID NOT NULL REFERENCES public.media(id) ON DELETE CASCADE,
    qr_code TEXT NOT NULL,
    guest_name TEXT,
    note TEXT,
    type media_type NOT NULL,
    file_name TEXT NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type TEXT NOT NULL,
    storage_url TEXT NOT NULL,
    storage_path TEXT,
    thumbnail_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT positive_guest_file_size CHECK (file_size > 0)
);

-- Indexes
CREATE INDEX idx_guest_uploads_media_id ON public.guest_uploads(media_id);
CREATE INDEX idx_guest_uploads_qr_code ON public.guest_uploads(qr_code);
CREATE INDEX idx_guest_uploads_created ON public.guest_uploads(created_at DESC);

-- Comments
COMMENT ON TABLE public.guest_uploads IS 'Guest uploaded media to QR codes';

-- -------------------------------------------------------
-- 2.9 PAYMENT HISTORY TABLE
-- -------------------------------------------------------
CREATE TABLE public.payment_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    transaction_id TEXT NOT NULL UNIQUE,
    provider_transaction_id TEXT,
    provider TEXT NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    currency TEXT NOT NULL DEFAULT 'TRY',
    status TEXT NOT NULL,
    plan_tier subscription_tier NOT NULL,
    billing_period TEXT NOT NULL CHECK (billing_period IN ('monthly', 'yearly')),
    description TEXT,
    error_message TEXT,
    processed_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT positive_amount CHECK (amount > 0)
);

-- Indexes
CREATE INDEX idx_payment_history_user_id ON public.payment_history(user_id);
CREATE INDEX idx_payment_history_transaction_id ON public.payment_history(transaction_id);
CREATE INDEX idx_payment_history_status ON public.payment_history(status);
CREATE INDEX idx_payment_history_created ON public.payment_history(created_at DESC);

-- Comments
COMMENT ON TABLE public.payment_history IS 'Payment transaction history';

-- =====================================================
-- PART 3: CREATE FUNCTIONS
-- =====================================================

-- -------------------------------------------------------
-- 3.1 Updated At Trigger Function
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.update_updated_at_column IS 'Automatically updates updated_at timestamp';

-- -------------------------------------------------------
-- 3.2 Handle New User (Create Subscription)
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    -- Create free subscription for new user
    INSERT INTO public.subscriptions (user_id, tier, status, start_date)
    VALUES (NEW.id, 'free', 'active', NOW())
    ON CONFLICT (user_id) DO NOTHING;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.handle_new_user IS 'Creates free subscription when user signs up';

-- -------------------------------------------------------
-- 3.3 Generate Invitation Slug
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.generate_invitation_slug(
    invitation_title TEXT,
    user_uuid UUID
)
RETURNS TEXT AS $$
DECLARE
    base_slug TEXT;
    final_slug TEXT;
    counter INTEGER := 0;
BEGIN
    -- Create base slug from title
    base_slug := lower(regexp_replace(invitation_title, '[^a-zA-Z0-9]+', '-', 'g'));
    base_slug := trim(both '-' from base_slug);
    base_slug := substring(base_slug from 1 for 50);
    
    -- Add user prefix for uniqueness
    base_slug := substring(user_uuid::text from 1 for 8) || '-' || base_slug;
    
    final_slug := base_slug;
    
    -- Ensure uniqueness
    WHILE EXISTS (SELECT 1 FROM public.invitations WHERE slug = final_slug) LOOP
        counter := counter + 1;
        final_slug := base_slug || '-' || counter;
    END LOOP;
    
    RETURN final_slug;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.generate_invitation_slug IS 'Generates unique slug for invitations';

-- -------------------------------------------------------
-- 3.4 Increment Invitation Views
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.increment_invitation_views(invitation_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.invitations
    SET view_count = view_count + 1
    WHERE id = invitation_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.increment_invitation_views IS 'Increments view count for invitation';

-- -------------------------------------------------------
-- 3.5 Increment Invitation Count (Monthly/Lifetime)
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.increment_invitation_count(p_user_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.subscriptions
    SET 
        invitations_created_this_month = invitations_created_this_month + 1,
        invitations_created_lifetime = invitations_created_lifetime + 1
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.increment_invitation_count IS 'Increments invitation counters for user';

-- -------------------------------------------------------
-- 3.6 Get Invitation Guest Stats
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_invitation_guest_stats(invitation_uuid UUID)
RETURNS TABLE (
    total INTEGER,
    pending INTEGER,
    attending INTEGER,
    declined INTEGER,
    total_companions INTEGER,
    total_attending INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER AS total,
        COUNT(*) FILTER (WHERE rsvp_status = 'pending')::INTEGER AS pending,
        COUNT(*) FILTER (WHERE rsvp_status = 'attending')::INTEGER AS attending,
        COUNT(*) FILTER (WHERE rsvp_status = 'declined')::INTEGER AS declined,
        COALESCE(SUM(companion_count), 0)::INTEGER AS total_companions,
        (COUNT(*) FILTER (WHERE rsvp_status = 'attending') + 
         COALESCE(SUM(companion_count) FILTER (WHERE rsvp_status = 'attending'), 0))::INTEGER AS total_attending
    FROM public.guests
    WHERE invitation_id = invitation_uuid;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.get_invitation_guest_stats IS 'Returns guest statistics for invitation';

-- -------------------------------------------------------
-- 3.7 Increment Template Usage
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.increment_template_usage(template_uuid UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.templates
    SET usage_count = usage_count + 1
    WHERE id = template_uuid;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.increment_template_usage IS 'Increments template usage counter';

-- -------------------------------------------------------
-- 3.8 Increment Media Scan Count
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.increment_media_scan_count(qr_code_value TEXT)
RETURNS VOID AS $$
BEGIN
    UPDATE public.media
    SET 
        scan_count = scan_count + 1,
        last_viewed_at = NOW()
    WHERE qr_code = qr_code_value;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.increment_media_scan_count IS 'Increments QR scan count for media';

-- -------------------------------------------------------
-- 3.9 Increment Media View Count
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.increment_media_view_count(media_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.media
    SET 
        view_count = view_count + 1,
        last_viewed_at = NOW()
    WHERE id = media_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.increment_media_view_count IS 'Increments view count for media';

-- -------------------------------------------------------
-- 3.10 Increment Guest Uploads Count
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.inc_guest_uploads_count(p_media_id UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE public.media
    SET guest_uploads_count = guest_uploads_count + 1
    WHERE id = p_media_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.inc_guest_uploads_count IS 'Increments guest upload counter for media';

-- -------------------------------------------------------
-- 3.11 Create User Subscription (Manual Helper)
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.create_user_subscription(p_user_id UUID)
RETURNS VOID AS $$
BEGIN
    -- Create free subscription for user
    INSERT INTO public.subscriptions (user_id, tier, status, start_date)
    VALUES (p_user_id, 'free', 'active', NOW())
    ON CONFLICT (user_id) DO NOTHING;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.create_user_subscription IS 'Manually creates free subscription for user';

-- -------------------------------------------------------
-- 3.12 Reset Monthly Counters (Maintenance)
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.reset_monthly_counters()
RETURNS VOID AS $$
BEGIN
    -- Reset monthly invitation counters for all users
    UPDATE public.subscriptions
    SET invitations_created_this_month = 0
    WHERE invitations_created_this_month > 0;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.reset_monthly_counters IS 'Resets monthly invitation counters (run monthly)';

-- -------------------------------------------------------
-- 3.13 Get User Stats (Analytics)
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_user_stats(p_user_id UUID)
RETURNS TABLE (
    total_invitations BIGINT,
    published_invitations BIGINT,
    total_guests BIGINT,
    total_rsvp_responses BIGINT,
    storage_used_mb NUMERIC,
    subscription_tier TEXT,
    subscription_status TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(i.id) as total_invitations,
        COUNT(i.id) FILTER (WHERE i.status = 'published') as published_invitations,
        COUNT(g.id) as total_guests,
        COUNT(g.id) FILTER (WHERE g.rsvp_status != 'pending') as total_rsvp_responses,
        COALESCE(s.storage_used_mb, 0) as storage_used_mb,
        COALESCE(s.tier::TEXT, 'free') as subscription_tier,
        COALESCE(s.status::TEXT, 'active') as subscription_status
    FROM auth.users u
    LEFT JOIN public.subscriptions s ON s.user_id = u.id
    LEFT JOIN public.invitations i ON i.user_id = u.id
    LEFT JOIN public.guests g ON g.invitation_id = i.id
    WHERE u.id = p_user_id
    GROUP BY s.storage_used_mb, s.tier, s.status;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.get_user_stats IS 'Returns comprehensive user statistics';

-- -------------------------------------------------------
-- 3.14 Clean Expired Media (Maintenance)
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.clean_expired_media()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER := 0;
BEGIN
    -- Mark expired media as expired
    UPDATE public.media
    SET status = 'expired'
    WHERE expires_at < NOW()
    AND status = 'active';
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.clean_expired_media IS 'Marks expired media as expired and returns count';

-- -------------------------------------------------------
-- 3.15 Update Storage Usage (Maintenance)
-- -------------------------------------------------------
CREATE OR REPLACE FUNCTION public.update_storage_usage(p_user_id UUID)
RETURNS VOID AS $$
DECLARE
    total_size_mb NUMERIC := 0;
BEGIN
    -- Calculate total storage used by user's media
    SELECT COALESCE(SUM(file_size) / (1024 * 1024), 0)
    INTO total_size_mb
    FROM public.media
    WHERE user_id = p_user_id
    AND status IN ('active', 'processing');
    
    -- Update subscription with new storage usage
    UPDATE public.subscriptions
    SET storage_used_mb = total_size_mb
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.update_storage_usage IS 'Updates user storage usage based on media files';

-- =====================================================
-- PART 4: CREATE TRIGGERS
-- =====================================================

-- Updated at triggers for all tables
CREATE TRIGGER update_subscriptions_updated_at
    BEFORE UPDATE ON public.subscriptions
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_invitations_updated_at
    BEFORE UPDATE ON public.invitations
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_guests_updated_at
    BEFORE UPDATE ON public.guests
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_invitation_guests_updated_at
    BEFORE UPDATE ON public.invitation_guests
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_templates_updated_at
    BEFORE UPDATE ON public.templates
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_template_categories_updated_at
    BEFORE UPDATE ON public.template_categories
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_user_templates_updated_at
    BEFORE UPDATE ON public.user_templates
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_media_updated_at
    BEFORE UPDATE ON public.media
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- Auth trigger for new user subscription
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- PART 5: ENABLE ROW LEVEL SECURITY
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitation_guests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.template_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.media ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guest_uploads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_history ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- PART 6: CREATE RLS POLICIES
-- =====================================================

-- -------------------------------------------------------
-- 6.1 Subscriptions Policies
-- -------------------------------------------------------
CREATE POLICY "Users can view own subscription"
    ON public.subscriptions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update own subscription"
    ON public.subscriptions FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own subscription"
    ON public.subscriptions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- -------------------------------------------------------
-- 6.2 Invitations Policies
-- -------------------------------------------------------
CREATE POLICY "Users can view own invitations"
    ON public.invitations FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create own invitations"
    ON public.invitations FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own invitations"
    ON public.invitations FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own invitations"
    ON public.invitations FOR DELETE
    USING (auth.uid() = user_id);

CREATE POLICY "Anyone can read published invitations"
    ON public.invitations FOR SELECT
    USING (status = 'published' AND is_public = true);

-- -------------------------------------------------------
-- 6.3 Guests Policies
-- -------------------------------------------------------
CREATE POLICY "Users can view guests of own invitations"
    ON public.guests FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.invitations
            WHERE invitations.id = guests.invitation_id
            AND invitations.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create guests for own invitations"
    ON public.guests FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.invitations
            WHERE invitations.id = invitation_id
            AND invitations.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update guests of own invitations"
    ON public.guests FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.invitations
            WHERE invitations.id = guests.invitation_id
            AND invitations.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can delete guests of own invitations"
    ON public.guests FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM public.invitations
            WHERE invitations.id = guests.invitation_id
            AND invitations.user_id = auth.uid()
        )
    );

CREATE POLICY "Guests can update own RSVP by token"
    ON public.guests FOR UPDATE
    USING (true)
    WITH CHECK (true);

-- -------------------------------------------------------
-- 6.4 Invitation Guests Policies (alternative table)
-- -------------------------------------------------------
CREATE POLICY "Users can view guests of own invitations"
    ON public.invitation_guests FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.invitations
            WHERE invitations.id = invitation_guests.invitation_id
            AND invitations.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create guests for own invitations"
    ON public.invitation_guests FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.invitations
            WHERE invitations.id = invitation_id
            AND invitations.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update guests of own invitations"
    ON public.invitation_guests FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.invitations
            WHERE invitations.id = invitation_guests.invitation_id
            AND invitations.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can delete guests of own invitations"
    ON public.invitation_guests FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM public.invitations
            WHERE invitations.id = invitation_guests.invitation_id
            AND invitations.user_id = auth.uid()
        )
    );

CREATE POLICY "Anyone can update invitation guests"
    ON public.invitation_guests FOR UPDATE
    USING (true)
    WITH CHECK (true);

-- -------------------------------------------------------
-- 6.5 Templates Policies (Public Read)
-- -------------------------------------------------------
CREATE POLICY "Templates are publicly readable"
    ON public.templates FOR SELECT
    USING (is_active = true);

-- -------------------------------------------------------
-- 6.6 Template Categories Policies (Public Read)
-- -------------------------------------------------------
CREATE POLICY "Template categories are publicly readable"
    ON public.template_categories FOR SELECT
    USING (is_active = true);

-- -------------------------------------------------------
-- 6.7 User Templates Policies
-- -------------------------------------------------------
CREATE POLICY "Users can view own saved templates"
    ON public.user_templates FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create own saved templates"
    ON public.user_templates FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own saved templates"
    ON public.user_templates FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own saved templates"
    ON public.user_templates FOR DELETE
    USING (auth.uid() = user_id);

-- -------------------------------------------------------
-- 6.8 Media Policies
-- -------------------------------------------------------
CREATE POLICY "Users can view own media"
    ON public.media FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create own media"
    ON public.media FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own media"
    ON public.media FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own media"
    ON public.media FOR DELETE
    USING (auth.uid() = user_id);

CREATE POLICY "Public media access by QR"
    ON public.media FOR SELECT
    USING (status = 'active');

-- -------------------------------------------------------
-- 6.9 Guest Uploads Policies
-- -------------------------------------------------------
CREATE POLICY "Users can view uploads for own media"
    ON public.guest_uploads FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.media
            WHERE media.id = guest_uploads.media_id
            AND media.user_id = auth.uid()
        )
    );

CREATE POLICY "Public can upload to media"
    ON public.guest_uploads FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.media
            WHERE media.id = media_id
            AND media.allow_guest_upload = true
            AND media.status = 'active'
        )
    );

CREATE POLICY "Anyone can view guest uploads by QR"
    ON public.guest_uploads FOR SELECT
    USING (true);

CREATE POLICY "Users can delete uploads for own media"
    ON public.guest_uploads FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM public.media
            WHERE media.id = guest_uploads.media_id
            AND media.user_id = auth.uid()
        )
    );

-- -------------------------------------------------------
-- 6.10 Payment History Policies
-- -------------------------------------------------------
CREATE POLICY "Users can view own payment history"
    ON public.payment_history FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own payment history"
    ON public.payment_history FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- =====================================================
-- PART 7: CREATE STORAGE BUCKETS
-- =====================================================

-- Create qr-media bucket
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'qr-media',
    'qr-media',
    true,
    104857600, -- 100MB
    ARRAY['video/mp4', 'video/quicktime', 'video/webm', 'image/jpeg', 'image/png', 'image/webp', 'image/gif', 'audio/mpeg', 'audio/wav']
)
ON CONFLICT (id) DO NOTHING;

-- Create invitation-images bucket
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'invitation-images',
    'invitation-images',
    true,
    10485760, -- 10MB
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- PART 8: STORAGE POLICIES
-- =====================================================

-- QR Media Storage Policies
CREATE POLICY "Anyone can view qr-media"
    ON storage.objects FOR SELECT
    USING (bucket_id = 'qr-media');

CREATE POLICY "Authenticated users can upload to qr-media"
    ON storage.objects FOR INSERT
    WITH CHECK (
        bucket_id = 'qr-media' 
        AND auth.role() = 'authenticated'
    );

CREATE POLICY "Users can update own files in qr-media"
    ON storage.objects FOR UPDATE
    USING (
        bucket_id = 'qr-media' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can delete own files in qr-media"
    ON storage.objects FOR DELETE
    USING (
        bucket_id = 'qr-media' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- Invitation Images Storage Policies
CREATE POLICY "Anyone can view invitation-images"
    ON storage.objects FOR SELECT
    USING (bucket_id = 'invitation-images');

CREATE POLICY "Authenticated users can upload to invitation-images"
    ON storage.objects FOR INSERT
    WITH CHECK (
        bucket_id = 'invitation-images' 
        AND auth.role() = 'authenticated'
    );

CREATE POLICY "Users can update own files in invitation-images"
    ON storage.objects FOR UPDATE
    USING (
        bucket_id = 'invitation-images' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can delete own files in invitation-images"
    ON storage.objects FOR DELETE
    USING (
        bucket_id = 'invitation-images' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- =====================================================
-- PART 9: SEED INITIAL DATA
-- =====================================================

-- ⚠️ NOTE: For complete realistic template catalog, run: database/05-seed-templates.sql
-- This section only creates minimal sample data for basic testing.

-- Seed Template Categories (Minimal)
INSERT INTO public.template_categories (name, slug, description, display_order) VALUES
    ('Düğün', 'dugun', 'Düğün davetiyeleri için özel tasarımlar', 1),
    ('Doğum Günü', 'dogum-gunu', 'Doğum günü kutlamaları için eğlenceli tasarımlar', 2),
    ('Nişan', 'nisan', 'Nişan törenleri için zarif tasarımlar', 3),
    ('Bebek', 'bebek', 'Bebek doğumu ve baby shower için sevimli tasarımlar', 4),
    ('Mezuniyet', 'mezuniyet', 'Mezuniyet kutlamaları için özel tasarımlar', 5),
    ('İş Etkinliği', 'is-etkinligi', 'Kurumsal etkinlikler için profesyonel tasarımlar', 6)
ON CONFLICT (slug) DO NOTHING;

-- Seed Sample Templates (Minimal)
DO $$
DECLARE
    category_dugun UUID;
    category_dogum UUID;
BEGIN
    -- Get category IDs
    SELECT id INTO category_dugun FROM public.template_categories WHERE slug = 'dugun';
    SELECT id INTO category_dogum FROM public.template_categories WHERE slug = 'dogum-gunu';
    
    -- Insert minimal sample templates
    INSERT INTO public.templates (
        category_id, name, slug, description, preview_image_url, 
        tier, is_featured, is_popular
    ) VALUES
        (category_dugun, 'Klasik Zarif', 'klasik-zarif', 'Zarif ve klasik düğün davetiyesi', 
         'https://images.unsplash.com/photo-1519741497674-611481863552?w=800', 'free', true, true),
        (category_dugun, 'Modern Minimalist', 'modern-minimalist', 'Modern ve minimalist düğün tasarımı', 
         'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800', 'pro', true, false),
        (category_dogum, 'Renkli Balon', 'renkli-balon', 'Rengarenk balonlarla doğum günü', 
         'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800', 'free', false, true)
    ON CONFLICT (slug) DO NOTHING;
    
    RAISE NOTICE '📝 Minimal sample data created. For full realistic template catalog with Canva-style designs, run: database/05-seed-templates.sql';
END $$;

-- =====================================================
-- REBUILD COMPLETE
-- =====================================================

-- Refresh schema cache
NOTIFY pgrst, 'reload schema';

SELECT 'Database rebuild completed successfully! 🎉' AS status;
SELECT 'Tables created: ' || COUNT(*)::text AS table_count FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
SELECT 'Functions created: ' || COUNT(*)::text AS function_count FROM pg_proc 
WHERE pronamespace = 'public'::regnamespace;

