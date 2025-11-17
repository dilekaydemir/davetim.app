-- =====================================================
-- DOĞUM GÜNÜ TEMPLATES (15) - PASTA, BALON, PARTİ FOTOĞRAFLARI
-- =====================================================
-- Her fotoğraf doğum günü pastası, balonlar, parti temalıdır

DELETE FROM public.templates WHERE category = 'birthday';

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- FREE (5)
('Neşeli Doğum Günü', 'Renkli balonlar ve neşe', 'birthday', 'fun', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop&q=80',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 26),

('Çocuk Doğum Günü', 'Çocuklar için eğlenceli parti', 'birthday', 'kids', 'free',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=800&h=600&fit=crop&q=80',
'{"primary": "#FF5722", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 27),

('Yetişkin Doğum Günü', 'Şık ve zarif yetişkin partisi', 'birthday', 'adult', 'free',
'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800&h=600&fit=crop&q=80',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 28),

('Pasta Temalı', 'Doğum günü pastası ve kutlama', 'birthday', 'cake', 'free',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=800&h=600&fit=crop&q=80',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F8BBD0"}',
'[]', '[]', '{"Quicksand", "Poppins", "Baloo 2"}', false, 29),

('Konfeti Parti', 'Renkli konfeti ve eğlence', 'birthday', 'confetti', 'free',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop&q=80',
'{"primary": "#FF6F00", "secondary": "#FFA726", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[]', '[]', '{"Fredoka One", "Righteous", "Baloo 2"}', false, 30),

-- PRO (5)
('Lüks Doğum Günü', 'Altın detaylı lüks kutlama', 'birthday', 'luxury', 'pro',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=800&h=600&fit=crop&q=80',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "milestone_age", "label": "Özel Yaş", "defaultValue": "30. Yaşıma özel kutlama", "style": {"fontSize": 24, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 31),

('Prenses Partisi', 'Küçük prensesler için özel', 'birthday', 'princess', 'pro',
'https://images.unsplash.com/photo-1530019308580-d18e0dc33a19?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1530019308580-d18e0dc33a19?w=800&h=600&fit=crop&q=80',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[{"id": "princess_theme", "label": "Prenses Teması", "defaultValue": "Küçük prensesimizin doğum günü şatosu", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', false, 32),

('Süper Kahraman Parti', 'Küçük kahramanlar için', 'birthday', 'superhero', 'pro',
'https://images.unsplash.com/photo-1608889175123-8ee362201f81?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1608889175123-8ee362201f81?w=800&h=600&fit=crop&q=80',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "hero_power", "label": "Süper Güç", "defaultValue": "Süper kahramanlar burada toplanıyor!", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Righteous"}}]',
'[]', '{"Righteous", "Fredoka One", "Baloo 2"}', false, 33),

('Vintage Doğum Günü', 'Nostaljik doğum günü kutlaması', 'birthday', 'vintage', 'pro',
'https://images.unsplash.com/photo-1511376777868-611b54f68947?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1511376777868-611b54f68947?w=800&h=600&fit=crop&q=80',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_wish", "label": "Nostaljik Dilek", "defaultValue": "Eski günlerin güzelliğiyle kutluyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 34),

('Bahçe Partisi', 'Doğada eğlenceli doğum günü', 'birthday', 'garden', 'pro',
'https://images.unsplash.com/photo-1509315811345-672d83ef2fbc?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1509315811345-672d83ef2fbc?w=800&h=600&fit=crop&q=80',
'{"primary": "#388E3C", "secondary": "#66BB6A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "garden_fun", "label": "Bahçe Eğlencesi", "defaultValue": "Doğanın kucağında parti zamanı", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 35),

-- PREMIUM (5)
('Kraliyet Doğum Günü', 'Muhteşem kraliyet kutlaması', 'birthday', 'royal', 'premium',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=800&h=600&fit=crop&q=80',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_celebration", "label": "Kraliyet Kutlaması", "defaultValue": "Kraliyet ailesinin özel gününe hoş geldiniz", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 36),

('Unicorn Parti', 'Sihirli unicorn temalı parti', 'birthday', 'unicorn', 'premium',
'https://images.unsplash.com/photo-1535254973040-607b474cb50d?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1535254973040-607b474cb50d?w=800&h=600&fit=crop&q=80',
'{"primary": "#E91E63", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[{"id": "unicorn_magic", "label": "Unicorn Sihri", "defaultValue": "Sihirli unicorn dünyasına hoş geldiniz", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]', '{"Pacifico", "Dancing Script", "Great Vibes"}', true, 37),

('Gece Kulübü Parti', 'VIP gece kulübü kutlaması', 'birthday', 'nightclub', 'premium',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&h=600&fit=crop&q=80',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#E91E63"}',
'[{"id": "vip_night", "label": "VIP Gece", "defaultValue": "VIP doğum günü kutlamasına davetlisiniz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 38),

('Havuz Partisi', 'Yaz eğlencesi havuz partisi', 'birthday', 'pool', 'premium',
'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800&h=600&fit=crop&q=80',
'{"primary": "#0097A7", "secondary": "#00BCD4", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "pool_fun", "label": "Havuz Eğlencesi", "defaultValue": "Serinletici havuz partisine hazır mısınız?", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 39),

('Tema Park Partisi', 'Tema parkta eğlenceli kutlama', 'birthday', 'theme_park', 'premium',
'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=800&h=600&fit=crop&q=80',
'{"primary": "#F57C00", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "theme_park", "label": "Tema Park", "defaultValue": "Lunaparkta unutulmaz bir gün!", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[]', '{"Fredoka One", "Righteous", "Baloo 2"}', false, 40);

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE '15 Birthday templates created with verified party photos!';
END $$;

