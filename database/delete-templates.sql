-- ============================================
-- DELETE ALL TEMPLATES AND CATEGORIES
-- ============================================
-- Use this to clean up and recreate templates
-- Run this in Supabase SQL Editor

-- ⚠️ WARNING: This will delete ALL invitations and templates!
-- Make sure you have a backup if needed.

-- 1. First, delete all invitations (they reference templates)
DELETE FROM guests;  -- Delete guests first (they reference invitations)
DELETE FROM invitations;  -- Now delete invitations

-- 2. Now we can delete templates
DELETE FROM templates;

-- 3. Delete all template categories
DELETE FROM template_categories;

-- 4. (Optional) Reset auto-increment sequences if any
-- ALTER SEQUENCE templates_id_seq RESTART WITH 1;
-- ALTER SEQUENCE template_categories_id_seq RESTART WITH 1;

-- 5. Verify deletion
SELECT COUNT(*) as guest_count FROM guests;
SELECT COUNT(*) as invitation_count FROM invitations;
SELECT COUNT(*) as template_count FROM templates;
SELECT COUNT(*) as category_count FROM template_categories;

-- Expected result: all should return 0

-- ============================================
-- NEXT STEP: Run database/templates-seed.sql
-- ============================================

