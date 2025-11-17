-- =====================================================
-- KALAN TEMPLATE'LER - PART 2 (41 Template)
-- =====================================================
-- Yıldönümü (8), Kına (7), Sünnet (7), Kutlamalar (8), Nişan Yemeği (5), Bekarlığa Veda (6)

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- ===============================
-- YILDONÜMÜ (8: 3 FREE, 3 PRO, 2 PREMIUM)
-- ===============================
('Romantik Yıldönümü', 'Romantik evlilik yıldönümü', 'anniversary', 'romantic', 'free',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800&h=600&fit=crop&q=80',
'{"primary": "#D81B60", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Great Vibes", "Lora"}', true, 65),

('Modern Yıldönümü', 'Minimalist yıldönümü', 'anniversary', 'modern', 'free',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=800&h=600&fit=crop&q=80',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 66),

('25. Yıl Yıldönümü', 'Gümüş yıldönümü', 'anniversary', 'silver', 'free',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=800&h=600&fit=crop&q=80',
'{"primary": "#607D8B", "secondary": "#90A4AE", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[]', '[]', '{"Playfair Display", "Lora", "Montserrat"}', false, 67),

('Altın Yıldönümü', '50. yıl altın', 'anniversary', 'golden', 'pro',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800&h=600&fit=crop&q=80',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "golden_years", "label": "50 Yıl", "defaultValue": "50 yıllık mutlu evlilik", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 68),

('Vintage Yıldönümü', 'Nostaljik yıldönümü', 'anniversary', 'vintage', 'pro',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=800&h=600&fit=crop&q=80',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_love", "label": "Eski Aşk", "defaultValue": "Yılların verdiği olgunluk", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 69),

('Bahçe Yıldönümü', 'Doğada yıldönümü', 'anniversary', 'garden', 'pro',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800&h=600&fit=crop&q=80',
'{"primary": "#388E3C", "secondary": "#66BB6A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "garden_love", "label": "Bahçe Aşkı", "defaultValue": "Doğanın güzelliğinde kutluyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]', '{"Lora", "Open Sans", "Raleway"}', false, 70),

('Kraliyet Yıldönümü', 'Muhteşem yıldönümü', 'anniversary', 'royal', 'premium',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=800&h=600&fit=crop&q=80',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_years", "label": "Kraliyet Yılları", "defaultValue": "Kraliyet çifti kutluyor", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 71),

('Elmas Yıldönümü', '60. yıl elmas', 'anniversary', 'diamond', 'premium',
'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=800&h=600&fit=crop&q=80',
'{"primary": "#455A64", "secondary": "#607D8B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "diamond_love", "label": "Elmas Aşk", "defaultValue": "60 yıllık elmas evlilik", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Montserrat"}', false, 72),

-- ===============================
-- KINA GECESİ (7: 3 FREE, 2 PRO, 2 PREMIUM)
-- ===============================
('Geleneksel Kına', 'Geleneksel kına gecesi', 'henna', 'traditional', 'free',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=800&h=600&fit=crop&q=80',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Lora", "Cormorant Garamond"}', true, 73),

('Modern Kına', 'Modern kına gecesi', 'henna', 'modern', 'free',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&h=600&fit=crop&q=80',
'{"primary": "#880E4F", "secondary": "#AD1457", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F48FB1"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 74),

('Romantik Kına', 'Romantik kına', 'henna', 'romantic', 'free',
'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=800&h=600&fit=crop&q=80',
'{"primary": "#D81B60", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', false, 75),

('Lüks Kına', 'Altın detaylı kına', 'henna', 'luxury', 'pro',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800&h=600&fit=crop&q=80',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "henna_night", "label": "Kına Gecesi", "defaultValue": "Gelinimizin kına gecesi", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Lora"}', true, 76),

('Bohem Kına', 'Özgür ruhlu kına', 'henna', 'bohemian', 'pro',
'https://images.unsplash.com/photo-1523438097201-512ae7d59c44?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1523438097201-512ae7d59c44?w=800&h=600&fit=crop&q=80',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "boho_henna", "label": "Bohem Kına", "defaultValue": "Özgür ruhlu kına eğlencesi", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Satisfy", "Lato"}', false, 77),

('Kraliyet Kınası', 'Muhteşem kına', 'henna', 'royal', 'premium',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=800&h=600&fit=crop&q=80',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_henna", "label": "Kraliyet Kınası", "defaultValue": "Kraliyet kına töreni", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 78),

('Saray Kınası', 'Saray temalı kına', 'henna', 'palace', 'premium',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800&h=600&fit=crop&q=80',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "palace_henna", "label": "Saray Kınası", "defaultValue": "Saray usulü kına eğlencesi", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Lora"}', false, 79),

-- ===============================
-- SÜNNET (7: 3 FREE, 2 PRO, 2 PREMIUM)
-- ===============================
('Klasik Sünnet', 'Geleneksel sünnet', 'circumcision', 'traditional', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop&q=80',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 80),

('Modern Sünnet', 'Modern sünnet', 'circumcision', 'modern', 'free',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=800&h=600&fit=crop&q=80',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]', '{"Poppins", "Montserrat", "Raleway"}', true, 81),

('Renkli Sünnet', 'Neşeli sünnet', 'circumcision', 'colorful', 'free',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop&q=80',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', false, 82),

('Lüks Sünnet', 'Altın detaylı sünnet', 'circumcision', 'luxury', 'pro',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop&q=80',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_circumcision", "label": "Lüks Sünnet", "defaultValue": "Şehzademizin sünnet töreni", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Montserrat"}', true, 83),

('Şehzade Sünnet', 'Şehzade temalı', 'circumcision', 'prince', 'pro',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=800&h=600&fit=crop&q=80',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "prince_theme", "label": "Şehzade", "defaultValue": "Küçük şehzademiz", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 84),

('Kraliyet Sünneti', 'Kraliyet töreni', 'circumcision', 'royal', 'premium',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop&q=80',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_circumcision", "label": "Kraliyet", "defaultValue": "Kraliyet sünnet töreni", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 85),

('Saray Sünneti', 'Saray temalı sünnet', 'circumcision', 'palace', 'premium',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=800&h=600&fit=crop&q=80',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "palace_circumcision", "label": "Saray", "defaultValue": "Saray usulü sünnet", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Montserrat"}', false, 86),

-- ===============================
-- KUTLAMALAR (8: 3 FREE, 3 PRO, 2 PREMIUM)
-- ===============================
('Neşeli Kutlama', 'Renkli kutlama', 'celebration', 'fun', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop&q=80',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 87),

('Modern Kutlama', 'Şık kutlama', 'celebration', 'modern', 'free',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop&q=80',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 88),

('Yılbaşı Partisi', 'Yeni yıl kutlaması', 'celebration', 'new_year', 'free',
'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=800&h=600&fit=crop&q=80',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Montserrat", "Poppins", "Raleway"}', false, 89),

('Lüks Kutlama', 'Altın detaylı kutlama', 'celebration', 'luxury', 'pro',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=800&h=600&fit=crop&q=80',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "celebration_theme", "label": "Kutlama", "defaultValue": "Özel günümüzü kutluyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Montserrat"}', true, 90),

('Açılış Töreni', 'İş açılışı', 'celebration', 'opening', 'pro',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop&q=80',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "opening_ceremony", "label": "Açılış", "defaultValue": "Yeni işyerimizin açılışı", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 91),

('Başarı Kutlaması', 'Başarı töreni', 'celebration', 'achievement', 'pro',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&h=600&fit=crop&q=80',
'{"primary": "#1976D2", "secondary": "#1E88E5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "achievement", "label": "Başarı", "defaultValue": "Başarımızı kutluyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 92),

('VIP Gala', 'VIP gala kutlaması', 'celebration', 'vip_gala', 'premium',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop&q=80',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "vip_gala", "label": "VIP Gala", "defaultValue": "VIP gala gecesi", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 93),

('Kraliyet Kutlaması', 'Muhteşem kutlama', 'celebration', 'royal', 'premium',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=800&h=600&fit=crop&q=80',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_celebration", "label": "Kraliyet", "defaultValue": "Kraliyet kutlaması", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Montserrat"}', false, 94),

-- ===============================
-- NİŞAN YEMEĞİ (5: 2 FREE, 2 PRO, 1 PREMIUM)
-- ===============================
('Klasik Nişan Yemeği', 'Zarif nişan yemeği', 'engagement_dinner', 'classic', 'free',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop&q=80',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Lora", "Montserrat"}', true, 95),

('Modern Nişan Yemeği', 'Minimalist yemek', 'engagement_dinner', 'modern', 'free',
'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=800&h=600&fit=crop&q=80',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 96),

('Lüks Nişan Yemeği', 'Altın detaylı yemek', 'engagement_dinner', 'luxury', 'pro',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop&q=80',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "dinner_menu", "label": "Yemek", "defaultValue": "Özel menü ve içecekler", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Lora"}', false, 97),

('Romantik Nişan Yemeği', 'Romantik akşam yemeği', 'engagement_dinner', 'romantic', 'pro',
'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=800&h=600&fit=crop&q=80',
'{"primary": "#D81B60", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "romantic_dinner", "label": "Romantik Yemek", "defaultValue": "Mumların ışığında yemek", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', false, 98),

('Kraliyet Nişan Yemeği', 'Muhteşem yemek', 'engagement_dinner', 'royal', 'premium',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop&q=80',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_dinner", "label": "Kraliyet Yemeği", "defaultValue": "Kraliyet sofrası", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 99),

-- ===============================
-- BEKARLIĞA VEDA (6: 2 FREE, 2 PRO, 2 PREMIUM)
-- ===============================
('Klasik Bekarlığa Veda', 'Erkekler için veda', 'bachelor_party', 'classic', 'free',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&h=600&fit=crop&q=80',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 100),

('Kızlar Gecesi', 'Kızlar için veda', 'bachelor_party', 'girls_night', 'free',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=800&h=600&fit=crop&q=80',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', true, 101),

('Gece Kulübü Veda', 'Kulüp partisi', 'bachelor_party', 'nightclub', 'pro',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&h=600&fit=crop&q=80',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#E91E63"}',
'[{"id": "club_night", "label": "Kulüp Gecesi", "defaultValue": "Gece kulübünde son eğlence", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 102),

('Spa Günü', 'Kızlar spa günü', 'bachelor_party', 'spa', 'pro',
'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800&h=600&fit=crop&q=80',
'{"primary": "#00897B", "secondary": "#26A69A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "spa_day", "label": "Spa", "defaultValue": "Rahatlatıcı spa günü", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]', '{"Lora", "Quicksand", "Open Sans"}', false, 103),

('VIP Bekarlığa Veda', 'VIP parti', 'bachelor_party', 'vip', 'premium',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&h=600&fit=crop&q=80',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "vip_party", "label": "VIP", "defaultValue": "VIP bekarlığa veda", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 104),

('Yat Partisi', 'Yatta lüks veda', 'bachelor_party', 'yacht', 'premium',
'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800&h=600&fit=crop&q=80',
'{"primary": "#006064", "secondary": "#00838F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "yacht_party", "label": "Yat", "defaultValue": "Yatta lüks parti", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Montserrat", "Cinzel"}', false, 105);

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE 'ALL 105 TEMPLATES CREATED SUCCESSFULLY!';
  RAISE NOTICE 'Distribution: Anniversary (8), Henna (7), Circumcision (7), Celebration (8), Engagement Dinner (5), Bachelor Party (6)';
  RAISE NOTICE 'All templates have relevant Unsplash photos!';
END $$;

