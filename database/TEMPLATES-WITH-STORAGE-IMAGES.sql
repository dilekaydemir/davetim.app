-- =====================================================
-- TEMPLATES - SUPABASE STORAGE IMAGES
-- =====================================================
-- Fotoğraflar: storage/templates/{category}/{subcategory}.jpg formatında
-- Örnek: storage/templates/wedding/classic.jpg

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
'wedding/classic.jpg',
'wedding/classic.jpg',
'{"primary": "#2C3E50", "secondary": "#34495E", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Playfair Display", "Montserrat", "Cinzel"}', true, 1),

('Romantik Düğün', 'Pembe tonlarında romantik düğün', 'wedding', 'romantic', 'free',
'wedding/romantic.jpg',
'wedding/romantic.jpg',
'{"primary": "#D4567D", "secondary": "#F8B4C6", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Great Vibes", "Lora"}', true, 2),

('Modern Düğün', 'Minimalist düğün', 'wedding', 'modern', 'free',
'wedding/modern.jpg',
'wedding/modern.jpg',
'{"primary": "#1A1A1A", "secondary": "#4A4A4A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 3),

('Bahçe Düğünü', 'Doğada düğün', 'wedding', 'garden', 'free',
'wedding/garden.jpg',
'wedding/garden.jpg',
'{"primary": "#2D5016", "secondary": "#7CB342", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]', '{"Lora", "Raleway", "Open Sans"}', false, 4),

('Sahil Düğünü', 'Deniz kenarında düğün', 'wedding', 'beach', 'free',
'wedding/beach.jpg',
'wedding/beach.jpg',
'{"primary": "#006994", "secondary": "#00A8CC", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F9A825"}',
'[]', '[]', '{"Lato", "Montserrat", "Raleway"}', false, 5),

('Lüks Düğün', 'Altın detaylı lüks düğün', 'wedding', 'luxury', 'pro',
'wedding/luxury.jpg',
'wedding/luxury.jpg',
'{"primary": "#8B6914", "secondary": "#B8860B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "venue_details", "label": "Düğün Mekanı", "defaultValue": "Grand Hyatt İstanbul", "style": {"fontSize": 20, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Playfair Display", "Cinzel", "Bodoni Moda"}', true, 6),

('Vintage Düğün', 'Nostaljik düğün', 'wedding', 'vintage', 'pro',
'wedding/vintage.jpg',
'wedding/vintage.jpg',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_note", "label": "Özel Mesaj", "defaultValue": "Bizimle bu günü paylaşın", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 7),

('Kır Düğünü', 'Rustik kır düğünü', 'wedding', 'rustic', 'pro',
'wedding/rustic.jpg',
'wedding/rustic.jpg',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FAFAFA", "text": "#3E2723", "accent": "#7CB342"}',
'[{"id": "rustic_welcome", "label": "Karşılama", "defaultValue": "Sevgiyle bekliyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]', '{"Lora", "Merriweather", "Open Sans"}', false, 8),

('Bohem Düğün', 'Bohem düğün', 'wedding', 'bohemian', 'pro',
'wedding/bohemian.jpg',
'wedding/bohemian.jpg',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "boho_message", "label": "Doğa Mesajı", "defaultValue": "Doğada birleşiyoruz", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Satisfy", "Lato"}', false, 9),

('Gül Bahçesi', 'Gül bahçesinde düğün', 'wedding', 'rose_garden', 'pro',
'wedding/rose_garden.jpg',
'wedding/rose_garden.jpg',
'{"primary": "#880E4F", "secondary": "#AD1457", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F48FB1"}',
'[{"id": "rose_garden", "label": "Bahçe", "defaultValue": "Gül bahçemizde buluşalım", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Great Vibes", "Lora"}', false, 10),

('Kraliyet Düğünü', 'Muhteşem kraliyet düğünü', 'wedding', 'royal', 'premium',
'wedding/royal.jpg',
'wedding/royal.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_title", "label": "Kraliyet Unvanı", "defaultValue": "Saygıdeğer Misafirlerimiz", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 11),

('Peri Masalı', 'Masalsı düğün', 'wedding', 'fairytale', 'premium',
'wedding/fairytale.jpg',
'wedding/fairytale.jpg',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "fairy_tale", "label": "Masal", "defaultValue": "Bir varmış bir yokmuş...", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', true, 12),

('Beyaz Gül', 'Beyaz güller düğün', 'wedding', 'white_rose', 'premium',
'wedding/white_rose.jpg',
'wedding/white_rose.jpg',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "white_elegance", "label": "Zarafet", "defaultValue": "Saf sevgimizle bekliyoruz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Lora", "Montserrat"}', false, 13),

('Kristal Düğün', 'Işıltılı kristal', 'wedding', 'crystal', 'premium',
'wedding/crystal.jpg',
'wedding/crystal.jpg',
'{"primary": "#455A64", "secondary": "#607D8B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "crystal_sparkle", "label": "Işıltı", "defaultValue": "Işıltımızla mutluluğu paylaşıyoruz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Montserrat", "Raleway"}', false, 14),

('Gün Batımı', 'Romantik gün batımı', 'wedding', 'sunset', 'premium',
'wedding/sunset.jpg',
'wedding/sunset.jpg',
'{"primary": "#E91E63", "secondary": "#FF6F00", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "sunset_romance", "label": "Gün Batımı", "defaultValue": "Güneş batarken sevgimiz doğuyor", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]', '{"Pacifico", "Dancing Script", "Great Vibes"}', false, 15),

-- ===============================
-- NİŞAN (10)
-- ===============================
('Klasik Nişan', 'Zarif nişan', 'engagement', 'classic', 'free',
'engagement/classic.jpg',
'engagement/classic.jpg',
'{"primary": "#B71C1C", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Lora", "Montserrat"}', true, 16),

('Romantik Nişan', 'Pembe romantik nişan', 'engagement', 'romantic', 'free',
'engagement/romantic.jpg',
'engagement/romantic.jpg',
'{"primary": "#D81B60", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Great Vibes", "Dancing Script", "Pacifico"}', true, 17),

('Modern Nişan', 'Minimalist nişan', 'engagement', 'modern', 'free',
'engagement/modern.jpg',
'engagement/modern.jpg',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 18),

('Lüks Nişan', 'Altın detaylı', 'engagement', 'luxury', 'pro',
'engagement/luxury.jpg',
'engagement/luxury.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "ring_story", "label": "Yüzük Hikayesi", "defaultValue": "Aşkımızın sembolü", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 19),

('Vintage Nişan', 'Nostaljik nişan', 'engagement', 'vintage', 'pro',
'engagement/vintage.jpg',
'engagement/vintage.jpg',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "love_letter", "label": "Aşk Mektubu", "defaultValue": "Eski günlerin romantizmiyle", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 20),

('Bohem Nişan', 'Bohem nişan', 'engagement', 'bohemian', 'pro',
'engagement/bohemian.jpg',
'engagement/bohemian.jpg',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "nature_love", "label": "Doğa Aşkı", "defaultValue": "Doğada birleşiyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Satisfy", "Lato"}', false, 21),

('Gül Buketi', 'Kırmızı güller', 'engagement', 'rose', 'pro',
'engagement/rose.jpg',
'engagement/rose.jpg',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F8BBD0"}',
'[{"id": "rose_promise", "label": "Gül Sözü", "defaultValue": "Her gül yaprak bir söz", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Great Vibes"}}]',
'[]', '{"Great Vibes", "Pacifico", "Dancing Script"}', false, 22),

('Kraliyet Nişanı', 'Kraliyet nişan', 'engagement', 'royal', 'premium',
'engagement/royal.jpg',
'engagement/royal.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_promise", "label": "Kraliyet", "defaultValue": "İki kraliyet ailesinin birleşimi", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 23),

('Pırlanta Nişan', 'Pırlanta yüzük', 'engagement', 'diamond', 'premium',
'engagement/diamond.jpg',
'engagement/diamond.jpg',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "diamond_forever", "label": "Pırlanta", "defaultValue": "Pırlanta gibi ebedi", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Montserrat"}', false, 24),

('Gün Batımı Nişan', 'Romantik gün batımı', 'engagement', 'sunset', 'premium',
'engagement/sunset.jpg',
'engagement/sunset.jpg',
'{"primary": "#E91E63", "secondary": "#FF6F00", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "sunset_promise", "label": "Gün Batımı", "defaultValue": "Güneş batarken aşkımız başlıyor", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]', '{"Pacifico", "Dancing Script", "Great Vibes"}', false, 25);

-- Tüm 105 template için devam edecek...
-- Şimdilik sadece Wedding (15) + Engagement (10) örneği

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE 'Templates created with Supabase Storage paths!';
  RAISE NOTICE 'Upload images to: storage/templates/{category}/{subcategory}.jpg';
  RAISE NOTICE 'Example: storage/templates/wedding/classic.jpg';
END $$;

