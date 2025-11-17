-- =====================================================
-- TEMPLATES V2 - ENHANCED SCHEMA
-- =====================================================
-- Bu script templates tablosunu yeni özelliklerle günceller
-- Dinamik text fields, decorative elements, fonts vb.
-- =====================================================

-- 1. Mevcut templates tablosunu yedekle (opsiyonel)
CREATE TABLE IF NOT EXISTS templates_backup AS SELECT * FROM templates;

-- 2. Yeni kolonlar ekle
ALTER TABLE templates 
ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'other',
ADD COLUMN IF NOT EXISTS subcategory TEXT,
ADD COLUMN IF NOT EXISTS color_palette JSONB DEFAULT '{"primary": "#000000", "secondary": "#FFFFFF", "accent": "#FF6B6B"}',
ADD COLUMN IF NOT EXISTS text_fields JSONB DEFAULT '[]',
ADD COLUMN IF NOT EXISTS decorative_elements JSONB DEFAULT '[]',
ADD COLUMN IF NOT EXISTS available_fonts TEXT[] DEFAULT ARRAY['Playfair Display', 'Montserrat', 'Dancing Script'],
ADD COLUMN IF NOT EXISTS default_image_url TEXT,
ADD COLUMN IF NOT EXISTS is_featured BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS sort_order INTEGER DEFAULT 0;

-- 3. Kategori enum oluştur (constraint olarak)
ALTER TABLE templates 
ADD CONSTRAINT check_category 
CHECK (category IN (
  'birthday',      -- Doğum günü
  'wedding',       -- Düğün
  'engagement',    -- Nişan
  'baby_shower',   -- Baby shower
  'graduation',    -- Mezuniyet
  'anniversary',   -- Yıldönümü
  'party',         -- Parti
  'corporate',     -- Kurumsal
  'other'          -- Diğer
));

-- 4. Index'ler ekle (performans için)
CREATE INDEX IF NOT EXISTS idx_templates_category ON templates(category);
CREATE INDEX IF NOT EXISTS idx_templates_tier ON templates(tier);
CREATE INDEX IF NOT EXISTS idx_templates_featured ON templates(is_featured);
CREATE INDEX IF NOT EXISTS idx_templates_sort_order ON templates(sort_order);

-- 5. Mevcut template'leri temizle
TRUNCATE TABLE templates CASCADE;

-- 6. Template ID sequence'ini sıfırla
ALTER SEQUENCE templates_id_seq RESTART WITH 1;

-- =====================================================
-- JSONB YAPILARI İÇİN ÖRNEK FORMAT
-- =====================================================

-- TEXT FIELDS FORMAT:
-- [
--   {
--     "id": "title",
--     "label": "Davetiye Başlığı",
--     "defaultValue": "Düğünümüze Davetlisiniz",
--     "position": {"x": 50, "y": 20},
--     "style": {
--       "fontSize": 32,
--       "fontFamily": "Playfair Display",
--       "color": "#000000",
--       "textAlign": "center",
--       "fontWeight": "bold"
--     },
--     "maxLength": 50,
--     "required": true
--   }
-- ]

-- DECORATIVE ELEMENTS FORMAT:
-- [
--   {
--     "id": "balloon1",
--     "type": "balloon",
--     "position": {"x": 10, "y": 10},
--     "size": {"width": 50, "height": 70},
--     "color": "#FF6B6B",
--     "rotation": 15,
--     "zIndex": 1
--   }
-- ]

-- COLOR PALETTE FORMAT:
-- {
--   "primary": "#FF6B6B",
--   "secondary": "#4ECDC4",
--   "accent": "#FFE66D",
--   "background": "#FFFFFF",
--   "text": "#2C3E50"
-- }

COMMENT ON COLUMN templates.category IS 'Davetiye kategorisi (birthday, wedding, engagement, vb.)';
COMMENT ON COLUMN templates.subcategory IS 'Alt kategori (retro, vintage, modern, vb.)';
COMMENT ON COLUMN templates.color_palette IS 'Şablona özel renk paleti (JSON)';
COMMENT ON COLUMN templates.text_fields IS 'Dinamik yazı alanları konfigürasyonu (JSON array)';
COMMENT ON COLUMN templates.decorative_elements IS 'Dekoratif elementler (balonlar, mumlar vb.) (JSON array)';
COMMENT ON COLUMN templates.available_fonts IS 'Kullanılabilir font listesi';
COMMENT ON COLUMN templates.default_image_url IS 'Temaya uygun varsayılan görsel URL';
COMMENT ON COLUMN templates.is_featured IS 'Öne çıkan şablon mu?';
COMMENT ON COLUMN templates.sort_order IS 'Sıralama önceliği';

-- =====================================================
-- BAŞARILI!
-- =====================================================
-- Templates tablosu V2 özellikleriyle güncellendi
-- Şimdi yeni template'leri seed edebilirsiniz
-- =====================================================

