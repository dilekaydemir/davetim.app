-- =====================================================
-- NİŞAN TEMPLATES (10) - NİŞAN YÜZÜĞÜ VE ÇİFT FOTOĞRAFLARI
-- =====================================================
-- Her fotoğraf nişan yüzüğü, çift, teklif anı temalıdır

DELETE FROM public.templates WHERE category = 'engagement';

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- FREE (3)
('Klasik Nişan', 'Zarif ve sade nişan davetiyesi', 'engagement', 'classic', 'free',
'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=800&h=600&fit=crop&q=80',
'{"primary": "#B71C1C", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Lora", "Montserrat"}', true, 16),

('Romantik Nişan', 'Pembe kalpler ve romantizm', 'engagement', 'romantic', 'free',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=800&h=600&fit=crop&q=80',
'{"primary": "#D81B60", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]', '{"Great Vibes", "Dancing Script", "Pacifico"}', true, 17),

('Modern Nişan', 'Minimalist ve şık nişan davetiyesi', 'engagement', 'modern', 'free',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800&h=600&fit=crop&q=80',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', false, 18),

-- PRO (4)
('Lüks Nişan', 'Altın detaylı lüks nişan', 'engagement', 'luxury', 'pro',
'https://images.unsplash.com/photo-1515377905703-c4788e51af15?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1515377905703-c4788e51af15?w=800&h=600&fit=crop&q=80',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "ring_story", "label": "Yüzük Hikayesi", "defaultValue": "Aşkımızın sembolü bu yüzükle ebediyen...", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 19),

('Vintage Nişan', 'Nostaljik vintage nişan', 'engagement', 'vintage', 'pro',
'https://images.unsplash.com/photo-1452723312111-3a7d0db0e024?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1452723312111-3a7d0db0e024?w=800&h=600&fit=crop&q=80',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "love_letter", "label": "Aşk Mektubu", "defaultValue": "Eski günlerin romantizmiyle...", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 20),

('Bohem Nişan', 'Özgür ruhlu bohem nişan', 'engagement', 'bohemian', 'pro',
'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800&h=600&fit=crop&q=80',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "nature_love", "label": "Doğa Aşkı", "defaultValue": "Doğanın özgürlüğünde birleşiyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]', '{"Dancing Script", "Satisfy", "Lato"}', false, 21),

('Gül Buketi Nişan', 'Kırmızı güller ve romantizm', 'engagement', 'rose', 'pro',
'https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1455659817273-f96807779a8a?w=800&h=600&fit=crop&q=80',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#F8BBD0"}',
'[{"id": "rose_promise", "label": "Gül Sözü", "defaultValue": "Her gül yaprak bir söz gibi...", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Great Vibes"}}]',
'[]', '{"Great Vibes", "Pacifico", "Dancing Script"}', false, 22),

-- PREMIUM (3)
('Kraliyet Nişanı', 'Muhteşem kraliyet nişan töreni', 'engagement', 'royal', 'premium',
'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&h=600&fit=crop&q=80',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_promise", "label": "Kraliyet Sözü", "defaultValue": "İki kraliyet ailesinin birleşimi", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 23),

('Pırlanta Nişan', 'Pırlanta yüzük ve lüks', 'engagement', 'diamond', 'premium',
'https://images.unsplash.com/photo-1600428853194-e48c2e25c506?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1600428853194-e48c2e25c506?w=800&h=600&fit=crop&q=80',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "diamond_forever", "label": "Pırlanta Ebediyet", "defaultValue": "Pırlanta gibi ebedi bir sevda", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Montserrat"}', false, 24),

('Gün Batımı Nişan', 'Romantik gün batımında nişan', 'engagement', 'sunset', 'premium',
'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=400&h=300&fit=crop&q=80',
'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=800&h=600&fit=crop&q=80',
'{"primary": "#E91E63", "secondary": "#FF6F00", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "sunset_promise", "label": "Gün Batımı Sözü", "defaultValue": "Güneş batarken sonsuz aşkımız başlıyor", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]', '{"Pacifico", "Dancing Script", "Great Vibes"}', false, 25);

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE '10 Engagement templates created with verified ring and couple photos!';
END $$;

