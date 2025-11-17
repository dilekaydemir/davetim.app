-- =====================================================
-- BEBEK ŞÖLENİ TEMPLATES (8) - BEBEK, HAMİLE, BEBEK EŞYALARI
-- =====================================================
-- Her fotoğraf bebek, hamile kadın, bebek odası temalıdır

DELETE FROM public.templates WHERE category = 'baby_shower';

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- FREE (3)
('Mavi Bebek Şöleni', 'Erkek bebek için mavi tonlar', 'baby_shower', 'boy', 'free',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800&h=600&fit=crop&q=80',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[]', '[]', '{"Quicksand", "Baloo 2", "Poppins"}', true, 41),

('Pembe Bebek Şöleni', 'Kız bebek için pembe tonlar', 'baby_shower', 'girl', 'free',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=800&h=600&fit=crop&q=80',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Quicksand", "Baloo 2", "Dancing Script"}', true, 42),

('Nötr Bebek Şöleni', 'Cinsiyetsiz bej-yeşil tonlar', 'baby_shower', 'neutral', 'free',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800&h=600&fit=crop&q=80',
'{"primary": "#8D6E63", "secondary": "#A1887F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#AED581"}',
'[]', '[]', '{"Lora", "Quicksand", "Open Sans"}', false, 43),

-- PRO (3)
('İkiz Bebek Şöleni', 'İkizler için özel tasarım', 'baby_shower', 'twins', 'pro',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800&h=600&fit=crop&q=80',
'{"primary": "#9C27B0", "secondary": "#BA68C8", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "twins_announce", "label": "İkiz Müjdesi", "defaultValue": "Çift mutluluk geliyor, ikiz bebeklerimiz!", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 44),

('Ayıcık Bebek', 'Ayıcık temalı sevimli şölen', 'baby_shower', 'teddy', 'pro',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=800&h=600&fit=crop&q=80',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#FFB74D"}',
'[{"id": "teddy_love", "label": "Ayıcık Sevgisi", "defaultValue": "Sevimli ayıcıklar gibi tatlı bebeğimiz", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Baloo 2"}}]',
'[]', '{"Baloo 2", "Quicksand", "Fredoka One"}', false, 45),

('Bulut Bebek', 'Bulut ve yıldız temalı', 'baby_shower', 'cloud', 'pro',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800&h=600&fit=crop&q=80',
'{"primary": "#5E92F3", "secondary": "#90CAF9", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "cloud_dream", "label": "Bulut Rüyası", "defaultValue": "Bulutların arasından gelen küçük melek", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]', '{"Quicksand", "Baloo 2", "Poppins"}', false, 46),

-- PREMIUM (2)
('Lüks Bebek Şöleni', 'Altın detaylı lüks bebek şöleni', 'baby_shower', 'luxury', 'premium',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800&h=600&fit=crop&q=80',
'{"primary": "#64B5F6", "secondary": "#90CAF9", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_baby", "label": "Lüks Bebek", "defaultValue": "Prens/Prenses bebeğimizin şatafatlı karşılanışı", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Quicksand", "Cinzel"}', true, 47),

('Kraliyet Bebek', 'Kraliyet temalı bebek şöleni', 'baby_shower', 'royal', 'premium',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800&h=600&fit=crop&q=80',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_baby", "label": "Kraliyet Bebeği", "defaultValue": "Kraliyet ailesinin yeni üyesi geliyor", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 48);

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE '8 Baby Shower templates created with verified baby photos!';
END $$;

