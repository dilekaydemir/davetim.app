-- =====================================================
-- KALAN 80 TEMPLATE - SUPABASE STORAGE PATHS
-- =====================================================
-- Birthday (15), Baby Shower (8), Graduation (8), Corporate (8),
-- Anniversary (8), Henna (7), Circumcision (7), Celebration (8),
-- Engagement Dinner (5), Bachelor Party (6)

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- ===============================
-- DOĞUM GÜNÜ (15)
-- ===============================
('Neşeli Doğum Günü', 'Renkli balonlar', 'birthday', 'fun', 'free',
'birthday/fun.jpg', 'birthday/fun.jpg',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 26),

('Çocuk Doğum Günü', 'Çocuklar için eğlenceli parti', 'birthday', 'kids', 'free',
'birthday/kids.jpg', 'birthday/kids.jpg',
'{"primary": "#FF5722", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 27),

('Yetişkin Doğum Günü', 'Şık yetişkin partisi', 'birthday', 'adult', 'free',
'birthday/adult.jpg', 'birthday/adult.jpg',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 28),

('Pasta Temalı', 'Doğum günü pastası', 'birthday', 'cake', 'free',
'birthday/cake.jpg', 'birthday/cake.jpg',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F8BBD0"}',
'[]', '[]', '{"Quicksand", "Poppins", "Baloo 2"}', false, 29),

('Konfeti Parti', 'Renkli konfeti', 'birthday', 'confetti', 'free',
'birthday/confetti.jpg', 'birthday/confetti.jpg',
'{"primary": "#FF6F00", "secondary": "#FFA726", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[]', '[]', '{"Fredoka One", "Righteous", "Baloo 2"}', false, 30),

('Lüks Doğum Günü', 'Altın detaylı lüks kutlama', 'birthday', 'luxury', 'pro',
'birthday/luxury.jpg', 'birthday/luxury.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "milestone_age", "label": "Özel Yaş", "defaultValue": "30. Yaşıma özel kutlama", "style": {"fontSize": 24, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 31),

('Prenses Partisi', 'Küçük prensesler için', 'birthday', 'princess', 'pro',
'birthday/princess.jpg', 'birthday/princess.jpg',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[{"id": "princess_theme", "label": "Prenses Teması", "defaultValue": "Küçük prensesimizin doğum günü", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', false, 32),

('Süper Kahraman Parti', 'Küçük kahramanlar için', 'birthday', 'superhero', 'pro',
'birthday/superhero.jpg', 'birthday/superhero.jpg',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "hero_power", "label": "Süper Güç", "defaultValue": "Süper kahramanlar toplanıyor!", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Righteous"}}]',
'[]', '{"Righteous", "Fredoka One", "Baloo 2"}', false, 33),

('Vintage Doğum Günü', 'Nostaljik kutlama', 'birthday', 'vintage', 'pro',
'birthday/vintage.jpg', 'birthday/vintage.jpg',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_wish", "label": "Nostaljik Dilek", "defaultValue": "Eski günlerin güzelliğiyle", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 34),

('Bahçe Partisi', 'Doğada eğlenceli doğum günü', 'birthday', 'garden', 'pro',
'birthday/garden.jpg', 'birthday/garden.jpg',
'{"primary": "#388E3C", "secondary": "#66BB6A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "garden_fun", "label": "Bahçe Eğlencesi", "defaultValue": "Doğada parti zamanı", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 35),

('Kraliyet Doğum Günü', 'Muhteşem kraliyet kutlaması', 'birthday', 'royal', 'premium',
'birthday/royal.jpg', 'birthday/royal.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_celebration", "label": "Kraliyet Kutlaması", "defaultValue": "Kraliyet kutlamasına hoş geldiniz", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 36),

('Unicorn Parti', 'Sihirli unicorn temalı', 'birthday', 'unicorn', 'premium',
'birthday/unicorn.jpg', 'birthday/unicorn.jpg',
'{"primary": "#E91E63", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[{"id": "unicorn_magic", "label": "Unicorn Sihri", "defaultValue": "Sihirli unicorn dünyasına hoş geldiniz", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]', '{"Pacifico", "Dancing Script", "Great Vibes"}', true, 37),

('Gece Kulübü Parti', 'VIP gece kulübü kutlaması', 'birthday', 'nightclub', 'premium',
'birthday/nightclub.jpg', 'birthday/nightclub.jpg',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#E91E63"}',
'[{"id": "vip_night", "label": "VIP Gece", "defaultValue": "VIP doğum günü kutlamasına davetlisiniz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 38),

('Havuz Partisi', 'Yaz eğlencesi havuz partisi', 'birthday', 'pool', 'premium',
'birthday/pool.jpg', 'birthday/pool.jpg',
'{"primary": "#0097A7", "secondary": "#00BCD4", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "pool_fun", "label": "Havuz Eğlencesi", "defaultValue": "Serinletici havuz partisine hazır mısınız?", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 39),

('Tema Park Partisi', 'Lunapark eğlencesi', 'birthday', 'theme_park', 'premium',
'birthday/theme_park.jpg', 'birthday/theme_park.jpg',
'{"primary": "#F57C00", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "theme_park", "label": "Tema Park", "defaultValue": "Lunaparkta unutulmaz bir gün!", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[]', '{"Fredoka One", "Righteous", "Baloo 2"}', false, 40),

-- ===============================
-- BEBEK ŞÖLENİ (8)
-- ===============================
('Mavi Bebek Şöleni', 'Erkek bebek için mavi tonlar', 'baby_shower', 'boy', 'free',
'baby_shower/boy.jpg', 'baby_shower/boy.jpg',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[]', '[]', '{"Quicksand", "Baloo 2", "Poppins"}', true, 41),

('Pembe Bebek Şöleni', 'Kız bebek için pembe tonlar', 'baby_shower', 'girl', 'free',
'baby_shower/girl.jpg', 'baby_shower/girl.jpg',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Quicksand", "Baloo 2", "Dancing Script"}', true, 42),

('Nötr Bebek Şöleni', 'Cinsiyetsiz bej-yeşil tonlar', 'baby_shower', 'neutral', 'free',
'baby_shower/neutral.jpg', 'baby_shower/neutral.jpg',
'{"primary": "#8D6E63", "secondary": "#A1887F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#AED581"}',
'[]', '[]', '{"Lora", "Quicksand", "Open Sans"}', false, 43),

('İkiz Bebek Şöleni', 'İkizler için özel', 'baby_shower', 'twins', 'pro',
'baby_shower/twins.jpg', 'baby_shower/twins.jpg',
'{"primary": "#9C27B0", "secondary": "#BA68C8", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "twins_announce", "label": "İkiz Müjdesi", "defaultValue": "Çift mutluluk geliyor, ikiz bebeklerimiz!", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 44),

('Ayıcık Bebek', 'Ayıcık temalı sevimli şölen', 'baby_shower', 'teddy', 'pro',
'baby_shower/teddy.jpg', 'baby_shower/teddy.jpg',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#FFB74D"}',
'[{"id": "teddy_love", "label": "Ayıcık Sevgisi", "defaultValue": "Sevimli ayıcıklar gibi tatlı bebeğimiz", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Baloo 2"}}]',
'[]', '{"Baloo 2", "Quicksand", "Fredoka One"}', false, 45),

('Bulut Bebek', 'Bulut ve yıldız temalı', 'baby_shower', 'cloud', 'pro',
'baby_shower/cloud.jpg', 'baby_shower/cloud.jpg',
'{"primary": "#5E92F3", "secondary": "#90CAF9", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "cloud_dream", "label": "Bulut Rüyası", "defaultValue": "Bulutların arasından gelen küçük melek", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 46),

('Lüks Bebek Şöleni', 'Altın detaylı lüks bebek şöleni', 'baby_shower', 'luxury', 'premium',
'baby_shower/luxury.jpg', 'baby_shower/luxury.jpg',
'{"primary": "#64B5F6", "secondary": "#90CAF9", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_baby", "label": "Lüks Bebek", "defaultValue": "Prens/Prenses bebeğimizin şatafatlı karşılanışı", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Quicksand", "Cinzel"}', true, 47),

('Kraliyet Bebek', 'Kraliyet temalı bebek şöleni', 'baby_shower', 'royal', 'premium',
'baby_shower/royal.jpg', 'baby_shower/royal.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_baby", "label": "Kraliyet Bebeği", "defaultValue": "Kraliyet ailesinin yeni üyesi geliyor", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 48);

-- Dosya çok uzun olduğu için kalan kategorileri ayrı dosyalarda oluşturuyorum

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE '23 templates created (Birthday + Baby Shower)!';
  RAISE NOTICE 'Remaining 57 templates in separate file';
END $$;

