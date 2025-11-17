-- =====================================================
-- KALAN 57 TEMPLATE - PART 2
-- =====================================================
-- Graduation (8), Corporate (8), Anniversary (8), Henna (7),
-- Circumcision (7), Celebration (8), Engagement Dinner (5), Bachelor Party (6)

INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES

-- ===============================
-- MEZUNİYET (8)
-- ===============================
('Klasik Mezuniyet', 'Sade ve şık mezuniyet', 'graduation', 'classic', 'free',
'graduation/classic.jpg', 'graduation/classic.jpg',
'{"primary": "#1565C0", "secondary": "#1976D2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 49),

('Modern Mezuniyet', 'Çağdaş mezuniyet', 'graduation', 'modern', 'free',
'graduation/modern.jpg', 'graduation/modern.jpg',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Raleway", "Poppins", "Open Sans"}', true, 50),

('Renkli Mezuniyet', 'Neşeli mezuniyet', 'graduation', 'colorful', 'free',
'graduation/colorful.jpg', 'graduation/colorful.jpg',
'{"primary": "#E91E63", "secondary": "#FF4081", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[]', '[]', '{"Fredoka One", "Quicksand", "Montserrat"}', false, 51),

('Lüks Mezuniyet', 'Altın detaylı mezuniyet', 'graduation', 'luxury', 'pro',
'graduation/luxury.jpg', 'graduation/luxury.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "degree_info", "label": "Diploma Bilgisi", "defaultValue": "Bilgisayar Mühendisliği Bölümü", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Montserrat"}', true, 52),

('Üniversite Mezuniyeti', 'Üniversite mezuniyet töreni', 'graduation', 'university', 'pro',
'graduation/university.jpg', 'graduation/university.jpg',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "university_name", "label": "Üniversite", "defaultValue": "İstanbul Üniversitesi", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 53),

('Lise Mezuniyeti', 'Lise mezuniyet balosu', 'graduation', 'high_school', 'pro',
'graduation/high_school.jpg', 'graduation/high_school.jpg',
'{"primary": "#C2185B", "secondary": "#E91E63", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[{"id": "school_name", "label": "Okul Adı", "defaultValue": "İstanbul Lisesi", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Poppins"}}]',
'[]', '{"Poppins", "Montserrat", "Raleway"}', false, 54),

('Doktora Mezuniyeti', 'Doktora töreni', 'graduation', 'phd', 'premium',
'graduation/phd.jpg', 'graduation/phd.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "phd_field", "label": "Doktora Alanı", "defaultValue": "Doktor unvanı", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 55),

('MBA Mezuniyeti', 'MBA mezuniyet', 'graduation', 'mba', 'premium',
'graduation/mba.jpg', 'graduation/mba.jpg',
'{"primary": "#37474F", "secondary": "#546E7A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "mba_program", "label": "MBA Programı", "defaultValue": "Executive MBA", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 56),

-- ===============================
-- İŞ ETKİNLİĞİ (8)
-- ===============================
('Kurumsal Etkinlik', 'Profesyonel iş etkinliği', 'corporate', 'business', 'free',
'corporate/business.jpg', 'corporate/business.jpg',
'{"primary": "#1976D2", "secondary": "#1E88E5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFC107"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 57),

('Konferans', 'Konferans ve seminer', 'corporate', 'conference', 'free',
'corporate/conference.jpg', 'corporate/conference.jpg',
'{"primary": "#37474F", "secondary": "#455A64", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[]', '[]', '{"Raleway", "Open Sans", "Poppins"}', true, 58),

('Toplantı', 'İş toplantısı', 'corporate', 'meeting', 'free',
'corporate/meeting.jpg', 'corporate/meeting.jpg',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#4CAF50"}',
'[]', '[]', '{"Open Sans", "Roboto", "Lato"}', false, 59),

('Gala Yemeği', 'Kurumsal gala', 'corporate', 'gala', 'pro',
'corporate/gala.jpg', 'corporate/gala.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "gala_theme", "label": "Gala Teması", "defaultValue": "Yılın Ödülleri", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Montserrat"}', true, 60),

('Ürün Lansmanı', 'Yeni ürün tanıtım', 'corporate', 'product_launch', 'pro',
'corporate/product_launch.jpg', 'corporate/product_launch.jpg',
'{"primary": "#E91E63", "secondary": "#EC407A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#00BCD4"}',
'[{"id": "product_name", "label": "Ürün Adı", "defaultValue": "Yeni Ürün Tanıtımı", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 61),

('Networking', 'İş ağı oluşturma', 'corporate', 'networking', 'pro',
'corporate/networking.jpg', 'corporate/networking.jpg',
'{"primary": "#00838F", "secondary": "#00ACC1", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "networking_theme", "label": "Networking", "defaultValue": "İş Dünyası Buluşması", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Raleway"}}]',
'[]', '{"Raleway", "Open Sans", "Poppins"}', false, 62),

('VIP Ödül Töreni', 'Prestijli ödül', 'corporate', 'award_ceremony', 'premium',
'corporate/award_ceremony.jpg', 'corporate/award_ceremony.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "award_category", "label": "Ödül Kategorisi", "defaultValue": "Yılın Başarı Ödülleri", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 63),

('CEO Zirvesi', 'Üst düzey yönetici toplantısı', 'corporate', 'ceo_summit', 'premium',
'corporate/ceo_summit.jpg', 'corporate/ceo_summit.jpg',
'{"primary": "#000000", "secondary": "#212121", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B8860B"}',
'[{"id": "summit_topic", "label": "Zirve Konusu", "defaultValue": "CEO Zirvesi 2024", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Montserrat"}}]',
'[]', '{"Montserrat", "Raleway", "Poppins"}', false, 64),

-- ===============================
-- YILDONÜMÜ (8)
-- ===============================
('Romantik Yıldönümü', 'Romantik evlilik yıldönümü', 'anniversary', 'romantic', 'free',
'anniversary/romantic.jpg', 'anniversary/romantic.jpg',
'{"primary": "#D81B60", "secondary": "#F06292", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[]', '[]', '{"Playfair Display", "Great Vibes", "Lora"}', true, 65),

('Modern Yıldönümü', 'Minimalist yıldönümü', 'anniversary', 'modern', 'free',
'anniversary/modern.jpg', 'anniversary/modern.jpg',
'{"primary": "#263238", "secondary": "#37474F", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#C0A062"}',
'[]', '[]', '{"Montserrat", "Raleway", "Poppins"}', true, 66),

('25. Yıl Yıldönümü', 'Gümüş yıldönümü', 'anniversary', 'silver', 'free',
'anniversary/silver.jpg', 'anniversary/silver.jpg',
'{"primary": "#607D8B", "secondary": "#90A4AE", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[]', '[]', '{"Playfair Display", "Lora", "Montserrat"}', false, 67),

('Altın Yıldönümü', '50. yıl altın yıldönümü', 'anniversary', 'golden', 'pro',
'anniversary/golden.jpg', 'anniversary/golden.jpg',
'{"primary": "#B8860B", "secondary": "#DAA520", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "golden_years", "label": "50 Yıl", "defaultValue": "50 yıllık mutlu evlilik", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Playfair Display", "Bodoni Moda"}', true, 68),

('Vintage Yıldönümü', 'Nostaljik yıldönümü', 'anniversary', 'vintage', 'pro',
'anniversary/vintage.jpg', 'anniversary/vintage.jpg',
'{"primary": "#5D4037", "secondary": "#8D6E63", "background": "#FFF8E1", "text": "#3E2723", "accent": "#D4A574"}',
'[{"id": "vintage_love", "label": "Eski Aşk", "defaultValue": "Yılların verdiği olgunluk", "style": {"fontSize": 17, "fontWeight": "normal", "color": "#3E2723", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cormorant Garamond", "Lora"}', false, 69),

('Bahçe Yıldönümü', 'Doğada yıldönümü', 'anniversary', 'garden', 'pro',
'anniversary/garden.jpg', 'anniversary/garden.jpg',
'{"primary": "#388E3C", "secondary": "#66BB6A", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB300"}',
'[{"id": "garden_love", "label": "Bahçe Aşkı", "defaultValue": "Doğanın güzelliğinde kutluyoruz", "style": {"fontSize": 18, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Lora"}}]',
'[]', '{"Lora", "Open Sans", "Raleway"}', false, 70),

('Kraliyet Yıldönümü', 'Muhteşem yıldönümü', 'anniversary', 'royal', 'premium',
'anniversary/royal.jpg', 'anniversary/royal.jpg',
'{"primary": "#4A148C", "secondary": "#7B1FA2", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFD700"}',
'[{"id": "royal_years", "label": "Kraliyet Yılları", "defaultValue": "Kraliyet çifti kutluyor", "style": {"fontSize": 20, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Cinzel"}}]',
'[]', '{"Cinzel", "Bodoni Moda", "Playfair Display"}', true, 71),

('Elmas Yıldönümü', '60. yıl elmas yıldönümü', 'anniversary', 'diamond', 'premium',
'anniversary/diamond.jpg', 'anniversary/diamond.jpg',
'{"primary": "#455A64", "secondary": "#607D8B", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#B0BEC5"}',
'[{"id": "diamond_love", "label": "Elmas Aşk", "defaultValue": "60 yıllık elmas evlilik", "style": {"fontSize": 19, "fontWeight": "bold", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Playfair Display"}}]',
'[]', '{"Playfair Display", "Cinzel", "Montserrat"}', false, 72);

-- Dosya çok uzuyor, Part 3'e geçiyorum

COMMIT;
NOTIFY pgrst, 'reload schema';

DO $$
BEGIN
  RAISE NOTICE '32 more templates created (Graduation + Corporate + Anniversary)!';
  RAISE NOTICE 'Remaining 25 templates in Part 3';
END $$;

