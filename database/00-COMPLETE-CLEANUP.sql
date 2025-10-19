-- =====================================================
-- COMPLETE CLEANUP SCRIPT
-- =====================================================
-- This script removes ALL custom database structures from Supabase
-- Run this ONLY when you want to completely reset the database
-- WARNING: This will delete ALL data!
-- =====================================================

-- Disable RLS temporarily for cleanup
ALTER TABLE IF EXISTS public.subscriptions DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.invitations DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.guests DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.invitation_guests DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.templates DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.template_categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.user_templates DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.media DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.guest_uploads DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.payment_history DISABLE ROW LEVEL SECURITY;

-- =====================================================
-- 1. DROP ALL TRIGGERS
-- =====================================================
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP TRIGGER IF EXISTS create_subscription_on_signup ON auth.users;
DROP TRIGGER IF EXISTS update_subscriptions_updated_at ON public.subscriptions;
DROP TRIGGER IF EXISTS update_invitations_updated_at ON public.invitations;
DROP TRIGGER IF EXISTS update_guests_updated_at ON public.guests;
DROP TRIGGER IF EXISTS update_invitation_guests_updated_at ON public.invitation_guests;
DROP TRIGGER IF EXISTS update_templates_updated_at ON public.templates;
DROP TRIGGER IF EXISTS update_template_categories_updated_at ON public.template_categories;
DROP TRIGGER IF EXISTS update_user_templates_updated_at ON public.user_templates;
DROP TRIGGER IF EXISTS update_media_updated_at ON public.media;
DROP TRIGGER IF EXISTS update_payment_history_updated_at ON public.payment_history;

-- =====================================================
-- 2. DROP ALL FUNCTIONS
-- =====================================================

-- Drop all custom functions in public schema
DO $$
DECLARE
    func_record RECORD;
BEGIN
    -- Drop all functions in public schema
    FOR func_record IN 
        SELECT routine_name, routine_type
        FROM information_schema.routines 
        WHERE routine_schema = 'public'
        AND routine_name NOT LIKE 'pg_%'
        AND routine_name NOT LIKE 'sql_%'
    LOOP
        EXECUTE 'DROP ' || func_record.routine_type || ' IF EXISTS public.' || func_record.routine_name || ' CASCADE';
    END LOOP;
END $$;

-- Drop specific known functions (backup method)
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;
DROP FUNCTION IF EXISTS public.create_user_subscription(uuid) CASCADE;
DROP FUNCTION IF EXISTS public.generate_invitation_slug(text, uuid) CASCADE;
DROP FUNCTION IF EXISTS public.increment_invitation_views(uuid) CASCADE;
DROP FUNCTION IF EXISTS public.increment_invitation_count(uuid) CASCADE;
DROP FUNCTION IF EXISTS public.get_invitation_guest_stats(uuid) CASCADE;
DROP FUNCTION IF EXISTS public.increment_template_usage(uuid) CASCADE;
DROP FUNCTION IF EXISTS public.increment_media_scan_count(text) CASCADE;
DROP FUNCTION IF EXISTS public.increment_media_view_count(uuid) CASCADE;
DROP FUNCTION IF EXISTS public.inc_guest_uploads_count(uuid) CASCADE;
DROP FUNCTION IF EXISTS public.update_updated_at_column() CASCADE;
DROP FUNCTION IF EXISTS public.reset_monthly_counters() CASCADE;
DROP FUNCTION IF EXISTS public.get_user_stats(uuid) CASCADE;
DROP FUNCTION IF EXISTS public.clean_expired_media() CASCADE;
DROP FUNCTION IF EXISTS public.update_storage_usage(uuid) CASCADE;

-- Drop any remaining functions that might have different signatures
DROP FUNCTION IF EXISTS public.generate_invitation_slug CASCADE;
DROP FUNCTION IF EXISTS public.increment_invitation_views CASCADE;
DROP FUNCTION IF EXISTS public.increment_invitation_count CASCADE;
DROP FUNCTION IF EXISTS public.get_invitation_guest_stats CASCADE;
DROP FUNCTION IF EXISTS public.increment_template_usage CASCADE;
DROP FUNCTION IF EXISTS public.increment_media_scan_count CASCADE;
DROP FUNCTION IF EXISTS public.increment_media_view_count CASCADE;
DROP FUNCTION IF EXISTS public.inc_guest_uploads_count CASCADE;
DROP FUNCTION IF EXISTS public.update_updated_at_column CASCADE;
DROP FUNCTION IF EXISTS public.handle_new_user CASCADE;
DROP FUNCTION IF EXISTS public.create_user_subscription CASCADE;
DROP FUNCTION IF EXISTS public.reset_monthly_counters CASCADE;
DROP FUNCTION IF EXISTS public.get_user_stats CASCADE;
DROP FUNCTION IF EXISTS public.clean_expired_media CASCADE;
DROP FUNCTION IF EXISTS public.update_storage_usage CASCADE;

-- =====================================================
-- 3. DROP ALL POLICIES
-- =====================================================

-- Subscriptions policies
DROP POLICY IF EXISTS "Users can view own subscription" ON public.subscriptions;
DROP POLICY IF EXISTS "Users can update own subscription" ON public.subscriptions;
DROP POLICY IF EXISTS "Users can insert own subscription" ON public.subscriptions;
DROP POLICY IF EXISTS "Service role can manage all subscriptions" ON public.subscriptions;

-- Invitations policies
DROP POLICY IF EXISTS "Users can view own invitations" ON public.invitations;
DROP POLICY IF EXISTS "Users can create own invitations" ON public.invitations;
DROP POLICY IF EXISTS "Users can update own invitations" ON public.invitations;
DROP POLICY IF EXISTS "Users can delete own invitations" ON public.invitations;
DROP POLICY IF EXISTS "Public invitations are viewable by anyone" ON public.invitations;
DROP POLICY IF EXISTS "Anyone can read published invitations" ON public.invitations;

-- Guests policies
DROP POLICY IF EXISTS "Users can view guests of own invitations" ON public.guests;
DROP POLICY IF EXISTS "Users can create guests for own invitations" ON public.guests;
DROP POLICY IF EXISTS "Users can update guests of own invitations" ON public.guests;
DROP POLICY IF EXISTS "Users can delete guests of own invitations" ON public.guests;
DROP POLICY IF EXISTS "Guests can view own data by token" ON public.guests;
DROP POLICY IF EXISTS "Guests can update own RSVP by token" ON public.guests;

-- Invitation guests policies (alternative table name)
DROP POLICY IF EXISTS "Users can view guests of own invitations" ON public.invitation_guests;
DROP POLICY IF EXISTS "Users can create guests for own invitations" ON public.invitation_guests;
DROP POLICY IF EXISTS "Users can update guests of own invitations" ON public.invitation_guests;
DROP POLICY IF EXISTS "Users can delete guests of own invitations" ON public.invitation_guests;
DROP POLICY IF EXISTS "Anyone can view invitation guests" ON public.invitation_guests;
DROP POLICY IF EXISTS "Anyone can update invitation guests" ON public.invitation_guests;

-- Templates policies
DROP POLICY IF EXISTS "Anyone can view active templates" ON public.templates;
DROP POLICY IF EXISTS "Templates are publicly readable" ON public.templates;

-- Template categories policies
DROP POLICY IF EXISTS "Anyone can view active categories" ON public.template_categories;
DROP POLICY IF EXISTS "Template categories are publicly readable" ON public.template_categories;

-- User templates policies
DROP POLICY IF EXISTS "Users can view own saved templates" ON public.user_templates;
DROP POLICY IF EXISTS "Users can create own saved templates" ON public.user_templates;
DROP POLICY IF EXISTS "Users can update own saved templates" ON public.user_templates;
DROP POLICY IF EXISTS "Users can delete own saved templates" ON public.user_templates;

-- Media policies
DROP POLICY IF EXISTS "Users can view own media" ON public.media;
DROP POLICY IF EXISTS "Users can create own media" ON public.media;
DROP POLICY IF EXISTS "Users can update own media" ON public.media;
DROP POLICY IF EXISTS "Users can delete own media" ON public.media;
DROP POLICY IF EXISTS "Anyone can view active media by QR code" ON public.media;
DROP POLICY IF EXISTS "Public media access by QR" ON public.media;

-- Guest uploads policies
DROP POLICY IF EXISTS "Users can view uploads for own media" ON public.guest_uploads;
DROP POLICY IF EXISTS "Anyone can view guest uploads by QR" ON public.guest_uploads;
DROP POLICY IF EXISTS "Anyone can create guest uploads" ON public.guest_uploads;
DROP POLICY IF EXISTS "Public can upload to media" ON public.guest_uploads;
DROP POLICY IF EXISTS "Users can delete uploads for own media" ON public.guest_uploads;

-- Payment history policies
DROP POLICY IF EXISTS "Users can view own payment history" ON public.payment_history;
DROP POLICY IF EXISTS "Users can insert own payment history" ON public.payment_history;

-- =====================================================
-- 4. DROP ALL TABLES (in correct order for foreign keys)
-- =====================================================

-- Drop tables with foreign key dependencies first
DROP TABLE IF EXISTS public.guest_uploads CASCADE;
DROP TABLE IF EXISTS public.media CASCADE;
DROP TABLE IF EXISTS public.user_templates CASCADE;
DROP TABLE IF EXISTS public.guests CASCADE;
DROP TABLE IF EXISTS public.invitation_guests CASCADE;
DROP TABLE IF EXISTS public.invitations CASCADE;
DROP TABLE IF EXISTS public.templates CASCADE;
DROP TABLE IF EXISTS public.template_categories CASCADE;
DROP TABLE IF EXISTS public.payment_history CASCADE;
DROP TABLE IF EXISTS public.subscriptions CASCADE;

-- =====================================================
-- 5. DROP STORAGE BUCKETS
-- =====================================================

-- Delete all objects in buckets first
DELETE FROM storage.objects WHERE bucket_id = 'qr-media';
DELETE FROM storage.objects WHERE bucket_id = 'invitation-images';
DELETE FROM storage.objects WHERE bucket_id = 'guest-uploads';

-- Delete bucket policies (if table exists)
DO $$
BEGIN
    -- Check if storage.bucket_policies table exists
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'storage' AND table_name = 'bucket_policies') THEN
        DELETE FROM storage.bucket_policies WHERE bucket_id = 'qr-media';
        DELETE FROM storage.bucket_policies WHERE bucket_id = 'invitation-images';
        DELETE FROM storage.bucket_policies WHERE bucket_id = 'guest-uploads';
    END IF;
END $$;

-- Drop buckets
DELETE FROM storage.buckets WHERE id = 'qr-media';
DELETE FROM storage.buckets WHERE id = 'invitation-images';
DELETE FROM storage.buckets WHERE id = 'guest-uploads';

-- =====================================================
-- 6. DROP CUSTOM TYPES (if any)
-- =====================================================
DROP TYPE IF EXISTS public.subscription_tier CASCADE;
DROP TYPE IF EXISTS public.subscription_status CASCADE;
DROP TYPE IF EXISTS public.invitation_status CASCADE;
DROP TYPE IF EXISTS public.rsvp_status CASCADE;
DROP TYPE IF EXISTS public.template_tier CASCADE;
DROP TYPE IF EXISTS public.media_type CASCADE;
DROP TYPE IF EXISTS public.media_status CASCADE;
DROP TYPE IF EXISTS public.storage_plan CASCADE;

-- =====================================================
-- CLEANUP COMPLETE
-- =====================================================

-- Refresh schema cache
NOTIFY pgrst, 'reload schema';

SELECT 'Database cleanup completed successfully!' AS status;

