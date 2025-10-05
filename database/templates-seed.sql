-- ============================================
-- DAVETIM TEMPLATE SEED DATA
-- ============================================
-- High-quality invitation templates for all tiers
-- Each template includes a background image and color palette

-- ============================================
-- CATEGORIES (Ensure these exist first)
-- ============================================

INSERT INTO template_categories (id, name, slug, description, icon, display_order, is_active)
VALUES
  (gen_random_uuid(), 'Düğün', 'dugun', 'Düğün davetiyeleri için özel tasarımlar', '💒', 1, true),
  (gen_random_uuid(), 'Nişan', 'nisan', 'Nişan törenleri için şık davetiyeler', '💍', 2, true),
  (gen_random_uuid(), 'Doğum Günü', 'dogum-gunu', 'Doğum günü partileri için eğlenceli tasarımlar', '🎂', 3, true),
  (gen_random_uuid(), 'Bebek Şöleni', 'bebek-soleni', 'Baby shower ve bebek kutlamaları', '👶', 4, true),
  (gen_random_uuid(), 'Mezuniyet', 'mezuniyet', 'Mezuniyet törenler için özel davetiyeler', '🎓', 5, true),
  (gen_random_uuid(), 'Sünnet', 'sunnet', 'Sünnet dügünleri için tasarımlar', '🎉', 6, true),
  (gen_random_uuid(), 'İş Etkinliği', 'is-etkinligi', 'Kurumsal etkinlikler ve toplantılar', '💼', 7, true),
  (gen_random_uuid(), 'Diğer', 'diger', 'Özel günler ve diğer etkinlikler', '🎊', 8, true)
ON CONFLICT (slug) DO NOTHING;

-- ============================================
-- FREE TIER TEMPLATES
-- Klasik ama modern, arka plan resimli tasarımlar
-- ============================================

-- FREE: Düğün - Klasik Beyaz
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'dugun' LIMIT 1),
  'Klasik Beyaz Düğün',
  'klasik-beyaz-dugun',
  'Zarif ve minimal beyaz tonlarda düğün davetiyesi',
  'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800',
  'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#8B7355',
      'secondary', '#D4AF37',
      'background', '#FFFFFF',
      'text', '#4A4A4A',
      'accent', '#C9A961'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=1200',
    'imagePosition', 'background',
    'layout', 'classic',
    'hasWatermark', true
  ),
  ARRAY['düğün', 'klasik', 'beyaz', 'zarif'],
  ARRAY['Klasik tasarım', 'Beyaz tonlar', 'Minimal', 'Arka plan görseli'],
  'free',
  false,
  true,
  false,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'klasik-beyaz-dugun');

-- FREE: Düğün - Romantik Pembe
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'dugun' LIMIT 1),
  'Romantik Pembe Düğün',
  'romantik-pembe-dugun',
  'Romantik pembe tonlarda çiçek desenli düğün davetiyesi',
  'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800',
  'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#E6739F',
      'secondary', '#FFB6C1',
      'background', '#FFF5F7',
      'text', '#5C4742',
      'accent', '#FF69B4'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=1200',
    'imagePosition', 'background',
    'layout', 'romantic',
    'hasWatermark', true
  ),
  ARRAY['düğün', 'romantik', 'pembe', 'çiçekli'],
  ARRAY['Romantik tasarım', 'Pembe tonlar', 'Çiçek deseni', 'Arka plan görseli'],
  'free',
  false,
  true,
  false,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'romantik-pembe-dugun');

-- FREE: Nişan - Modern Mavi
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'nisan' LIMIT 1),
  'Modern Mavi Nişan',
  'modern-mavi-nisan',
  'Modern ve şık mavi tonlarda nişan davetiyesi',
  'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800',
  'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#4A90E2',
      'secondary', '#7FB3D5',
      'background', '#F0F8FF',
      'text', '#2C3E50',
      'accent', '#5DADE2'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=1200',
    'imagePosition', 'background',
    'layout', 'modern',
    'hasWatermark', true
  ),
  ARRAY['nişan', 'modern', 'mavi', 'şık'],
  ARRAY['Modern tasarım', 'Mavi tonlar', 'Şık görünüm', 'Arka plan görseli'],
  'free',
  false,
  false,
  false,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'modern-mavi-nisan');

-- FREE: Doğum Günü - Renkli Balon
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'dogum-gunu' LIMIT 1),
  'Renkli Balon Partisi',
  'renkli-balon-partisi',
  'Eğlenceli ve renkli balon temalı doğum günü davetiyesi',
  'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800',
  'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#FF6B6B',
      'secondary', '#4ECDC4',
      'background', '#FFF9F0',
      'text', '#2D3436',
      'accent', '#FFD93D'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=1200',
    'imagePosition', 'background',
    'layout', 'fun',
    'hasWatermark', true
  ),
  ARRAY['doğum günü', 'renkli', 'balon', 'eğlenceli'],
  ARRAY['Renkli tasarım', 'Balon teması', 'Eğlenceli', 'Arka plan görseli'],
  'free',
  false,
  true,
  false,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'renkli-balon-partisi');

-- FREE: Bebek Şöleni - Pastel Ton
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'bebek-soleni' LIMIT 1),
  'Pastel Bebek Şöleni',
  'pastel-bebek-soleni',
  'Yumuşak pastel tonlarda bebek şöleni davetiyesi',
  'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800',
  'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#A8D8EA',
      'secondary', '#FFCCE6',
      'background', '#FFFEF7',
      'text', '#6C757D',
      'accent', '#B4E7CE'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=1200',
    'imagePosition', 'background',
    'layout', 'soft',
    'hasWatermark', true
  ),
  ARRAY['bebek', 'pastel', 'yumuşak', 'şirin'],
  ARRAY['Pastel renkler', 'Yumuşak tasarım', 'Bebek teması', 'Arka plan görseli'],
  'free',
  false,
  false,
  false,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'pastel-bebek-soleni');

-- ============================================
-- PRO TIER TEMPLATES
-- Daha kaliteli, premium hissi veren tasarımlar
-- ============================================

-- PRO: Düğün - Altın Detay
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'dugun' LIMIT 1),
  'Altın Detaylı Lüks Düğün',
  'altin-detayli-luks-dugun',
  'Altın detaylar ve zarif desenlerle premium düğün davetiyesi',
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#D4AF37',
      'secondary', '#C9A961',
      'background', '#FFFEF9',
      'text', '#3E2723',
      'accent', '#B8860B'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1519741497674-611481863552?w=1200',
    'imagePosition', 'background',
    'layout', 'luxury',
    'hasWatermark', false,
    'premiumFeatures', jsonb_build_array('Altın efektler', 'Özel fontlar', 'Animasyonlu detaylar')
  ),
  ARRAY['düğün', 'lüks', 'altın', 'premium', 'zarif'],
  ARRAY['Premium tasarım', 'Altın detaylar', 'Lüks görünüm', 'Özel efektler', 'Watermark yok'],
  'pro',
  true,
  true,
  true,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'altin-detayli-luks-dugun');

-- PRO: Düğün - Bohem Tarzı
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'dugun' LIMIT 1),
  'Bohem Tarzı Düğün',
  'bohem-tarzi-dugun',
  'Doğal ve bohem tarzda çiçek desenli düğün davetiyesi',
  'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800',
  'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#8B6F47',
      'secondary', '#C19A6B',
      'background', '#FAF9F6',
      'text', '#4A3728',
      'accent', '#D2B48C'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=1200',
    'imagePosition', 'background',
    'layout', 'bohemian',
    'hasWatermark', false,
    'premiumFeatures', jsonb_build_array('Bohem desenleri', 'Özel tipografi', 'Doğal renkler')
  ),
  ARRAY['düğün', 'bohem', 'doğal', 'çiçekli', 'vintage'],
  ARRAY['Bohem tasarım', 'Doğal tonlar', 'Çiçek detayları', 'Özel yazı tipleri', 'Watermark yok'],
  'pro',
  true,
  true,
  false,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'bohem-tarzi-dugun');

-- PRO: Nişan - Gül Bahçesi
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'nisan' LIMIT 1),
  'Gül Bahçesi Nişan',
  'gul-bahcesi-nisan',
  'Zarif gül desenleri ile premium nişan davetiyesi',
  'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=800',
  'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#DC143C',
      'secondary', '#FF6B9D',
      'background', '#FFF0F5',
      'text', '#4B0011',
      'accent', '#E94B3C'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=1200',
    'imagePosition', 'background',
    'layout', 'elegant',
    'hasWatermark', false,
    'premiumFeatures', jsonb_build_array('Gül desenleri', 'Zarif düzen', 'Premium görseller')
  ),
  ARRAY['nişan', 'gül', 'zarif', 'romantik', 'premium'],
  ARRAY['Zarif tasarım', 'Gül desenleri', 'Premium görsel', 'Özel efektler', 'Watermark yok'],
  'pro',
  true,
  false,
  false,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'gul-bahcesi-nisan');

-- PRO: Doğum Günü - Şık ve Lüks
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'dogum-gunu' LIMIT 1),
  'Şık ve Lüks Doğum Günü',
  'sik-ve-luks-dogum-gunu',
  'Yetişkin doğum günleri için şık ve lüks tasarım',
  'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=800',
  'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#2C3E50',
      'secondary', '#C9A961',
      'background', '#F8F9FA',
      'text', '#1A252F',
      'accent', '#D4AF37'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=1200',
    'imagePosition', 'background',
    'layout', 'sophisticated',
    'hasWatermark', false,
    'premiumFeatures', jsonb_build_array('Lüks tasarım', 'Altın detaylar', 'Yetişkin teması')
  ),
  ARRAY['doğum günü', 'lüks', 'şık', 'yetişkin', 'premium'],
  ARRAY['Lüks tasarım', 'Şık görünüm', 'Altın detaylar', 'Yetişkin teması', 'Watermark yok'],
  'pro',
  true,
  false,
  false,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'sik-ve-luks-dogum-gunu');

-- ============================================
-- PREMIUM TIER TEMPLATES
-- En kaliteli, ultra premium tasarımlar
-- ============================================

-- PREMIUM: Düğün - Kraliyet Saraylı
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'dugun' LIMIT 1),
  'Kraliyet Sarayı Düğün',
  'kraliyet-sarayi-dugun',
  'Ultra lüks kraliyet temalı düğün davetiyesi',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#4A0E4E',
      'secondary', '#D4AF37',
      'background', '#FFFDF7',
      'text', '#2C1B33',
      'accent', '#9B59B6'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=1200',
    'imagePosition', 'background',
    'layout', 'royal',
    'hasWatermark', false,
    'premiumFeatures', jsonb_build_array('Kraliyet desenleri', '3D efektler', 'Animasyonlar', 'Özel fontlar', 'Altın yaldız efekti')
  ),
  ARRAY['düğün', 'kraliyet', 'ultra lüks', 'premium', 'exclusive'],
  ARRAY['Kraliyet tasarımı', '3D efektler', 'Animasyonlu', 'Ultra lüks', 'Özel fontlar', 'Watermark yok'],
  'premium',
  true,
  true,
  true,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'kraliyet-sarayi-dugun');

-- PREMIUM: Düğün - Kristal Işıltısı
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'dugun' LIMIT 1),
  'Kristal Işıltısı Düğün',
  'kristal-isiltisi-dugun',
  'Işıltılı kristal efektleriyle ultra premium düğün davetiyesi',
  'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800',
  'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#E8F4F8',
      'secondary', '#B8D8E0',
      'background', '#FFFFFF',
      'text', '#2C4F5F',
      'accent', '#7DD3C0'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=1200',
    'imagePosition', 'background',
    'layout', 'crystal',
    'hasWatermark', false,
    'premiumFeatures', jsonb_build_array('Kristal efektler', 'Parıltı animasyonları', 'Glassmorphism', 'Premium görseller')
  ),
  ARRAY['düğün', 'kristal', 'ışıltı', 'modern', 'premium'],
  ARRAY['Kristal tasarım', 'Parıltı efektleri', 'Modern ve lüks', 'Glassmorphism', 'Watermark yok'],
  'premium',
  true,
  true,
  true,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'kristal-isiltisi-dugun');

-- PREMIUM: Nişan - Elmas Görkemi
INSERT INTO templates (
  id, category_id, name, slug, description,
  preview_image_url, thumbnail_url,
  design_config, tags, features,
  tier, is_premium, is_popular, is_featured, is_active
)
SELECT
  gen_random_uuid(),
  (SELECT id FROM template_categories WHERE slug = 'nisan' LIMIT 1),
  'Elmas Görkemi Nişan',
  'elmas-gorkemi-nisan',
  'Elmas temalı ultra lüks nişan davetiyesi',
  'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800',
  'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=400',
  jsonb_build_object(
    'colors', jsonb_build_object(
      'primary', '#E8E8E8',
      'secondary', '#C0C0C0',
      'background', '#FAFAFA',
      'text', '#2C2C2C',
      'accent', '#9A9A9A'
    ),
    'backgroundImage', 'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=1200',
    'imagePosition', 'background',
    'layout', 'diamond',
    'hasWatermark', false,
    'premiumFeatures', jsonb_build_array('Elmas desenleri', 'Metalik efektler', '3D animasyonlar', 'Lüks tipografi')
  ),
  ARRAY['nişan', 'elmas', 'gümüş', 'ultra lüks', 'premium'],
  ARRAY['Elmas tema', 'Metalik efektler', '3D tasarım', 'Ultra premium', 'Watermark yok'],
  'premium',
  true,
  false,
  true,
  true
WHERE NOT EXISTS (SELECT 1 FROM templates WHERE slug = 'elmas-gorkemi-nisan');

-- ============================================
-- SUMMARY
-- ============================================
-- Categories: 8
-- FREE Templates: 5 (klasik ve modern tasarımlar)
-- PRO Templates: 4 (premium hissi veren kaliteli tasarımlar)
-- PREMIUM Templates: 3 (ultra lüks, özel efektli tasarımlar)
-- Total: 12 High-Quality Templates

-- All templates include:
-- ✓ Background images from Unsplash
-- ✓ Carefully crafted color palettes
-- ✓ Category-appropriate designs
-- ✓ Tier-specific features
-- ✓ Watermark only for FREE tier

