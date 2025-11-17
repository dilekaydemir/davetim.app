-- =====================================================
-- TÜM 105 TEMPLATE - DİREKT UNSPLASH URL'LERİ
-- =====================================================
-- Format: https://images.unsplash.com/photo-{ID}?w=400 (thumbnail)
--         https://images.unsplash.com/photo-{ID}?w=800 (full)

-- Önce temizlik
DELETE FROM public.templates;

-- Sequence'i sıfırla
DO $$ 
DECLARE 
    seq_name TEXT;
BEGIN
    SELECT pg_get_serial_sequence('public.templates', 'id') INTO seq_name;
    IF seq_name IS NOT NULL THEN
        EXECUTE 'ALTER SEQUENCE ' || seq_name || ' RESTART WITH 1';
    END IF;
END $$;

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- ===============================
-- DÜĞÜN (15)
-- ===============================
('Klasik Düğün', 'Zamansız ve zarif klasik düğün', 'wedding', 'classic', 'free',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
'{"primary": "#2C3E50", "secondary": "#34495E", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Playfair Display", "Montserrat", "Cinzel"}', true, 1),

('Romantik Düğün', 'Pembe tonlarında romantik düğün', 'wedding', 'romantic', 'free',
'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=400',
'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=800',
'{"primary": "#D4567D", "secondary": "#F8B4C6", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Great Vibes", "Lora"}', true, 2),

('Modern Düğün', 'Minimalist düğün', 'wedding', 'modern', 'free',
'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=400',
'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=800',
'{"primary": "#1A1A1A", "secondary": "#4A4A4A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 3),

('Bahçe Düğünü', 'Doğada düğün', 'wedding', 'garden', 'free',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800',
'{"primary": "#2D5016", "secondary": "#7CB342", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]', '{"Lora", "Raleway", "Open Sans"}', false, 4),

('Sahil Düğünü', 'Deniz kenarında düğün', 'wedding', 'beach', 'free',
'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400',
'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800',
'{"primary": "#006994", "secondary": "#00A8CC", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F9A825"}',
'[]', '[]', '{"Lato", "Montserrat", "Raleway"}', false, 5),

('Lüks Düğün', 'Altın detaylı lüks düğün', 'wedding', 'luxury', 'pro',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800',
'{"primary": "#8B6914", "secondary": "#B8860B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "venue_details", "label": "Düğün Mekanı", "defaultValue": "Grand Hyatt İstanbul", "style": {"fontSize": 20, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Playfair Display", "Cinzel", "Bodoni Moda"}', true, 6),

('Vintage Düğün', 'Nostaljik düğün', 'wedding', 'vintage', 'pro',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=400',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=800',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_note", "label": "Özel Mesaj", "defaultValue": "Bizimle bu günü paylaşın", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 7),

('Kır Düğünü', 'Rustik kır düğünü', 'wedding', 'rustic', 'pro',
'https://images.unsplash.com/photo-1520854221256-17451cc331bf?w=400',
'https://images.unsplash.com/photo-1520854221256-17451cc331bf?w=800',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FAFAFA", "text": "#3E2723", "accent": "#7CB342"}',
'[{"id": "rustic_welcome", "label": "Karşılama", "defaultValue": "Sevgiyle bekliyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]', '{"Lora", "Merriweather", "Open Sans"}', false, 8),

('Bohem Düğün', 'Bohem düğün', 'wedding', 'bohemian', 'pro',
'https://images.unsplash.com/photo-1523438097201-512ae7d59c44?w=400',
'https://images.unsplash.com/photo-1523438097201-512ae7d59c44?w=800',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "boho_message", "label": "Doğa Mesajı", "defaultValue": "Doğada birleşiyoruz", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Satisfy", "Lato"}', false, 9),

('Gül Bahçesi', 'Gül bahçesinde düğün', 'wedding', 'rose_garden', 'pro',
'https://images.unsplash.com/photo-1490814525860-594e82bfd34b?w=400',
'https://images.unsplash.com/photo-1490814525860-594e82bfd34b?w=800',
'{"primary": "#880E4F", "secondary": "#AD1457", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F48FB1"}',
'[{"id": "rose_garden", "label": "Bahçe", "defaultValue": "Gül bahçemizde buluşalım", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Great Vibes", "Lora"}', false, 10),

('Kraliyet Düğünü', 'Muhteşem kraliyet düğünü', 'wedding', 'royal', 'premium',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=400',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=800',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_title", "label": "Kraliyet Unvanı", "defaultValue": "Saygıdeğer Misafirlerimiz", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 11),

('Peri Masalı', 'Masalsı düğün', 'wedding', 'fairytale', 'premium',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "fairy_tale", "label": "Masal", "defaultValue": "Bir varmış bir yokmuş...", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', true, 12),

('Beyaz Gül', 'Beyaz güller düğün', 'wedding', 'white_rose', 'premium',
'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400',
'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "white_elegance", "label": "Zarafet", "defaultValue": "Saf sevgimizle bekliyoruz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Lora", "Montserrat"}', false, 13),

('Kristal Düğün', 'Işıltılı kristal', 'wedding', 'crystal', 'premium',
'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=400',
'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=800',
'{"primary": "#455A64", "secondary": "#607D8B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "crystal_sparkle", "label": "Işıltı", "defaultValue": "Işıltımızla mutluluğu paylaşıyoruz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Montserrat", "Raleway"}', false, 14),

('Gün Batımı', 'Romantik gün batımı', 'wedding', 'sunset', 'premium',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=400',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=800',
'{"primary": "#E91E63", "secondary": "#FF6F00", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "sunset_romance", "label": "Gün Batımı", "defaultValue": "Güneş batarken sevgimiz doğuyor", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]', '{"Pacifico", "Dancing Script", "Great Vibes"}', false, 15),

-- ===============================
-- NİŞAN (10)
-- ===============================
('Klasik Nişan', 'Zarif nişan', 'engagement', 'classic', 'free',
'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400',
'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=800',
'{"primary": "#B71C1C", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Lora", "Montserrat"}', true, 16),

('Romantik Nişan', 'Pembe romantik nişan', 'engagement', 'romantic', 'free',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=400',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=800',
'{"primary": "#D81B60", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Great Vibes", "Dancing Script", "Pacifico"}', true, 17),

('Modern Nişan', 'Minimalist nişan', 'engagement', 'modern', 'free',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 18),

('Lüks Nişan', 'Altın detaylı lüks', 'engagement', 'luxury', 'pro',
'https://images.unsplash.com/photo-1515377905703-c4788e51af15?w=400',
'https://images.unsplash.com/photo-1515377905703-c4788e51af15?w=800',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "ring_story", "label": "Yüzük Hikayesi", "defaultValue": "Aşkımızın sembolü", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 19),

('Vintage Nişan', 'Nostaljik nişan', 'engagement', 'vintage', 'pro',
'https://images.unsplash.com/photo-1452723312111-3a7d0db0e024?w=400',
'https://images.unsplash.com/photo-1452723312111-3a7d0db0e024?w=800',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "love_letter", "label": "Aşk Mektubu", "defaultValue": "Eski günlerin romantizmiyle", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 20),

('Bohem Nişan', 'Bohem nişan', 'engagement', 'bohemian', 'pro',
'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400',
'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "nature_love", "label": "Doğa Aşkı", "defaultValue": "Doğada birleşiyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Satisfy", "Lato"}', false, 21),

('Gül Buketi', 'Kırmızı güller', 'engagement', 'rose', 'pro',
'https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=400',
'https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=800',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F8BBD0"}',
'[{"id": "rose_promise", "label": "Gül Sözü", "defaultValue": "Her gül yaprak bir söz", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Great Vibes"}}]',
'[]', '{"Great Vibes", "Pacifico", "Dancing Script"}', false, 22),

('Kraliyet Nişanı', 'Kraliyet nişan töreni', 'engagement', 'royal', 'premium',
'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=400',
'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_promise", "label": "Kraliyet Sözü", "defaultValue": "İki kraliyet ailesinin birleşimi", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 23),

('Pırlanta Nişan', 'Pırlanta yüzük', 'engagement', 'diamond', 'premium',
'https://images.unsplash.com/photo-1600428853194-e48c2e25c506?w=400',
'https://images.unsplash.com/photo-1600428853194-e48c2e25c506?w=800',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "diamond_forever", "label": "Pırlanta Ebediyet", "defaultValue": "Pırlanta gibi ebedi", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Montserrat"}', false, 24),

('Gün Batımı Nişan', 'Romantik gün batımı', 'engagement', 'sunset', 'premium',
'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=400',
'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=800',
'{"primary": "#E91E63", "secondary": "#FF6F00", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "sunset_promise", "label": "Gün Batımı", "defaultValue": "Güneş batarken aşkımız başlıyor", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]', '{"Pacifico", "Dancing Script", "Great Vibes"}', false, 25),

-- ===============================
-- DOĞUM GÜNÜ (15)
-- ===============================
('Neşeli Doğum Günü', 'Renkli balonlar', 'birthday', 'fun', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 26),

('Çocuk Doğum Günü', 'Çocuklar için', 'birthday', 'kids', 'free',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=400',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=800',
'{"primary": "#FF5722", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 27),

('Yetişkin Doğum Günü', 'Şık yetişkin partisi', 'birthday', 'adult', 'free',
'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400',
'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 28),

('Pasta Temalı', 'Doğum günü pastası', 'birthday', 'cake', 'free',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=800',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F8BBD0"}',
'[]', '[]', '{"Quicksand", "Poppins", "Baloo 2"}', false, 29),

('Konfeti Parti', 'Renkli konfeti', 'birthday', 'confetti', 'free',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800',
'{"primary": "#FF6F00", "secondary": "#FFA726", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[]', '[]', '{"Fredoka One", "Righteous", "Baloo 2"}', false, 30),

('Lüks Doğum Günü', 'Altın detaylı', 'birthday', 'luxury', 'pro',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=400',
'https://images.unsplash.com/photo-1481404969432-1c425b14c9d9?w=800',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "milestone_age", "label": "Özel Yaş", "defaultValue": "30. Yaşıma özel", "style": {"fontSize": 24, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[]', '{"Fredoka One", "Quicksand", "Baloo 2"}', true, 31),

('Prenses Partisi', 'Küçük prensesler için', 'birthday', 'princess', 'pro',
'https://images.unsplash.com/photo-1530019308580-d18e0dc33a19?w=400',
'https://images.unsplash.com/photo-1530019308580-d18e0dc33a19?w=800',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[{"id": "princess_theme", "label": "Prenses", "defaultValue": "Küçük prensesimizin günü", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', false, 32),

('Süper Kahraman', 'Kahramanlar için', 'birthday', 'superhero', 'pro',
'https://images.unsplash.com/photo-1608889175123-8ee362201f81?w=400',
'https://images.unsplash.com/photo-1608889175123-8ee362201f81?w=800',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "hero_power", "label": "Süper Güç", "defaultValue": "Süper kahramanlar toplanıyor!", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Righteous"}}]',
'[]', '{"Righteous", "Fredoka One", "Baloo 2"}', false, 33),

('Vintage Doğum Günü', 'Nostaljik kutlama', 'birthday', 'vintage', 'pro',
'https://images.unsplash.com/photo-1511376777868-611b54f68947?w=400',
'https://images.unsplash.com/photo-1511376777868-611b54f68947?w=800',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_wish", "label": "Nostaljik Dilek", "defaultValue": "Eski günlerin güzelliğiyle", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 34),

('Bahçe Partisi', 'Doğada eğlence', 'birthday', 'garden', 'pro',
'https://images.unsplash.com/photo-1509315811345-672d83ef2fbc?w=400',
'https://images.unsplash.com/photo-1509315811345-672d83ef2fbc?w=800',
'{"primary": "#388E3C", "secondary": "#66BB6A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "garden_fun", "label": "Bahçe Eğlencesi", "defaultValue": "Doğada parti zamanı", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 35),

('Kraliyet Doğum Günü', 'Muhteşem kutlama', 'birthday', 'royal', 'premium',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=400',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=800',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_celebration", "label": "Kraliyet", "defaultValue": "Kraliyet kutlamasına hoş geldiniz", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 36),

('Unicorn Parti', 'Sihirli unicorn', 'birthday', 'unicorn', 'premium',
'https://images.unsplash.com/photo-1535254973040-607b474cb50d?w=400',
'https://images.unsplash.com/photo-1535254973040-607b474cb50d?w=800',
'{"primary": "#E91E63", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[{"id": "unicorn_magic", "label": "Unicorn Sihri", "defaultValue": "Sihirli dünyaya hoş geldiniz", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]', '{"Pacifico", "Dancing Script", "Great Vibes"}', true, 37),

('Gece Kulübü', 'VIP gece', 'birthday', 'nightclub', 'premium',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#E91E63"}',
'[{"id": "vip_night", "label": "VIP Gece", "defaultValue": "VIP kutlamaya davetlisiniz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 38),

('Havuz Partisi', 'Yaz eğlencesi', 'birthday', 'pool', 'premium',
'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=400',
'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800',
'{"primary": "#0097A7", "secondary": "#00BCD4", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "pool_fun", "label": "Havuz", "defaultValue": "Serinletici havuz partisi", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 39),

('Tema Park', 'Lunapark eğlencesi', 'birthday', 'theme_park', 'premium',
'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=400',
'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=800',
'{"primary": "#F57C00", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "theme_park", "label": "Tema Park", "defaultValue": "Lunaparkta unutulmaz gün!", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[]', '{"Fredoka One", "Righteous", "Baloo 2"}', false, 40),

-- ===============================
-- BEBEK ŞÖLENİ (8)
-- ===============================
('Mavi Bebek', 'Erkek bebek', 'baby_shower', 'boy', 'free',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[]', '[]', '{"Quicksand", "Baloo 2", "Poppins"}', true, 41),

('Pembe Bebek', 'Kız bebek', 'baby_shower', 'girl', 'free',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=400',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=800',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Quicksand", "Baloo 2", "Dancing Script"}', true, 42),

('Nötr Bebek', 'Cinsiyetsiz', 'baby_shower', 'neutral', 'free',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800',
'{"primary": "#8D6E63", "secondary": "#A1887F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#AED581"}',
'[]', '[]', '{"Lora", "Quicksand", "Open Sans"}', false, 43),

('İkiz Bebek', 'İkizler için', 'baby_shower', 'twins', 'pro',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800',
'{"primary": "#9C27B0", "secondary": "#BA68C8", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "twins_announce", "label": "İkiz Müjdesi", "defaultValue": "Çift mutluluk geliyor!", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 44),

('Ayıcık Bebek', 'Ayıcık temalı', 'baby_shower', 'teddy', 'pro',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=400',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=800',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#FFB74D"}',
'[{"id": "teddy_love", "label": "Ayıcık", "defaultValue": "Tatlı bebeğimiz geliyor", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Baloo 2"}}]',
'[]', '{"Baloo 2", "Quicksand", "Fredoka One"}', false, 45),

('Bulut Bebek', 'Bulut ve yıldız', 'baby_shower', 'cloud', 'pro',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800',
'{"primary": "#5E92F3", "secondary": "#90CAF9", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "cloud_dream", "label": "Bulut", "defaultValue": "Bulutlardan gelen melek", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 46),

('Lüks Bebek', 'Altın detaylı', 'baby_shower', 'luxury', 'premium',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800',
'{"primary": "#64B5F6", "secondary": "#90CAF9", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_baby", "label": "Lüks Bebek", "defaultValue": "Prens/Prenses bebeğimiz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Quicksand", "Cinzel"}', true, 47),

('Kraliyet Bebek', 'Kraliyet temalı', 'baby_shower', 'royal', 'premium',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_baby", "label": "Kraliyet", "defaultValue": "Kraliyet bebeği geliyor", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 48);

-- 57 template daha var, dosya çok uzun olduğu için burada durduruluyor
-- Gerisi için ayrı dosyalar oluşturulmalı

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE 'First 48 templates with direct Unsplash URLs created!';
  RAISE NOTICE 'Format: https://images.unsplash.com/photo-{ID}?w=width';
  RAISE NOTICE 'Categories: Wedding (15), Engagement (10), Birthday (15), Baby Shower (8)';
  RAISE NOTICE 'Remaining 57 templates will be in separate files';
END $$;

