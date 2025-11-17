-- =====================================================
-- DÜĞÜN (WEDDING) TEMPLATES - 20 ŞABLON
-- =====================================================
-- FREE: 2 | PRO: 8 | PREMIUM: 10
-- =====================================================

-- FREE TEMPLATES (2)
-- =====================================================

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, preview_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- 1. Klasik Düğün
(
  'Klasik Düğün',
  'Zamansız ve şık klasik düğün davetiyesi',
  'wedding',
  'classic',
  'free',
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop',
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&h=600&fit=crop',
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=1200',
  '{"primary": "#2C3E50", "secondary": "#ECF0F1", "accent": "#C0A062", "background": "#FFFFFF", "text": "#2C3E50"}'::jsonb,
  '[
    {"id": "title", "label": "Davetiye Başlığı", "defaultValue": "Düğünümüze Davetlisiniz", "position": {"x": 50, "y": 15}, "style": {"fontSize": 36, "fontFamily": "Playfair Display", "color": "#2C3E50", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 50, "required": true},
    {"id": "couple", "label": "Çift İsimleri", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 30}, "style": {"fontSize": 48, "fontFamily": "Playfair Display", "color": "#C0A062", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 50}, "style": {"fontSize": 24, "fontFamily": "Montserrat", "color": "#2C3E50", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Grand Hotel Ballroom", "position": {"x": 50, "y": 60}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#2C3E50", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}
  ]'::jsonb,
  '[
    {"id": "heart1", "type": "heart", "position": {"x": 20, "y": 25}, "size": {"width": 30, "height": 30}, "color": "#C0A062", "rotation": -15, "opacity": 0.3, "zIndex": 1},
    {"id": "heart2", "type": "heart", "position": {"x": 80, "y": 25}, "size": {"width": 30, "height": 30}, "color": "#C0A062", "rotation": 15, "opacity": 0.3, "zIndex": 1}
  ]'::jsonb,
  ARRAY['Playfair Display', 'Montserrat', 'Cinzel'],
  true,
  1
),

-- 2. Minimal Düğün
(
  'Minimal Düğün',
  'Sade ve modern minimal düğün davetiyesi',
  'wedding',
  'minimal',
  'free',
  'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=400&h=300&fit=crop',
  'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=800&h=600&fit=crop',
  'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=1200',
  '{"primary": "#000000", "secondary": "#FFFFFF", "accent": "#808080", "background": "#F5F5F5", "text": "#000000"}'::jsonb,
  '[
    {"id": "couple", "label": "Çift İsimleri", "defaultValue": "AYŞE & MEHMET", "position": {"x": 50, "y": 40}, "style": {"fontSize": 42, "fontFamily": "Montserrat", "color": "#000000", "textAlign": "center", "fontWeight": "300", "letterSpacing": 8, "textTransform": "uppercase"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15.06.2024", "position": {"x": 50, "y": 55}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#808080", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "İstanbul", "position": {"x": 50, "y": 65}, "style": {"fontSize": 18, "fontFamily": "Montserrat", "color": "#808080", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}
  ]'::jsonb,
  '[]'::jsonb,
  ARRAY['Montserrat', 'Poppins'],
  true,
  2
);

-- PRO TEMPLATES (8)
-- =====================================================

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, preview_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- 3. Romantik Gül Bahçesi
(
  'Romantik Gül Bahçesi',
  'Pembe güller ve romantik detaylarla süslü düğün davetiyesi',
  'wedding',
  'romantic',
  'pro',
  'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400&h=300&fit=crop',
  'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800&h=600&fit=crop',
  'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=1200',
  '{"primary": "#D4526E", "secondary": "#F8E8EE", "accent": "#FFB6C1", "background": "#FFF5F7", "text": "#4A4A4A"}'::jsonb,
  '[
    {"id": "title", "label": "Başlık", "defaultValue": "Aşkımızı Kutlayın", "position": {"x": 50, "y": 20}, "style": {"fontSize": 32, "fontFamily": "Dancing Script", "color": "#D4526E", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 50, "required": true},
    {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 35}, "style": {"fontSize": 44, "fontFamily": "Playfair Display", "color": "#D4526E", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024, Cumartesi", "position": {"x": 50, "y": 55}, "style": {"fontSize": 22, "fontFamily": "Montserrat", "color": "#4A4A4A", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 40, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Çırağan Sarayı", "position": {"x": 50, "y": 65}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#4A4A4A", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true},
    {"id": "message", "label": "Mesaj", "defaultValue": "Mutluluğumuzu paylaşmak için sizleri bekliyoruz", "position": {"x": 50, "y": 80}, "style": {"fontSize": 16, "fontFamily": "Montserrat", "color": "#4A4A4A", "textAlign": "center", "fontWeight": "normal", "fontStyle": "italic"}, "maxLength": 80, "required": false}
  ]'::jsonb,
  '[
    {"id": "flower1", "type": "flower", "position": {"x": 10, "y": 10}, "size": {"width": 60, "height": 60}, "color": "#FFB6C1", "rotation": -20, "opacity": 0.6, "zIndex": 1},
    {"id": "flower2", "type": "flower", "position": {"x": 90, "y": 10}, "size": {"width": 60, "height": 60}, "color": "#FFB6C1", "rotation": 20, "opacity": 0.6, "zIndex": 1},
    {"id": "flower3", "type": "flower", "position": {"x": 10, "y": 85}, "size": {"width": 50, "height": 50}, "color": "#D4526E", "rotation": 10, "opacity": 0.5, "zIndex": 1},
    {"id": "flower4", "type": "flower", "position": {"x": 90, "y": 85}, "size": {"width": 50, "height": 50}, "color": "#D4526E", "rotation": -10, "opacity": 0.5, "zIndex": 1}
  ]'::jsonb,
  ARRAY['Dancing Script', 'Playfair Display', 'Montserrat'],
  true,
  10
),

-- 4. Vintage Nostalji
(
  'Vintage Nostalji',
  'Retro tarzda vintage düğün davetiyesi',
  'wedding',
  'vintage',
  'pro',
  'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400&h=300&fit=crop',
  'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800&h=600&fit=crop',
  'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=1200',
  '{"primary": "#8B7355", "secondary": "#F4E8D8", "accent": "#C9A66B", "background": "#FFF8F0", "text": "#5D4E37"}'::jsonb,
  '[
    {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 35}, "style": {"fontSize": 40, "fontFamily": "Playfair Display", "color": "#8B7355", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
    {"id": "subtitle", "label": "Alt Başlık", "defaultValue": "Evliliğe İlk Adım", "position": {"x": 50, "y": 48}, "style": {"fontSize": 18, "fontFamily": "Montserrat", "color": "#C9A66B", "textAlign": "center", "fontWeight": "normal", "fontStyle": "italic"}, "maxLength": 50, "required": false},
    {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 60}, "style": {"fontSize": 24, "fontFamily": "Cinzel", "color": "#5D4E37", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Tarihi Köşk", "position": {"x": 50, "y": 72}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#5D4E37", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}
  ]'::jsonb,
  '[
    {"id": "ribbon1", "type": "ribbon", "position": {"x": 50, "y": 5}, "size": {"width": 80, "height": 50}, "color": "#C9A66B", "rotation": 0, "opacity": 0.4, "zIndex": 1}
  ]'::jsonb,
  ARRAY['Playfair Display', 'Cinzel', 'Montserrat'],
  false,
  11
),

-- 5. Boho Rüya
(
  'Boho Rüya',
  'Doğal ve özgür ruhlu boho tarzı düğün',
  'wedding',
  'boho',
  'pro',
  'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400&h=300&fit=crop',
  'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800&h=600&fit=crop',
  'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=1200',
  '{"primary": "#8B4513", "secondary": "#F5DEB3", "accent": "#98D8C8", "background": "#FFF8DC", "text": "#654321"}'::jsonb,
  '[
    {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 38}, "style": {"fontSize": 38, "fontFamily": "Dancing Script", "color": "#8B4513", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 55}, "style": {"fontSize": 22, "fontFamily": "Montserrat", "color": "#654321", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Doğa İçinde", "position": {"x": 50, "y": 68}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#654321", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}
  ]'::jsonb,
  '[
    {"id": "flower1", "type": "flower", "position": {"x": 15, "y": 15}, "size": {"width": 50, "height": 50}, "color": "#98D8C8", "rotation": -25, "opacity": 0.5, "zIndex": 1},
    {"id": "flower2", "type": "flower", "position": {"x": 85, "y": 15}, "size": {"width": 50, "height": 50}, "color": "#F5DEB3", "rotation": 25, "opacity": 0.5, "zIndex": 1}
  ]'::jsonb,
  ARRAY['Dancing Script', 'Montserrat', 'Poppins'],
  false,
  12
),

-- 6. Modern Geometrik
(
  'Modern Geometrik',
  'Geometrik desenlerle modern düğün davetiyesi',
  'wedding',
  'modern',
  'pro',
  'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400&h=300&fit=crop',
  'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800&h=600&fit=crop',
  'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=1200',
  '{"primary": "#1A237E", "secondary": "#E8EAF6", "accent": "#FFD700", "background": "#FFFFFF", "text": "#1A237E"}'::jsonb,
  '[
    {"id": "couple", "label": "Çift", "defaultValue": "AYŞE & MEHMET", "position": {"x": 50, "y": 42}, "style": {"fontSize": 40, "fontFamily": "Montserrat", "color": "#1A237E", "textAlign": "center", "fontWeight": "bold", "letterSpacing": 4, "textTransform": "uppercase"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15.06.2024", "position": {"x": 50, "y": 58}, "style": {"fontSize": 22, "fontFamily": "Poppins", "color": "#FFD700", "textAlign": "center", "fontWeight": "600"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Modern Sanat Müzesi", "position": {"x": 50, "y": 70}, "style": {"fontSize": 18, "fontFamily": "Poppins", "color": "#1A237E", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}
  ]'::jsonb,
  '[]'::jsonb,
  ARRAY['Montserrat', 'Poppins'],
  false,
  13
),

-- 7. Rustik Ahşap
(
  'Rustik Ahşap',
  'Doğal ahşap dokulu rustik düğün',
  'wedding',
  'rustic',
  'pro',
  'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=400&h=300&fit=crop',
  'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=800&h=600&fit=crop',
  'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=1200',
  '{"primary": "#6B4423", "secondary": "#D2B48C", "accent": "#228B22", "background": "#FAF0E6", "text": "#3E2723"}'::jsonb,
  '[
    {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 40}, "style": {"fontSize": 42, "fontFamily": "Playfair Display", "color": "#6B4423", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 56}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#3E2723", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Çiftlik Evi", "position": {"x": 50, "y": 68}, "style": {"fontSize": 18, "fontFamily": "Montserrat", "color": "#3E2723", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}
  ]'::jsonb,
  '[
    {"id": "flower1", "type": "flower", "position": {"x": 20, "y": 20}, "size": {"width": 40, "height": 40}, "color": "#228B22", "rotation": -15, "opacity": 0.4, "zIndex": 1},
    {"id": "flower2", "type": "flower", "position": {"x": 80, "y": 20}, "size": {"width": 40, "height": 40}, "color": "#228B22", "rotation": 15, "opacity": 0.4, "zIndex": 1}
  ]'::jsonb,
  ARRAY['Playfair Display', 'Montserrat'],
  false,
  14
),

-- 8. Deniz Kenarı
(
  'Deniz Kenarı',
  'Plaj düğünü için deniz temalı davetiye',
  'wedding',
  'beach',
  'pro',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=600&fit=crop',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=1200',
  '{"primary": "#0077BE", "secondary": "#87CEEB", "accent": "#FFD700", "background": "#F0F8FF", "text": "#003366"}'::jsonb,
  '[
    {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 38}, "style": {"fontSize": 40, "fontFamily": "Dancing Script", "color": "#0077BE", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 54}, "style": {"fontSize": 22, "fontFamily": "Montserrat", "color": "#003366", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Kumsalda Gün Batımı", "position": {"x": 50, "y": 66}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#003366", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}
  ]'::jsonb,
  '[
    {"id": "star1", "type": "star", "position": {"x": 25, "y": 25}, "size": {"width": 30, "height": 30}, "color": "#FFD700", "rotation": 0, "opacity": 0.5, "zIndex": 1},
    {"id": "star2", "type": "star", "position": {"x": 75, "y": 25}, "size": {"width": 30, "height": 30}, "color": "#FFD700", "rotation": 0, "opacity": 0.5, "zIndex": 1}
  ]'::jsonb,
  ARRAY['Dancing Script', 'Montserrat', 'Poppins'],
  false,
  15
),

-- 9. Gece Yıldızları
(
  'Gece Yıldızları',
  'Yıldızlı gece temalı romantik düğün',
  'wedding',
  'night',
  'pro',
  'https://images.unsplash.com/photo-1502635385003-ee1e6a1a742d?w=400&h=300&fit=crop',
  'https://images.unsplash.com/photo-1502635385003-ee1e6a1a742d?w=800&h=600&fit=crop',
  'https://images.unsplash.com/photo-1502635385003-ee1e6a1a742d?w=1200',
  '{"primary": "#191970", "secondary": "#E6E6FA", "accent": "#C0C0C0", "background": "#0F0F23", "text": "#FFFFFF"}'::jsonb,
  '[
    {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 40}, "style": {"fontSize": 42, "fontFamily": "Playfair Display", "color": "#FFFFFF", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 56}, "style": {"fontSize": 22, "fontFamily": "Montserrat", "color": "#C0C0C0", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Yıldızlar Altında", "position": {"x": 50, "y": 68}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#E6E6FA", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}
  ]'::jsonb,
  '[
    {"id": "star1", "type": "star", "position": {"x": 15, "y": 15}, "size": {"width": 25, "height": 25}, "color": "#C0C0C0", "rotation": 0, "opacity": 0.7, "zIndex": 1},
    {"id": "star2", "type": "star", "position": {"x": 85, "y": 15}, "size": {"width": 25, "height": 25}, "color": "#C0C0C0", "rotation": 0, "opacity": 0.7, "zIndex": 1},
    {"id": "star3", "type": "star", "position": {"x": 20, "y": 80}, "size": {"width": 20, "height": 20}, "color": "#FFD700", "rotation": 0, "opacity": 0.6, "zIndex": 1},
    {"id": "star4", "type": "star", "position": {"x": 80, "y": 80}, "size": {"width": 20, "height": 20}, "color": "#FFD700", "rotation": 0, "opacity": 0.6, "zIndex": 1}
  ]'::jsonb,
  ARRAY['Playfair Display', 'Montserrat', 'Cinzel'],
  false,
  16
),

-- 10. Bahçe Partisi
(
  'Bahçe Partisi',
  'Çiçekli bahçede düğün davetiyesi',
  'wedding',
  'garden',
  'pro',
  'https://images.unsplash.com/photo-1470229538611-16ba8c7ffbd7?w=400&h=300&fit=crop',
  'https://images.unsplash.com/photo-1470229538611-16ba8c7ffbd7?w=800&h=600&fit=crop',
  'https://images.unsplash.com/photo-1470229538611-16ba8c7ffbd7?w=1200',
  '{"primary": "#228B22", "secondary": "#F0FFF0", "accent": "#FF69B4", "background": "#F5FFFA", "text": "#2F4F2F"}'::jsonb,
  '[
    {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 38}, "style": {"fontSize": 40, "fontFamily": "Dancing Script", "color": "#228B22", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 54}, "style": {"fontSize": 22, "fontFamily": "Montserrat", "color": "#2F4F2F", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Botanik Bahçesi", "position": {"x": 50, "y": 66}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#2F4F2F", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}
  ]'::jsonb,
  '[
    {"id": "flower1", "type": "flower", "position": {"x": 12, "y": 12}, "size": {"width": 55, "height": 55}, "color": "#FF69B4", "rotation": -20, "opacity": 0.6, "zIndex": 1},
    {"id": "flower2", "type": "flower", "position": {"x": 88, "y": 12}, "size": {"width": 55, "height": 55}, "color": "#FF69B4", "rotation": 20, "opacity": 0.6, "zIndex": 1},
    {"id": "flower3", "type": "flower", "position": {"x": 12, "y": 82}, "size": {"width": 45, "height": 45}, "color": "#228B22", "rotation": 15, "opacity": 0.5, "zIndex": 1},
    {"id": "flower4", "type": "flower", "position": {"x": 88, "y": 82}, "size": {"width": 45, "height": 45}, "color": "#228B22", "rotation": -15, "opacity": 0.5, "zIndex": 1}
  ]'::jsonb,
  ARRAY['Dancing Script', 'Montserrat', 'Poppins'],
  false,
  17
);

-- PREMIUM TEMPLATES devam edecek...
-- Dosya boyutu nedeniyle ayrı dosyalara bölünecek

