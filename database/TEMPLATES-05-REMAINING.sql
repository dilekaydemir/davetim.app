-- =====================================================
-- REMAINING CATEGORIES (57 templates)
-- =====================================================
-- Mezuniyet, İş Etkinliği, Yıldönümü, Kına, Sünnet, Kutlamalar, Nişan Yemeği, Bekarlığa Veda

-- Önce mevcut template'leri temizle
DELETE FROM public.templates WHERE category IN ('graduation', 'corporate', 'anniversary', 'henna', 'circumcision', 'celebration', 'engagement_dinner', 'bachelor_party');

-- =====================================================
-- CATEGORY 5: MEZUNİYET (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- FREE (3)
('Klasik Mezuniyet', 'Sade ve şık mezuniyet davetiyesi', 'graduation', 'classic', 'free',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&h=600&fit=crop',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 49),

('Modern Mezuniyet', 'Çağdaş ve minimalist mezuniyet', 'graduation', 'modern', 'free',
'https://images.unsplash.com/photo-1627556704283-54fc5b7d3263?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1627556704283-54fc5b7d3263?w=800&h=600&fit=crop',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Raleway", "Poppins", "Open Sans"}', true, 50),

('Renkli Mezuniyet', 'Neşeli ve renkli mezuniyet', 'graduation', 'colorful', 'free',
'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Montserrat"}', false, 51),

-- PRO (3)
('Lüks Mezuniyet', 'Altın detaylı mezuniyet töreni', 'graduation', 'luxury', 'pro',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&h=600&fit=crop',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "degree_info", "label": "Diploma Bilgisi", "defaultValue": "Bilgisayar Mühendisliği Mezuniyeti", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Montserrat"}', true, 52),

('Üniversite Mezuniyeti', 'Üniversite mezuniyet kutlaması', 'graduation', 'university', 'pro',
'https://images.unsplash.com/photo-1627556704283-54fc5b7d3263?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1627556704283-54fc5b7d3263?w=800&h=600&fit=crop',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "university_name", "label": "Üniversite", "defaultValue": "İstanbul Üniversitesi", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 53),

('Lise Mezuniyeti', 'Lise mezuniyet balosu', 'graduation', 'high_school', 'pro',
'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=800&h=600&fit=crop',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "school_name", "label": "Okul Adı", "defaultValue": "İstanbul Lisesi", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Poppins"}}]',
'[]', '{"Poppins", "Montserrat", "Raleway"}', false, 54),

-- PREMIUM (2)
('Doktora Mezuniyeti', 'Doktora derecesi töreni', 'graduation', 'phd', 'premium',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "phd_field", "label": "Doktora Alanı", "defaultValue": "Doktor unvanıyla onurlandırıyoruz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 55),

('MBA Mezuniyeti', 'MBA mezuniyet töreni', 'graduation', 'mba', 'premium',
'https://images.unsplash.com/photo-1627556704283-54fc5b7d3263?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1627556704283-54fc5b7d3263?w=800&h=600&fit=crop',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "mba_program", "label": "MBA Programı", "defaultValue": "Executive MBA Programı Mezuniyeti", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 56);

-- =====================================================
-- CATEGORY 6: İŞ ETKİNLİĞİ (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- FREE (3)
('Kurumsal Etkinlik', 'Profesyonel iş etkinliği', 'corporate', 'business', 'free',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop',
'{"primary": "#1976D2", "secondary": "#1E88E5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 57),

('Konferans', 'Konferans ve seminer davetiyesi', 'corporate', 'conference', 'free',
'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800&h=600&fit=crop',
'{"primary": "#37474F", "secondary": "#455A64", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[]', '[]', '{"Raleway", "Open Sans", "Poppins"}', true, 58),

('Toplantı', 'İş toplantısı daveti', 'corporate', 'meeting', 'free',
'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=800&h=600&fit=crop',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#4CAF50"}',
'[]', '[]', '{"Open Sans", "Roboto", "Lato"}', false, 59),

-- PRO (3)
('Gala Yemeği', 'Kurumsal gala yemeği', 'corporate', 'gala', 'pro',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "gala_theme", "label": "Gala Teması", "defaultValue": "Yılın En Başarılı Yöneticileri Ödül Töreni", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Montserrat"}', true, 60),

('Ürün Lansmanı', 'Yeni ürün tanıtım etkinliği', 'corporate', 'product_launch', 'pro',
'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#EC407A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[{"id": "product_name", "label": "Ürün Adı", "defaultValue": "Yeni Ürünümüzü Sizlerle Tanıştırıyoruz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 61),

('Networking Etkinliği', 'İş ağı oluşturma etkinliği', 'corporate', 'networking', 'pro',
'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=800&h=600&fit=crop',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "networking_theme", "label": "Networking", "defaultValue": "İş Dünyası Liderleriyle Buluşma", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Raleway"}}]',
'[]', '{"Raleway", "Open Sans", "Poppins"}', false, 62),

-- PREMIUM (2)
('VIP Ödül Töreni', 'Prestijli ödül töreni', 'corporate', 'award_ceremony', 'premium',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "award_category", "label": "Ödül Kategorisi", "defaultValue": "VIP Yılın Başarı Ödülleri", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 63),

('CEO Zirvesi', 'Üst düzey yönetici zirvesi', 'corporate', 'ceo_summit', 'premium',
'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800&h=600&fit=crop',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[{"id": "summit_topic", "label": "Zirve Konusu", "defaultValue": "Geleceğin Liderleri CEO Zirvesi", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 64);

-- Continue with remaining categories (Anniversary, Henna, etc.) in next batch...
-- This is getting long, splitting to Part 2

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE 'Graduation and Corporate templates created (16 templates)!';
END $$;

