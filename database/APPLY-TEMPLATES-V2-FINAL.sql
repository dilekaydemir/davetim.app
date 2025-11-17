-- =====================================================
-- TEMPLATES V2 - FINAL VERSION
-- =====================================================
-- This script:
-- 1. Updates schema with new V2 columns
-- 2. Deletes existing templates
-- 3. Seeds initial 9 templates (3 per tier)
-- =====================================================

-- =====================================================
-- PART 1: SCHEMA UPDATES
-- =====================================================

-- Add new V2 columns if they don't exist
ALTER TABLE templates 
ADD COLUMN IF NOT EXISTS category TEXT,
ADD COLUMN IF NOT EXISTS subcategory TEXT,
ADD COLUMN IF NOT EXISTS color_palette JSONB DEFAULT '{}',
ADD COLUMN IF NOT EXISTS text_fields JSONB DEFAULT '[]',
ADD COLUMN IF NOT EXISTS decorative_elements JSONB DEFAULT '[]',
ADD COLUMN IF NOT EXISTS available_fonts TEXT[] DEFAULT ARRAY['Playfair Display', 'Montserrat', 'Dancing Script'],
ADD COLUMN IF NOT EXISTS default_image_url TEXT,
ADD COLUMN IF NOT EXISTS is_featured BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS sort_order INTEGER DEFAULT 0;

-- Make category_id nullable (if it exists and is NOT NULL)
ALTER TABLE templates 
ALTER COLUMN category_id DROP NOT NULL;

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_templates_category_v2 ON templates(category);
CREATE INDEX IF NOT EXISTS idx_templates_tier ON templates(tier);
CREATE INDEX IF NOT EXISTS idx_templates_featured ON templates(is_featured);

-- =====================================================
-- PART 2: CLEAR EXISTING TEMPLATES
-- =====================================================

DELETE FROM templates;

-- =====================================================
-- PART 3: RESTART SEQUENCE
-- =====================================================

DO $$
DECLARE
    seq_name TEXT;
BEGIN
    -- Dynamically find the sequence name for templates.id
    SELECT pg_get_serial_sequence('templates', 'id') INTO seq_name;
    
    IF seq_name IS NOT NULL THEN
        EXECUTE format('ALTER SEQUENCE %s RESTART WITH 1', seq_name);
        RAISE NOTICE 'Sequence % restarted', seq_name;
    ELSE
        RAISE NOTICE 'No sequence found for templates.id';
    END IF;
END $$;

-- =====================================================
-- PART 4: SEED INITIAL TEMPLATES
-- =====================================================

-- ========== FREE PLAN TEMPLATES (3) ==========

-- FREE: Wedding - Classic
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES (
  'Klasik Düğün',
  'Zamansız ve şık klasik düğün davetiyesi',
  'wedding',
  'classic',
  'free',
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
  '{"primary": "#2C3E50", "secondary": "#ECF0F1", "accent": "#C0A062", "text": "#2C3E50"}',
  '[{"id": "title", "label": "Davetiye Başlığı", "defaultValue": "Düğünümüze Davetlisiniz", "style": {"fontSize": 32, "fontWeight": "bold", "color": "#2C3E50", "textAlign": "center"}, "position": {"x": 50, "y": 20}, "constraints": {"maxLength": 50}}, {"id": "names", "label": "İsimler", "defaultValue": "Ayşe & Mehmet", "style": {"fontSize": 28, "fontWeight": "600", "color": "#C0A062", "textAlign": "center"}, "position": {"x": 50, "y": 35}, "constraints": {"maxLength": 40}}, {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2025", "style": {"fontSize": 18, "color": "#2C3E50", "textAlign": "center"}, "position": {"x": 50, "y": 55}, "constraints": {"maxLength": 30}}, {"id": "venue", "label": "Mekan", "defaultValue": "Grand Otel Ballroom", "style": {"fontSize": 16, "color": "#2C3E50", "textAlign": "center"}, "position": {"x": 50, "y": 65}, "constraints": {"maxLength": 50}}]',
  '[{"id": "heart1", "type": "heart", "position": {"x": 20, "y": 35}, "size": {"width": 30, "height": 30}, "color": "#C0A062", "opacity": 0.3}, {"id": "heart2", "type": "heart", "position": {"x": 80, "y": 35}, "size": {"width": 30, "height": 30}, "color": "#C0A062", "opacity": 0.3}]',
  ARRAY['Playfair Display', 'Montserrat', 'Cinzel'],
  true,
  1
);

-- FREE: Birthday - Fun
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES (
  'Neşeli Doğum Günü',
  'Renkli ve eğlenceli doğum günü davetiyesi',
  'birthday',
  'fun',
  'free',
  'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400',
  'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800',
  '{"primary": "#FF6B9D", "secondary": "#FFF4E6", "accent": "#FFD93D", "text": "#2C3E50"}',
  '[{"id": "title", "label": "Başlık", "defaultValue": "Doğum Günü Partisi", "style": {"fontSize": 36, "fontWeight": "bold", "color": "#FF6B9D", "textAlign": "center"}, "position": {"x": 50, "y": 25}, "constraints": {"maxLength": 40}}, {"id": "name", "label": "İsim", "defaultValue": "Zeynep", "style": {"fontSize": 32, "fontWeight": "600", "color": "#FFD93D", "textAlign": "center"}, "position": {"x": 50, "y": 40}, "constraints": {"maxLength": 30}}, {"id": "age", "label": "Yaş", "defaultValue": "7 Yaşında!", "style": {"fontSize": 24, "color": "#FF6B9D", "textAlign": "center"}, "position": {"x": 50, "y": 55}, "constraints": {"maxLength": 20}}, {"id": "details", "label": "Detaylar", "defaultValue": "15 Haziran 2025, Saat 14:00", "style": {"fontSize": 16, "color": "#2C3E50", "textAlign": "center"}, "position": {"x": 50, "y": 70}, "constraints": {"maxLength": 60}}]',
  '[{"id": "balloon1", "type": "balloon", "position": {"x": 15, "y": 10}, "size": {"width": 40, "height": 50}, "color": "#FF6B9D", "opacity": 0.8}, {"id": "balloon2", "type": "balloon", "position": {"x": 85, "y": 15}, "size": {"width": 35, "height": 45}, "color": "#FFD93D", "opacity": 0.8}, {"id": "confetti", "type": "confetti", "position": {"x": 50, "y": 85}, "size": {"width": 60, "height": 20}, "color": "multi", "opacity": 0.7}]',
  ARRAY['Fredoka One', 'Quicksand', 'Baloo 2'],
  true,
  2
);

-- FREE: Engagement - Romantic
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES (
  'Romantik Nişan',
  'Zarif ve romantik nişan davetiyesi',
  'engagement',
  'romantic',
  'free',
  'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400',
  'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800',
  '{"primary": "#D4A5A5", "secondary": "#FFF5F5", "accent": "#9B6B6B", "text": "#5C4033"}',
  '[{"id": "title", "label": "Başlık", "defaultValue": "Nişanlanıyoruz", "style": {"fontSize": 30, "fontWeight": "600", "color": "#9B6B6B", "textAlign": "center"}, "position": {"x": 50, "y": 22}, "constraints": {"maxLength": 40}}, {"id": "names", "label": "İsimler", "defaultValue": "Elif & Can", "style": {"fontSize": 28, "fontWeight": "bold", "color": "#D4A5A5", "textAlign": "center"}, "position": {"x": 50, "y": 38}, "constraints": {"maxLength": 35}}, {"id": "date", "label": "Tarih", "defaultValue": "20 Temmuz 2025", "style": {"fontSize": 18, "color": "#5C4033", "textAlign": "center"}, "position": {"x": 50, "y": 58}, "constraints": {"maxLength": 30}}, {"id": "venue", "label": "Mekan", "defaultValue": "Bahçe Restaurant", "style": {"fontSize": 16, "color": "#5C4033", "textAlign": "center"}, "position": {"x": 50, "y": 68}, "constraints": {"maxLength": 50}}]',
  '[{"id": "ring", "type": "ring", "position": {"x": 50, "y": 10}, "size": {"width": 35, "height": 35}, "color": "#D4A5A5", "opacity": 0.6}, {"id": "rose1", "type": "rose", "position": {"x": 10, "y": 50}, "size": {"width": 25, "height": 25}, "color": "#D4A5A5", "opacity": 0.5}, {"id": "rose2", "type": "rose", "position": {"x": 90, "y": 50}, "size": {"width": 25, "height": 25}, "color": "#D4A5A5", "opacity": 0.5}]',
  ARRAY['Great Vibes', 'Lora', 'Cormorant Garamond'],
  false,
  3
);

-- ========== PRO PLAN TEMPLATES (3) ==========

-- PRO: Wedding - Elegant
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES (
  'Zarif Düğün',
  'Profesyonel ve zarif düğün davetiyesi - Altın detaylar',
  'wedding',
  'elegant',
  'pro',
  'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400',
  'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800',
  '{"primary": "#1A1A2E", "secondary": "#F5F5DC", "accent": "#D4AF37", "text": "#1A1A2E"}',
  '[{"id": "title", "label": "Davetiye Başlığı", "defaultValue": "Evleniyoruz", "style": {"fontSize": 38, "fontWeight": "bold", "color": "#D4AF37", "textAlign": "center"}, "position": {"x": 50, "y": 18}, "constraints": {"maxLength": 50}}, {"id": "names", "label": "Çiftler", "defaultValue": "Selin & Emre", "style": {"fontSize": 34, "fontWeight": "700", "color": "#1A1A2E", "textAlign": "center"}, "position": {"x": 50, "y": 32}, "constraints": {"maxLength": 40}}, {"id": "quote", "label": "Alıntı", "defaultValue": "Aşk, iki kalbin bir ritimde atmasıdır", "style": {"fontSize": 16, "fontStyle": "italic", "color": "#D4AF37", "textAlign": "center"}, "position": {"x": 50, "y": 48}, "constraints": {"maxLength": 80}}, {"id": "date", "label": "Tarih", "defaultValue": "25 Ağustos 2025", "style": {"fontSize": 20, "color": "#1A1A2E", "textAlign": "center"}, "position": {"x": 50, "y": 62}, "constraints": {"maxLength": 30}}, {"id": "venue", "label": "Mekan", "defaultValue": "Lütfi Kırdar Kongre Merkezi", "style": {"fontSize": 18, "color": "#1A1A2E", "textAlign": "center"}, "position": {"x": 50, "y": 72}, "constraints": {"maxLength": 50}}]',
  '[{"id": "frame", "type": "frame", "position": {"x": 5, "y": 5}, "size": {"width": 90, "height": 90}, "color": "#D4AF37", "opacity": 0.4, "style": "ornate"}, {"id": "divider1", "type": "divider", "position": {"x": 50, "y": 45}, "size": {"width": 60, "height": 2}, "color": "#D4AF37", "opacity": 0.6}, {"id": "floral1", "type": "floral", "position": {"x": 25, "y": 32}, "size": {"width": 20, "height": 20}, "color": "#D4AF37", "opacity": 0.3}, {"id": "floral2", "type": "floral", "position": {"x": 75, "y": 32}, "size": {"width": 20, "height": 20}, "color": "#D4AF37", "opacity": 0.3}]',
  ARRAY['Cormorant Garamond', 'Cinzel', 'Playfair Display'],
  true,
  4
);

-- PRO: Birthday - Modern
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES (
  'Modern Doğum Günü',
  'Şık ve modern doğum günü davetiyesi',
  'birthday',
  'modern',
  'pro',
  'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400',
  'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=800',
  '{"primary": "#6C5CE7", "secondary": "#FFEAA7", "accent": "#FD79A8", "text": "#2D3436"}',
  '[{"id": "title", "label": "Başlık", "defaultValue": "Doğum Günü Kutlaması", "style": {"fontSize": 34, "fontWeight": "bold", "color": "#6C5CE7", "textAlign": "center"}, "position": {"x": 50, "y": 20}, "constraints": {"maxLength": 45}}, {"id": "name", "label": "İsim", "defaultValue": "Ahmet", "style": {"fontSize": 36, "fontWeight": "700", "color": "#FD79A8", "textAlign": "center"}, "position": {"x": 50, "y": 35}, "constraints": {"maxLength": 30}}, {"id": "age", "label": "Yaş", "defaultValue": "30 Yaşında!", "style": {"fontSize": 26, "fontWeight": "600", "color": "#FFEAA7", "textAlign": "center"}, "position": {"x": 50, "y": 50}, "constraints": {"maxLength": 20}}, {"id": "date", "label": "Tarih ve Saat", "defaultValue": "10 Eylül 2025, 19:00", "style": {"fontSize": 18, "color": "#2D3436", "textAlign": "center"}, "position": {"x": 50, "y": 65}, "constraints": {"maxLength": 40}}, {"id": "venue", "label": "Mekan", "defaultValue": "Skybar Rooftop", "style": {"fontSize": 16, "color": "#2D3436", "textAlign": "center"}, "position": {"x": 50, "y": 75}, "constraints": {"maxLength": 50}}]',
  '[{"id": "star1", "type": "star", "position": {"x": 15, "y": 12}, "size": {"width": 30, "height": 30}, "color": "#FFEAA7", "opacity": 0.7}, {"id": "star2", "type": "star", "position": {"x": 85, "y": 18}, "size": {"width": 25, "height": 25}, "color": "#FD79A8", "opacity": 0.7}, {"id": "geometric1", "type": "circle", "position": {"x": 10, "y": 80}, "size": {"width": 40, "height": 40}, "color": "#6C5CE7", "opacity": 0.2}, {"id": "geometric2", "type": "triangle", "position": {"x": 88, "y": 85}, "size": {"width": 35, "height": 35}, "color": "#FD79A8", "opacity": 0.2}]',
  ARRAY['Poppins', 'Montserrat', 'Raleway'],
  true,
  5
);

-- PRO: Corporate Event
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES (
  'Kurumsal Etkinlik',
  'Profesyonel iş etkinliği davetiyesi',
  'corporate',
  'professional',
  'pro',
  'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=400',
  'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800',
  '{"primary": "#2C3E50", "secondary": "#ECF0F1", "accent": "#3498DB", "text": "#2C3E50"}',
  '[{"id": "title", "label": "Etkinlik Başlığı", "defaultValue": "Yıllık Değerlendirme Toplantısı", "style": {"fontSize": 32, "fontWeight": "bold", "color": "#2C3E50", "textAlign": "center"}, "position": {"x": 50, "y": 25}, "constraints": {"maxLength": 60}}, {"id": "company", "label": "Şirket Adı", "defaultValue": "ABC Teknoloji A.Ş.", "style": {"fontSize": 20, "fontWeight": "600", "color": "#3498DB", "textAlign": "center"}, "position": {"x": 50, "y": 40}, "constraints": {"maxLength": 50}}, {"id": "date", "label": "Tarih ve Saat", "defaultValue": "15 Kasım 2025, 10:00", "style": {"fontSize": 18, "color": "#2C3E50", "textAlign": "center"}, "position": {"x": 50, "y": 58}, "constraints": {"maxLength": 40}}, {"id": "venue", "label": "Mekan", "defaultValue": "Hilton Convention Center", "style": {"fontSize": 16, "color": "#2C3E50", "textAlign": "center"}, "position": {"x": 50, "y": 70}, "constraints": {"maxLength": 50}}, {"id": "dresscode", "label": "Kıyafet", "defaultValue": "Business Formal", "style": {"fontSize": 14, "color": "#7F8C8D", "textAlign": "center"}, "position": {"x": 50, "y": 82}, "constraints": {"maxLength": 30}}]',
  '[{"id": "line1", "type": "line", "position": {"x": 20, "y": 15}, "size": {"width": 60, "height": 2}, "color": "#3498DB", "opacity": 0.5}, {"id": "line2", "type": "line", "position": {"x": 20, "y": 88}, "size": {"width": 60, "height": 2}, "color": "#3498DB", "opacity": 0.5}]',
  ARRAY['Roboto', 'Open Sans', 'Lato'],
  false,
  6
);

-- ========== PREMIUM PLAN TEMPLATES (3) ==========

-- PREMIUM: Wedding - Luxury
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES (
  'Lüks Düğün',
  'Ultra lüks düğün davetiyesi - Premium tasarım',
  'wedding',
  'luxury',
  'premium',
  'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400',
  'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800',
  '{"primary": "#0F0F0F", "secondary": "#F8F8F8", "accent": "#FFD700", "text": "#0F0F0F"}',
  '[{"id": "pretitle", "label": "Ön Başlık", "defaultValue": "Birlikte Bir Ömür", "style": {"fontSize": 18, "fontStyle": "italic", "color": "#FFD700", "textAlign": "center"}, "position": {"x": 50, "y": 15}, "constraints": {"maxLength": 40}}, {"id": "title", "label": "Ana Başlık", "defaultValue": "Düğün Töreni", "style": {"fontSize": 42, "fontWeight": "bold", "color": "#0F0F0F", "textAlign": "center"}, "position": {"x": 50, "y": 25}, "constraints": {"maxLength": 50}}, {"id": "names", "label": "Çiftler", "defaultValue": "Aylin & Kerem", "style": {"fontSize": 38, "fontWeight": "700", "color": "#FFD700", "textAlign": "center"}, "position": {"x": 50, "y": 38}, "constraints": {"maxLength": 40}}, {"id": "quote", "label": "Özel Mesaj", "defaultValue": "İki kalp, bir yürek, sonsuz bir aşk", "style": {"fontSize": 16, "fontStyle": "italic", "color": "#0F0F0F", "textAlign": "center"}, "position": {"x": 50, "y": 52}, "constraints": {"maxLength": 100}}, {"id": "date", "label": "Tarih", "defaultValue": "5 Ekim 2025, Cumartesi", "style": {"fontSize": 20, "fontWeight": "600", "color": "#0F0F0F", "textAlign": "center"}, "position": {"x": 50, "y": 65}, "constraints": {"maxLength": 40}}, {"id": "time", "label": "Saat", "defaultValue": "18:00", "style": {"fontSize": 18, "color": "#0F0F0F", "textAlign": "center"}, "position": {"x": 50, "y": 73}, "constraints": {"maxLength": 20}}, {"id": "venue", "label": "Mekan", "defaultValue": "Four Seasons Hotel Bosphorus", "style": {"fontSize": 18, "color": "#0F0F0F", "textAlign": "center"}, "position": {"x": 50, "y": 82}, "constraints": {"maxLength": 60}}]',
  '[{"id": "border", "type": "frame", "position": {"x": 3, "y": 3}, "size": {"width": 94, "height": 94}, "color": "#FFD700", "opacity": 0.6, "style": "luxury"}, {"id": "corner1", "type": "corner-ornament", "position": {"x": 8, "y": 8}, "size": {"width": 15, "height": 15}, "color": "#FFD700", "opacity": 0.8}, {"id": "corner2", "type": "corner-ornament", "position": {"x": 92, "y": 8}, "size": {"width": 15, "height": 15}, "color": "#FFD700", "opacity": 0.8, "rotation": 90}, {"id": "corner3", "type": "corner-ornament", "position": {"x": 8, "y": 92}, "size": {"width": 15, "height": 15}, "color": "#FFD700", "opacity": 0.8, "rotation": 270}, {"id": "corner4", "type": "corner-ornament", "position": {"x": 92, "y": 92}, "size": {"width": 15, "height": 15}, "color": "#FFD700", "opacity": 0.8, "rotation": 180}, {"id": "divider1", "type": "ornate-divider", "position": {"x": 50, "y": 48}, "size": {"width": 70, "height": 3}, "color": "#FFD700", "opacity": 0.7}, {"id": "floral-left", "type": "floral-bouquet", "position": {"x": 15, "y": 38}, "size": {"width": 25, "height": 25}, "color": "#FFD700", "opacity": 0.4}, {"id": "floral-right", "type": "floral-bouquet", "position": {"x": 85, "y": 38}, "size": {"width": 25, "height": 25}, "color": "#FFD700", "opacity": 0.4}]',
  ARRAY['Bodoni Moda', 'Playfair Display', 'Cormorant Garamond'],
  true,
  7
);

-- PREMIUM: Birthday - Deluxe
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES (
  'Deluxe Doğum Günü',
  'Premium doğum günü davetiyesi - Özel tasarım',
  'birthday',
  'deluxe',
  'premium',
  'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=400',
  'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=800',
  '{"primary": "#E91E63", "secondary": "#FFF0F5", "accent": "#FFD700", "text": "#1A1A1A"}',
  '[{"id": "pretitle", "label": "Ön Mesaj", "defaultValue": "Özel Bir Gün", "style": {"fontSize": 16, "fontStyle": "italic", "color": "#FFD700", "textAlign": "center"}, "position": {"x": 50, "y": 12}, "constraints": {"maxLength": 30}}, {"id": "title", "label": "Başlık", "defaultValue": "Doğum Günü Partisi", "style": {"fontSize": 38, "fontWeight": "bold", "color": "#E91E63", "textAlign": "center"}, "position": {"x": 50, "y": 22}, "constraints": {"maxLength": 45}}, {"id": "name", "label": "İsim", "defaultValue": "Deniz", "style": {"fontSize": 40, "fontWeight": "700", "color": "#FFD700", "textAlign": "center"}, "position": {"x": 50, "y": 35}, "constraints": {"maxLength": 30}}, {"id": "age", "label": "Yaş", "defaultValue": "25 Yaşında!", "style": {"fontSize": 28, "fontWeight": "600", "color": "#E91E63", "textAlign": "center"}, "position": {"x": 50, "y": 48}, "constraints": {"maxLength": 20}}, {"id": "message", "label": "Özel Mesaj", "defaultValue": "Hep birlikte kutlayalım!", "style": {"fontSize": 16, "fontStyle": "italic", "color": "#1A1A1A", "textAlign": "center"}, "position": {"x": 50, "y": 58}, "constraints": {"maxLength": 60}}, {"id": "date", "label": "Tarih", "defaultValue": "20 Aralık 2025", "style": {"fontSize": 20, "color": "#1A1A1A", "textAlign": "center"}, "position": {"x": 50, "y": 70}, "constraints": {"maxLength": 30}}, {"id": "time", "label": "Saat", "defaultValue": "20:00", "style": {"fontSize": 18, "color": "#1A1A1A", "textAlign": "center"}, "position": {"x": 50, "y": 78}, "constraints": {"maxLength": 20}}, {"id": "venue", "label": "Mekan", "defaultValue": "Sunset Beach Club", "style": {"fontSize": 16, "color": "#1A1A1A", "textAlign": "center"}, "position": {"x": 50, "y": 86}, "constraints": {"maxLength": 50}}]',
  '[{"id": "balloon-left1", "type": "balloon", "position": {"x": 10, "y": 8}, "size": {"width": 45, "height": 55}, "color": "#E91E63", "opacity": 0.8}, {"id": "balloon-left2", "type": "balloon", "position": {"x": 18, "y": 15}, "size": {"width": 40, "height": 50}, "color": "#FFD700", "opacity": 0.7}, {"id": "balloon-right1", "type": "balloon", "position": {"x": 90, "y": 10}, "size": {"width": 42, "height": 52}, "color": "#FFD700", "opacity": 0.8}, {"id": "balloon-right2", "type": "balloon", "position": {"x": 82, "y": 18}, "size": {"width": 38, "height": 48}, "color": "#E91E63", "opacity": 0.7}, {"id": "confetti1", "type": "confetti", "position": {"x": 30, "y": 60}, "size": {"width": 40, "height": 15}, "color": "multi", "opacity": 0.6}, {"id": "confetti2", "type": "confetti", "position": {"x": 70, "y": 65}, "size": {"width": 35, "height": 12}, "color": "multi", "opacity": 0.6}, {"id": "star1", "type": "star", "position": {"x": 20, "y": 45}, "size": {"width": 25, "height": 25}, "color": "#FFD700", "opacity": 0.5}, {"id": "star2", "type": "star", "position": {"x": 80, "y": 50}, "size": {"width": 22, "height": 22}, "color": "#FFD700", "opacity": 0.5}, {"id": "party-hat", "type": "party-hat", "position": {"x": 50, "y": 5}, "size": {"width": 30, "height": 35}, "color": "#E91E63", "opacity": 0.7}]',
  ARRAY['Pacifico', 'Fredoka One', 'Righteous'],
  true,
  8
);

-- PREMIUM: Anniversary - Romantic Luxury
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES (
  'Romantik Yıldönümü',
  'Lüks yıldönümü davetiyesi - Premium romantik tasarım',
  'anniversary',
  'romantic-luxury',
  'premium',
  'https://images.unsplash.com/photo-1518709594023-6eab9bab7b23?w=400',
  'https://images.unsplash.com/photo-1518709594023-6eab9bab7b23?w=800',
  '{"primary": "#8B4789", "secondary": "#FFF5F8", "accent": "#D4AF37", "text": "#3E2723"}',
  '[{"id": "pretitle", "label": "Ön Başlık", "defaultValue": "Birlikte", "style": {"fontSize": 16, "fontStyle": "italic", "color": "#D4AF37", "textAlign": "center"}, "position": {"x": 50, "y": 14}, "constraints": {"maxLength": 30}}, {"id": "title", "label": "Ana Başlık", "defaultValue": "10. Yıl Dönümümüz", "style": {"fontSize": 36, "fontWeight": "bold", "color": "#8B4789", "textAlign": "center"}, "position": {"x": 50, "y": 26}, "constraints": {"maxLength": 50}}, {"id": "names", "label": "Çift İsimleri", "defaultValue": "Merve & Burak", "style": {"fontSize": 32, "fontWeight": "700", "color": "#D4AF37", "textAlign": "center"}, "position": {"x": 50, "y": 40}, "constraints": {"maxLength": 40}}, {"id": "years", "label": "Yıl", "defaultValue": "2015 - 2025", "style": {"fontSize": 18, "color": "#3E2723", "textAlign": "center"}, "position": {"x": 50, "y": 52}, "constraints": {"maxLength": 30}}, {"id": "quote", "label": "Özel Mesaj", "defaultValue": "On yıl önce başlayan aşk hikayemizi sizlerle kutlamak istiyoruz", "style": {"fontSize": 15, "fontStyle": "italic", "color": "#8B4789", "textAlign": "center"}, "position": {"x": 50, "y": 62}, "constraints": {"maxLength": 120}}, {"id": "date", "label": "Tarih", "defaultValue": "14 Şubat 2025, Cuma", "style": {"fontSize": 19, "fontWeight": "600", "color": "#3E2723", "textAlign": "center"}, "position": {"x": 50, "y": 74}, "constraints": {"maxLength": 40}}, {"id": "venue", "label": "Mekan", "defaultValue": "The Ritz-Carlton Terrace", "style": {"fontSize": 17, "color": "#3E2723", "textAlign": "center"}, "position": {"x": 50, "y": 84}, "constraints": {"maxLength": 60}}]',
  '[{"id": "frame-outer", "type": "frame", "position": {"x": 2, "y": 2}, "size": {"width": 96, "height": 96}, "color": "#D4AF37", "opacity": 0.5, "style": "elegant"}, {"id": "frame-inner", "type": "frame", "position": {"x": 5, "y": 5}, "size": {"width": 90, "height": 90}, "color": "#8B4789", "opacity": 0.3, "style": "delicate"}, {"id": "rose-top-left", "type": "rose", "position": {"x": 12, "y": 10}, "size": {"width": 20, "height": 20}, "color": "#8B4789", "opacity": 0.6}, {"id": "rose-top-right", "type": "rose", "position": {"x": 88, "y": 10}, "size": {"width": 20, "height": 20}, "color": "#8B4789", "opacity": 0.6}, {"id": "rose-bottom-left", "type": "rose", "position": {"x": 12, "y": 90}, "size": {"width": 18, "height": 18}, "color": "#D4AF37", "opacity": 0.5}, {"id": "rose-bottom-right", "type": "rose", "position": {"x": 88, "y": 90}, "size": {"width": 18, "height": 18}, "color": "#D4AF37", "opacity": 0.5}, {"id": "heart-center", "type": "heart", "position": {"x": 50, "y": 48}, "size": {"width": 35, "height": 35}, "color": "#D4AF37", "opacity": 0.2}, {"id": "divider-top", "type": "ornate-divider", "position": {"x": 50, "y": 58}, "size": {"width": 60, "height": 2}, "color": "#D4AF37", "opacity": 0.6}, {"id": "sparkle1", "type": "sparkle", "position": {"x": 25, "y": 40}, "size": {"width": 15, "height": 15}, "color": "#D4AF37", "opacity": 0.4}, {"id": "sparkle2", "type": "sparkle", "position": {"x": 75, "y": 42}, "size": {"width": 15, "height": 15}, "color": "#D4AF37", "opacity": 0.4}]',
  ARRAY['Great Vibes', 'Cormorant Garamond', 'Playfair Display'],
  true,
  9
);

-- =====================================================
-- VERIFICATION
-- =====================================================

SELECT 
  id,
  name,
  category,
  subcategory,
  tier,
  is_featured,
  sort_order
FROM templates
ORDER BY sort_order;

