-- =====================================================
-- SON 25 TEMPLATE - PART 3
-- =====================================================
-- Henna (7), Circumcision (7), Celebration (8),
-- Engagement Dinner (5), Bachelor Party (6)

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- ===============================
-- KINA GECESİ (7)
-- ===============================
('Geleneksel Kına', 'Geleneksel kına gecesi', 'henna', 'traditional', 'free',
'henna/traditional.jpg', 'henna/traditional.jpg',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Lora", "Cormorant Garamond"}', true, 73),

('Modern Kına', 'Modern kına gecesi', 'henna', 'modern', 'free',
'henna/modern.jpg', 'henna/modern.jpg',
'{"primary": "#880E4F", "secondary": "#AD1457", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F48FB1"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 74),

('Romantik Kına', 'Romantik kına gecesi', 'henna', 'romantic', 'free',
'henna/romantic.jpg', 'henna/romantic.jpg',
'{"primary": "#D81B60", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', false, 75),

('Lüks Kına', 'Altın detaylı lüks kına', 'henna', 'luxury', 'pro',
'henna/luxury.jpg', 'henna/luxury.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "henna_night", "label": "Kına Gecesi", "defaultValue": "Gelinimizin kına gecesi", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Lora"}', true, 76),

('Bohem Kına', 'Özgür ruhlu kına', 'henna', 'bohemian', 'pro',
'henna/bohemian.jpg', 'henna/bohemian.jpg',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "boho_henna", "label": "Bohem Kına", "defaultValue": "Özgür ruhlu kına eğlencesi", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Satisfy", "Lato"}', false, 77),

('Kraliyet Kınası', 'Muhteşem kraliyet kınası', 'henna', 'royal', 'premium',
'henna/royal.jpg', 'henna/royal.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_henna", "label": "Kraliyet Kınası", "defaultValue": "Kraliyet kına töreni", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 78),

('Saray Kınası', 'Saray temalı kına', 'henna', 'palace', 'premium',
'henna/palace.jpg', 'henna/palace.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "palace_henna", "label": "Saray Kınası", "defaultValue": "Saray usulü kına eğlencesi", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Lora"}', false, 79),

-- ===============================
-- SÜNNET (7)
-- ===============================
('Klasik Sünnet', 'Geleneksel sünnet töreni', 'circumcision', 'traditional', 'free',
'circumcision/traditional.jpg', 'circumcision/traditional.jpg',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 80),

('Modern Sünnet', 'Modern sünnet töreni', 'circumcision', 'modern', 'free',
'circumcision/modern.jpg', 'circumcision/modern.jpg',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]', '{"Poppins", "Montserrat", "Raleway"}', true, 81),

('Renkli Sünnet', 'Neşeli renkli sünnet', 'circumcision', 'colorful', 'free',
'circumcision/colorful.jpg', 'circumcision/colorful.jpg',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', false, 82),

('Lüks Sünnet', 'Altın detaylı lüks sünnet', 'circumcision', 'luxury', 'pro',
'circumcision/luxury.jpg', 'circumcision/luxury.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_circumcision", "label": "Lüks Sünnet", "defaultValue": "Şehzademizin sünnet töreni", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Montserrat"}', true, 83),

('Şehzade Sünnet', 'Şehzade temalı sünnet', 'circumcision', 'prince', 'pro',
'circumcision/prince.jpg', 'circumcision/prince.jpg',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "prince_theme", "label": "Şehzade Teması", "defaultValue": "Küçük şehzademiz", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 84),

('Kraliyet Sünneti', 'Kraliyet töreni', 'circumcision', 'royal', 'premium',
'circumcision/royal.jpg', 'circumcision/royal.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_circumcision", "label": "Kraliyet Töreni", "defaultValue": "Kraliyet sünnet töreni", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 85),

('Saray Sünneti', 'Saray temalı sünnet', 'circumcision', 'palace', 'premium',
'circumcision/palace.jpg', 'circumcision/palace.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "palace_circumcision", "label": "Saray Töreni", "defaultValue": "Saray usulü sünnet", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Montserrat"}', false, 86),

-- ===============================
-- KUTLAMALAR (8)
-- ===============================
('Neşeli Kutlama', 'Renkli kutlama', 'celebration', 'fun', 'free',
'celebration/fun.jpg', 'celebration/fun.jpg',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 87),

('Modern Kutlama', 'Şık modern kutlama', 'celebration', 'modern', 'free',
'celebration/modern.jpg', 'celebration/modern.jpg',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 88),

('Yılbaşı Partisi', 'Yeni yıl kutlaması', 'celebration', 'new_year', 'free',
'celebration/new_year.jpg', 'celebration/new_year.jpg',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Montserrat", "Poppins", "Raleway"}', false, 89),

('Lüks Kutlama', 'Altın detaylı kutlama', 'celebration', 'luxury', 'pro',
'celebration/luxury.jpg', 'celebration/luxury.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "celebration_theme", "label": "Kutlama Teması", "defaultValue": "Özel günümüzü kutluyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Montserrat"}', true, 90),

('Açılış Töreni', 'İş yeri açılışı', 'celebration', 'opening', 'pro',
'celebration/opening.jpg', 'celebration/opening.jpg',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "opening_ceremony", "label": "Açılış", "defaultValue": "Yeni işyerimizin açılışı", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 91),

('Başarı Kutlaması', 'Başarı töreni', 'celebration', 'achievement', 'pro',
'celebration/achievement.jpg', 'celebration/achievement.jpg',
'{"primary": "#1976D2", "secondary": "#1E88E5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "achievement", "label": "Başarı", "defaultValue": "Başarımızı kutluyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 92),

('VIP Gala', 'VIP gala kutlaması', 'celebration', 'vip_gala', 'premium',
'celebration/vip_gala.jpg', 'celebration/vip_gala.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "vip_gala", "label": "VIP Gala", "defaultValue": "VIP gala gecesi", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 93),

('Kraliyet Kutlaması', 'Muhteşem kraliyet kutlaması', 'celebration', 'royal', 'premium',
'celebration/royal.jpg', 'celebration/royal.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_celebration", "label": "Kraliyet Kutlaması", "defaultValue": "Kraliyet kutlaması", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Montserrat"}', false, 94),

-- ===============================
-- NİŞAN YEMEĞİ (5)
-- ===============================
('Klasik Nişan Yemeği', 'Zarif nişan yemeği', 'engagement_dinner', 'classic', 'free',
'engagement_dinner/classic.jpg', 'engagement_dinner/classic.jpg',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Lora", "Montserrat"}', true, 95),

('Modern Nişan Yemeği', 'Minimalist yemek', 'engagement_dinner', 'modern', 'free',
'engagement_dinner/modern.jpg', 'engagement_dinner/modern.jpg',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 96),

('Lüks Nişan Yemeği', 'Altın detaylı yemek', 'engagement_dinner', 'luxury', 'pro',
'engagement_dinner/luxury.jpg', 'engagement_dinner/luxury.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "dinner_menu", "label": "Yemek Menüsü", "defaultValue": "Özel menü ve içecekler", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Lora"}', false, 97),

('Romantik Nişan Yemeği', 'Romantik akşam yemeği', 'engagement_dinner', 'romantic', 'pro',
'engagement_dinner/romantic.jpg', 'engagement_dinner/romantic.jpg',
'{"primary": "#D81B60", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "romantic_dinner", "label": "Romantik Yemek", "defaultValue": "Mumların ışığında yemek", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', false, 98),

('Kraliyet Nişan Yemeği', 'Muhteşem yemek', 'engagement_dinner', 'royal', 'premium',
'engagement_dinner/royal.jpg', 'engagement_dinner/royal.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_dinner", "label": "Kraliyet Yemeği", "defaultValue": "Kraliyet sofrası", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 99),

-- ===============================
-- BEKARLIĞA VEDA (6)
-- ===============================
('Klasik Bekarlığa Veda', 'Erkekler için veda', 'bachelor_party', 'classic', 'free',
'bachelor_party/classic.jpg', 'bachelor_party/classic.jpg',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 100),

('Kızlar Gecesi', 'Kızlar için veda', 'bachelor_party', 'girls_night', 'free',
'bachelor_party/girls_night.jpg', 'bachelor_party/girls_night.jpg',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', true, 101),

('Gece Kulübü Veda', 'Kulüp partisi', 'bachelor_party', 'nightclub', 'pro',
'bachelor_party/nightclub.jpg', 'bachelor_party/nightclub.jpg',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#E91E63"}',
'[{"id": "club_night", "label": "Kulüp Gecesi", "defaultValue": "Gece kulübünde son eğlence", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 102),

('Spa Günü', 'Kızlar spa günü', 'bachelor_party', 'spa', 'pro',
'bachelor_party/spa.jpg', 'bachelor_party/spa.jpg',
'{"primary": "#00897B", "secondary": "#26A69A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "spa_day", "label": "Spa Günü", "defaultValue": "Rahatlatıcı spa günü", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]', '{"Lora", "Quicksand", "Open Sans"}', false, 103),

('VIP Bekarlığa Veda', 'VIP parti', 'bachelor_party', 'vip', 'premium',
'bachelor_party/vip.jpg', 'bachelor_party/vip.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "vip_party", "label": "VIP Parti", "defaultValue": "VIP bekarlığa veda", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 104),

('Yat Partisi', 'Yatta lüks veda', 'bachelor_party', 'yacht', 'premium',
'bachelor_party/yacht.jpg', 'bachelor_party/yacht.jpg',
'{"primary": "#006064", "secondary": "#00838F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "yacht_party", "label": "Yat Partisi", "defaultValue": "Yatta lüks parti", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Montserrat", "Cinzel"}', false, 105);

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE '✅ ALL 105 TEMPLATES CREATED SUCCESSFULLY!';
  RAISE NOTICE 'Distribution: FREE=38, PRO=42, PREMIUM=25';
  RAISE NOTICE '12 Categories: Wedding, Engagement, Birthday, Baby Shower, Graduation, Corporate, Anniversary, Henna, Circumcision, Celebration, Engagement Dinner, Bachelor Party';
  RAISE NOTICE 'All templates use Supabase Storage paths: {category}/{subcategory}.jpg';
  RAISE NOTICE '🚀 Templates are ready to use!';
END $$;

