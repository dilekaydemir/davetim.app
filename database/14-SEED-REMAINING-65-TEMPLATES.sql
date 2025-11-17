-- =====================================================
-- REMAINING 65 TEMPLATES (41-105)
-- =====================================================
-- Baby Shower, Graduation, Corporate, Anniversary, 
-- Henna, Circumcision, Celebration, Engagement Dinner, Bachelor Party

-- =====================================================
-- CATEGORY 4: BEBEK ŞÖLENİ (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE BEBEK ŞÖLENİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Mavi Bebek Şöleni', 'Erkek bebek için mavi tonlar', 'baby_shower', 'boy', 'free',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[]', '[]',
'{"Quicksand", "Baloo 2", "Poppins"}', true, 41),

('Pembe Bebek Şöleni', 'Kız bebek için pembe tonlar', 'baby_shower', 'girl', 'free',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]',
'{"Quicksand", "Baloo 2", "Dancing Script"}', true, 42),

('Nötr Bebek Şöleni', 'Cinsiyetsiz bej-yeşil tonlar', 'baby_shower', 'neutral', 'free',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#8D6E63", "secondary": "#A1887F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#AED581"}',
'[]', '[]',
'{"Lora", "Quicksand", "Open Sans"}', false, 43);

-- PRO BEBEK ŞÖLENİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('İkiz Bebek Şöleni', 'İkizler için özel tasarım', 'baby_shower', 'twins', 'pro',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#9C27B0", "secondary": "#BA68C8", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "twins_info", "label": "İkiz Bilgisi", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]',
'{"Quicksand", "Baloo 2", "Poppins"}', false, 44),

('Ayıcık Bebek', 'Ayıcık temalı sevimli şölen', 'baby_shower', 'teddy', 'pro',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#FFB74D"}',
'[{"id": "teddy_theme", "label": "Ayıcık Mesajı", "defaultValue": "", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Baloo 2"}}]',
'[]',
'{"Baloo 2", "Quicksand", "Fredoka One"}', false, 45),

('Bulut Bebek', 'Bulut ve yıldız temalı', 'baby_shower', 'cloud', 'pro',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#5E92F3", "secondary": "#90CAF9", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD54F"}',
'[{"id": "cloud_wish", "label": "Bulut Dileği", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Quicksand"}}]',
'[]',
'{"Quicksand", "Baloo 2", "Poppins"}', false, 46);

-- PREMIUM BEBEK ŞÖLENİ TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Bebek Şöleni', 'Altın detaylı lüks bebek şöleni', 'baby_shower', 'luxury', 'premium',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#64B5F6", "secondary": "#90CAF9", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_baby", "label": "Lüks Bebek Mesajı", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Quicksand", "Cinzel"}', true, 47),

('Kraliyet Bebek', 'Kraliyet temalı bebek şöleni', 'baby_shower', 'royal', 'premium',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1648377/pexels-photo-1648377.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_baby", "label": "Kraliyet Bebeği", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', false, 48);

-- =====================================================
-- CATEGORY 5: MEZUNİYET (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE MEZUNİYET TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Klasik Mezuniyet', 'Sade ve şık mezuniyet davetiyesi', 'graduation', 'classic', 'free',
'https://images.pexels.com/photos/267885/pexels-photo-267885.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/267885/pexels-photo-267885.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', true, 49),

('Modern Mezuniyet', 'Çağdaş ve minimalist mezuniyet', 'graduation', 'modern', 'free',
'https://images.pexels.com/photos/1205651/pexels-photo-1205651.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1205651/pexels-photo-1205651.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]',
'{"Raleway", "Poppins", "Open Sans"}', true, 50),

('Renkli Mezuniyet', 'Neşeli ve renkli mezuniyet', 'graduation', 'colorful', 'free',
'https://images.pexels.com/photos/267885/pexels-photo-267885.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/267885/pexels-photo-267885.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[]', '[]',
'{"Fredoka One", "Quicksand", "Montserrat"}', false, 51);

-- PRO MEZUNİYET TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Mezuniyet', 'Altın detaylı mezuniyet töreni', 'graduation', 'luxury', 'pro',
'https://images.pexels.com/photos/267885/pexels-photo-267885.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/267885/pexels-photo-267885.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "degree", "label": "Diploma Bilgisi", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Montserrat"}', true, 52),

('Üniversite Mezuniyeti', 'Üniversite mezuniyet kutlaması', 'graduation', 'university', 'pro',
'https://images.pexels.com/photos/1205651/pexels-photo-1205651.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1205651/pexels-photo-1205651.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "university", "label": "Üniversite", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 53),

('Lise Mezuniyeti', 'Lise mezuniyet balosu', 'graduation', 'high_school', 'pro',
'https://images.pexels.com/photos/267885/pexels-photo-267885.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/267885/pexels-photo-267885.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "school", "label": "Okul Adı", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Poppins"}}]',
'[]',
'{"Poppins", "Montserrat", "Raleway"}', false, 54);

-- PREMIUM MEZUNİYET TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Doktora Mezuniyeti', 'Doktora derecesi töreni', 'graduation', 'phd', 'premium',
'https://images.pexels.com/photos/1205651/pexels-photo-1205651.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1205651/pexels-photo-1205651.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "phd_title", "label": "Doktora Alanı", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 55),

('MBA Mezuniyeti', 'MBA mezuniyet töreni', 'graduation', 'mba', 'premium',
'https://images.pexels.com/photos/267885/pexels-photo-267885.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/267885/pexels-photo-267885.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "mba_program", "label": "MBA Programı", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 56);

-- =====================================================
-- CATEGORY 6: İŞ ETKİNLİĞİ (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE İŞ ETKİNLİĞİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Kurumsal Etkinlik', 'Profesyonel iş etkinliği', 'corporate', 'business', 'free',
'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#1976D2", "secondary": "#1E88E5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', true, 57),

('Konferans', 'Konferans ve seminer davetiyesi', 'corporate', 'conference', 'free',
'https://images.pexels.com/photos/2774556/pexels-photo-2774556.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/2774556/pexels-photo-2774556.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#37474F", "secondary": "#455A64", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[]', '[]',
'{"Raleway", "Open Sans", "Poppins"}', true, 58),

('Toplantı', 'İş toplantısı daveti', 'corporate', 'meeting', 'free',
'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#4CAF50"}',
'[]', '[]',
'{"Open Sans", "Roboto", "Lato"}', false, 59);

-- PRO İŞ ETKİNLİĞİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Gala Yemeği', 'Kurumsal gala yemeği', 'corporate', 'gala', 'pro',
'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "gala_info", "label": "Gala Bilgisi", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Montserrat"}', true, 60),

('Ürün Lansmanı', 'Yeni ürün tanıtım etkinliği', 'corporate', 'product_launch', 'pro',
'https://images.pexels.com/photos/2774556/pexels-photo-2774556.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/2774556/pexels-photo-2774556.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#E91E63", "secondary": "#EC407A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[{"id": "product_name", "label": "Ürün Adı", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 61),

('Networking Etkinliği', 'İş ağı oluşturma etkinliği', 'corporate', 'networking', 'pro',
'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "networking", "label": "Networking Bilgisi", "defaultValue": "", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Raleway"}}]',
'[]',
'{"Raleway", "Open Sans", "Poppins"}', false, 62);

-- PREMIUM İŞ ETKİNLİĞİ TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('VIP Ödül Töreni', 'Prestijli ödül töreni', 'corporate', 'award_ceremony', 'premium',
'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "award_info", "label": "Ödül Bilgisi", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 63),

('CEO Zirvesi', 'Üst düzey yönetici zirvesi', 'corporate', 'ceo_summit', 'premium',
'https://images.pexels.com/photos/2774556/pexels-photo-2774556.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/2774556/pexels-photo-2774556.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[{"id": "summit_theme", "label": "Zirve Teması", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 64);

-- =====================================================
-- CATEGORY 7: YILDÖNÜMÜ (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE YILDÖNÜMÜ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Klasik Yıldönümü', 'Sade ve zarif yıldönümü', 'anniversary', 'classic', 'free',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Lora", "Montserrat"}', true, 65),

('Romantik Yıldönümü', 'Romantik yıldönümü kutlaması', 'anniversary', 'romantic', 'free',
'https://images.pexels.com/photos/1024960/pexels-photo-1024960.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024960/pexels-photo-1024960.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#E91E63", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]',
'{"Great Vibes", "Dancing Script", "Pacifico"}', true, 66),

('Modern Yıldönümü', 'Çağdaş yıldönümü kutlaması', 'anniversary', 'modern', 'free',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 67);

-- PRO YILDÖNÜMÜ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Altın Yıldönümü', '50. yıl altın yıldönümü', 'anniversary', 'golden', 'pro',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "years_together", "label": "Beraber Geçen Yıllar", "defaultValue": "50 Yıl", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 68),

('Gümüş Yıldönümü', '25. yıl gümüş yıldönümü', 'anniversary', 'silver', 'pro',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#607D8B", "secondary": "#78909C", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "silver_anniversary", "label": "Gümüş Yıldönümü", "defaultValue": "25 Yıl", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Montserrat", "Lora"}', false, 69),

('Ruby Yıldönümü', '40. yıl yakut yıldönümü', 'anniversary', 'ruby', 'pro',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B71C1C", "secondary": "#D32F2F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FF5252"}',
'[{"id": "ruby_years", "label": "Yakut Yıldönümü", "defaultValue": "40 Yıl", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Lora", "Montserrat"}', false, 70);

-- PREMIUM YILDÖNÜMÜ TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Elmas Yıldönümü', '60. yıl elmas yıldönümü', 'anniversary', 'diamond', 'premium',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "diamond_anniversary", "label": "Elmas Yıldönümü", "defaultValue": "60 Yıl", "style": {"fontSize": 24, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 71),

('Platin Yıldönümü', '70. yıl platin yıldönümü', 'anniversary', 'platinum', 'premium',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#455A64", "secondary": "#607D8B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#90A4AE"}',
'[{"id": "platinum_years", "label": "Platin Yıldönümü", "defaultValue": "70 Yıl", "style": {"fontSize": 23, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Montserrat"}', false, 72);

-- =====================================================
-- CATEGORY 8: KINA GECESİ (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE KINA GECESİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Geleneksel Kına', 'Geleneksel kına gecesi', 'henna', 'traditional', 'free',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Lora", "Montserrat"}', true, 73),

('Modern Kına', 'Çağdaş kına gecesi', 'henna', 'modern', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#E91E63", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', true, 74),

('Kırmızı Kına', 'Kırmızı tonlarda kına gecesi', 'henna', 'red', 'free',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B71C1C", "secondary": "#D32F2F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FF5252"}',
'[]', '[]',
'{"Dancing Script", "Great Vibes", "Lora"}', false, 75);

-- PRO KINA GECESİ TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Kına', 'Altın detaylı lüks kına', 'henna', 'luxury', 'pro',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "henna_ceremony", "label": "Kına Töreni", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 76),

('Vintage Kına', 'Nostaljik kına gecesi', 'henna', 'vintage', 'pro',
'https://images.pexels.com/photos/1729798/pexels-photo-1729798.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729798/pexels-photo-1729798.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#6D4C41", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_henna", "label": "Vintage Kına", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]',
'{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 77),

('Bohem Kına', 'Özgür ruhlu bohem kına', 'henna', 'bohemian', 'pro',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
'[{"id": "boho_henna", "label": "Bohem Kına", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
'[]',
'{"Dancing Script", "Satisfy", "Lato"}', false, 78);

-- PREMIUM KINA GECESİ TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Kraliyet Kınası', 'Muhteşem kraliyet kına töreni', 'henna', 'royal', 'premium',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_henna", "label": "Kraliyet Kınası", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 79),

('Sultan Kınası', 'Sultan tarzı kına gecesi', 'henna', 'sultan', 'premium',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "sultan_ceremony", "label": "Sultan Kınası", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Montserrat"}', false, 80);

-- =====================================================
-- CATEGORY 9: SÜNNET (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE SÜNNET TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Klasik Sünnet', 'Geleneksel sünnet düğünü', 'circumcision', 'classic', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Fredoka One", "Quicksand", "Baloo 2"}', true, 81),

('Neşeli Sünnet', 'Renkli ve eğlenceli sünnet', 'circumcision', 'fun', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#FF5722", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[]', '[]',
'{"Fredoka One", "Righteous", "Baloo 2"}', true, 82),

('Modern Sünnet', 'Çağdaş sünnet davetiyesi', 'circumcision', 'modern', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 83);

-- PRO SÜNNET TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Şehzade Sünnet', 'Şehzade temalı sünnet düğünü', 'circumcision', 'prince', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "prince_info", "label": "Şehzade Bilgisi", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 84),

('Aslan Kral Sünnet', 'Aslan kral temalı sünnet', 'circumcision', 'lion_king', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#F57C00", "secondary": "#FF9800", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "lion_theme", "label": "Aslan Teması", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Righteous"}}]',
'[]',
'{"Righteous", "Fredoka One", "Baloo 2"}', false, 85),

('Süper Kahraman Sünnet', 'Kahraman temalı sünnet', 'circumcision', 'superhero', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#D32F2F", "secondary": "#F44336", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFEB3B"}',
'[{"id": "superhero_theme", "label": "Kahraman Teması", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Righteous"}}]',
'[]',
'{"Righteous", "Fredoka One", "Baloo 2"}', false, 86);

-- PREMIUM SÜNNET TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Kraliyet Sünnet', 'Muhteşem kraliyet sünnet düğünü', 'circumcision', 'royal', 'premium',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_circumcision", "label": "Kraliyet Sünnet", "defaultValue": "", "style": {"fontSize": 22, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 87),

('VIP Sünnet', 'VIP sünnet düğünü', 'circumcision', 'vip', 'premium',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[{"id": "vip_ceremony", "label": "VIP Töreni", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 88);

-- =====================================================
-- CATEGORY 10: KUTLAMALAR (8 templates: 3 FREE, 3 PRO, 2 PREMIUM)
-- =====================================================

-- FREE KUTLAMALAR TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Yılbaşı Kutlaması', 'Yeni yıl kutlama daveti', 'celebration', 'new_year', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Fredoka One", "Quicksand", "Montserrat"}', true, 89),

('Bayram Kutlaması', 'Bayram kutlama daveti', 'celebration', 'holiday', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#388E3C", "secondary": "#66BB6A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Lora", "Montserrat"}', true, 90),

('Genel Kutlama', 'Her türlü kutlama için', 'celebration', 'general', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 91);

-- PRO KUTLAMALAR TEMPLATES (3)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Başarı Kutlaması', 'Başarı ve kazanım kutlaması', 'celebration', 'achievement', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "achievement_info", "label": "Başarı Bilgisi", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Montserrat"}', true, 92),

('Terfi Kutlaması', 'Terfi ve yükselme kutlaması', 'celebration', 'promotion', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#1976D2", "secondary": "#1E88E5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "promotion_info", "label": "Terfi Bilgisi", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 93),

('Yeni Ev Kutlaması', 'Yeni ev açılış partisi', 'celebration', 'housewarming', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#388E3C", "secondary": "#66BB6A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "new_home", "label": "Yeni Ev Adresi", "defaultValue": "", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]',
'{"Lora", "Open Sans", "Poppins"}', false, 94);

-- PREMIUM KUTLAMALAR TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('VIP Kutlama', 'VIP özel kutlama etkinliği', 'celebration', 'vip', 'premium',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[{"id": "vip_celebration", "label": "VIP Kutlama", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Montserrat"}', true, 95),

('Gala Kutlaması', 'Muhteşem gala gecesi', 'celebration', 'gala', 'premium',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "gala_night", "label": "Gala Gecesi", "defaultValue": "", "style": {"fontSize": 21, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Bodoni Moda"}', false, 96);

-- =====================================================
-- CATEGORY 11: NİŞAN YEMEĞİ (4 templates: 1 FREE, 2 PRO, 1 PREMIUM)
-- =====================================================

-- FREE NİŞAN YEMEĞİ TEMPLATES (1)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Klasik Nişan Yemeği', 'Sade ve zarif nişan yemeği', 'engagement_dinner', 'classic', 'free',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#C62828", "secondary": "#E53935", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]',
'{"Playfair Display", "Lora", "Montserrat"}', true, 97);

-- PRO NİŞAN YEMEĞİ TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Romantik Nişan Yemeği', 'Romantik akşam yemeği', 'engagement_dinner', 'romantic', 'pro',
'https://images.pexels.com/photos/1024960/pexels-photo-1024960.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024960/pexels-photo-1024960.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#E91E63", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[{"id": "dinner_menu", "label": "Yemek Menüsü", "defaultValue": "", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Great Vibes"}}]',
'[]',
'{"Great Vibes", "Dancing Script", "Pacifico"}', true, 98),

('Modern Nişan Yemeği', 'Çağdaş nişan yemeği', 'engagement_dinner', 'modern', 'pro',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/265705/pexels-photo-265705.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[{"id": "dinner_note", "label": "Yemek Notu", "defaultValue": "", "style": {"fontSize": 16, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 99);

-- PREMIUM NİŞAN YEMEĞİ TEMPLATES (1)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Lüks Nişan Yemeği', 'Lüks restoran yemeği', 'engagement_dinner', 'luxury', 'premium',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "luxury_dinner", "label": "Lüks Yemek", "defaultValue": "", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 100);

-- =====================================================
-- CATEGORY 12: BEKARLIĞA VEDA (5 templates: 2 FREE, 2 PRO, 1 PREMIUM)
-- =====================================================

-- FREE BEKARLIĞA VEDA TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Kızlar Gecesi', 'Kızlar bekarlığa veda partisi', 'bachelor_party', 'girls_night', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#EC407A", "secondary": "#F48FB1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC0CB"}',
'[]', '[]',
'{"Dancing Script", "Great Vibes", "Pacifico"}', true, 101),

('Erkekler Gecesi', 'Erkekler bekarlığa veda partisi', 'bachelor_party', 'boys_night', 'free',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#1976D2", "secondary": "#42A5F5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]',
'{"Montserrat", "Raleway", "Poppins"}', true, 102);

-- PRO BEKARLIĞA VEDA TEMPLATES (2)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('Gece Kulübü Partisi', 'Gece kulübünde bekarlığa veda', 'bachelor_party', 'nightclub', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#E91E63"}',
'[{"id": "club_info", "label": "Kulüp Bilgisi", "defaultValue": "", "style": {"fontSize": 18, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]',
'{"Montserrat", "Raleway", "Poppins"}', false, 103),

('Tatil Partisi', 'Tatilde bekarlığa veda', 'bachelor_party', 'vacation', 'pro',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "vacation_info", "label": "Tatil Bilgisi", "defaultValue": "", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Pacifico"}}]',
'[]',
'{"Pacifico", "Dancing Script", "Quicksand"}', false, 104);

-- PREMIUM BEKARLIĞA VEDA TEMPLATES (1)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

('VIP Bekarlığa Veda', 'VIP bekarlığa veda partisi', 'bachelor_party', 'vip', 'premium',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=400&h=300',
'https://images.pexels.com/photos/1729797/pexels-photo-1729797.jpeg?auto=compress&cs=tinysrgb&w=800&h=600',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "vip_party", "label": "VIP Parti", "defaultValue": "", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]',
'{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 105);

-- Final Commit
COMMIT;

-- Notify pgrst to reload schema
NOTIFY pgrst, 'reload schema';
SELECT pg_notify('pgrst', 'reload schema');

-- Final success message
DO $$
BEGIN
  RAISE NOTICE 'ALL 105 TEMPLATES CREATED SUCCESSFULLY!';
  RAISE NOTICE 'Distribution: FREE=38, PRO=42, PREMIUM=25';
  RAISE NOTICE '12 Categories: Wedding, Engagement, Birthday, Baby Shower, Graduation, Corporate, Anniversary, Henna, Circumcision, Celebration, Engagement Dinner, Bachelor Party';
  RAISE NOTICE 'All templates have appropriate colors, fonts, and plan-based features';
  RAISE NOTICE 'Templates are ready to use!';
END $$;


