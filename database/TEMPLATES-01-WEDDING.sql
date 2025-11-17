-- =====================================================
-- CATEGORY 1: DÜĞÜN (15 templates: 5 FREE, 5 PRO, 5 PREMIUM)
-- =====================================================
-- Her template için özenle seçilmiş, düğün temalı fotoğraflar
-- Unsplash ve diğer kaynaklardan alakalı görseller

-- Önce mevcut template'leri temizle
DELETE FROM public.templates WHERE category = 'wedding';

-- FREE DÜĞÜN TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- 1. Klasik Düğün (Düğün Yüzükleri)
('Klasik Düğün', 'Zamansız ve zarif klasik düğün davetiyesi', 'wedding', 'classic', 'free',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&h=600&fit=crop',
'{"primary": "#2C3E50", "secondary": "#34495E", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]',
'{"Playfair Display", "Montserrat", "Cinzel"}', true, 1),

-- 2. Romantik Düğün (Gelin Eli)
('Romantik Düğün', 'Pembe tonlarında romantik düğün davetiyesi', 'wedding', 'romantic', 'free',
'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=800&h=600&fit=crop',
'{"primary": "#D4567D", "secondary": "#F8B4C6", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Great Vibes", "Lora"}', true, 2),

-- 3. Modern Düğün (Minimalist Gelin Damat)
('Modern Düğün', 'Minimalist ve çağdaş düğün davetiyesi', 'wedding', 'modern', 'free',
'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=800&h=600&fit=crop',
'{"primary": "#1A1A1A", "secondary": "#4A4A4A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 3),

-- 4. Bahçe Düğünü (Açık Hava Düğün Töreni)
('Bahçe Düğünü', 'Doğal ve yeşil tonlarda bahçe düğünü', 'wedding', 'garden', 'free',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800&h=600&fit=crop',
'{"primary": "#2D5016", "secondary": "#7CB342", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]',
'{"Lora", "Raleway", "Open Sans"}', false, 4),

-- 5. Sahil Düğünü (Deniz Kenarı Düğün)
('Sahil Düğünü', 'Deniz manzaralı sahil düğünü', 'wedding', 'beach', 'free',
'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800&h=600&fit=crop',
'{"primary": "#006994", "secondary": "#00A8CC", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F9A825"}',
'[]', '[]',
'{"Lato", "Montserrat", "Raleway"}', false, 5);

-- PRO DÜĞÜN TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- 6. Lüks Düğün (Kristal Avize ve Düğün Masası)
('Lüks Düğün', 'Altın detaylı lüks düğün davetiyesi', 'wedding', 'luxury', 'pro',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800&h=600&fit=crop',
'{"primary": "#8B6914", "secondary": "#B8860B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "venue_details", "label": "Düğün Mekanı", "defaultValue": "Örn: Grand Hyatt İstanbul, Taksim Salonu", "style": {"fontSize": 20, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}, {"id": "dress_code", "label": "Kıyafet Kodu", "defaultValue": "Black Tie / Smokin", "style": {"fontSize": 16, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Playfair Display", "Cinzel", "Bodoni Moda"}', true, 6),

-- 7. Vintage Düğün (Eski Fotoğraf Makinesi ve Çiçekler)
('Vintage Düğün', 'Nostaljik vintage düğün davetiyesi', 'wedding', 'vintage', 'pro',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=800&h=600&fit=crop',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_note", "label": "Özel Mesajınız", "defaultValue": "Bizimle bu özel günü paylaşın", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 7),

-- 8. Kır Düğünü (Rustik Ahşap ve Lavanta)
('Kır Düğünü', 'Rustik kır düğünü davetiyesi', 'wedding', 'rustic', 'pro',
'https://images.unsplash.com/photo-1520854221256-17451cc331bf?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1520854221256-17451cc331bf?w=800&h=600&fit=crop',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FAFAFA", "text": "#3E2723", "accent": "#7CB342"}',
'[{"id": "rustic_welcome", "label": "Karşılama Mesajı", "defaultValue": "Sevgiyle bekliyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]',
'{"Lora", "Merriweather", "Open Sans"}', false, 8),

-- 9. Bohem Düğün (Makrame ve Pampas)
('Bohem Düğün', 'Özgür ruhlu bohem düğün davetiyesi', 'wedding', 'bohemian', 'pro',
'https://images.unsplash.com/photo-1523438097201-512ae7d59c44?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1523438097201-512ae7d59c44?w=800&h=600&fit=crop',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "boho_message", "label": "Doğa Mesajı", "defaultValue": "Doğanın kucağında birleşiyoruz", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]',
'{"Dancing Script", "Satisfy", "Lato"}', false, 9),

-- 10. Gül Bahçesi Düğünü (Pembe Güller)
('Gül Bahçesi Düğünü', 'Gül bahçesinde rüya gibi düğün', 'wedding', 'rose_garden', 'pro',
'https://images.unsplash.com/photo-1490814525860-594e82bfd34b?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1490814525860-594e82bfd34b?w=800&h=600&fit=crop',
'{"primary": "#880E4F", "secondary": "#AD1457", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F48FB1"}',
'[{"id": "rose_garden", "label": "Bahçe Detayları", "defaultValue": "Gül bahçemizde buluşalım", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Great Vibes", "Lora"}', false, 10);

-- PREMIUM DÜĞÜN TEMPLATES (5)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- 11. Kraliyet Düğünü (Taç ve Kırmızı Halı)
('Kraliyet Düğünü', 'Muhteşem kraliyet düğünü davetiyesi', 'wedding', 'royal', 'premium',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_title", "label": "Kraliyet Unvanı", "defaultValue": "Saygıdeğer Misafirlerimiz", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}, {"id": "royal_dress", "label": "Resmi Kıyafet", "defaultValue": "White Tie / Frak", "style": {"fontSize": 16, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 11),

-- 12. Peri Masalı Düğünü (Sihirli Orman)
('Peri Masalı Düğünü', 'Masalsı peri düğünü davetiyesi', 'wedding', 'fairytale', 'premium',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800&h=600&fit=crop',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "fairy_tale", "label": "Masal Başlangıcı", "defaultValue": "Bir varmış bir yokmuş, iki gönül bir olmuş...", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]',
'{"Dancing Script", "Great Vibes", "Pacifico"}', true, 12),

-- 13. Beyaz Gül Düğünü (Beyaz Güller ve İnciler)
('Beyaz Gül Düğünü', 'Beyaz güller eşliğinde şık düğün', 'wedding', 'white_rose', 'premium',
'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800&h=600&fit=crop',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "white_elegance", "label": "Zarafet Mesajı", "defaultValue": "Saf sevgimizle sizleri bekliyoruz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Lora", "Montserrat"}', false, 13),

-- 14. Kristal Düğün (Kristal Avize)
('Kristal Düğün', 'Işıltılı kristal düğün davetiyesi', 'wedding', 'crystal', 'premium',
'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=800&h=600&fit=crop',
'{"primary": "#455A64", "secondary": "#607D8B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "crystal_sparkle", "label": "Işıltı Mesajı", "defaultValue": "Işıltımızla mutluluğumuzu paylaşıyoruz", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Montserrat", "Raleway"}', false, 14),

-- 15. Gün Batımı Düğünü (Romantik Sunset)
('Gün Batımı Düğünü', 'Romantik gün batımında düğün', 'wedding', 'sunset', 'premium',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#FF6F00", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "sunset_romance", "label": "Gün Batımı Aşkı", "defaultValue": "Güneş batarken sevgimiz doğuyor", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]',
'{"Pacifico", "Dancing Script", "Great Vibes"}', false, 15);

-- Commit
COMMIT;

-- Notify schema reload
NOTIFY pgrst, 'reload schema';

-- Success message
DO $$
BEGIN
  RAISE NOTICE '15 Wedding templates created successfully with relevant photos!';
END $$;

