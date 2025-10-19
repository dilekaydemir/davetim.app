-- ===============================================
-- TEMPLATE CATEGORIES & TEMPLATES SEED DATA
-- ===============================================
-- Canva-inspired realistic invitation templates
-- with proper categories, designs, and tier-based access
-- ===============================================

-- -------------------------------------------------------
-- PART 1: TEMPLATE CATEGORIES
-- -------------------------------------------------------

-- Clear existing data (if any)
TRUNCATE TABLE public.template_categories CASCADE;
TRUNCATE TABLE public.templates CASCADE;

-- Insert Template Categories
INSERT INTO public.template_categories (name, slug, description, icon, display_order, is_active) VALUES
-- Düğün (Wedding)
('Düğün', 'dugun', 'Hayatınızın en özel gününü unutulmaz kılacak zarif düğün davetiyeleri', '💍', 1, true),

-- Nişan (Engagement)
('Nişan', 'nisan', 'Mutluluğunuzu paylaşmak için şık nişan davetiye tasarımları', '💖', 2, true),

-- Doğum Günü (Birthday)
('Doğum Günü', 'dogum-gunu', 'Her yaş için renkli ve eğlenceli doğum günü davetiyeleri', '🎂', 3, true),

-- Bebek Şöleni (Baby Shower)
('Bebek Şöleni', 'bebek-soleni', 'Sevimli ve tatlı bebek karşılama partisi davetiyeleri', '👶', 4, true),

-- Mezuniyet (Graduation)
('Mezuniyet', 'mezuniyet', 'Başarınızı kutlamak için özel mezuniyet töreni davetiyeleri', '🎓', 5, true),

-- İş Etkinlikleri (Business Events)
('İş Etkinliği', 'is-etkinligi', 'Profesyonel iş toplantıları ve etkinlikler için kurumsal davetiyeler', '💼', 6, true),

-- Yıldönümü (Anniversary)
('Yıldönümü', 'yildonumu', 'Birlikteliğinizi kutlamak için romantik yıldönümü davetiyeleri', '🎊', 7, true),

-- Kına Gecesi (Henna Night)
('Kına Gecesi', 'kina-gecesi', 'Geleneksel Türk düğünleri için özel kına gecesi davetiyeleri', '🌺', 8, true),

-- Sünnet (Circumcision)
('Sünnet', 'sunnet', 'Geleneksel sünnet törenleri için özel tasarlanmış davetiyeler', '🎪', 9, true),

-- Yılbaşı & Kutlamalar (New Year & Celebrations)
('Kutlamalar', 'kutlamalar', 'Özel günler ve bayramlar için renkli kutlama davetiyeleri', '🎉', 10, true);

-- -------------------------------------------------------
-- PART 2: WEDDING TEMPLATES (Düğün)
-- -------------------------------------------------------

INSERT INTO public.templates (
  category_id, 
  name, 
  slug, 
  description, 
  preview_image_url, 
  thumbnail_url,
  design_config, 
  tags, 
  features, 
  tier, 
  is_premium, 
  is_popular, 
  is_featured, 
  is_active
) VALUES

-- FREE Wedding Templates (3 templates)
(
  (SELECT id FROM public.template_categories WHERE slug = 'dugun' LIMIT 1),
  'Klasik Beyaz Düğün',
  'klasik-beyaz-dugun',
  'Zarif ve minimalist beyaz tonlarda klasik düğün davetiyesi. Altın detaylar ve serif fontlar.',
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
  '{
    "layout": "centered",
    "backgroundColor": "#FFFFFF",
    "accentColor": "#D4AF37",
    "fontFamily": "Playfair Display",
    "fontSizes": {
      "title": 48,
      "subtitle": 24,
      "body": 16
    },
    "elements": [
      {
        "type": "border",
        "style": "gold-frame",
        "thickness": 2
      },
      {
        "type": "ornament",
        "position": "top-center",
        "icon": "floral-divider"
      }
    ],
    "spacing": {
      "padding": 40,
      "lineHeight": 1.8
    }
  }',
  ARRAY['düğün', 'klasik', 'zarif', 'minimalist', 'beyaz', 'altın'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  true,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'dugun' LIMIT 1),
  'Romantic Çiçek Bahçesi',
  'romantic-cicek-bahcesi',
  'Pembe ve yeşil tonlarda çiçek desenleriyle romantik düğün davetiyesi.',
  'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800',
  'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400',
  '{
    "layout": "floral-border",
    "backgroundColor": "#FFF5F7",
    "accentColor": "#E91E63",
    "fontFamily": "Great Vibes",
    "fontSizes": {
      "title": 52,
      "subtitle": 22,
      "body": 16
    },
    "elements": [
      {
        "type": "floral-frame",
        "style": "watercolor",
        "corners": true
      },
      {
        "type": "divider",
        "style": "leaves",
        "position": "between-sections"
      }
    ],
    "spacing": {
      "padding": 35,
      "lineHeight": 1.7
    }
  }',
  ARRAY['düğün', 'romantic', 'çiçek', 'pembe', 'bahçe', 'doğa'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  false,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'dugun' LIMIT 1),
  'Modern Geometric Düğün',
  'modern-geometric-dugun',
  'Geometrik şekiller ve modern tipografi ile çağdaş düğün davetiyesi.',
  'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800',
  'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400',
  '{
    "layout": "asymmetric",
    "backgroundColor": "#F8F9FA",
    "accentColor": "#212529",
    "fontFamily": "Montserrat",
    "fontSizes": {
      "title": 44,
      "subtitle": 20,
      "body": 15
    },
    "elements": [
      {
        "type": "geometric-shapes",
        "style": "minimal-lines",
        "position": "corners"
      },
      {
        "type": "divider",
        "style": "thin-line",
        "color": "#212529"
      }
    ],
    "spacing": {
      "padding": 45,
      "lineHeight": 1.6
    }
  }',
  ARRAY['düğün', 'modern', 'geometrik', 'minimalist', 'contemporary'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  false,
  false,
  true
),

-- PRO Wedding Templates (4 templates)
(
  (SELECT id FROM public.template_categories WHERE slug = 'dugun' LIMIT 1),
  'Lüks Altın & Mermer',
  'luks-altin-mermer',
  'Premium altın detaylar ve mermer doku ile lüks düğün davetiyesi. Özel animasyonlu görsel yükleme desteği.',
  'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800',
  'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400',
  '{
    "layout": "marble-overlay",
    "backgroundColor": "#FFFFFF",
    "accentColor": "#FFD700",
    "textureImage": "marble-white",
    "fontFamily": "Cormorant Garamond",
    "fontSizes": {
      "title": 56,
      "subtitle": 26,
      "body": 17
    },
    "elements": [
      {
        "type": "gold-foil-effect",
        "areas": ["title", "ornaments"]
      },
      {
        "type": "ornamental-frame",
        "style": "art-deco",
        "thickness": 3
      },
      {
        "type": "monogram",
        "position": "top-center",
        "style": "initials-circle"
      }
    ],
    "animations": {
      "entrance": "fade-in-up",
      "duration": 1200
    },
    "spacing": {
      "padding": 50,
      "lineHeight": 2
    }
  }',
  ARRAY['düğün', 'lüks', 'premium', 'altın', 'mermer', 'zarif'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar', 'Animasyonlar'],
  'pro',
  false,
  true,
  true,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'dugun' LIMIT 1),
  'Vintage Bohem Düğün',
  'vintage-bohem-dugun',
  'Retro çiçek desenler ve vintage tipografi ile bohem tarzı düğün davetiyesi.',
  'https://images.unsplash.com/photo-1544216717-3bbf52512659?w=800',
  'https://images.unsplash.com/photo-1544216717-3bbf52512659?w=400',
  '{
    "layout": "vintage-frame",
    "backgroundColor": "#FFF8E7",
    "accentColor": "#8B4513",
    "fontFamily": "Crimson Text",
    "fontSizes": {
      "title": 50,
      "subtitle": 24,
      "body": 16
    },
    "elements": [
      {
        "type": "vintage-ornaments",
        "style": "hand-drawn",
        "position": "corners"
      },
      {
        "type": "floral-watercolor",
        "opacity": 0.3,
        "position": "background"
      }
    ],
    "spacing": {
      "padding": 40,
      "lineHeight": 1.8
    }
  }',
  ARRAY['düğün', 'vintage', 'bohem', 'retro', 'çiçek', 'rustik'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar'],
  'pro',
  false,
  true,
  false,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'dugun' LIMIT 1),
  'Deniz Temalı Düğün',
  'deniz-temali-dugun',
  'Mavi tonlarda deniz ve kumsal temalı yaz düğünü davetiyesi.',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
  '{
    "layout": "beach-theme",
    "backgroundColor": "#E0F2F7",
    "accentColor": "#006064",
    "fontFamily": "Lato",
    "fontSizes": {
      "title": 46,
      "subtitle": 22,
      "body": 16
    },
    "elements": [
      {
        "type": "nautical-icons",
        "style": "anchor-shells",
        "position": "decorative"
      },
      {
        "type": "wave-divider",
        "style": "smooth-waves"
      }
    ],
    "spacing": {
      "padding": 38,
      "lineHeight": 1.7
    }
  }',
  ARRAY['düğün', 'deniz', 'plaj', 'mavi', 'yaz', 'tatil'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar'],
  'pro',
  false,
  false,
  false,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'dugun' LIMIT 1),
  'Rustik Kır Düğünü',
  'rustik-kir-dugunu',
  'Ahşap doku ve doğal renklerle rustik kır düğünü davetiyesi.',
  'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800',
  'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400',
  '{
    "layout": "rustic-wood",
    "backgroundColor": "#F5E6D3",
    "accentColor": "#5D4037",
    "textureImage": "wood-grain",
    "fontFamily": "Merriweather",
    "fontSizes": {
      "title": 48,
      "subtitle": 23,
      "body": 16
    },
    "elements": [
      {
        "type": "wood-frame",
        "style": "barn-wood"
      },
      {
        "type": "wildflowers",
        "style": "sketched",
        "position": "scattered"
      }
    ],
    "spacing": {
      "padding": 35,
      "lineHeight": 1.7
    }
  }',
  ARRAY['düğün', 'rustik', 'kır', 'doğa', 'ahşap', 'country'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar'],
  'pro',
  false,
  false,
  false,
  true
),

-- PREMIUM Wedding Templates (3 templates)
(
  (SELECT id FROM public.template_categories WHERE slug = 'dugun' LIMIT 1),
  'Royal Palace Düğün',
  'royal-palace-dugun',
  'Kraliyet tarzı lüks detaylar, animasyonlar ve video arka plan desteğiyle sarayı andıran düğün davetiyesi.',
  'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=800',
  'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=400',
  '{
    "layout": "royal-palace",
    "backgroundColor": "#FAF9F6",
    "accentColor": "#8B0000",
    "secondaryColor": "#FFD700",
    "fontFamily": "Cinzel",
    "fontSizes": {
      "title": 60,
      "subtitle": 28,
      "body": 18
    },
    "elements": [
      {
        "type": "royal-crest",
        "position": "header",
        "animated": true
      },
      {
        "type": "ornate-border",
        "style": "baroque",
        "thickness": 4,
        "animated": true
      },
      {
        "type": "video-background",
        "style": "particle-effect",
        "color": "gold"
      }
    ],
    "animations": {
      "entrance": "luxury-fade",
      "interactions": "hover-shimmer",
      "duration": 1500
    },
    "ai": {
      "textSuggestions": true,
      "designRecommendations": true
    },
    "spacing": {
      "padding": 55,
      "lineHeight": 2.2
    }
  }',
  ARRAY['düğün', 'royal', 'lüks', 'saray', 'altın', 'premium'],
  ARRAY['QR Media', 'AI Tasarım', 'Video arka plan', 'Sınırsız görsel', 'Tüm özellikler'],
  'premium',
  true,
  true,
  true,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'dugun' LIMIT 1),
  'Magical Garden Wedding',
  'magical-garden-wedding',
  'Sihirli bahçe teması, animasyonlu çiçek efektleri ve AI destekli kişiselleştirme.',
  'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800',
  'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400',
  '{
    "layout": "enchanted-garden",
    "backgroundColor": "#F0F8F0",
    "accentColor": "#2E7D32",
    "secondaryColor": "#FF6F91",
    "fontFamily": "Dancing Script",
    "fontSizes": {
      "title": 58,
      "subtitle": 26,
      "body": 17
    },
    "elements": [
      {
        "type": "animated-flowers",
        "style": "blooming",
        "position": "floating"
      },
      {
        "type": "butterfly-effect",
        "animated": true,
        "quantity": 5
      },
      {
        "type": "ivy-frame",
        "style": "watercolor",
        "animated": true
      }
    ],
    "animations": {
      "entrance": "garden-bloom",
      "scroll": "parallax-flowers",
      "duration": 2000
    },
    "ai": {
      "textSuggestions": true,
      "designRecommendations": true,
      "colorHarmonization": true
    },
    "spacing": {
      "padding": 48,
      "lineHeight": 2
    }
  }',
  ARRAY['düğün', 'magical', 'garden', 'fairy-tale', 'animasyonlu', 'premium'],
  ARRAY['QR Media', 'AI Tasarım', 'Animasyonlar', 'Sınırsız görsel', 'Tüm özellikler'],
  'premium',
  true,
  true,
  true,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'dugun' LIMIT 1),
  'Crystal Elegance',
  'crystal-elegance',
  'Kristal efektler, ışık yansımaları ve 3D elementi ile premium düğün davetiyesi.',
  'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=800',
  'https://images.unsplash.com/photo-1460978812857-470ed1c77af0?w=400',
  '{
    "layout": "crystal-luxury",
    "backgroundColor": "#FFFFFF",
    "accentColor": "#C0C0C0",
    "secondaryColor": "#B9F2FF",
    "fontFamily": "Italiana",
    "fontSizes": {
      "title": 54,
      "subtitle": 25,
      "body": 17
    },
    "elements": [
      {
        "type": "crystal-effect",
        "style": "diamond-sparkle",
        "animated": true
      },
      {
        "type": "light-rays",
        "style": "prism",
        "animated": true
      },
      {
        "type": "3d-frame",
        "style": "beveled-glass",
        "depth": 2
      }
    ],
    "animations": {
      "entrance": "crystal-shimmer",
      "scroll": "light-refraction",
      "hover": "sparkle-trail",
      "duration": 1800
    },
    "ai": {
      "textSuggestions": true,
      "designRecommendations": true,
      "smartContrast": true
    },
    "spacing": {
      "padding": 52,
      "lineHeight": 2.1
    }
  }',
  ARRAY['düğün', 'crystal', 'lüks', 'elegant', '3d', 'premium'],
  ARRAY['QR Media', 'AI Tasarım', '3D efektler', 'Sınırsız görsel', 'Tüm özellikler'],
  'premium',
  true,
  false,
  false,
  true
);

-- -------------------------------------------------------
-- PART 3: ENGAGEMENT TEMPLATES (Nişan)
-- -------------------------------------------------------

INSERT INTO public.templates (
  category_id, 
  name, 
  slug, 
  description, 
  preview_image_url, 
  thumbnail_url,
  design_config, 
  tags, 
  features, 
  tier, 
  is_premium, 
  is_popular, 
  is_featured, 
  is_active
) VALUES

-- FREE Engagement Templates (2 templates)
(
  (SELECT id FROM public.template_categories WHERE slug = 'nisan' LIMIT 1),
  'Romantik Kırmızı Nişan',
  'romantik-kirmizi-nisan',
  'Aşk dolu kırmızı tonlarda kalp motifleri ile romantik nişan davetiyesi.',
  'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=800',
  'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=400',
  '{
    "layout": "heart-centered",
    "backgroundColor": "#FFF0F0",
    "accentColor": "#C62828",
    "fontFamily": "Pacifico",
    "fontSizes": {
      "title": 46,
      "subtitle": 22,
      "body": 16
    },
    "elements": [
      {
        "type": "heart-motif",
        "style": "watercolor",
        "position": "scattered"
      },
      {
        "type": "ring-icon",
        "position": "top-center"
      }
    ],
    "spacing": {
      "padding": 35,
      "lineHeight": 1.7
    }
  }',
  ARRAY['nişan', 'romantic', 'kırmızı', 'kalp', 'aşk'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  false,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'nisan' LIMIT 1),
  'Şık Pembe & Altın Nişan',
  'sik-pembe-altin-nisan',
  'Pembe ve altın kombinasyonu ile şık nişan davetiyesi.',
  'https://images.unsplash.com/photo-1516450137517-162bfbeb8dba?w=800',
  'https://images.unsplash.com/photo-1516450137517-162bfbeb8dba?w=400',
  '{
    "layout": "elegant-frame",
    "backgroundColor": "#FFE4E1",
    "accentColor": "#FFD700",
    "fontFamily": "Lobster",
    "fontSizes": {
      "title": 48,
      "subtitle": 23,
      "body": 16
    },
    "elements": [
      {
        "type": "gold-border",
        "style": "delicate-lines",
        "thickness": 2
      },
      {
        "type": "floral-corner",
        "style": "minimal-roses"
      }
    ],
    "spacing": {
      "padding": 38,
      "lineHeight": 1.8
    }
  }',
  ARRAY['nişan', 'şık', 'pembe', 'altın', 'zarif'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  true,
  true
),

-- PRO Engagement Templates (2 templates)
(
  (SELECT id FROM public.template_categories WHERE slug = 'nisan' LIMIT 1),
  'Lüks Bordo & Gold Nişan',
  'luks-bordo-gold-nisan',
  'Bordo ve altın harmonyası ile premium nişan davetiyesi. Özel görsel yükleme desteği.',
  'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800',
  'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=400',
  '{
    "layout": "luxury-burgundy",
    "backgroundColor": "#8B0000",
    "accentColor": "#FFD700",
    "textColor": "#FFFFFF",
    "fontFamily": "Playfair Display",
    "fontSizes": {
      "title": 52,
      "subtitle": 25,
      "body": 17
    },
    "elements": [
      {
        "type": "gold-foil-frame",
        "style": "ornate"
      },
      {
        "type": "damask-pattern",
        "opacity": 0.2,
        "position": "background"
      }
    ],
    "spacing": {
      "padding": 45,
      "lineHeight": 1.9
    }
  }',
  ARRAY['nişan', 'lüks', 'bordo', 'altın', 'premium'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar'],
  'pro',
  false,
  true,
  false,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'nisan' LIMIT 1),
  'Vintage Polaroid Nişan',
  'vintage-polaroid-nisan',
  'Polaroid çerçeveler ile nostaljik nişan davetiyesi.',
  'https://images.unsplash.com/photo-1452421822248-d4c2b47f0c81?w=800',
  'https://images.unsplash.com/photo-1452421822248-d4c2b47f0c81?w=400',
  '{
    "layout": "polaroid-collage",
    "backgroundColor": "#FFF9E6",
    "accentColor": "#8B4513",
    "fontFamily": "Shadows Into Light",
    "fontSizes": {
      "title": 44,
      "subtitle": 21,
      "body": 15
    },
    "elements": [
      {
        "type": "polaroid-frames",
        "quantity": 3,
        "rotation": true
      },
      {
        "type": "handwritten-notes",
        "style": "script"
      }
    ],
    "spacing": {
      "padding": 32,
      "lineHeight": 1.6
    }
  }',
  ARRAY['nişan', 'vintage', 'polaroid', 'nostaljik', 'retro'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar'],
  'pro',
  false,
  false,
  false,
  true
);

-- -------------------------------------------------------
-- PART 4: BIRTHDAY TEMPLATES (Doğum Günü)
-- -------------------------------------------------------

INSERT INTO public.templates (
  category_id, 
  name, 
  slug, 
  description, 
  preview_image_url, 
  thumbnail_url,
  design_config, 
  tags, 
  features, 
  tier, 
  is_premium, 
  is_popular, 
  is_featured, 
  is_active
) VALUES

-- FREE Birthday Templates (3 templates)
(
  (SELECT id FROM public.template_categories WHERE slug = 'dogum-gunu' LIMIT 1),
  'Renkli Balonlar',
  'renkli-balonlar',
  'Her yaş için renkli balon temaları ile neşeli doğum günü davetiyesi.',
  'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800',
  'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400',
  '{
    "layout": "balloon-party",
    "backgroundColor": "#FFF9C4",
    "accentColor": "#FF5722",
    "fontFamily": "Fredoka One",
    "fontSizes": {
      "title": 50,
      "subtitle": 24,
      "body": 16
    },
    "elements": [
      {
        "type": "balloons",
        "style": "floating",
        "colors": ["#FF5722", "#2196F3", "#4CAF50", "#FFC107"]
      },
      {
        "type": "confetti",
        "style": "scattered"
      }
    ],
    "spacing": {
      "padding": 30,
      "lineHeight": 1.6
    }
  }',
  ARRAY['doğum-günü', 'balon', 'renkli', 'eğlenceli', 'parti'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  true,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'dogum-gunu' LIMIT 1),
  'Prenses Teması',
  'prenses-temasi',
  'Kız çocukları için pembe tonlarda taç ve prenses temalı doğum günü davetiyesi.',
  'https://images.unsplash.com/photo-1464349153735-7db50ed83c84?w=800',
  'https://images.unsplash.com/photo-1464349153735-7db50ed83c84?w=400',
  '{
    "layout": "princess-castle",
    "backgroundColor": "#FFE4F5",
    "accentColor": "#FF69B4",
    "fontFamily": "Cinzel Decorative",
    "fontSizes": {
      "title": 48,
      "subtitle": 22,
      "body": 15
    },
    "elements": [
      {
        "type": "crown",
        "style": "glittery",
        "position": "top-center"
      },
      {
        "type": "castle-silhouette",
        "position": "background",
        "opacity": 0.15
      }
    ],
    "spacing": {
      "padding": 35,
      "lineHeight": 1.7
    }
  }',
  ARRAY['doğum-günü', 'prenses', 'kız-çocuk', 'pembe', 'taç'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  false,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'dogum-gunu' LIMIT 1),
  'Süper Kahraman',
  'super-kahraman',
  'Erkek çocukları için süper kahraman temalı güçlü doğum günü davetiyesi.',
  'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800',
  'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400',
  '{
    "layout": "superhero-action",
    "backgroundColor": "#1A237E",
    "accentColor": "#FFC107",
    "textColor": "#FFFFFF",
    "fontFamily": "Bangers",
    "fontSizes": {
      "title": 52,
      "subtitle": 24,
      "body": 16
    },
    "elements": [
      {
        "type": "superhero-logo",
        "style": "comic-burst"
      },
      {
        "type": "action-lines",
        "style": "dynamic"
      }
    ],
    "spacing": {
      "padding": 32,
      "lineHeight": 1.6
    }
  }',
  ARRAY['doğum-günü', 'superhero', 'erkek-çocuk', 'güçlü', 'kahraman'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  false,
  false,
  true
),

-- PRO Birthday Templates (2 templates)
(
  (SELECT id FROM public.template_categories WHERE slug = 'dogum-gunu' LIMIT 1),
  'Unicorn Magic',
  'unicorn-magic',
  'Unicorn ve gökkuşağı teması ile sihirli doğum günü davetiyesi. Görsel yükleme desteği.',
  'https://images.unsplash.com/photo-1513467535987-fd81bc7d62f8?w=800',
  'https://images.unsplash.com/photo-1513467535987-fd81bc7d62f8?w=400',
  '{
    "layout": "unicorn-dream",
    "backgroundColor": "#F0E6FF",
    "accentColor": "#9C27B0",
    "fontFamily": "Quicksand",
    "fontSizes": {
      "title": 50,
      "subtitle": 23,
      "body": 16
    },
    "elements": [
      {
        "type": "unicorn-illustration",
        "style": "watercolor"
      },
      {
        "type": "rainbow",
        "style": "gradient",
        "position": "arc"
      },
      {
        "type": "stars-sparkles",
        "quantity": 20
      }
    ],
    "spacing": {
      "padding": 38,
      "lineHeight": 1.7
    }
  }',
  ARRAY['doğum-günü', 'unicorn', 'gökkuşağı', 'sihir', 'kız-çocuk'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar'],
  'pro',
  false,
  true,
  true,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'dogum-gunu' LIMIT 1),
  'Gaming Party',
  'gaming-party',
  'Video oyun teması ile gamer doğum günü davetiyesi.',
  'https://images.unsplash.com/photo-1511882150382-421056c89033?w=800',
  'https://images.unsplash.com/photo-1511882150382-421056c89033?w=400',
  '{
    "layout": "gaming-console",
    "backgroundColor": "#212121",
    "accentColor": "#00E676",
    "textColor": "#FFFFFF",
    "fontFamily": "Press Start 2P",
    "fontSizes": {
      "title": 32,
      "subtitle": 18,
      "body": 12
    },
    "elements": [
      {
        "type": "pixel-art",
        "style": "8-bit-graphics"
      },
      {
        "type": "game-controller",
        "style": "neon-outline"
      }
    ],
    "spacing": {
      "padding": 35,
      "lineHeight": 1.8
    }
  }',
  ARRAY['doğum-günü', 'gaming', 'oyun', 'gamer', 'teknoloji'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar'],
  'pro',
  false,
  false,
  false,
  true
);

-- -------------------------------------------------------
-- PART 5: BABY SHOWER TEMPLATES (Bebek Şöleni)
-- -------------------------------------------------------

INSERT INTO public.templates (
  category_id, 
  name, 
  slug, 
  description, 
  preview_image_url, 
  thumbnail_url,
  design_config, 
  tags, 
  features, 
  tier, 
  is_premium, 
  is_popular, 
  is_featured, 
  is_active
) VALUES

-- FREE Baby Shower Templates (2 templates)
(
  (SELECT id FROM public.template_categories WHERE slug = 'bebek-soleni' LIMIT 1),
  'Sevimli Ayıcık',
  'sevimli-ayicik',
  'Teddy bear teması ile sevimli bebek karşılama davetiyesi.',
  'https://images.unsplash.com/photo-1515488764276-beab7607c1e6?w=800',
  'https://images.unsplash.com/photo-1515488764276-beab7607c1e6?w=400',
  '{
    "layout": "teddy-bear",
    "backgroundColor": "#FFF8DC",
    "accentColor": "#D2691E",
    "fontFamily": "Comic Neue",
    "fontSizes": {
      "title": 44,
      "subtitle": 21,
      "body": 15
    },
    "elements": [
      {
        "type": "teddy-bear-illustration",
        "style": "soft-cute"
      },
      {
        "type": "baby-blocks",
        "letters": "ABC"
      }
    ],
    "spacing": {
      "padding": 32,
      "lineHeight": 1.7
    }
  }',
  ARRAY['baby-shower', 'ayıcık', 'sevimli', 'bebek', 'tatlı'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  true,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'bebek-soleni' LIMIT 1),
  'Mavi & Pembe Bulutlar',
  'mavi-pembe-bulutlar',
  'Bulut ve yıldız teması ile pastel renkli bebek davetiyesi.',
  'https://images.unsplash.com/photo-1566004100631-35d015d6a491?w=800',
  'https://images.unsplash.com/photo-1566004100631-35d015d6a491?w=400',
  '{
    "layout": "cloud-sky",
    "backgroundColor": "#E3F2FD",
    "accentColor": "#90CAF9",
    "fontFamily": "Nunito",
    "fontSizes": {
      "title": 46,
      "subtitle": 22,
      "body": 15
    },
    "elements": [
      {
        "type": "fluffy-clouds",
        "style": "soft-gradient"
      },
      {
        "type": "stars",
        "style": "twinkle",
        "quantity": 10
      }
    ],
    "spacing": {
      "padding": 34,
      "lineHeight": 1.7
    }
  }',
  ARRAY['baby-shower', 'bulut', 'pastel', 'mavi', 'pembe'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  false,
  true
),

-- PRO Baby Shower Template (1 template)
(
  (SELECT id FROM public.template_categories WHERE slug = 'bebek-soleni' LIMIT 1),
  'Little Prince / Princess',
  'little-prince-princess',
  'Kraliyet teması ile özel bebek karşılama davetiyesi. Görsel yükleme desteği.',
  'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=800',
  'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=400',
  '{
    "layout": "royal-baby",
    "backgroundColor": "#FFF5E1",
    "accentColor": "#DAA520",
    "fontFamily": "Cormorant Infant",
    "fontSizes": {
      "title": 48,
      "subtitle": 23,
      "body": 16
    },
    "elements": [
      {
        "type": "baby-crown",
        "style": "gold-foil"
      },
      {
        "type": "royal-crest",
        "style": "simple-elegant"
      }
    ],
    "spacing": {
      "padding": 40,
      "lineHeight": 1.8
    }
  }',
  ARRAY['baby-shower', 'royal', 'prince', 'princess', 'lüks'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar'],
  'pro',
  false,
  false,
  false,
  true
);

-- -------------------------------------------------------
-- PART 6: GRADUATION TEMPLATES (Mezuniyet)
-- -------------------------------------------------------

INSERT INTO public.templates (
  category_id, 
  name, 
  slug, 
  description, 
  preview_image_url, 
  thumbnail_url,
  design_config, 
  tags, 
  features, 
  tier, 
  is_premium, 
  is_popular, 
  is_featured, 
  is_active
) VALUES

-- FREE Graduation Templates (2 templates)
(
  (SELECT id FROM public.template_categories WHERE slug = 'mezuniyet' LIMIT 1),
  'Klasik Mezuniyet',
  'klasik-mezuniyet',
  'Kep ve diploma teması ile klasik mezuniyet töreni davetiyesi.',
  'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800',
  'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400',
  '{
    "layout": "graduation-cap",
    "backgroundColor": "#212121",
    "accentColor": "#FFD700",
    "textColor": "#FFFFFF",
    "fontFamily": "Merriweather",
    "fontSizes": {
      "title": 48,
      "subtitle": 22,
      "body": 16
    },
    "elements": [
      {
        "type": "graduation-cap",
        "style": "gold-tassel"
      },
      {
        "type": "diploma-scroll",
        "style": "ribbon"
      }
    ],
    "spacing": {
      "padding": 35,
      "lineHeight": 1.7
    }
  }',
  ARRAY['mezuniyet', 'graduation', 'kep', 'diploma', 'başarı'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  true,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'mezuniyet' LIMIT 1),
  'Modern Mezuniyet',
  'modern-mezuniyet',
  'Minimalist ve modern tasarım ile mezuniyet davetiyesi.',
  'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=800',
  'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400',
  '{
    "layout": "modern-minimal",
    "backgroundColor": "#FFFFFF",
    "accentColor": "#1565C0",
    "fontFamily": "Raleway",
    "fontSizes": {
      "title": 46,
      "subtitle": 21,
      "body": 15
    },
    "elements": [
      {
        "type": "geometric-shapes",
        "style": "clean-lines"
      },
      {
        "type": "achievement-badge",
        "style": "minimalist"
      }
    ],
    "spacing": {
      "padding": 40,
      "lineHeight": 1.8
    }
  }',
  ARRAY['mezuniyet', 'modern', 'minimalist', 'temiz', 'professional'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  false,
  false,
  true
);

-- -------------------------------------------------------
-- PART 7: BUSINESS EVENT TEMPLATES (İş Etkinliği)
-- -------------------------------------------------------

INSERT INTO public.templates (
  category_id, 
  name, 
  slug, 
  description, 
  preview_image_url, 
  thumbnail_url,
  design_config, 
  tags, 
  features, 
  tier, 
  is_premium, 
  is_popular, 
  is_featured, 
  is_active
) VALUES

-- PRO Business Event Templates (2 templates)
(
  (SELECT id FROM public.template_categories WHERE slug = 'is-etkinligi' LIMIT 1),
  'Kurumsal Profesyonel',
  'kurumsal-profesyonel',
  'Şık ve profesyonel iş toplantıları için kurumsal davetiye.',
  'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800',
  'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=400',
  '{
    "layout": "corporate-clean",
    "backgroundColor": "#FFFFFF",
    "accentColor": "#1A237E",
    "fontFamily": "Open Sans",
    "fontSizes": {
      "title": 42,
      "subtitle": 20,
      "body": 14
    },
    "elements": [
      {
        "type": "logo-placeholder",
        "position": "header"
      },
      {
        "type": "minimal-line",
        "style": "horizontal-divider"
      }
    ],
    "spacing": {
      "padding": 45,
      "lineHeight": 1.6
    }
  }',
  ARRAY['business', 'kurumsal', 'profesyonel', 'toplantı', 'corporate'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar'],
  'pro',
  false,
  true,
  false,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'is-etkinligi' LIMIT 1),
  'Networking Event',
  'networking-event',
  'Networking etkinlikleri için modern ve dinamik davetiye.',
  'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800',
  'https://images.unsplash.com/photo-1511578314322-379afb476865?w=400',
  '{
    "layout": "networking-modern",
    "backgroundColor": "#37474F",
    "accentColor": "#00ACC1",
    "textColor": "#FFFFFF",
    "fontFamily": "Roboto",
    "fontSizes": {
      "title": 44,
      "subtitle": 21,
      "body": 15
    },
    "elements": [
      {
        "type": "network-nodes",
        "style": "connected-dots"
      },
      {
        "type": "tech-pattern",
        "opacity": 0.1
      }
    ],
    "spacing": {
      "padding": 38,
      "lineHeight": 1.7
    }
  }',
  ARRAY['business', 'networking', 'teknoloji', 'modern', 'dinamik'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar'],
  'pro',
  false,
  false,
  false,
  true
);

-- -------------------------------------------------------
-- PART 8: ANNIVERSARY TEMPLATES (Yıldönümü)
-- -------------------------------------------------------

INSERT INTO public.templates (
  category_id, 
  name, 
  slug, 
  description, 
  preview_image_url, 
  thumbnail_url,
  design_config, 
  tags, 
  features, 
  tier, 
  is_premium, 
  is_popular, 
  is_featured, 
  is_active
) VALUES

-- FREE Anniversary Template (1 template)
(
  (SELECT id FROM public.template_categories WHERE slug = 'yildonumu' LIMIT 1),
  'Romantic Anniversary',
  'romantic-anniversary',
  'Romantik ve zarif yıldönümü kutlama davetiyesi.',
  'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=800',
  'https://images.unsplash.com/photo-1518568814500-bf0f8d125f46?w=400',
  '{
    "layout": "heart-romantic",
    "backgroundColor": "#FFF0F5",
    "accentColor": "#C71585",
    "fontFamily": "Great Vibes",
    "fontSizes": {
      "title": 50,
      "subtitle": 24,
      "body": 16
    },
    "elements": [
      {
        "type": "intertwined-hearts",
        "style": "elegant-lines"
      },
      {
        "type": "rose-petals",
        "style": "scattered",
        "opacity": 0.3
      }
    ],
    "spacing": {
      "padding": 36,
      "lineHeight": 1.8
    }
  }',
  ARRAY['yıldönümü', 'romantic', 'anniversary', 'aşk', 'kutlama'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  false,
  true
);

-- -------------------------------------------------------
-- PART 9: HENNA NIGHT TEMPLATES (Kına Gecesi)
-- -------------------------------------------------------

INSERT INTO public.templates (
  category_id, 
  name, 
  slug, 
  description, 
  preview_image_url, 
  thumbnail_url,
  design_config, 
  tags, 
  features, 
  tier, 
  is_premium, 
  is_popular, 
  is_featured, 
  is_active
) VALUES

-- FREE Henna Night Template (1 template)
(
  (SELECT id FROM public.template_categories WHERE slug = 'kina-gecesi' LIMIT 1),
  'Geleneksel Kına Gecesi',
  'geleneksel-kina-gecesi',
  'Osmanlı motifleri ile geleneksel kına gecesi davetiyesi.',
  'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=800',
  'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=400',
  '{
    "layout": "ottoman-pattern",
    "backgroundColor": "#8B0000",
    "accentColor": "#FFD700",
    "textColor": "#FFFFFF",
    "fontFamily": "Cinzel",
    "fontSizes": {
      "title": 48,
      "subtitle": 23,
      "body": 16
    },
    "elements": [
      {
        "type": "ottoman-motif",
        "style": "traditional",
        "position": "border"
      },
      {
        "type": "henna-hands",
        "style": "decorative"
      }
    ],
    "spacing": {
      "padding": 38,
      "lineHeight": 1.7
    }
  }',
  ARRAY['kına', 'geleneksel', 'turkish', 'osmanlı', 'henna'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  true,
  true
),

-- PRO Henna Night Template (1 template)
(
  (SELECT id FROM public.template_categories WHERE slug = 'kina-gecesi' LIMIT 1),
  'Modern Kına Stili',
  'modern-kina-stili',
  'Geleneksel ve modern karışımı şık kına gecesi davetiyesi.',
  'https://images.unsplash.com/photo-1560264280-88b68371db39?w=800',
  'https://images.unsplash.com/photo-1560264280-88b68371db39?w=400',
  '{
    "layout": "modern-traditional-fusion",
    "backgroundColor": "#FAFAFA",
    "accentColor": "#D32F2F",
    "fontFamily": "Poppins",
    "fontSizes": {
      "title": 46,
      "subtitle": 22,
      "body": 15
    },
    "elements": [
      {
        "type": "geometric-henna",
        "style": "modern-patterns"
      },
      {
        "type": "candles",
        "style": "illustrated"
      }
    ],
    "spacing": {
      "padding": 40,
      "lineHeight": 1.8
    }
  }',
  ARRAY['kına', 'modern', 'şık', 'fusion', 'contemporary'],
  ARRAY['Görsel yükleme', 'WhatsApp paylaşımı', 'Excel export', 'Özel fontlar'],
  'pro',
  false,
  false,
  false,
  true
);

-- -------------------------------------------------------
-- PART 10: CIRCUMCISION TEMPLATES (Sünnet)
-- -------------------------------------------------------

INSERT INTO public.templates (
  category_id, 
  name, 
  slug, 
  description, 
  preview_image_url, 
  thumbnail_url,
  design_config, 
  tags, 
  features, 
  tier, 
  is_premium, 
  is_popular, 
  is_featured, 
  is_active
) VALUES

-- FREE Circumcision Template (1 template)
(
  (SELECT id FROM public.template_categories WHERE slug = 'sunnet' LIMIT 1),
  'Prens Sünnet Şöleni',
  'prens-sunnet-soleni',
  'Şehzade teması ile özel sünnet töreni davetiyesi.',
  'https://images.unsplash.com/photo-1464146072230-91cabc968266?w=800',
  'https://images.unsplash.com/photo-1464146072230-91cabc968266?w=400',
  '{
    "layout": "prince-theme",
    "backgroundColor": "#1A237E",
    "accentColor": "#FFD700",
    "textColor": "#FFFFFF",
    "fontFamily": "Cinzel",
    "fontSizes": {
      "title": 48,
      "subtitle": 23,
      "body": 16
    },
    "elements": [
      {
        "type": "crown",
        "style": "prince-crown"
      },
      {
        "type": "ottoman-sword",
        "style": "decorative"
      }
    ],
    "spacing": {
      "padding": 38,
      "lineHeight": 1.8
    }
  }',
  ARRAY['sünnet', 'prens', 'şehzade', 'geleneksel', 'tören'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  true,
  true
);

-- -------------------------------------------------------
-- PART 11: CELEBRATION TEMPLATES (Kutlamalar)
-- -------------------------------------------------------

INSERT INTO public.templates (
  category_id, 
  name, 
  slug, 
  description, 
  preview_image_url, 
  thumbnail_url,
  design_config, 
  tags, 
  features, 
  tier, 
  is_premium, 
  is_popular, 
  is_featured, 
  is_active
) VALUES

-- FREE Celebration Templates (2 templates)
(
  (SELECT id FROM public.template_categories WHERE slug = 'kutlamalar' LIMIT 1),
  'Yılbaşı Partisi',
  'yilbasi-partisi',
  'Kar ve ışıklar teması ile yılbaşı kutlama davetiyesi.',
  'https://images.unsplash.com/photo-1482517967863-00e15c9b44be?w=800',
  'https://images.unsplash.com/photo-1482517967863-00e15c9b44be?w=400',
  '{
    "layout": "winter-wonderland",
    "backgroundColor": "#0D47A1",
    "accentColor": "#FFFFFF",
    "fontFamily": "Pacifico",
    "fontSizes": {
      "title": 50,
      "subtitle": 24,
      "body": 16
    },
    "elements": [
      {
        "type": "snowflakes",
        "style": "falling",
        "animated": false
      },
      {
        "type": "christmas-lights",
        "style": "twinkling"
      }
    ],
    "spacing": {
      "padding": 35,
      "lineHeight": 1.7
    }
  }',
  ARRAY['yılbaşı', 'new-year', 'christmas', 'kış', 'kutlama'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  false,
  true
),

(
  (SELECT id FROM public.template_categories WHERE slug = 'kutlamalar' LIMIT 1),
  'Bayram Kutlaması',
  'bayram-kutlamasi',
  'İslami motifler ile bayram davetiyesi.',
  'https://images.unsplash.com/photo-1579541814924-49fef17c5be5?w=800',
  'https://images.unsplash.com/photo-1579541814924-49fef17c5be5?w=400',
  '{
    "layout": "islamic-pattern",
    "backgroundColor": "#004D40",
    "accentColor": "#FFD700",
    "textColor": "#FFFFFF",
    "fontFamily": "Amiri",
    "fontSizes": {
      "title": 46,
      "subtitle": 22,
      "body": 16
    },
    "elements": [
      {
        "type": "islamic-ornament",
        "style": "traditional-pattern"
      },
      {
        "type": "crescent-star",
        "style": "gold"
      }
    ],
    "spacing": {
      "padding": 40,
      "lineHeight": 1.9
    }
  }',
  ARRAY['bayram', 'eid', 'islamic', 'ramazan', 'kurban'],
  ARRAY['Basit düzenleme', 'PDF indirme', 'Link paylaşımı'],
  'free',
  false,
  true,
  true,
  true
);

-- ===============================================
-- SUCCESS MESSAGE
-- ===============================================
DO $$ 
BEGIN
    RAISE NOTICE '✅ Template categories and templates seeded successfully!';
    RAISE NOTICE '📊 Total categories: %', (SELECT COUNT(*) FROM public.template_categories WHERE is_active = true);
    RAISE NOTICE '📄 Total templates: %', (SELECT COUNT(*) FROM public.templates WHERE is_active = true);
    RAISE NOTICE '🆓 FREE templates: %', (SELECT COUNT(*) FROM public.templates WHERE tier = 'free' AND is_active = true);
    RAISE NOTICE '⭐ PRO templates: %', (SELECT COUNT(*) FROM public.templates WHERE tier = 'pro' AND is_active = true);
    RAISE NOTICE '👑 PREMIUM templates: %', (SELECT COUNT(*) FROM public.templates WHERE tier = 'premium' AND is_active = true);
END $$;

