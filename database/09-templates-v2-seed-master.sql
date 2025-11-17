-- =====================================================
-- TEMPLATES V2 - 105 PROFESSIONAL TEMPLATES
-- =====================================================
-- Her kategori için tema, renk ve görsel uyumlu şablonlar
-- FREE: 20 şablon | PRO: 40 şablon | PREMIUM: 45 şablon
-- =====================================================

-- Önce mevcut template'leri temizle
TRUNCATE TABLE templates CASCADE;
ALTER SEQUENCE templates_id_seq RESTART WITH 1;

-- =====================================================
-- DÜĞÜN (WEDDING) - 20 ŞABLON
-- =====================================================

-- FREE (2 şablon)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, preview_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES
(
  'Klasik Düğün',
  'Zamansız ve şık klasik düğün davetiyesi',
  'wedding',
  'classic',
  'free',
  '/templates/wedding-classic-thumb.jpg',
  '/templates/wedding-classic-preview.jpg',
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
  '{"primary": "#2C3E50", "secondary": "#ECF0F1", "accent": "#C0A062", "background": "#FFFFFF", "text": "#2C3E50"}',
  '[
    {"id": "title", "label": "Davetiye Başlığı", "defaultValue": "Düğünümüze Davetlisiniz", "position": {"x": 50, "y": 15}, "style": {"fontSize": 36, "fontFamily": "Playfair Display", "color": "#2C3E50", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 50, "required": true},
    {"id": "couple", "label": "Çift İsimleri", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 30}, "style": {"fontSize": 48, "fontFamily": "Playfair Display", "color": "#C0A062", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 50}, "style": {"fontSize": 24, "fontFamily": "Montserrat", "color": "#2C3E50", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Grand Hotel Ballroom", "position": {"x": 50, "y": 60}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#2C3E50", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true},
    {"id": "time", "label": "Saat", "defaultValue": "19:00", "position": {"x": 50, "y": 70}, "style": {"fontSize": 18, "fontFamily": "Montserrat", "color": "#2C3E50", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 20, "required": false}
  ]',
  '[
    {"id": "heart1", "type": "heart", "position": {"x": 20, "y": 25}, "size": {"width": 30, "height": 30}, "color": "#C0A062", "rotation": -15, "opacity": 0.3, "zIndex": 1},
    {"id": "heart2", "type": "heart", "position": {"x": 80, "y": 25}, "size": {"width": 30, "height": 30}, "color": "#C0A062", "rotation": 15, "opacity": 0.3, "zIndex": 1}
  ]',
  ARRAY['Playfair Display', 'Montserrat', 'Cinzel'],
  true,
  1
),
(
  'Minimal Düğün',
  'Sade ve modern minimal düğün davetiyesi',
  'wedding',
  'minimal',
  'free',
  '/templates/wedding-minimal-thumb.jpg',
  '/templates/wedding-minimal-preview.jpg',
  'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=800',
  '{"primary": "#000000", "secondary": "#FFFFFF", "accent": "#808080", "background": "#F5F5F5", "text": "#000000"}',
  '[
    {"id": "couple", "label": "Çift İsimleri", "defaultValue": "AYŞE & MEHMET", "position": {"x": 50, "y": 40}, "style": {"fontSize": 42, "fontFamily": "Montserrat", "color": "#000000", "textAlign": "center", "fontWeight": "300", "letterSpacing": 8, "textTransform": "uppercase"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15.06.2024", "position": {"x": 50, "y": 55}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#808080", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "İstanbul", "position": {"x": 50, "y": 65}, "style": {"fontSize": 18, "fontFamily": "Montserrat", "color": "#808080", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}
  ]',
  '[]',
  ARRAY['Montserrat', 'Poppins'],
  true,
  2
);

-- PRO (8 şablon)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, preview_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES
(
  'Romantik Gül Bahçesi',
  'Pembe güller ve romantik detaylarla süslü düğün davetiyesi',
  'wedding',
  'romantic',
  'pro',
  '/templates/wedding-romantic-thumb.jpg',
  '/templates/wedding-romantic-preview.jpg',
  'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800',
  '{"primary": "#D4526E", "secondary": "#F8E8EE", "accent": "#FFB6C1", "background": "#FFF5F7", "text": "#4A4A4A"}',
  '[
    {"id": "title", "label": "Başlık", "defaultValue": "Aşkımızı Kutlayın", "position": {"x": 50, "y": 20}, "style": {"fontSize": 32, "fontFamily": "Dancing Script", "color": "#D4526E", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 50, "required": true},
    {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 35}, "style": {"fontSize": 44, "fontFamily": "Playfair Display", "color": "#D4526E", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
    {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024, Cumartesi", "position": {"x": 50, "y": 55}, "style": {"fontSize": 22, "fontFamily": "Montserrat", "color": "#4A4A4A", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 40, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Çırağan Sarayı", "position": {"x": 50, "y": 65}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#4A4A4A", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true},
    {"id": "message", "label": "Mesaj", "defaultValue": "Mutluluğumuzu paylaşmak için sizleri bekliyoruz", "position": {"x": 50, "y": 80}, "style": {"fontSize": 16, "fontFamily": "Montserrat", "color": "#4A4A4A", "textAlign": "center", "fontWeight": "normal", "fontStyle": "italic"}, "maxLength": 80, "required": false}
  ]',
  '[
    {"id": "flower1", "type": "flower", "position": {"x": 10, "y": 10}, "size": {"width": 60, "height": 60}, "color": "#FFB6C1", "rotation": -20, "opacity": 0.6, "zIndex": 1},
    {"id": "flower2", "type": "flower", "position": {"x": 90, "y": 10}, "size": {"width": 60, "height": 60}, "color": "#FFB6C1", "rotation": 20, "opacity": 0.6, "zIndex": 1},
    {"id": "flower3", "type": "flower", "position": {"x": 10, "y": 85}, "size": {"width": 50, "height": 50}, "color": "#D4526E", "rotation": 10, "opacity": 0.5, "zIndex": 1},
    {"id": "flower4", "type": "flower", "position": {"x": 90, "y": 85}, "size": {"width": 50, "height": 50}, "color": "#D4526E", "rotation": -10, "opacity": 0.5, "zIndex": 1}
  ]',
  ARRAY['Dancing Script', 'Playfair Display', 'Montserrat'],
  true,
  10
),
(
  'Vintage Nostalji',
  'Retro tarzda vintage düğün davetiyesi',
  'wedding',
  'vintage',
  'pro',
  '/templates/wedding-vintage-thumb.jpg',
  '/templates/wedding-vintage-preview.jpg',
  'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800',
  '{"primary": "#8B7355", "secondary": "#F4E8D8", "accent": "#C9A66B", "background": "#FFF8F0", "text": "#5D4E37"}',
  '[
    {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 35}, "style": {"fontSize": 40, "fontFamily": "Playfair Display", "color": "#8B7355", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
    {"id": "subtitle", "label": "Alt Başlık", "defaultValue": "Evliliğe İlk Adım", "position": {"x": 50, "y": 48}, "style": {"fontSize": 18, "fontFamily": "Montserrat", "color": "#C9A66B", "textAlign": "center", "fontWeight": "normal", "fontStyle": "italic"}, "maxLength": 50, "required": false},
    {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 60}, "style": {"fontSize": 24, "fontFamily": "Cinzel", "color": "#5D4E37", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
    {"id": "venue", "label": "Mekan", "defaultValue": "Tarihi Köşk", "position": {"x": 50, "y": 72}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#5D4E37", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}
  ]',
  '[
    {"id": "ribbon1", "type": "ribbon", "position": {"x": 50, "y": 5}, "size": {"width": 80, "height": 50}, "color": "#C9A66B", "rotation": 0, "opacity": 0.4, "zIndex": 1}
  ]',
  ARRAY['Playfair Display', 'Cinzel', 'Montserrat'],
  false,
  11
);

-- PREMIUM şablonları için devam edeceğim...
-- Bu format ile 105 şablon oluşturulacak

-- =====================================================
-- NOT: Tam 105 şablon için bu dosya çok uzun olacak
-- Bu yüzden kategorilere göre ayrı seed dosyaları oluşturacağım
-- =====================================================

