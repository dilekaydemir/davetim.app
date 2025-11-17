-- =====================================================
-- TEST: Bohem Düğün Template'i Kontrol
-- =====================================================

-- 1. Mevcut template'i kontrol et
SELECT 
  id,
  name,
  category,
  subcategory,
  tier,
  thumbnail_url,
  default_image_url,
  is_active
FROM templates
WHERE category = 'wedding' AND subcategory = 'bohemian';

-- 2. Eğer yoksa veya yanlış path varsa, güncelle/ekle
INSERT INTO templates (
  name, 
  description, 
  category, 
  subcategory, 
  tier, 
  thumbnail_url, 
  default_image_url, 
  color_palette, 
  text_fields, 
  decorative_elements, 
  available_fonts, 
  is_featured, 
  sort_order,
  is_active
) VALUES (
  'Bohem Düğün',
  'Özgür ruhlu bohem düğün',
  'wedding',
  'bohemian',
  'pro',
  'wedding/bohemian.jpg',
  'wedding/bohemian.jpg',
  '{"primary": "#8E6C88", "secondary": "#B39EB5", "background": "#FFFFFF", "text": "#FFFFFF", "accent": "#FFB74D"}',
  '[{"id": "boho_message", "label": "Doğa Mesajı", "defaultValue": "Doğada birleşiyoruz", "style": {"fontSize": 19, "fontWeight": "normal", "color": "#FFFFFF", "textAlign": "center", "fontFamily": "Dancing Script"}}]',
  '[]',
  '{"Dancing Script", "Satisfy", "Lato"}',
  false,
  9,
  true
)
ON CONFLICT (id) DO UPDATE SET
  thumbnail_url = EXCLUDED.thumbnail_url,
  default_image_url = EXCLUDED.default_image_url,
  is_active = true;

-- 3. Sonucu kontrol et
SELECT 
  id,
  name,
  thumbnail_url,
  default_image_url,
  is_active
FROM templates
WHERE category = 'wedding' AND subcategory = 'bohemian';

-- 4. Tam URL'i test et
SELECT 
  name,
  'https://lwowqdxysoqrwoylhouy.supabase.co/storage/v1/object/public/templates/' || thumbnail_url AS full_url
FROM templates
WHERE category = 'wedding' AND subcategory = 'bohemian';

