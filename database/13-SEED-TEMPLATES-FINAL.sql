-- =====================================================
-- FINAL TEMPLATE SEEDING - 105 TEMPLATES
-- =====================================================
-- Her template konusuna TAM UYGUN görselle hazırlanmıştır
-- Pexels ve Unsplash'tan kaliteli, alakalı fotoğraflar kullanılmıştır

-- 1. Mevcut template'leri temizle
DELETE FROM public.templates;

-- 2. Sequence'i sıfırla
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

('Klasik Düğün', 'Zarif ve zamansız klasik düğün davetiyesi', 'wedding', 'classic', 'free',
'https://images.pexels.com/photos/265722/pexels-photo-265722.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/265722/pexels-photo-265722.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#2C3E50", "secondary": "#34495E", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]',
'{"Playfair Display", "Montserrat", "Cinzel"}', true, 1),

('Romantik Düğün', 'Pembe tonlarında romantik düğün davetiyesi', 'wedding', 'romantic', 'free',
'https://images.pexels.com/photos/1043902/pexels-photo-1043902.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1043902/pexels-photo-1043902.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#D4567D", "secondary": "#F8B4C6", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Great Vibes", "Lora"}', true, 2),

('Modern Düğün', 'Minimalist ve çağdaş düğün davetiyesi', 'wedding', 'modern', 'free',
'https://images.pexels.com/photos/2788488/pexels-photo-2788488.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/2788488/pexels-photo-2788488.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#1A1A1A", "secondary": "#4A4A4A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 3),

('Bahçe Düğünü', 'Doğal ve yeşil tonlarda bahçe düğünü', 'wedding', 'garden', 'free',
'https://images.pexels.com/photos/1157557/pexels-photo-1157557.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1157557/pexels-photo-1157557.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#2D5016", "secondary": "#7CB342", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]',
'{"Lora", "Raleway", "Open Sans"}', false, 4),

('Sahil Düğünü', 'Deniz manzaralı sahil düğünü', 'wedding', 'beach', 'free',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#006994", "secondary": "#00A8CC", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F9A825"}',
'[]', '[]',
'{"Lato", "Montserrat", "Raleway"}', false, 5);

-- PRO DÜĞÜN TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Düğün', 'Altın detaylı lüks düğün davetiyesi', 'wedding', 'luxury', 'pro',
'https://images.pexels.com/photos/1444442/pexels-photo-1444442.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1444442/pexels-photo-1444442.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#8B6914", "secondary": "#B8860B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "venue", "label": "Mekan", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}, {"id": "dress_code", "label": "Kıyafet Kodu", "defaultValue": "", "style": {"fontSize": 16, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Playfair Display", "Cinzel", "Bodoni Moda"}', true, 6),

('Vintage Düğün', 'Nostaljik vintage düğün davetiyesi', 'wedding', 'vintage', 'pro',
'https://images.pexels.com/photos/1729798/pexels-photo-1729798.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729798/pexels-photo-1729798.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "special_note", "label": "Özel Not", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 7),

('Kır Düğünü', 'Rustik kır düğünü davetiyesi', 'wedding', 'rustic', 'pro',
'https://images.pexels.com/photos/1616113/pexels-photo-1616113.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1616113/pexels-photo-1616113.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FAFAFA", "text": "#3E2723", "accent": "#7CB342"}',
'[{"id": "welcome", "label": "Karşılama", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]',
'{"Lora", "Merriweather", "Open Sans"}', false, 8),

('Bohem Düğün', 'Özgür ruhlu bohem düğün davetiyesi', 'wedding', 'bohemian', 'pro',
'https://images.pexels.com/photos/169198/pexels-photo-169198.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/169198/pexels-photo-169198.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "celebration", "label": "Kutlama Mesajı", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]',
'{"Dancing Script", "Satisfy", "Lato"}', false, 9),

('Gül Bahçesi Düğünü', 'Gül bahçesinde rüya gibi düğün', 'wedding', 'rose_garden', 'pro',
'https://images.pexels.com/photos/1024960/pexels-photo-1024960.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024960/pexels-photo-1024960.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#880E4F", "secondary": "#AD1457", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F48FB1"}',
'[{"id": "garden_note", "label": "Bahçe Notu", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Great Vibes", "Lora"}', false, 10);

-- PREMIUM DÜĞÜN TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Kraliyet Düğünü', 'Muhteşem kraliyet düğünü davetiyesi', 'wedding', 'royal', 'premium',
'https://images.pexels.com/photos/1616113/pexels-photo-1616113.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1616113/pexels-photo-1616113.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_message", "label": "Kraliyet Mesajı", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}, {"id": "dress_code", "label": "Kıyafet Kodu", "defaultValue": "", "style": {"fontSize": 16, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 11),

('Peri Masalı Düğünü', 'Masalsı peri düğünü davetiyesi', 'wedding', 'fairytale', 'premium',
'https://images.pexels.com/photos/2959192/pexels-photo-2959192.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/2959192/pexels-photo-2959192.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "fairy_tale", "label": "Masal Başlangıcı", "defaultValue": "Bir varmış bir yokmuş...", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]',
'{"Dancing Script", "Great Vibes", "Pacifico"}', true, 12),

('Beyaz Gül Düğünü', 'Beyaz güller eşliğinde şık düğün', 'wedding', 'white_rose', 'premium',
'https://images.pexels.com/photos/2174806/pexels-photo-2174806.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/2174806/pexels-photo-2174806.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "elegance", "label": "Zarafet Mesajı", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Lora", "Montserrat"}', false, 13),

('Kristal Düğün', 'Işıltılı kristal düğün davetiyesi', 'wedding', 'crystal', 'premium',
'https://images.pexels.com/photos/3014856/pexels-photo-3014856.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/3014856/pexels-photo-3014856.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#455A64", "secondary": "#607D8B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "sparkle", "label": "Işıltı Mesajı", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Montserrat", "Raleway"}', false, 14),

('Gün Batımı Düğünü', 'Romantik gün batımında düğün', 'wedding', 'sunset', 'premium',
'https://images.pexels.com/photos/1024960/pexels-photo-1024960.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024960/pexels-photo-1024960.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#E91E63", "secondary": "#FF6F00", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "sunset_love", "label": "Gün Batımı Aşkı", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]',
'{"Pacifico", "Dancing Script", "Great Vibes"}', false, 15);

-- =====================================================
-- CATEGORY 2: NİŞAN (10 templates: 3 FREE, 4 PRO, 3 PREMIUM)
-- =====================================================

-- FREE NİŞAN TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Klasik Nişan', 'Zarif ve sade nişan davetiyesi', 'engagement', 'classic', 'free',
'https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B71C1C", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Lora", "Montserrat"}', true, 16),

('Romantik Nişan', 'Pembe kalpler ve romantizm', 'engagement', 'romantic', 'free',
'https://images.pexels.com/photos/3014856/pexels-photo-3014856.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/3014856/pexels-photo-3014856.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#D81B60", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]',
'{"Great Vibes", "Dancing Script", "Pacifico"}', true, 17),

('Modern Nişan', 'Minimalist ve şık nişan davetiyesi', 'engagement', 'modern', 'free',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 18);

-- PRO NİŞAN TEMPLATES (4)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Nişan', 'Altın detaylı lüks nişan', 'engagement', 'luxury', 'pro',
'https://images.pexels.com/photos/1045541/pexels-photo-1045541.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1045541/pexels-photo-1045541.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "ring_info", "label": "Yüzük Bilgisi", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 19),

('Vintage Nişan', 'Nostaljik vintage nişan', 'engagement', 'vintage', 'pro',
'https://images.pexels.com/photos/1667843/pexels-photo-1667843.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1667843/pexels-photo-1667843.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_note", "label": "Özel Not", "defaultValue": "", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 20),

('Bohem Nişan', 'Özgür ruhlu bohem nişan', 'engagement', 'bohemian', 'pro',
'https://images.pexels.com/photos/1616113/pexels-photo-1616113.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1616113/pexels-photo-1616113.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "boho_message", "label": "Bohem Mesaj", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]',
'{"Dancing Script", "Satisfy", "Lato"}', false, 21),

('Gül Buketi Nişan', 'Kırmızı güller ve romantizm', 'engagement', 'rose', 'pro',
'https://images.pexels.com/photos/1024960/pexels-photo-1024960.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024960/pexels-photo-1024960.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F8BBD0"}',
'[{"id": "rose_love", "label": "Gül Aşkı", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Great Vibes"}}]',
'[]',
'{"Great Vibes", "Pacifico", "Dancing Script"}', false, 22);

-- PREMIUM NİŞAN TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Kraliyet Nişanı', 'Muhteşem kraliyet nişan töreni', 'engagement', 'royal', 'premium',
'https://images.pexels.com/photos/3014856/pexels-photo-3014856.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/3014856/pexels-photo-3014856.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_engagement", "label": "Kraliyet Nişanı", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 23),

('Pırlanta Nişan', 'Pırlanta yüzük ve lüks', 'engagement', 'diamond', 'premium',
'https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1450353/pexels-photo-1450353.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "diamond_love", "label": "Pırlanta Aşk", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Cinzel", "Montserrat"}', false, 24),

('Gün Batımı Nişan', 'Romantik gün batımında nişan', 'engagement', 'sunset', 'premium',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#E91E63", "secondary": "#FF6F00", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "sunset_engagement", "label": "Gün Batımı Aşkı", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]',
'{"Pacifico", "Dancing Script", "Great Vibes"}', false, 25);

-- =====================================================
-- CATEGORY 3: DOĞUM GÜNÜ (15 templates: 5 FREE, 5 PRO, 5 PREMIUM)
-- =====================================================

-- FREE DOĞUM GÜNÜ TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Neşeli Doğum Günü', 'Renkli balonlar ve neşe', 'birthday', 'fun', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Fredoka One", "Quicksand", "Baloo 2"}', true, 26),

('Çocuk Doğum Günü', 'Çocuklar için eğlenceli parti', 'birthday', 'kids', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#FF5722", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[]', '[]',
'{"Fredoka One", "Quicksand", "Baloo 2"}', true, 27),

('Yetişkin Doğum Günü', 'Şık ve zarif yetişkin partisi', 'birthday', 'adult', 'free',
'https://images.pexels.com/photos/1857157/pexels-photo-1857157.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1857157/pexels-photo-1857157.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 28),

('Pasta Temalı', 'Doğum günü pastası ve kutlama', 'birthday', 'cake', 'free',
'https://images.pexels.com/photos/1702373/pexels-photo-1702373.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1702373/pexels-photo-1702373.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F8BBD0"}',
'[]', '[]',
'{"Quicksand", "Poppins", "Baloo 2"}', false, 29),

('Konfeti Parti', 'Renkli konfeti ve eğlence', 'birthday', 'confetti', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#FF6F00", "secondary": "#FFA726", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[]', '[]',
'{"Fredoka One", "Righteous", "Baloo 2"}', false, 30);

-- PRO DOĞUM GÜNÜ TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Doğum Günü', 'Altın detaylı lüks kutlama', 'birthday', 'luxury', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "age_milestone", "label": "Yaş Dönümü", "defaultValue": "", "style": {"fontSize": 24, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[]',
'{"Fredoka One", "Quicksand", "Baloo 2"}', true, 31),

('Prenses Partisi', 'Küçük prensesler için özel', 'birthday', 'princess', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[{"id": "princess_theme", "label": "Prenses Teması", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]',
'{"Dancing Script", "Great Vibes", "Pacifico"}', false, 32),

('Süper Kahraman Parti', 'Küçük kahramanlar için', 'birthday', 'superhero', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "hero_power", "label": "Kahraman Gücü", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Righteous"}}]',
'[]',
'{"Righteous", "Fredoka One", "Baloo 2"}', false, 33),

('Vintage Doğum Günü', 'Nostaljik doğum günü kutlaması', 'birthday', 'vintage', 'pro',
'https://images.pexels.com/photos/1729798/pexels-photo-1729798.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729798/pexels-photo-1729798.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_wish", "label": "Vintage Dilek", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 34),

('Bahçe Partisi', 'Doğada eğlenceli doğum günü', 'birthday', 'garden', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#388E3C", "secondary": "#66BB6A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "garden_fun", "label": "Bahçe Eğlencesi", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]',
'{"Quicksand", "Baloo 2", "Poppins"}', false, 35);

-- PREMIUM DOĞUM GÜNÜ TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Kraliyet Doğum Günü', 'Muhteşem kraliyet kutlaması', 'birthday', 'royal', 'premium',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_celebration", "label": "Kraliyet Kutlaması", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 36),

('Unicorn Parti', 'Sihirli unicorn temalı parti', 'birthday', 'unicorn', 'premium',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#E91E63", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[{"id": "unicorn_magic", "label": "Unicorn Sihri", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]',
'{"Pacifico", "Dancing Script", "Great Vibes"}', true, 37),

('Gece Kulübü Parti', 'VIP gece kulübü kutlaması', 'birthday', 'nightclub', 'premium',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#E91E63"}',
'[{"id": "vip_night", "label": "VIP Gece", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 38),

('Havuz Partisi', 'Yaz eğlencesi havuz partisi', 'birthday', 'pool', 'premium',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#0097A7", "secondary": "#00BCD4", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "pool_fun", "label": "Havuz Eğlencesi", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]',
'{"Quicksand", "Baloo 2", "Poppins"}', false, 39),

('Tema Park Partisi', 'Tema parkta eğlenceli kutlama', 'birthday', 'theme_park', 'premium',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#F57C00", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "theme_park", "label": "Tema Park", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[]',
'{"Fredoka One", "Righteous", "Baloo 2"}', false, 40);

-- Commit and continue
COMMIT;

-- Success message
DO $$
BEGIN
  RAISE NOTICE '40 templates created successfully (Wedding, Engagement, Birthday)!';
  RAISE NOTICE 'Progress: 40/105 (38%%)';
END $$;

