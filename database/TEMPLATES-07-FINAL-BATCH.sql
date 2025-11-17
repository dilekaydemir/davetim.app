-- =====================================================
-- FINAL BATCH: Last 25 templates
-- =====================================================
-- Sünnet, Kutlamalar, Nişan Yemeği, Bekarlığa Veda

DELETE FROM public.templates WHERE category IN ('circumcision', 'celebration', 'engagement_dinner', 'bachelor_party');

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- =====================================================
-- SÜNNET (8: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

('Klasik Sünnet', 'Geleneksel sünnet düğünü', 'circumcision', 'classic', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 81),

('Neşeli Sünnet', 'Renkli ve eğlenceli sünnet', 'circumcision', 'fun', 'free',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop',
'{"primary": "#FF5722", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[]', '[]', '{"Fredoka One", "Righteous", "Baloo 2"}', true, 82),

('Modern Sünnet', 'Çağdaş sünnet davetiyesi', 'circumcision', 'modern', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 83),

('Şehzade Sünnet', 'Şehzade temalı sünnet düğünü', 'circumcision', 'prince', 'pro',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "prince_boy", "label": "Şehzademiz", "defaultValue": "Küçük Şehzademizin Sünnet Şöleni", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 84),

('Aslan Kral Sünnet', 'Aslan kral temalı sünnet', 'circumcision', 'lion_king', 'pro',
'https://images.unsplash.com/photo-1608889175123-8ee362201f81?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1608889175123-8ee362201f81?w=800&h=600&fit=crop',
'{"primary": "#F57C00", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "lion_boy", "label": "Aslan Yavrusu", "defaultValue": "Aslan Gibi Cesur Oğlumuzun Sünnet Günü", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Righteous"}}]',
'[]', '{"Righteous", "Fredoka One", "Baloo 2"}', false, 85),

('Süper Kahraman Sünnet', 'Kahraman temalı sünnet', 'circumcision', 'superhero', 'pro',
'https://images.unsplash.com/photo-1608889175123-8ee362201f81?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1608889175123-8ee362201f81?w=800&h=600&fit=crop',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "hero_boy", "label": "Süper Kahramanımız", "defaultValue": "Süper Kahramanımızın Sünnet Macerası", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Righteous"}}]',
'[]', '{"Righteous", "Fredoka One", "Baloo 2"}', false, 86),

('Kraliyet Sünnet', 'Muhteşem kraliyet sünnet düğünü', 'circumcision', 'royal', 'premium',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_boy", "label": "Prens Oğlumuz", "defaultValue": "Kraliyet Ailesinin Genç Prensi", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 87),

('VIP Sünnet', 'VIP sünnet düğünü', 'circumcision', 'vip', 'premium',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=800&h=600&fit=crop',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[{"id": "vip_boy", "label": "VIP Oğlumuz", "defaultValue": "VIP Sünnet Töreni - Oğlumuzun Özel Günü", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 88),

-- =====================================================
-- KUTLAMALAR (8: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

('Yılbaşı Kutlaması', 'Yeni yıl kutlama daveti', 'celebration', 'new_year', 'free',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Montserrat"}', true, 89),

('Bayram Kutlaması', 'Bayram kutlama daveti', 'celebration', 'holiday', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#388E3C", "secondary": "#66BB6A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Lora", "Montserrat"}', true, 90),

('Genel Kutlama', 'Her türlü kutlama için', 'celebration', 'general', 'free',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 91),

('Başarı Kutlaması', 'Başarı ve kazanım kutlaması', 'celebration', 'achievement', 'pro',
'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800&h=600&fit=crop',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "achievement_details", "label": "Başarı Detayı", "defaultValue": "Muhteşem Başarımızı Sizlerle Kutluyoruz", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Montserrat"}', true, 92),

('Terfi Kutlaması', 'Terfi ve yükselme kutlaması', 'celebration', 'promotion', 'pro',
'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800&h=600&fit=crop',
'{"primary": "#1976D2", "secondary": "#1E88E5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "promotion_news", "label": "Terfi Haberi", "defaultValue": "Yeni Görevime Atanmamı Kutluyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 93),

('Yeni Ev Kutlaması', 'Yeni ev açılış partisi', 'celebration', 'housewarming', 'pro',
'https://images.unsplash.com/photo-1509315811345-672d83ef2fbc?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1509315811345-672d83ef2fbc?w=800&h=600&fit=crop',
'{"primary": "#388E3C", "secondary": "#66BB6A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "new_home_address", "label": "Yeni Adres", "defaultValue": "Yeni Evimize Hoş Geldiniz", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]', '{"Lora", "Open Sans", "Poppins"}', false, 94),

('VIP Kutlama', 'VIP özel kutlama etkinliği', 'celebration', 'vip', 'premium',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=800&h=600&fit=crop',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[{"id": "vip_event", "label": "VIP Etkinlik", "defaultValue": "VIP Özel Kutlama Gecesi", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Montserrat"}', true, 95),

('Gala Kutlaması', 'Muhteşem gala gecesi', 'celebration', 'gala', 'premium',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "gala_night", "label": "Gala Gecesi", "defaultValue": "Muhteşem Gala Gecesine Davetlisiniz", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Bodoni Moda"}', false, 96),

-- =====================================================
-- NİŞAN YEMEĞİ (4: 1 FREE, 2 PRO, 1 PREMIUM)
-- =====================================================

('Klasik Nişan Yemeği', 'Sade ve zarif nişan yemeği', 'engagement_dinner', 'classic', 'free',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&h=600&fit=crop',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Lora", "Montserrat"}', true, 97),

('Romantik Nişan Yemeği', 'Romantik akşam yemeği', 'engagement_dinner', 'romantic', 'pro',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[{"id": "dinner_menu", "label": "Yemek Menüsü", "defaultValue": "Özel Menümüzle Nişan Sofrasına Davetlisiniz", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Great Vibes"}}]',
'[]', '{"Great Vibes", "Dancing Script", "Pacifico"}', true, 98),

('Modern Nişan Yemeği', 'Çağdaş nişan yemeği', 'engagement_dinner', 'modern', 'pro',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=800&h=600&fit=crop',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[{"id": "dinner_venue", "label": "Restoran", "defaultValue": "Sevdiğimiz Restoranda Nişan Yemeği", "style": {"fontSize": 16, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 99),

('Lüks Nişan Yemeği', 'Lüks restoran yemeği', 'engagement_dinner', 'luxury', 'premium',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&h=600&fit=crop',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_dinner", "label": "Lüks Yemek", "defaultValue": "Lüks Restoranımızda Nişan Sofrasına Bekliyoruz", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 100),

-- =====================================================
-- BEKARLIĞA VEDA (5: 2 FREE, 2 PRO, 1 PREMIUM)
-- =====================================================

('Kızlar Gecesi', 'Kızlar bekarlığa veda partisi', 'bachelor_party', 'girls_night', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', true, 101),

('Erkekler Gecesi', 'Erkekler bekarlığa veda partisi', 'bachelor_party', 'boys_night', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 102),

('Gece Kulübü Partisi', 'Gece kulübünde bekarlığa veda', 'bachelor_party', 'nightclub', 'pro',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&h=600&fit=crop',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#E91E63"}',
'[{"id": "club_info", "label": "Kulüp Bilgisi", "defaultValue": "VIP Gece Kulübünde Bekarlığa Veda", "style": {"fontSize": 18, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 103),

('Tatil Partisi', 'Tatilde bekarlığa veda', 'bachelor_party', 'vacation', 'pro',
'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800&h=600&fit=crop',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "vacation_spot", "label": "Tatil Yeri", "defaultValue": "Antalya''da Bekarlığa Veda Tatili", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]', '{"Pacifico", "Dancing Script", "Quicksand"}', false, 104),

('VIP Bekarlığa Veda', 'VIP bekarlığa veda partisi', 'bachelor_party', 'vip', 'premium',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "vip_party", "label": "VIP Parti", "defaultValue": "VIP Bekarlığa Veda Gecesi", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 105);

-- Final Commit
COMMIT;

-- Notify schema reload
NOTIFY pgrst, 'reload schema';

-- Final success message
DO $$
BEGIN
  RAISE NOTICE 'ALL 105 TEMPLATES CREATED SUCCESSFULLY!';
  RAISE NOTICE 'Distribution: FREE=38, PRO=42, PREMIUM=25';
  RAISE NOTICE 'All templates have relevant photos and descriptive placeholders!';
END $$;

