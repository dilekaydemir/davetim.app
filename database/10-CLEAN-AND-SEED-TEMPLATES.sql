-- =====================================================
-- CLEAN AND SEED 105 PROFESSIONAL TEMPLATES
-- =====================================================

-- 1. DELETE ALL EXISTING TEMPLATES
DELETE FROM public.templates;

-- 2. RESET SEQUENCE
DO $$ 
DECLARE 
    seq_name TEXT;
BEGIN
    SELECT pg_get_serial_sequence('public.templates', 'id') INTO seq_name;
    IF seq_name IS NOT NULL THEN
        EXECUTE 'ALTER SEQUENCE ' || seq_name || ' RESTART WITH 1';
    END IF;
END $$;

-- =====================================================
-- CATEGORY 1: DÜĞÜN (15 templates: 5 FREE, 5 PRO, 5 PREMIUM)
-- =====================================================

-- FREE DÜĞÜN TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Klasik Düğün', 'Zamansız ve şık klasik düğün davetiyesi', 'wedding', 'classic', 'free', 
'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&h=600&fit=crop',
'{"primary": "#2C3E50", "secondary": "#34495E", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]',
'{"Playfair Display", "Montserrat", "Cinzel"}', true, 1),

('Romantik Düğün', 'Pembe tonlarında romantik düğün davetiyesi', 'wedding', 'romantic', 'free',
'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=800&h=600&fit=crop',
'{"primary": "#D4567D", "secondary": "#F8B4C6", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Great Vibes", "Lora"}', true, 2),

('Modern Düğün', 'Minimalist ve modern düğün davetiyesi', 'wedding', 'modern', 'free',
'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=800&h=600&fit=crop',
'{"primary": "#1A1A1A", "secondary": "#4A4A4A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', true, 3),

('Bahçe Düğünü', 'Doğal ve yeşil tonlarda bahçe düğünü', 'wedding', 'garden', 'free',
'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800&h=600&fit=crop',
'{"primary": "#2D5016", "secondary": "#7CB342", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]',
'{"Lora", "Raleway", "Open Sans"}', false, 4),

('Sahil Düğünü', 'Deniz temalı sahil düğünü davetiyesi', 'wedding', 'beach', 'free',
'https://images.unsplash.com/photo-1519167758481-83f29da8c962?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519167758481-83f29da8c962?w=800&h=600&fit=crop',
'{"primary": "#006994", "secondary": "#00A8CC", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F9A825"}',
'[]', '[]',
'{"Lato", "Montserrat", "Raleway"}', false, 5);

-- PRO DÜĞÜN TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Düğün', 'Altın detaylı lüks düğün davetiyesi', 'wedding', 'luxury', 'pro',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800&h=600&fit=crop',
'{"primary": "#8B6914", "secondary": "#B8860B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "venue", "label": "Mekan", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}, {"id": "dress_code", "label": "Kıyafet", "defaultValue": "", "style": {"fontSize": 16, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Playfair Display", "Cinzel", "Bodoni Moda"}', true, 6),

('Vintage Düğün', 'Nostaljik vintage düğün davetiyesi', 'wedding', 'vintage', 'pro',
'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=800&h=600&fit=crop',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "special_note", "label": "Özel Not", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 7),

('Kır Düğünü', 'Rustik kır düğünü davetiyesi', 'wedding', 'rustic', 'pro',
'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800&h=600&fit=crop',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FAFAFA", "text": "#3E2723", "accent": "#7CB342"}',
'[{"id": "welcome", "label": "Karşılama", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]',
'{"Lora", "Merriweather", "Open Sans"}', false, 8),

('Bohem Düğün', 'Özgür ruhlu bohem düğün davetiyesi', 'wedding', 'bohemian', 'pro',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800&h=600&fit=crop',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "celebration", "label": "Kutlama", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]',
'{"Dancing Script", "Satisfy", "Lato"}', false, 9),

('Gökyüzü Düğünü', 'Mavi tonlarda gökyüzü temalı düğün', 'wedding', 'sky', 'pro',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800&h=600&fit=crop',
'{"primary": "#1565C0", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "invitation_text", "label": "Davet Metni", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Poppins"}}]',
'[]',
'{"Poppins", "Raleway", "Montserrat"}', false, 10);

-- PREMIUM DÜĞÜN TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Kraliyet Düğünü', 'Muhteşem kraliyet düğünü davetiyesi', 'wedding', 'royal', 'premium',
'https://images.unsplash.com/photo-1543418219-44e30b057fea?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1543418219-44e30b057fea?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_message", "label": "Kraliyet Mesajı", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}, {"id": "dress_code", "label": "Kıyafet Kodu", "defaultValue": "", "style": {"fontSize": 16, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[{"id": "crown-1", "type": "elegant", "name": "Altın Çerçeve", "imageUrl": "/graphics/Frame-Border-PNG-HD.png", "position": {"x": 50, "y": 15}, "size": {"width": 150, "height": 150}, "rotation": 0, "opacity": 0.3}]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 11),

('Peri Masalı Düğünü', 'Masalsı peri düğünü davetiyesi', 'wedding', 'fairytale', 'premium',
'https://images.unsplash.com/photo-1519657337289-077653f724ed?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519657337289-077653f724ed?w=800&h=600&fit=crop',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "fairy_tale", "label": "Masal Başlangıcı", "defaultValue": "Bir varmış bir yokmuş...", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[{"id": "flower-wreath", "type": "elegant", "name": "Çiçek Çelenk", "imageUrl": "/graphics/Wreath-Funeral-Flowers-Transparent-Background.png", "position": {"x": 50, "y": 50}, "size": {"width": 140, "height": 140}, "rotation": 0, "opacity": 0.4}]',
'{"Dancing Script", "Great Vibes", "Pacifico"}', true, 12),

('Gül Bahçesi Düğünü', 'Gül temalı romantik düğün', 'wedding', 'rose_garden', 'premium',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=800&h=600&fit=crop',
'{"primary": "#880E4F", "secondary": "#AD1457", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F48FB1"}',
'[{"id": "garden_note", "label": "Bahçe Notu", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[{"id": "rose-1", "type": "elegant", "name": "Kırmızı Gül Buketi", "imageUrl": "/graphics/Red-Rose-Bouquet-PNG-HD.png", "position": {"x": 50, "y": 20}, "size": {"width": 120, "height": 140}, "rotation": 0, "opacity": 0.6}]',
'{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 13),

('Kristal Düğün', 'Işıltılı kristal düğün davetiyesi', 'wedding', 'crystal', 'premium',
'https://images.unsplash.com/photo-1470240731273-7821a6eeb6bd?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1470240731273-7821a6eeb6bd?w=800&h=600&fit=crop',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "sparkle", "label": "Işıltı Mesajı", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "sparkle-1", "type": "celebration", "name": "Işıltılı Havai Fişek", "imageUrl": "/graphics/Sparkle-Gold-Fireworks-PNG-Clipart.png", "position": {"x": 50, "y": 85}, "size": {"width": 120, "height": 140}, "rotation": 0, "opacity": 0.5}]',
'{"Cinzel", "Montserrat", "Raleway"}', false, 14),

('Gökkuşağı Düğünü', 'Renkli ve neşeli düğün davetiyesi', 'wedding', 'rainbow', 'premium',
'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "rainbow_love", "label": "Gökkuşağı Aşkı", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[{"id": "balloons-1", "type": "party", "name": "Renkli Balon Demeti", "imageUrl": "/graphics/Bunch-of-Balloons-PNG-Image.png", "position": {"x": 30, "y": 25}, "size": {"width": 110, "height": 130}, "rotation": -15, "opacity": 0.7}, {"id": "confetti-1", "type": "celebration", "name": "Renkli Konfeti", "imageUrl": "/graphics/Red-Confetti-PNG-Pic.png", "position": {"x": 70, "y": 75}, "size": {"width": 120, "height": 120}, "rotation": 0, "opacity": 0.6}]',
'{"Pacifico", "Fredoka One", "Quicksand"}', true, 15);

-- =====================================================
-- CATEGORY 2: NİŞAN (10 templates: 3 FREE, 4 PRO, 3 PREMIUM)
-- =====================================================

-- FREE NİŞAN TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Klasik Nişan', 'Zarif ve klasik nişan davetiyesi', 'engagement', 'classic', 'free',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800&h=600&fit=crop',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Lora", "Montserrat"}', false, 16),

('Modern Nişan', 'Çağdaş ve şık nişan davetiyesi', 'engagement', 'modern', 'free',
'https://images.unsplash.com/photo-1525268771113-32d9e9021a97?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1525268771113-32d9e9021a97?w=800&h=600&fit=crop',
'{"primary": "#6A1B9A", "secondary": "#8E24AA", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 17),

('Romantik Nişan', 'Pembe tonlarında romantik nişan', 'engagement', 'romantic', 'free',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&h=600&fit=crop',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]',
'{"Great Vibes", "Dancing Script", "Lato"}', false, 18);

-- PRO NİŞAN TEMPLATES (4)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Nişan', 'Altın detaylı lüks nişan davetiyesi', 'engagement', 'luxury', 'pro',
'https://images.unsplash.com/photo-1529634137920-cf8d40a8cd38?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1529634137920-cf8d40a8cd38?w=800&h=600&fit=crop',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "rings", "label": "Yüzük Töreni", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 19),

('Çiçek Bahçesi Nişan', 'Çiçek temalı nişan davetiyesi', 'engagement', 'floral', 'pro',
'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=800&h=600&fit=crop',
'{"primary": "#AD1457", "secondary": "#C2185B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F48FB1"}',
'[{"id": "garden_info", "label": "Bahçe Bilgisi", "defaultValue": "", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]',
'{"Lora", "Merriweather", "Open Sans"}', false, 20),

('Minimalist Nişan', 'Sade ve zarif minimalist nişan', 'engagement', 'minimal', 'pro',
'https://images.unsplash.com/photo-1519741347686-c1e0aadf4611?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519741347686-c1e0aadf4611?w=800&h=600&fit=crop',
'{"primary": "#424242", "secondary": "#616161", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#E0E0E0"}',
'[{"id": "minimal_note", "label": "Not", "defaultValue": "", "style": {"fontSize": 16, "fontWeight": "300", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Raleway"}}]',
'[]',
'{"Raleway", "Lato", "Open Sans"}', false, 21),

('Gökyüzü Nişan', 'Mavi tonlarda gökyüzü temalı nişan', 'engagement', 'sky', 'pro',
'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=600&fit=crop',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "sky_message", "label": "Gökyüzü Mesajı", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Poppins"}}]',
'[]',
'{"Poppins", "Montserrat", "Raleway"}', false, 22);

-- PREMIUM NİŞAN TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Kristal Nişan', 'Işıltılı kristal nişan davetiyesi', 'engagement', 'crystal', 'premium',
'https://images.unsplash.com/photo-1519741347686-c1e0aadf4611?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519741347686-c1e0aadf4611?w=800&h=600&fit=crop',
'{"primary": "#455A64", "secondary": "#607D8B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "crystal_shine", "label": "Işıltı", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "sparkle-1", "type": "celebration", "name": "Altın Havai Fişek", "imageUrl": "/graphics/Festive-Gold-Fireworks-PNG-Clipart.png", "position": {"x": 50, "y": 80}, "size": {"width": 130, "height": 150}, "rotation": 0, "opacity": 0.4}]',
'{"Cinzel", "Bodoni Moda", "Raleway"}', false, 23),

('Pembe Gül Nişan', 'Gül temalı romantik nişan', 'engagement', 'rose', 'premium',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=800&h=600&fit=crop',
'{"primary": "#AD1457", "secondary": "#D81B60", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F8BBD0"}',
'[{"id": "rose_love", "label": "Gül Aşkı", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[{"id": "rose-petals", "type": "wedding", "name": "Gül Yaprakları", "imageUrl": "/graphics/Rose-Petals-PNG-File.png", "position": {"x": 50, "y": 25}, "size": {"width": 110, "height": 90}, "rotation": 0, "opacity": 0.6}]',
'{"Playfair Display", "Great Vibes", "Lora"}', false, 24),

('Altın Yıldız Nişan', 'Yıldız temalı büyülü nişan', 'engagement', 'star', 'premium',
'https://images.unsplash.com/photo-1464047736614-af63643285bf?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1464047736614-af63643285bf?w=800&h=600&fit=crop',
'{"primary": "#1A237E", "secondary": "#283593", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "star_wish", "label": "Yıldız Dileği", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[{"id": "fireworks-1", "type": "celebration", "name": "Havai Fişek", "imageUrl": "/graphics/Fireworks-PNG-File.png", "position": {"x": 70, "y": 30}, "size": {"width": 110, "height": 130}, "rotation": 0, "opacity": 0.5}]',
'{"Dancing Script", "Pacifico", "Satisfy"}', false, 25);

-- =====================================================
-- CATEGORY 3: DOĞUM GÜNÜ (15 templates: 5 FREE, 5 PRO, 5 PREMIUM)
-- =====================================================

-- FREE DOĞUM GÜNÜ TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Neşeli Doğum Günü', 'Renkli ve neşeli doğum günü davetiyesi', 'birthday', 'fun', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Fredoka One", "Quicksand", "Baloo 2"}', true, 26),

('Balon Doğum Günü', 'Balon temalı doğum günü', 'birthday', 'balloon', 'free',
'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=800&h=600&fit=crop',
'{"primary": "#F44336", "secondary": "#FF5722", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[]', '[]',
'{"Fredoka One", "Righteous", "Baloo 2"}', false, 27),

('Pasta Doğum Günü', 'Pasta temalı tatlı doğum günü', 'birthday', 'cake', 'free',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=800&h=600&fit=crop',
'{"primary": "#FF6B9D", "secondary": "#FFA8C5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C2185B"}',
'[]', '[]',
'{"Pacifico", "Fredoka One", "Quicksand"}', false, 28),

('Çocuk Doğum Günü', 'Çocuklar için renkli doğum günü', 'birthday', 'kids', 'free',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=800&h=600&fit=crop',
'{"primary": "#42A5F5", "secondary": "#66BB6A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFCA28"}',
'[]', '[]',
'{"Fredoka One", "Baloo 2", "Righteous"}', false, 29),

('Yetişkin Doğum Günü', 'Zarif yetişkin doğum günü davetiyesi', 'birthday', 'adult', 'free',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=800&h=600&fit=crop',
'{"primary": "#5E35B1", "secondary": "#7E57C2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Lato"}', false, 30);

-- PRO DOĞUM GÜNÜ TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Altın Doğum Günü', 'Altın detaylı özel doğum günü', 'birthday', 'gold', 'pro',
'https://images.unsplash.com/photo-1464347744102-11db6282f854?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1464347744102-11db6282f854?w=800&h=600&fit=crop',
'{"primary": "#F57F17", "secondary": "#FBC02D", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "age_milestone", "label": "Yaş Dönümü", "defaultValue": "", "style": {"fontSize": 24, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Playfair Display", "Raleway"}', true, 31),

('Temalı Parti', 'Tema partisi doğum günü davetiyesi', 'birthday', 'theme_party', 'pro',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "theme_info", "label": "Tema Bilgisi", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[]',
'{"Fredoka One", "Righteous", "Quicksand"}', false, 32),

('Vintage Doğum Günü', 'Nostaljik vintage doğum günü', 'birthday', 'vintage', 'pro',
'https://images.unsplash.com/photo-1531956656798-56686eeef3d4?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1531956656798-56686eeef3d4?w=800&h=600&fit=crop',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_note", "label": "Nostaljik Not", "defaultValue": "", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]',
'{"Lora", "Playfair Display", "Merriweather"}', false, 33),

('Gökkuşağı Doğum Günü', 'Renkli gökkuşağı doğum günü', 'birthday', 'rainbow', 'pro',
'https://images.unsplash.com/photo-1481391243133-f96216dcb5d2?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1481391243133-f96216dcb5d2?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "rainbow_wish", "label": "Gökkuşağı Dileği", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]',
'{"Pacifico", "Fredoka One", "Quicksand"}', false, 34),

('Havuz Partisi', 'Yaz havuz partisi doğum günü', 'birthday', 'pool_party', 'pro',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=800&h=600&fit=crop',
'{"primary": "#0288D1", "secondary": "#03A9F4", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFA726"}',
'[{"id": "pool_info", "label": "Havuz Bilgisi", "defaultValue": "", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Poppins", "Raleway"}', false, 35);

-- PREMIUM DOĞUM GÜNÜ TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Kraliyet Doğum Günü', 'Muhteşem kraliyet doğum günü', 'birthday', 'royal', 'premium',
'https://images.unsplash.com/photo-1464347744102-11db6282f854?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1464347744102-11db6282f854?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_celebration", "label": "Kraliyet Kutlaması", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "crown-frame", "type": "elegant", "name": "Altın Çerçeve", "imageUrl": "/graphics/Frame-Border-PNG-HD.png", "position": {"x": 50, "y": 50}, "size": {"width": 160, "height": 160}, "rotation": 0, "opacity": 0.3}]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 36),

('Konfeti Patlaması', 'Renkli konfeti doğum günü', 'birthday', 'confetti', 'premium',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "party_blast", "label": "Parti Patlaması", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[{"id": "confetti-1", "type": "celebration", "name": "Renkli Konfeti", "imageUrl": "/graphics/Red-Confetti-PNG-Pic.png", "position": {"x": 50, "y": 20}, "size": {"width": 130, "height": 130}, "rotation": 0, "opacity": 0.7}, {"id": "balloons-1", "type": "party", "name": "Renkli Balon Demeti", "imageUrl": "/graphics/Bunch-of-Balloons-PNG-Image.png", "position": {"x": 70, "y": 75}, "size": {"width": 120, "height": 140}, "rotation": 15, "opacity": 0.8}]',
'{"Fredoka One", "Righteous", "Baloo 2"}', true, 37),

('Yıldızlar Doğum Günü', 'Işıltılı yıldızlı doğum günü', 'birthday', 'stars', 'premium',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=800&h=600&fit=crop',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "star_wish", "label": "Yıldız Dileği", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[{"id": "fireworks-1", "type": "celebration", "name": "Pembe Havai Fişek", "imageUrl": "/graphics/Pink-Vector-Fireworks-PNG-File.png", "position": {"x": 50, "y": 25}, "size": {"width": 100, "height": 120}, "rotation": 0, "opacity": 0.6}]',
'{"Pacifico", "Dancing Script", "Satisfy"}', false, 38),

('Süper Kahraman Parti', 'Süper kahramanlı doğum günü', 'birthday', 'superhero', 'premium',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "hero_power", "label": "Süper Güç", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[{"id": "party-hat", "type": "birthday", "name": "Parti Şapkası", "imageUrl": "/graphics/Party-Hat-PNG-Transparent-Image.png", "position": {"x": 30, "y": 20}, "size": {"width": 90, "height": 110}, "rotation": -20, "opacity": 0.7}]',
'{"Fredoka One", "Righteous", "Baloo 2"}', false, 39),

('Prenses Parti', 'Prenses temalı doğum günü', 'birthday', 'princess', 'premium',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=800&h=600&fit=crop',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "princess_wish", "label": "Prenses Dileği", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Great Vibes"}}]',
'[{"id": "gold-bow", "type": "elegant", "name": "Altın Fiyonk", "imageUrl": "/graphics/Gold-Bow-PNG-Image.png", "position": {"x": 50, "y": 15}, "size": {"width": 90, "height": 80}, "rotation": 0, "opacity": 0.7}]',
'{"Great Vibes", "Dancing Script", "Pacifico"}', false, 40);

-- Commit changes so far
COMMIT;

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ 40 templates created successfully (Wedding, Engagement, Birthday)!';
END $$;

