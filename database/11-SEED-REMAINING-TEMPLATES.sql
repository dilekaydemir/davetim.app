-- =====================================================
-- REMAINING 65 TEMPLATES (Part 2 of Template Seeding)
-- =====================================================
-- This file adds templates 41-105
-- Run this AFTER 10-CLEAN-AND-SEED-TEMPLATES.sql

-- =====================================================
-- CATEGORY 4: BEBEK ŞÖLENİ (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE BEBEK ŞÖLENİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Mavi Bebek Şöleni', 'Erkek bebek için mavi tonlarda', 'baby_shower', 'boy', 'free',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800&h=600&fit=crop',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[]', '[]',
'{"Quicksand", "Baloo 2", "Poppins"}', false, 41),

('Pembe Bebek Şöleni', 'Kız bebek için pembe tonlarda', 'baby_shower', 'girl', 'free',
'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=800&h=600&fit=crop',
'{"primary": "#F06292", "secondary": "#F8BBD0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[]', '[]',
'{"Quicksand", "Pacifico", "Baloo 2"}', false, 42),

('Sarı Bebek Şöleni', 'Cinsiyetsiz sarı tonlarda bebek şöleni', 'baby_shower', 'neutral', 'free',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=800&h=600&fit=crop',
'{"primary": "#FFA726", "secondary": "#FFD54F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#66BB6A"}',
'[]', '[]',
'{"Quicksand", "Fredoka One", "Baloo 2"}', false, 43);

-- PRO BEBEK ŞÖLENİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Bulut Bebek Şöleni', 'Bulut temalı bebek şöleni', 'baby_shower', 'cloud', 'pro',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800&h=600&fit=crop',
'{"primary": "#64B5F6", "secondary": "#90CAF9", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "baby_name", "label": "Bebek İsmi", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]',
'{"Quicksand", "Baloo 2", "Fredoka One"}', false, 44),

('Ayıcık Bebek Şöleni', 'Sevimli ayıcık temalı', 'baby_shower', 'bear', 'pro',
'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=800&h=600&fit=crop',
'{"primary": "#8D6E63", "secondary": "#A1887F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "teddy_note", "label": "Ayıcık Notu", "defaultValue": "", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Baloo 2"}}]',
'[]',
'{"Baloo 2", "Quicksand", "Fredoka One"}', false, 45),

('Gökkuşağı Bebek', 'Renkli gökkuşağı bebek şöleni', 'baby_shower', 'rainbow', 'pro',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=800&h=600&fit=crop',
'{"primary": "#EC407A", "secondary": "#AB47BC", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "rainbow_baby", "label": "Gökkuşağı Bebeği", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]',
'{"Pacifico", "Quicksand", "Fredoka One"}', false, 46);

-- PREMIUM BEBEK ŞÖLENİ TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Bebek Şöleni', 'Altın detaylı lüks bebek şöleni', 'baby_shower', 'luxury', 'premium',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800&h=600&fit=crop',
'{"primary": "#64B5F6", "secondary": "#90CAF9", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_baby", "label": "Lüks Bebek", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[{"id": "baby-stork", "type": "baby", "name": "Leylek", "imageUrl": "/graphics/Stork-PNG-Transparent-Image.png", "position": {"x": 50, "y": 20}, "size": {"width": 100, "height": 120}, "rotation": 0, "opacity": 0.6}]',
'{"Playfair Display", "Quicksand", "Baloo 2"}', false, 47),

('Yıldızlı Bebek', 'Yıldız temalı bebek şöleni', 'baby_shower', 'stars', 'premium',
'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=800&h=600&fit=crop',
'{"primary": "#F48FB1", "secondary": "#FCE4EC", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "star_baby", "label": "Yıldız Bebeği", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[{"id": "stars-1", "type": "celebration", "name": "Altın Yıldızlar", "imageUrl": "/graphics/Sparkle-Gold-Fireworks-PNG-Clipart.png", "position": {"x": 70, "y": 30}, "size": {"width": 90, "height": 110}, "rotation": 0, "opacity": 0.5}]',
'{"Pacifico", "Dancing Script", "Quicksand"}', false, 48);

-- =====================================================
-- CATEGORY 5: MEZUNİYET (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE MEZUNİYET TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Klasik Mezuniyet', 'Geleneksel mezuniyet davetiyesi', 'graduation', 'classic', 'free',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&h=600&fit=crop',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Lato"}', false, 49),

('Modern Mezuniyet', 'Çağdaş mezuniyet kutlaması', 'graduation', 'modern', 'free',
'https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?w=800&h=600&fit=crop',
'{"primary": "#424242", "secondary": "#616161", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFA726"}',
'[]', '[]',
'{"Poppins", "Raleway", "Open Sans"}', false, 50),

('Renkli Mezuniyet', 'Neşeli renkli mezuniyet', 'graduation', 'colorful', 'free',
'https://images.unsplash.com/photo-1519741347686-c1e0aadf4611?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519741347686-c1e0aadf4611?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Fredoka One", "Quicksand", "Montserrat"}', false, 51);

-- PRO MEZUNİYET TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Altın Mezuniyet', 'Altın detaylı özel mezuniyet', 'graduation', 'gold', 'pro',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&h=600&fit=crop',
'{"primary": "#F57F17", "secondary": "#FBC02D", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "degree_info", "label": "Diploma Bilgisi", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Playfair Display", "Cinzel"}', false, 52),

('Üniversite Mezuniyeti', 'Üniversite mezuniyet töreni', 'graduation', 'university', 'pro',
'https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?w=800&h=600&fit=crop',
'{"primary": "#1565C0", "secondary": "#1E88E5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFCA28"}',
'[{"id": "university_name", "label": "Üniversite Adı", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Raleway"}}]',
'[]',
'{"Raleway", "Montserrat", "Lato"}', false, 53),

('Lise Mezuniyeti', 'Lise mezuniyet balosu', 'graduation', 'high_school', 'pro',
'https://images.unsplash.com/photo-1519741347686-c1e0aadf4611?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519741347686-c1e0aadf4611?w=800&h=600&fit=crop',
'{"primary": "#7B1FA2", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "school_name", "label": "Okul Adı", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Poppins"}}]',
'[]',
'{"Poppins", "Montserrat", "Quicksand"}', false, 54);

-- PREMIUM MEZUNİYET TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Mezuniyet Balosu', 'Muhteşem mezuniyet balosu', 'graduation', 'luxury_ball', 'premium',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#6A1B9A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "achievement", "label": "Başarı", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "diploma-1", "type": "graduation", "name": "Diploma", "imageUrl": "/graphics/Gold-Bow-PNG-Image.png", "position": {"x": 50, "y": 20}, "size": {"width": 100, "height": 90}, "rotation": 0, "opacity": 0.6}]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 55),

('Yıldızlı Başarı', 'Yıldız temalı mezuniyet', 'graduation', 'stars', 'premium',
'https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?w=800&h=600&fit=crop',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "success_story", "label": "Başarı Hikayesi", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[{"id": "confetti-2", "type": "celebration", "name": "Altın Konfeti", "imageUrl": "/graphics/Festive-Gold-Fireworks-PNG-Clipart.png", "position": {"x": 70, "y": 75}, "size": {"width": 110, "height": 130}, "rotation": 0, "opacity": 0.5}]',
'{"Montserrat", "Raleway", "Poppins"}', false, 56);

-- =====================================================
-- CATEGORY 6: İŞ ETKİNLİĞİ (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE İŞ ETKİNLİĞİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Kurumsal Etkinlik', 'Profesyonel kurumsal etkinlik', 'corporate', 'formal', 'free',
'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800&h=600&fit=crop',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Lato"}', false, 57),

('Konferans', 'İş konferansı davetiyesi', 'corporate', 'conference', 'free',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop',
'{"primary": "#424242", "secondary": "#616161", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FF6F00"}',
'[]', '[]',
'{"Roboto", "Open Sans", "Lato"}', false, 58),

('Seminer', 'Eğitim semineri davetiyesi', 'corporate', 'seminar', 'free',
'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=800&h=600&fit=crop',
'{"primary": "#0277BD", "secondary": "#0288D1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFA726"}',
'[]', '[]',
'{"Poppins", "Raleway", "Open Sans"}', false, 59);

-- PRO İŞ ETKİNLİĞİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Gala Gecesi', 'Lüks gala gecesi davetiyesi', 'corporate', 'gala', 'pro',
'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#6A1B9A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "gala_info", "label": "Gala Bilgisi", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Cinzel", "Montserrat"}', false, 60),

('Ürün Lansmanı', 'Ürün tanıtım etkinliği', 'corporate', 'product_launch', 'pro',
'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800&h=600&fit=crop',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "product_name", "label": "Ürün Adı", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Poppins", "Raleway"}', false, 61),

('Networking Etkinliği', 'İş ağı oluşturma etkinliği', 'corporate', 'networking', 'pro',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop',
'{"primary": "#00796B", "secondary": "#009688", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "network_info", "label": "Networking Bilgisi", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Raleway"}}]',
'[]',
'{"Raleway", "Lato", "Open Sans"}', false, 62);

-- PREMIUM İŞ ETKİNLİĞİ TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Kurumsal Gala', 'Altın detaylı kurumsal gala', 'corporate', 'luxury_gala', 'premium',
'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=800&h=600&fit=crop',
'{"primary": "#1A237E", "secondary": "#283593", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "vip_info", "label": "VIP Bilgisi", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "frame-1", "type": "elegant", "name": "Altın Çerçeve", "imageUrl": "/graphics/Frame-Border-PNG-HD.png", "position": {"x": 50, "y": 50}, "size": {"width": 150, "height": 150}, "rotation": 0, "opacity": 0.3}]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 63),

('Ödül Töreni', 'Prestijli ödül töreni', 'corporate', 'award_ceremony', 'premium',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "award_name", "label": "Ödül Adı", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[{"id": "trophy-1", "type": "celebration", "name": "Havai Fişek", "imageUrl": "/graphics/Festive-Gold-Fireworks-PNG-Clipart.png", "position": {"x": 50, "y": 80}, "size": {"width": 120, "height": 140}, "rotation": 0, "opacity": 0.5}]',
'{"Playfair Display", "Cinzel", "Montserrat"}', false, 64);

-- =====================================================
-- CATEGORY 7: YILDONÜMÜ (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE YILDONÜMÜ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Evlilik Yıldönümü', 'Evlilik yıldönümü kutlaması', 'anniversary', 'wedding', 'free',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&h=600&fit=crop',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Lora", "Montserrat"}', false, 65),

('Romantik Yıldönümü', 'Romantik yıldönümü kutlaması', 'anniversary', 'romantic', 'free',
'https://images.unsplash.com/photo-1464047736614-af63643285bf?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1464047736614-af63643285bf?w=800&h=600&fit=crop',
'{"primary": "#AD1457", "secondary": "#D81B60", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Great Vibes", "Dancing Script", "Lato"}', false, 66),

('Modern Yıldönümü', 'Çağdaş yıldönümü kutlaması', 'anniversary', 'modern', 'free',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800&h=600&fit=crop',
'{"primary": "#424242", "secondary": "#616161", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 67);

-- PRO YILDONÜMÜ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Altın Yıldönümü', '50. yıl altın düğün', 'anniversary', 'golden', 'pro',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800&h=600&fit=crop',
'{"primary": "#F57F17", "secondary": "#FBC02D", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "years_together", "label": "Birlikte Geçen Yıllar", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Bodoni Moda"}', false, 68),

('Gümüş Yıldönümü', '25. yıl gümüş düğün', 'anniversary', 'silver', 'pro',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&h=600&fit=crop',
'{"primary": "#607D8B", "secondary": "#78909C", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "silver_milestone", "label": "Gümüş Dönüm Noktası", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Lato"}', false, 69),

('Kristal Yıldönümü', '15. yıl kristal düğün', 'anniversary', 'crystal', 'pro',
'https://images.unsplash.com/photo-1470240731273-7821a6eeb6bd?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1470240731273-7821a6eeb6bd?w=800&h=600&fit=crop',
'{"primary": "#455A64", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#90CAF9"}',
'[{"id": "crystal_love", "label": "Kristal Aşk", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Lora", "Montserrat"}', false, 70);

-- PREMIUM YILDONÜMÜ TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Muhteşem Yıldönümü', 'Lüks yıldönümü kutlaması', 'anniversary', 'luxury', 'premium',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800&h=600&fit=crop',
'{"primary": "#6A1B9A", "secondary": "#8E24AA", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "love_story", "label": "Aşk Hikayesi", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "hearts-1", "type": "wedding", "name": "Gül Yaprakları", "imageUrl": "/graphics/Rose-Petals-PNG-File.png", "position": {"x": 50, "y": 25}, "size": {"width": 120, "height": 100}, "rotation": 0, "opacity": 0.6}]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 71),

('Peri Masalı Yıldönümü', 'Masalsı yıldönümü kutlaması', 'anniversary', 'fairytale', 'premium',
'https://images.unsplash.com/photo-1519657337289-077653f724ed?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519657337289-077653f724ed?w=800&h=600&fit=crop',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "fairytale_love", "label": "Masal Aşkı", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[{"id": "wreath-1", "type": "elegant", "name": "Çiçek Çelenk", "imageUrl": "/graphics/Wreath-Funeral-Flowers-Transparent-Background.png", "position": {"x": 50, "y": 50}, "size": {"width": 140, "height": 140}, "rotation": 0, "opacity": 0.4}]',
'{"Dancing Script", "Great Vibes", "Pacifico"}', false, 72);

-- =====================================================
-- CATEGORY 8: KINA GECESİ (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE KINA GECESİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Geleneksel Kına', 'Geleneksel kına gecesi davetiyesi', 'henna', 'traditional', 'free',
'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=800&h=600&fit=crop',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Lora", "Montserrat"}', false, 73),

('Modern Kına', 'Modern kına gecesi', 'henna', 'modern', 'free',
'https://images.unsplash.com/photo-1519657337289-077653f724ed?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519657337289-077653f724ed?w=800&h=600&fit=crop',
'{"primary": "#AD1457", "secondary": "#D81B60", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 74),

('Kırmızı Kına', 'Kırmızı tonlarda kına gecesi', 'henna', 'red', 'free',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&h=600&fit=crop',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Lora", "Playfair Display", "Lato"}', false, 75);

-- PRO KINA GECESİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Altın Kına', 'Altın detaylı lüks kına gecesi', 'henna', 'gold', 'pro',
'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=800&h=600&fit=crop',
'{"primary": "#F57F17", "secondary": "#FBC02D", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "henna_night", "label": "Kına Gecesi", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Cinzel", "Lora"}', false, 76),

('Pembe Kına', 'Pembe tonlarda romantik kına', 'henna', 'pink', 'pro',
'https://images.unsplash.com/photo-1519657337289-077653f724ed?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519657337289-077653f724ed?w=800&h=600&fit=crop',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "bride_name", "label": "Gelin Adı", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Great Vibes"}}]',
'[]',
'{"Great Vibes", "Dancing Script", "Pacifico"}', false, 77),

('Bordo Kına', 'Bordo tonlarda şık kına gecesi', 'henna', 'burgundy', 'pro',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&h=600&fit=crop',
'{"primary": "#880E4F", "secondary": "#AD1457", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "special_note", "label": "Özel Not", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]',
'{"Lora", "Playfair Display", "Montserrat"}', false, 78);

-- PREMIUM KINA GECESİ TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Kına Gecesi', 'Muhteşem lüks kına gecesi', 'henna', 'luxury', 'premium',
'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=800&h=600&fit=crop',
'{"primary": "#6A1B9A", "secondary": "#8E24AA", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_henna", "label": "Lüks Kına", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "henna-1", "type": "wedding", "name": "Gül Yaprakları", "imageUrl": "/graphics/Rose-Petals-PNG-File.png", "position": {"x": 50, "y": 20}, "size": {"width": 110, "height": 90}, "rotation": 0, "opacity": 0.6}]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 79),

('Kraliyet Kına', 'Kraliyet kına gecesi', 'henna', 'royal', 'premium',
'https://images.unsplash.com/photo-1519657337289-077653f724ed?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1519657337289-077653f724ed?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_henna", "label": "Kraliyet Kınası", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "frame-2", "type": "elegant", "name": "Altın Çerçeve", "imageUrl": "/graphics/Frame-Border-PNG-HD.png", "position": {"x": 50, "y": 50}, "size": {"width": 150, "height": 150}, "rotation": 0, "opacity": 0.3}]',
'{"Cinzel", "Playfair Display", "Bodoni Moda"}', false, 80);

-- =====================================================
-- CATEGORY 9: SÜNNET (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE SÜNNET TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Klasik Sünnet', 'Geleneksel sünnet düğünü', 'circumcision', 'classic', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Lato"}', false, 81),

('Modern Sünnet', 'Modern sünnet düğünü', 'circumcision', 'modern', 'free',
'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=800&h=600&fit=crop',
'{"primary": "#00796B", "secondary": "#009688", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFA726"}',
'[]', '[]',
'{"Poppins", "Montserrat", "Raleway"}', false, 82),

('Renkli Sünnet', 'Neşeli renkli sünnet düğünü', 'circumcision', 'colorful', 'free',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Fredoka One", "Quicksand", "Baloo 2"}', false, 83);

-- PRO SÜNNET TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Prens Sünnet', 'Prens temalı sünnet düğünü', 'circumcision', 'prince', 'pro',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#1565C0", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "prince_name", "label": "Prens Adı", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Cinzel"}', false, 84),

('Süper Kahraman Sünnet', 'Süper kahraman temalı', 'circumcision', 'superhero', 'pro',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "hero_name", "label": "Kahraman Adı", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[]',
'{"Fredoka One", "Righteous", "Baloo 2"}', false, 85),

('Spor Temalı Sünnet', 'Spor temalı sünnet düğünü', 'circumcision', 'sports', 'pro',
'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=800&h=600&fit=crop',
'{"primary": "#00796B", "secondary": "#26A69A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFA726"}',
'[{"id": "sports_theme", "label": "Spor Dalı", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Poppins", "Raleway"}', false, 86);

-- PREMIUM SÜNNET TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Sünnet Düğünü', 'Muhteşem lüks sünnet düğünü', 'circumcision', 'luxury', 'premium',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#6A1B9A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_celebration", "label": "Lüks Kutlama", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "crown-2", "type": "elegant", "name": "Altın Çerçeve", "imageUrl": "/graphics/Frame-Border-PNG-HD.png", "position": {"x": 50, "y": 50}, "size": {"width": 150, "height": 150}, "rotation": 0, "opacity": 0.3}]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 87),

('Yıldızlı Sünnet', 'Yıldız temalı sünnet düğünü', 'circumcision', 'stars', 'premium',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=800&h=600&fit=crop',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "star_celebration", "label": "Yıldız Kutlaması", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[{"id": "confetti-3", "type": "celebration", "name": "Renkli Konfeti", "imageUrl": "/graphics/Red-Confetti-PNG-Pic.png", "position": {"x": 50, "y": 20}, "size": {"width": 120, "height": 120}, "rotation": 0, "opacity": 0.6}, {"id": "balloons-2", "type": "party", "name": "Balon Demeti", "imageUrl": "/graphics/Bunch-of-Balloons-PNG-Image.png", "position": {"x": 70, "y": 75}, "size": {"width": 110, "height": 130}, "rotation": 15, "opacity": 0.7}]',
'{"Montserrat", "Fredoka One", "Poppins"}', false, 88);

-- =====================================================
-- CATEGORY 10: KUTLAMALAR (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE KUTLAMALAR TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Yeni Yıl Kutlaması', 'Yeni yıl kutlama daveti', 'celebration', 'new_year', 'free',
'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=800&h=600&fit=crop',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Montserrat", "Poppins", "Raleway"}', false, 89),

('Bayram Kutlaması', 'Dini bayram kutlaması', 'celebration', 'holiday', 'free',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop',
'{"primary": "#00796B", "secondary": "#26A69A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]',
'{"Lora", "Playfair Display", "Montserrat"}', false, 90),

('Başarı Kutlaması', 'Başarı kutlama etkinliği', 'celebration', 'achievement', 'free',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&h=600&fit=crop',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 91);

-- PRO KUTLAMALAR TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Altın Kutlama', 'Altın detaylı özel kutlama', 'celebration', 'gold', 'pro',
'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=800&h=600&fit=crop',
'{"primary": "#F57F17", "secondary": "#FBC02D", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "celebration_reason", "label": "Kutlama Nedeni", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Cinzel", "Montserrat"}', false, 92),

('Topluluk Kutlaması', 'Topluluk etkinliği kutlaması', 'celebration', 'community', 'pro',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&h=600&fit=crop',
'{"primary": "#7B1FA2", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "community_event", "label": "Topluluk Etkinliği", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 93),

('Festival Kutlaması', 'Festival kutlama daveti', 'celebration', 'festival', 'pro',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "festival_name", "label": "Festival Adı", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Fredoka One"}}]',
'[]',
'{"Fredoka One", "Pacifico", "Quicksand"}', false, 94);

-- PREMIUM KUTLAMALAR TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Muhteşem Kutlama', 'Lüks kutlama etkinliği', 'celebration', 'luxury', 'premium',
'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#6A1B9A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "grand_celebration", "label": "Muhteşem Kutlama", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "fireworks-2", "type": "celebration", "name": "Havai Fişek", "imageUrl": "/graphics/Festive-Gold-Fireworks-PNG-Clipart.png", "position": {"x": 50, "y": 80}, "size": {"width": 130, "height": 150}, "rotation": 0, "opacity": 0.5}]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 95),

('Gökkuşağı Kutlama', 'Renkli gökkuşağı kutlama', 'celebration', 'rainbow', 'premium',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#9C27B0", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "rainbow_joy", "label": "Gökkuşağı Neşesi", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[{"id": "balloons-3", "type": "party", "name": "Renkli Balon Demeti", "imageUrl": "/graphics/Bunch-of-Balloons-PNG-Image.png", "position": {"x": 30, "y": 25}, "size": {"width": 110, "height": 130}, "rotation": -15, "opacity": 0.7}, {"id": "confetti-4", "type": "celebration", "name": "Renkli Konfeti", "imageUrl": "/graphics/Red-Confetti-PNG-Pic.png", "position": {"x": 70, "y": 75}, "size": {"width": 120, "height": 120}, "rotation": 0, "opacity": 0.6}]',
'{"Pacifico", "Fredoka One", "Quicksand"}', false, 96);

-- =====================================================
-- CATEGORY 11: NİŞAN YEMEĞİ (4 templates: 1 FREE, 2 PRO, 1 PREMIUM)
-- =====================================================

-- FREE NİŞAN YEMEĞİ TEMPLATE (1)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Klasik Nişan Yemeği', 'Geleneksel nişan yemeği daveti', 'engagement_dinner', 'classic', 'free',
'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&h=600&fit=crop',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Lora", "Montserrat"}', false, 97);

-- PRO NİŞAN YEMEĞİ TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Modern Nişan Yemeği', 'Modern nişan yemeği daveti', 'engagement_dinner', 'modern', 'pro',
'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&h=600&fit=crop',
'{"primary": "#424242", "secondary": "#616161", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[{"id": "dinner_venue", "label": "Yemek Mekanı", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 98),

('Romantik Nişan Yemeği', 'Romantik nişan yemeği', 'engagement_dinner', 'romantic', 'pro',
'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&h=600&fit=crop',
'{"primary": "#AD1457", "secondary": "#D81B60", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "romantic_note", "label": "Romantik Not", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Great Vibes"}}]',
'[]',
'{"Great Vibes", "Dancing Script", "Pacifico"}', false, 99);

-- PREMIUM NİŞAN YEMEĞİ TEMPLATE (1)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Nişan Yemeği', 'Lüks nişan yemeği daveti', 'engagement_dinner', 'luxury', 'premium',
'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&h=600&fit=crop',
'{"primary": "#6A1B9A", "secondary": "#8E24AA", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_dinner", "label": "Lüks Yemek", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "elegant-frame", "type": "elegant", "name": "Altın Çerçeve", "imageUrl": "/graphics/Frame-Border-PNG-HD.png", "position": {"x": 50, "y": 50}, "size": {"width": 150, "height": 150}, "rotation": 0, "opacity": 0.3}]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 100);

-- =====================================================
-- CATEGORY 12: BEKARLIĞA VEDA (5 templates: 2 FREE, 2 PRO, 1 PREMIUM)
-- =====================================================

-- FREE BEKARLIĞA VEDA TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Bekarlığa Veda Partisi', 'Neşeli bekarlığa veda partisi', 'bachelor_party', 'party', 'free',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Fredoka One", "Quicksand", "Baloo 2"}', false, 101),

('Kız Partisi', 'Kız arkadaşlarla parti', 'bachelor_party', 'girls_night', 'free',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=800&h=600&fit=crop',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]',
'{"Pacifico", "Dancing Script", "Quicksand"}', false, 102);

-- PRO BEKARLIĞA VEDA TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Şık Bekarlığa Veda', 'Şık bekarlığa veda etkinliği', 'bachelor_party', 'elegant', 'pro',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#424242", "secondary": "#616161", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFA726"}',
'[{"id": "party_theme", "label": "Parti Teması", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 103),

('Gece Kulübü Parti', 'Gece kulübü partisi', 'bachelor_party', 'nightclub', 'pro',
'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=800&h=600&fit=crop',
'{"primary": "#6A1B9A", "secondary": "#8E24AA", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "club_name", "label": "Kulüp Adı", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Poppins"}}]',
'[]',
'{"Poppins", "Montserrat", "Raleway"}', false, 104);

-- PREMIUM BEKARLIĞA VEDA TEMPLATE (1)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Bekarlığa Veda', 'Lüks bekarlığa veda partisi', 'bachelor_party', 'luxury', 'premium',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
'{"primary": "#4A148C", "secondary": "#6A1B9A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_party", "label": "Lüks Parti", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[{"id": "party-celebration", "type": "party", "name": "Renkli Balon Demeti", "imageUrl": "/graphics/Bunch-of-Balloons-PNG-Image.png", "position": {"x": 30, "y": 25}, "size": {"width": 110, "height": 130}, "rotation": -15, "opacity": 0.7}, {"id": "confetti-final", "type": "celebration", "name": "Konfeti", "imageUrl": "/graphics/Red-Confetti-PNG-Pic.png", "position": {"x": 70, "y": 75}, "size": {"width": 120, "height": 120}, "rotation": 0, "opacity": 0.6}]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 105);

-- Final Commit
COMMIT;

-- Notify pgrst to reload schema
NOTIFY pgrst, 'reload schema';
SELECT pg_notify('pgrst', 'reload schema');

-- Final success message
DO $$
BEGIN
  RAISE NOTICE '🎉 ✅ ALL 105 TEMPLATES CREATED SUCCESSFULLY!';
  RAISE NOTICE '📊 Distribution: FREE=38, PRO=42, PREMIUM=25';
  RAISE NOTICE '🎨 12 Categories: Wedding, Engagement, Birthday, Baby Shower, Graduation, Corporate, Anniversary, Henna, Circumcision, Celebration, Engagement Dinner, Bachelor Party';
  RAISE NOTICE '✨ All templates have appropriate images, colors, text fields (PRO/PREMIUM), and decorative elements (PREMIUM)';
  RAISE NOTICE '🚀 Templates are ready to use!';
END $$;

