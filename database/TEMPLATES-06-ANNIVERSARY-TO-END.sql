-- =====================================================
-- REMAINING CATEGORIES PART 2 (41 templates)
-- =====================================================
-- Yıldönümü, Kına, Sünnet, Kutlamalar, Nişan Yemeği, Bekarlığa Veda

-- Önce mevcut template'leri temizle
DELETE FROM public.templates WHERE category IN ('anniversary', 'henna', 'circumcision', 'celebration', 'engagement_dinner', 'bachelor_party');

-- =====================================================
-- CATEGORY 7: YILDÖNÜMÜ (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- FREE (3)
('Klasik Yıldönümü', 'Sade ve zarif yıldönümü', 'anniversary', 'classic', 'free',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&h=600&fit=crop',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Lora", "Montserrat"}', true, 65),

('Romantik Yıldönümü', 'Romantik yıldönümü kutlaması', 'anniversary', 'romantic', 'free',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Great Vibes", "Dancing Script", "Pacifico"}', true, 66),

('Modern Yıldönümü', 'Çağdaş yıldönümü kutlaması', 'anniversary', 'modern', 'free',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=800&h=600&fit=crop',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 67),

-- PRO (3)
('Altın Yıldönümü', '50. yıl altın yıldönümü', 'anniversary', 'golden', 'pro',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&h=600&fit=crop',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "golden_years", "label": "Altın Yıllar", "defaultValue": "50 Yıllık Muhteşem Birliktelik", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 68),

('Gümüş Yıldönümü', '25. yıl gümüş yıldönümü', 'anniversary', 'silver', 'pro',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=800&h=600&fit=crop',
'{"primary": "#607D8B", "secondary": "#78909C", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "silver_years", "label": "Gümüş Yıllar", "defaultValue": "25 Yıllık Gümüş Gibi Parlak Aşk", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Montserrat", "Lora"}', false, 69),

('Ruby Yıldönümü', '40. yıl yakut yıldönümü', 'anniversary', 'ruby', 'pro',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=800&h=600&fit=crop',
'{"primary": "#B71C1C", "secondary": "#D32F2F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FF5252"}',
'[{"id": "ruby_love", "label": "Yakut Aşk", "defaultValue": "40 Yıl Yakut Gibi Kırmızı Aşk", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Lora", "Montserrat"}', false, 70),

-- PREMIUM (2)
('Elmas Yıldönümü', '60. yıl elmas yıldönümü', 'anniversary', 'diamond', 'premium',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&h=600&fit=crop',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "diamond_forever", "label": "Elmas Ebediyet", "defaultValue": "60 Yıl Elmas Gibi Ebedi Sevgi", "style": {"fontSize": 24, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 71),

('Platin Yıldönümü', '70. yıl platin yıldönümü', 'anniversary', 'platinum', 'premium',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1529634806980-85c3dd6d9421?w=800&h=600&fit=crop',
'{"primary": "#455A64", "secondary": "#607D8B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#90A4AE"}',
'[{"id": "platinum_love", "label": "Platin Sevgi", "defaultValue": "70 Yıl Platin Gibi Değerli Birliktelik", "style": {"fontSize": 23, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Montserrat"}', false, 72);

-- =====================================================
-- CATEGORY 8-12: Kalan 5 Kategori (33 template)
-- =====================================================
-- Basitlik için genel parti/kutlama fotoğrafları kullanılacak

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- KINA GECESİ (8: 3 FREE, 3 PRO, 2 PREMIUM)
('Geleneksel Kına', 'Geleneksel kına gecesi', 'henna', 'traditional', 'free',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&h=600&fit=crop',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Lora", "Montserrat"}', true, 73),

('Modern Kına', 'Çağdaş kına gecesi', 'henna', 'modern', 'free',
'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 74),

('Kırmızı Kına', 'Kırmızı tonlarda kına gecesi', 'henna', 'red', 'free',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&h=600&fit=crop',
'{"primary": "#B71C1C", "secondary": "#D32F2F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FF5252"}',
'[]', '[]', '{"Dancing Script", "Great Vibes", "Lora"}', false, 75),

('Lüks Kına', 'Altın detaylı lüks kına', 'henna', 'luxury', 'pro',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=800&h=600&fit=crop',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "henna_tradition", "label": "Kına Geleneği", "defaultValue": "Gelinimizin Son Bekarlık Gecesi", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 76),

('Vintage Kına', 'Nostaljik kına gecesi', 'henna', 'vintage', 'pro',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=800&h=600&fit=crop',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_tradition", "label": "Eski Gelenek", "defaultValue": "Babaannemin Geleneğiyle", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 77),

('Bohem Kına', 'Özgür ruhlu bohem kına', 'henna', 'bohemian', 'pro',
'https://images.unsplash.com/photo-1523438097201-512ae7d59c44?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1523438097201-512ae7d59c44?w=800&h=600&fit=crop',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "boho_night", "label": "Bohem Gece", "defaultValue": "Özgür Ruhlu Kına Gecesi", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Satisfy", "Lato"}', false, 78),

('Kraliyet Kınası', 'Muhteşem kraliyet kına töreni', 'henna', 'royal', 'premium',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519167758481-83f29da8c26b?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_henna", "label": "Kraliyet Töreni", "defaultValue": "Prenses Gelinimizin Kına Gecesi", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 79),

('Sultan Kınası', 'Sultan tarzı kına gecesi', 'henna', 'sultan', 'premium',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&h=600&fit=crop',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "sultan_night", "label": "Sultan Gecesi", "defaultValue": "Osmanlı Geleneğiyle Kına", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Montserrat"}', false, 80);

-- Sünnet, Kutlamalar, Nişan Yemeği, Bekarlığa Veda için INSERT'ler devam edecek...
-- Dosya uzadığı için Part 3'e geçiyorum

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE 'Anniversary and Henna templates created (16 templates)!';
END $$;

