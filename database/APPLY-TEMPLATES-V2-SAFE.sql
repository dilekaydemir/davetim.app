-- =====================================================
-- TEMPLATES V2 - SAFE VERSION (Hata Kontrolü ile)
-- =====================================================
-- Bu dosyayı Supabase SQL Editor'de çalıştırın
-- =====================================================

-- 1. Schema güncellemelerini uygula (IF NOT EXISTS ile güvenli)
DO $$ 
BEGIN
  -- category kolonu
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='templates' AND column_name='category') THEN
    ALTER TABLE templates ADD COLUMN category TEXT DEFAULT 'other';
  END IF;
  
  -- subcategory kolonu
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='templates' AND column_name='subcategory') THEN
    ALTER TABLE templates ADD COLUMN subcategory TEXT;
  END IF;
  
  -- color_palette kolonu
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='templates' AND column_name='color_palette') THEN
    ALTER TABLE templates ADD COLUMN color_palette JSONB DEFAULT '{"primary": "#000000", "secondary": "#FFFFFF", "accent": "#FF6B6B"}'::jsonb;
  END IF;
  
  -- text_fields kolonu
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='templates' AND column_name='text_fields') THEN
    ALTER TABLE templates ADD COLUMN text_fields JSONB DEFAULT '[]'::jsonb;
  END IF;
  
  -- decorative_elements kolonu
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='templates' AND column_name='decorative_elements') THEN
    ALTER TABLE templates ADD COLUMN decorative_elements JSONB DEFAULT '[]'::jsonb;
  END IF;
  
  -- available_fonts kolonu
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='templates' AND column_name='available_fonts') THEN
    ALTER TABLE templates ADD COLUMN available_fonts TEXT[] DEFAULT ARRAY['Playfair Display', 'Montserrat', 'Dancing Script'];
  END IF;
  
  -- default_image_url kolonu
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='templates' AND column_name='default_image_url') THEN
    ALTER TABLE templates ADD COLUMN default_image_url TEXT;
  END IF;
  
  -- is_featured kolonu
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='templates' AND column_name='is_featured') THEN
    ALTER TABLE templates ADD COLUMN is_featured BOOLEAN DEFAULT false;
  END IF;
  
  -- sort_order kolonu
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='templates' AND column_name='sort_order') THEN
    ALTER TABLE templates ADD COLUMN sort_order INTEGER DEFAULT 0;
  END IF;
END $$;

-- 2. Index'ler ekle (IF NOT EXISTS ile güvenli)
CREATE INDEX IF NOT EXISTS idx_templates_category ON templates(category);
CREATE INDEX IF NOT EXISTS idx_templates_tier ON templates(tier);
CREATE INDEX IF NOT EXISTS idx_templates_featured ON templates(is_featured);
CREATE INDEX IF NOT EXISTS idx_templates_sort_order ON templates(sort_order);

-- 3. Mevcut template'leri temizle (güvenli yöntem)
DELETE FROM templates;

-- 4. 9 Temel Şablon Ekle
-- =====================================================

-- DÜĞÜN (3 şablon)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, preview_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES
('Klasik Düğün', 'Zamansız ve şık klasik düğün davetiyesi', 'wedding', 'classic', 'free',
 'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop',
 'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&h=600&fit=crop',
 'https://images.unsplash.com/photo-1519741497674-611481863552?w=1200',
 '{"primary": "#2C3E50", "secondary": "#ECF0F1", "accent": "#C0A062", "background": "#FFFFFF", "text": "#2C3E50"}'::jsonb,
 '[{"id": "title", "label": "Davetiye Başlığı", "defaultValue": "Düğünümüze Davetlisiniz", "position": {"x": 50, "y": 15}, "style": {"fontSize": 36, "fontFamily": "Playfair Display", "color": "#2C3E50", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 50, "required": true},
   {"id": "couple", "label": "Çift İsimleri", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 30}, "style": {"fontSize": 48, "fontFamily": "Playfair Display", "color": "#C0A062", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
   {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 50}, "style": {"fontSize": 24, "fontFamily": "Montserrat", "color": "#2C3E50", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true},
   {"id": "venue", "label": "Mekan", "defaultValue": "Grand Hotel Ballroom", "position": {"x": 50, "y": 60}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#2C3E50", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}]'::jsonb,
 '[{"id": "heart1", "type": "heart", "position": {"x": 20, "y": 25}, "size": {"width": 30, "height": 30}, "color": "#C0A062", "rotation": -15, "opacity": 0.3, "zIndex": 1},
   {"id": "heart2", "type": "heart", "position": {"x": 80, "y": 25}, "size": {"width": 30, "height": 30}, "color": "#C0A062", "rotation": 15, "opacity": 0.3, "zIndex": 1}]'::jsonb,
 ARRAY['Playfair Display', 'Montserrat', 'Cinzel'], true, 1),

('Romantik Gül Bahçesi', 'Pembe güller ve romantik detaylarla süslü düğün davetiyesi', 'wedding', 'romantic', 'pro',
 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400&h=300&fit=crop',
 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800&h=600&fit=crop',
 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=1200',
 '{"primary": "#D4526E", "secondary": "#F8E8EE", "accent": "#FFB6C1", "background": "#FFF5F7", "text": "#4A4A4A"}'::jsonb,
 '[{"id": "title", "label": "Başlık", "defaultValue": "Aşkımızı Kutlayın", "position": {"x": 50, "y": 20}, "style": {"fontSize": 32, "fontFamily": "Dancing Script", "color": "#D4526E", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 50, "required": true},
   {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 35}, "style": {"fontSize": 44, "fontFamily": "Playfair Display", "color": "#D4526E", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
   {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024, Cumartesi", "position": {"x": 50, "y": 55}, "style": {"fontSize": 22, "fontFamily": "Montserrat", "color": "#4A4A4A", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 40, "required": true},
   {"id": "venue", "label": "Mekan", "defaultValue": "Çırağan Sarayı", "position": {"x": 50, "y": 65}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#4A4A4A", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}]'::jsonb,
 '[{"id": "flower1", "type": "flower", "position": {"x": 10, "y": 10}, "size": {"width": 60, "height": 60}, "color": "#FFB6C1", "rotation": -20, "opacity": 0.6, "zIndex": 1},
   {"id": "flower2", "type": "flower", "position": {"x": 90, "y": 10}, "size": {"width": 60, "height": 60}, "color": "#FFB6C1", "rotation": 20, "opacity": 0.6, "zIndex": 1}]'::jsonb,
 ARRAY['Dancing Script', 'Playfair Display', 'Montserrat'], true, 2),

('Lüks Saray Düğünü', 'Altın detaylar ve saray atmosferi', 'wedding', 'luxury', 'premium',
 'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=400&h=300&fit=crop',
 'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=800&h=600&fit=crop',
 'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=1200',
 '{"primary": "#8B0000", "secondary": "#FFD700", "accent": "#FFFFFF", "background": "#FFF8DC", "text": "#2C1810"}'::jsonb,
 '[{"id": "title", "label": "Başlık", "defaultValue": "Düğünümüze Şeref Vermenizi Dileriz", "position": {"x": 50, "y": 18}, "style": {"fontSize": 28, "fontFamily": "Cinzel", "color": "#8B0000", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 60, "required": true},
   {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 35}, "style": {"fontSize": 52, "fontFamily": "Playfair Display", "color": "#FFD700", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
   {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024, Cumartesi", "position": {"x": 50, "y": 55}, "style": {"fontSize": 24, "fontFamily": "Cinzel", "color": "#2C1810", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 40, "required": true},
   {"id": "time", "label": "Saat", "defaultValue": "19:00", "position": {"x": 50, "y": 65}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#2C1810", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 20, "required": true},
   {"id": "venue", "label": "Mekan", "defaultValue": "Dolmabahçe Sarayı", "position": {"x": 50, "y": 75}, "style": {"fontSize": 22, "fontFamily": "Cinzel", "color": "#8B0000", "textAlign": "center", "fontWeight": "600"}, "maxLength": 50, "required": true}]'::jsonb,
 '[{"id": "ribbon1", "type": "ribbon", "position": {"x": 50, "y": 5}, "size": {"width": 100, "height": 60}, "color": "#FFD700", "rotation": 0, "opacity": 0.5, "zIndex": 1}]'::jsonb,
 ARRAY['Cinzel', 'Playfair Display', 'Montserrat'], true, 3);

-- NİŞAN (3 şablon)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, preview_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES
('Klasik Nişan', 'Kalp detayları ile klasik nişan davetiyesi', 'engagement', 'classic', 'free',
 'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=400&h=300&fit=crop',
 'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=800&h=600&fit=crop',
 'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=1200',
 '{"primary": "#DC143C", "secondary": "#FFE4E1", "accent": "#FF69B4", "background": "#FFFFFF", "text": "#2C2C2C"}'::jsonb,
 '[{"id": "title", "label": "Başlık", "defaultValue": "Nişanımıza Davetlisiniz", "position": {"x": 50, "y": 25}, "style": {"fontSize": 34, "fontFamily": "Playfair Display", "color": "#DC143C", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 50, "required": true},
   {"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 45}, "style": {"fontSize": 42, "fontFamily": "Dancing Script", "color": "#DC143C", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
   {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 65}, "style": {"fontSize": 22, "fontFamily": "Montserrat", "color": "#2C2C2C", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 30, "required": true}]'::jsonb,
 '[{"id": "heart1", "type": "heart", "position": {"x": 25, "y": 35}, "size": {"width": 35, "height": 35}, "color": "#FF69B4", "rotation": -20, "opacity": 0.4, "zIndex": 1},
   {"id": "heart2", "type": "heart", "position": {"x": 75, "y": 35}, "size": {"width": 35, "height": 35}, "color": "#FF69B4", "rotation": 20, "opacity": 0.4, "zIndex": 1}]'::jsonb,
 ARRAY['Playfair Display', 'Dancing Script', 'Montserrat'], false, 4),

('Romantik Gün Batımı', 'Gün batımı temalı romantik nişan', 'engagement', 'romantic', 'pro',
 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=400&h=300&fit=crop',
 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&h=600&fit=crop',
 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1200',
 '{"primary": "#FF6347", "secondary": "#FFE4B5", "accent": "#FF69B4", "background": "#FFF5EE", "text": "#8B4513"}'::jsonb,
 '[{"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 40}, "style": {"fontSize": 44, "fontFamily": "Dancing Script", "color": "#FF6347", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
   {"id": "subtitle", "label": "Alt Başlık", "defaultValue": "Hayatımızın En Güzel Gününde Yanımızda Olun", "position": {"x": 50, "y": 55}, "style": {"fontSize": 18, "fontFamily": "Montserrat", "color": "#8B4513", "textAlign": "center", "fontWeight": "normal", "fontStyle": "italic"}, "maxLength": 60, "required": false},
   {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024", "position": {"x": 50, "y": 70}, "style": {"fontSize": 22, "fontFamily": "Montserrat", "color": "#8B4513", "textAlign": "center", "fontWeight": "600"}, "maxLength": 30, "required": true}]'::jsonb,
 '[{"id": "heart1", "type": "heart", "position": {"x": 15, "y": 20}, "size": {"width": 40, "height": 40}, "color": "#FF69B4", "rotation": -15, "opacity": 0.5, "zIndex": 1},
   {"id": "heart2", "type": "heart", "position": {"x": 85, "y": 20}, "size": {"width": 40, "height": 40}, "color": "#FF6347", "rotation": 15, "opacity": 0.5, "zIndex": 1}]'::jsonb,
 ARRAY['Dancing Script', 'Montserrat', 'Poppins'], false, 5),

('Lüks Restoran Nişanı', 'Lüks restoran ortamında şık nişan', 'engagement', 'luxury', 'premium',
 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=300&fit=crop',
 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&h=600&fit=crop',
 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=1200',
 '{"primary": "#000000", "secondary": "#FFD700", "accent": "#FFFFFF", "background": "#1C1C1C", "text": "#FFFFFF"}'::jsonb,
 '[{"id": "couple", "label": "Çift", "defaultValue": "Ayşe & Mehmet", "position": {"x": 50, "y": 38}, "style": {"fontSize": 48, "fontFamily": "Cinzel", "color": "#FFD700", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 40, "required": true},
   {"id": "subtitle", "label": "Alt Başlık", "defaultValue": "Nişan Yemeğine Davetlisiniz", "position": {"x": 50, "y": 52}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#FFFFFF", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": false},
   {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024, 20:00", "position": {"x": 50, "y": 65}, "style": {"fontSize": 22, "fontFamily": "Montserrat", "color": "#FFD700", "textAlign": "center", "fontWeight": "600"}, "maxLength": 40, "required": true},
   {"id": "venue", "label": "Mekan", "defaultValue": "Mikla Restaurant", "position": {"x": 50, "y": 78}, "style": {"fontSize": 20, "fontFamily": "Cinzel", "color": "#FFFFFF", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}]'::jsonb,
 '[]'::jsonb,
 ARRAY['Cinzel', 'Montserrat', 'Playfair Display'], true, 6);

-- DOĞUM GÜNÜ (3 şablon)
INSERT INTO templates (name, description, category, subcategory, tier, thumbnail_url, preview_url, default_image_url, color_palette, text_fields, decorative_elements, available_fonts, is_featured, sort_order) VALUES
('Klasik Doğum Günü', 'Renkli balonlar ve pasta ile klasik doğum günü', 'birthday', 'classic', 'free',
 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=300&fit=crop',
 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=600&fit=crop',
 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=1200',
 '{"primary": "#FF6B6B", "secondary": "#4ECDC4", "accent": "#FFE66D", "background": "#FFF9F0", "text": "#2C3E50"}'::jsonb,
 '[{"id": "title", "label": "Başlık", "defaultValue": "Doğum Günü Partisine Davetlisiniz!", "position": {"x": 50, "y": 20}, "style": {"fontSize": 32, "fontFamily": "Poppins", "color": "#FF6B6B", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 50, "required": true},
   {"id": "name", "label": "İsim", "defaultValue": "Ayşe", "position": {"x": 50, "y": 40}, "style": {"fontSize": 48, "fontFamily": "Poppins", "color": "#4ECDC4", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 30, "required": true},
   {"id": "age", "label": "Yaş", "defaultValue": "5", "position": {"x": 50, "y": 55}, "style": {"fontSize": 56, "fontFamily": "Poppins", "color": "#FFE66D", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 3, "required": true},
   {"id": "date", "label": "Tarih ve Saat", "defaultValue": "15 Haziran 2024, 14:00", "position": {"x": 50, "y": 75}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#2C3E50", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 40, "required": true}]'::jsonb,
 '[{"id": "balloon1", "type": "balloon", "position": {"x": 15, "y": 15}, "size": {"width": 40, "height": 60}, "color": "#FF6B6B", "rotation": -10, "opacity": 0.8, "zIndex": 1},
   {"id": "balloon2", "type": "balloon", "position": {"x": 85, "y": 15}, "size": {"width": 40, "height": 60}, "color": "#4ECDC4", "rotation": 10, "opacity": 0.8, "zIndex": 1},
   {"id": "confetti", "type": "confetti", "position": {"x": 50, "y": 10}, "size": {"width": 60, "height": 60}, "color": "#FFE66D", "rotation": 0, "opacity": 0.6, "zIndex": 2}]'::jsonb,
 ARRAY['Poppins', 'Montserrat'], true, 7),

('30. Yaş Milestone', 'Altın detaylarla 30. yaş kutlaması', 'birthday', 'milestone', 'pro',
 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400&h=300&fit=crop',
 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=800&h=600&fit=crop',
 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=1200',
 '{"primary": "#000000", "secondary": "#FFD700", "accent": "#FFFFFF", "background": "#1A1A1A", "text": "#FFFFFF"}'::jsonb,
 '[{"id": "title", "label": "Başlık", "defaultValue": "30 Yaşıma Özel", "position": {"x": 50, "y": 30}, "style": {"fontSize": 28, "fontFamily": "Montserrat", "color": "#FFFFFF", "textAlign": "center", "fontWeight": "300", "letterSpacing": 4, "textTransform": "uppercase"}, "maxLength": 40, "required": true},
   {"id": "name", "label": "İsim", "defaultValue": "MEHMET", "position": {"x": 50, "y": 45}, "style": {"fontSize": 52, "fontFamily": "Cinzel", "color": "#FFD700", "textAlign": "center", "fontWeight": "bold", "letterSpacing": 6}, "maxLength": 30, "required": true},
   {"id": "date", "label": "Tarih", "defaultValue": "15 Haziran 2024, 21:00", "position": {"x": 50, "y": 65}, "style": {"fontSize": 20, "fontFamily": "Montserrat", "color": "#FFD700", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 40, "required": true},
   {"id": "venue", "label": "Mekan", "defaultValue": "360 Istanbul", "position": {"x": 50, "y": 78}, "style": {"fontSize": 18, "fontFamily": "Montserrat", "color": "#FFFFFF", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true}]'::jsonb,
 '[{"id": "star1", "type": "star", "position": {"x": 20, "y": 20}, "size": {"width": 30, "height": 30}, "color": "#FFD700", "rotation": 0, "opacity": 0.7, "zIndex": 1},
   {"id": "star2", "type": "star", "position": {"x": 80, "y": 20}, "size": {"width": 30, "height": 30}, "color": "#FFD700", "rotation": 0, "opacity": 0.7, "zIndex": 1}]'::jsonb,
 ARRAY['Cinzel', 'Montserrat', 'Poppins'], true, 8),

('Prenses Teması', 'Pembe ve mor tonlarında prenses temalı parti', 'birthday', 'princess', 'premium',
 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop',
 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=600&fit=crop',
 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200',
 '{"primary": "#FF69B4", "secondary": "#DDA0DD", "accent": "#FFD700", "background": "#FFF0F5", "text": "#8B008B"}'::jsonb,
 '[{"id": "title", "label": "Başlık", "defaultValue": "Prenses Partisine Hoş Geldiniz!", "position": {"x": 50, "y": 22}, "style": {"fontSize": 30, "fontFamily": "Dancing Script", "color": "#FF69B4", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 50, "required": true},
   {"id": "name", "label": "Prenses İsmi", "defaultValue": "Prenses Ayşe", "position": {"x": 50, "y": 40}, "style": {"fontSize": 46, "fontFamily": "Playfair Display", "color": "#8B008B", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 30, "required": true},
   {"id": "age", "label": "Yaş", "defaultValue": "5 Yaşında!", "position": {"x": 50, "y": 55}, "style": {"fontSize": 32, "fontFamily": "Dancing Script", "color": "#FFD700", "textAlign": "center", "fontWeight": "bold"}, "maxLength": 20, "required": true},
   {"id": "date", "label": "Tarih ve Saat", "defaultValue": "15 Haziran 2024, Cumartesi 15:00", "position": {"x": 50, "y": 70}, "style": {"fontSize": 18, "fontFamily": "Montserrat", "color": "#8B008B", "textAlign": "center", "fontWeight": "normal"}, "maxLength": 50, "required": true},
   {"id": "venue", "label": "Mekan", "defaultValue": "Prenses Sarayı", "position": {"x": 50, "y": 82}, "style": {"fontSize": 20, "fontFamily": "Playfair Display", "color": "#FF69B4", "textAlign": "center", "fontWeight": "600"}, "maxLength": 50, "required": true}]'::jsonb,
 '[{"id": "star1", "type": "star", "position": {"x": 15, "y": 12}, "size": {"width": 35, "height": 35}, "color": "#FFD700", "rotation": -15, "opacity": 0.7, "zIndex": 1},
   {"id": "star2", "type": "star", "position": {"x": 85, "y": 12}, "size": {"width": 35, "height": 35}, "color": "#FFD700", "rotation": 15, "opacity": 0.7, "zIndex": 1},
   {"id": "heart1", "type": "heart", "position": {"x": 10, "y": 85}, "size": {"width": 30, "height": 30}, "color": "#FF69B4", "rotation": -10, "opacity": 0.6, "zIndex": 1},
   {"id": "heart2", "type": "heart", "position": {"x": 90, "y": 85}, "size": {"width": 30, "height": 30}, "color": "#DDA0DD", "rotation": 10, "opacity": 0.6, "zIndex": 1}]'::jsonb,
 ARRAY['Dancing Script', 'Playfair Display', 'Montserrat'], true, 9);

-- =====================================================
-- SONUÇ
-- =====================================================
SELECT 
  '✅ Toplam ' || COUNT(*) || ' şablon başarıyla eklendi!' as summary,
  COUNT(CASE WHEN tier = 'free' THEN 1 END) as free_count,
  COUNT(CASE WHEN tier = 'pro' THEN 1 END) as pro_count,
  COUNT(CASE WHEN tier = 'premium' THEN 1 END) as premium_count
FROM templates;

SELECT 
  category as "Kategori",
  tier as "Plan",
  COUNT(*) as "Adet"
FROM templates
GROUP BY category, tier
ORDER BY category, tier;

