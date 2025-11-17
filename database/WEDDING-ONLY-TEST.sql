-- =====================================================
-- WEDDING TEMPLATES - CATEGORY/SUBCATEGORY BASED PHOTOS
-- =====================================================
-- Her fotoğraf subcategory'ye göre seçildi (template ismine değil!)

DELETE FROM public.templates WHERE category = 'wedding';

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- CLASSIC (sade, zarif, geleneksel düğün fotoğrafları)
('Klasik Düğün', 'Zamansız ve zarif klasik düğün', 'wedding', 'classic', 'free',
'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=400',
'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=800',
'{"primary": "#2C3E50", "secondary": "#34495E", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Playfair Display", "Montserrat", "Cinzel"}', true, 1),

-- ROMANTIC (romantik, pembe, çiçekli düğün)
('Romantik Düğün', 'Pembe tonlarında romantik düğün', 'wedding', 'romantic', 'free',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
'{"primary": "#D4567D", "secondary": "#F8B4C6", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Great Vibes", "Lora"}', true, 2),

-- MODERN (minimalist, çağdaş, şık düğün)
('Modern Düğün', 'Minimalist düğün', 'wedding', 'modern', 'free',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800',
'{"primary": "#1A1A1A", "secondary": "#4A4A4A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 3),

-- GARDEN (bahçe, doğa, yeşillik, açık hava düğünü)
('Bahçe Düğünü', 'Doğada düğün', 'wedding', 'garden', 'free',
'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400',
'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800',
'{"primary": "#2D5016", "secondary": "#7CB342", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]', '{"Lora", "Raleway", "Open Sans"}', false, 4),

-- BEACH (sahil, deniz, plaj düğünü)
('Sahil Düğünü', 'Deniz kenarında düğün', 'wedding', 'beach', 'free',
'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400',
'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800',
'{"primary": "#006994", "secondary": "#00A8CC", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F9A825"}',
'[]', '[]', '{"Lato", "Montserrat", "Raleway"}', false, 5),

-- LUXURY (lüks, altın, zengin, şatafatlı düğün)
('Lüks Düğün', 'Altın detaylı lüks düğün', 'wedding', 'luxury', 'pro',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=400',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=800',
'{"primary": "#8B6914", "secondary": "#B8860B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "venue_details", "label": "Düğün Mekanı", "defaultValue": "Grand Hyatt İstanbul", "style": {"fontSize": 20, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Playfair Display", "Cinzel", "Bodoni Moda"}', true, 6),

-- VINTAGE (nostaljik, eski, antika, retro düğün)
('Vintage Düğün', 'Nostaljik düğün', 'wedding', 'vintage', 'pro',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=400',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=800',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_note", "label": "Özel Mesaj", "defaultValue": "Bizimle bu günü paylaşın", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 7),

-- RUSTIC (kır düğünü, ahşap, rustik, doğal)
('Kır Düğünü', 'Rustik kır düğünü', 'wedding', 'rustic', 'pro',
'https://images.unsplash.com/photo-1520854221256-17451cc331bf?w=400',
'https://images.unsplash.com/photo-1520854221256-17451cc331bf?w=800',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FAFAFA", "text": "#3E2723", "accent": "#7CB342"}',
'[{"id": "rustic_welcome", "label": "Karşılama", "defaultValue": "Sevgiyle bekliyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]', '{"Lora", "Merriweather", "Open Sans"}', false, 8),

-- BOHEMIAN (bohem, özgür, doğal, çiçekli, boho düğün)
('Bohem Düğün', 'Bohem düğün', 'wedding', 'bohemian', 'pro',
'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400',
'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "boho_message", "label": "Doğa Mesajı", "defaultValue": "Doğada birleşiyoruz", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Satisfy", "Lato"}', false, 9),

-- ROSE_GARDEN (gül bahçesi, pembe güller, romantik bahçe)
('Gül Bahçesi', 'Gül bahçesinde düğün', 'wedding', 'rose_garden', 'pro',
'https://images.unsplash.com/photo-1490814525860-594e82bfd34b?w=400',
'https://images.unsplash.com/photo-1490814525860-594e82bfd34b?w=800',
'{"primary": "#880E4F", "secondary": "#AD1457", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F48FB1"}',
'[{"id": "rose_garden", "label": "Bahçe", "defaultValue": "Gül bahçemizde buluşalım", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Great Vibes", "Lora"}', false, 10),

-- ROYAL (kraliyet, muhteşem, saray, lüks düğün)
('Kraliyet Düğünü', 'Muhteşem kraliyet düğünü', 'wedding', 'royal', 'premium',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_title", "label": "Kraliyet Unvanı", "defaultValue": "Saygıdeğer Misafirlerimiz", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 11),

-- FAIRYTALE (peri masalı, masal, prenses düğünü)
('Peri Masalı', 'Masalsı düğün', 'wedding', 'fairytale', 'premium',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "fairy_tale", "label": "Masal", "defaultValue": "Bir varmış bir yokmuş...", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Great Vibes", "Pacifico"}', true, 12),

-- WHITE_ROSE (beyaz güller, saf, zarif, beyaz düğün)
('Beyaz Gül', 'Beyaz güller düğün', 'wedding', 'white_rose', 'premium',
'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=400',
'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=800',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "white_elegance", "label": "Zarafet", "defaultValue": "Saf sevgimizle bekliyoruz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Lora", "Montserrat"}', false, 13),

-- CRYSTAL (kristal, ışıltılı, parlak, şık düğün)
('Kristal Düğün', 'Işıltılı kristal', 'wedding', 'crystal', 'premium',
'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=400',
'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=800',
'{"primary": "#455A64", "secondary": "#607D8B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "crystal_sparkle", "label": "Işıltı", "defaultValue": "Işıltımızla mutluluğu paylaşıyoruz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Montserrat", "Raleway"}', false, 14),

-- SUNSET (gün batımı, romantik, turuncu-pembe, akşam düğünü)
('Gün Batımı', 'Romantik gün batımı', 'wedding', 'sunset', 'premium',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=400',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=800',
'{"primary": "#E91E63", "secondary": "#FF6F00", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "sunset_romance", "label": "Gün Batımı", "defaultValue": "Güneş batarken sevgimiz doğuyor", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]', '{"Pacifico", "Dancing Script", "Great Vibes"}', false, 15);

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE '15 Wedding templates created based on subcategory (not template name)!';
  RAISE NOTICE 'Each photo selected according to: classic, romantic, modern, garden, beach, luxury, vintage, rustic, bohemian, rose_garden, royal, fairytale, white_rose, crystal, sunset';
END $$;

