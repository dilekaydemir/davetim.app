-- Templates System Migration for Supabase
-- Run this in Supabase SQL Editor

-- =====================================================
-- 1. Create template_categories table
-- =====================================================
CREATE TABLE IF NOT EXISTS public.template_categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  icon VARCHAR(50), -- lucide-react icon name
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 2. Create templates table
-- =====================================================
CREATE TABLE IF NOT EXISTS public.templates (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  category_id UUID NOT NULL REFERENCES public.template_categories(id) ON DELETE CASCADE,
  
  -- Basic Info
  name VARCHAR(200) NOT NULL,
  slug VARCHAR(200) UNIQUE NOT NULL,
  description TEXT,
  
  -- Visual Assets
  preview_image_url TEXT NOT NULL, -- Main preview image
  thumbnail_url TEXT, -- Smaller thumbnail
  demo_url TEXT, -- Live demo URL if available
  
  -- Template Design Data (JSON)
  design_config JSONB NOT NULL DEFAULT '{}', -- Full template configuration
  
  -- Features & Tags
  tags TEXT[] DEFAULT '{}', -- e.g., ['modern', 'minimalist', 'floral']
  features TEXT[] DEFAULT '{}', -- e.g., ['RSVP', 'Map', 'Photo Gallery']
  
  -- Pricing & Access
  tier VARCHAR(20) DEFAULT 'free' CHECK (tier IN ('free', 'pro', 'premium')),
  is_premium BOOLEAN DEFAULT false,
  
  -- Stats & Metadata
  usage_count INTEGER DEFAULT 0, -- How many times used
  is_popular BOOLEAN DEFAULT false,
  is_featured BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 3. Create user_templates table (for saved/customized templates)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.user_templates (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  template_id UUID NOT NULL REFERENCES public.templates(id) ON DELETE CASCADE,
  
  -- Customization
  custom_name VARCHAR(200),
  custom_design_config JSONB DEFAULT '{}', -- User's customizations
  
  -- Status
  is_favorite BOOLEAN DEFAULT false,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  UNIQUE(user_id, template_id)
);

-- =====================================================
-- 4. Create indexes for better performance
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_templates_category_id ON public.templates(category_id);
CREATE INDEX IF NOT EXISTS idx_templates_slug ON public.templates(slug);
CREATE INDEX IF NOT EXISTS idx_templates_tier ON public.templates(tier);
CREATE INDEX IF NOT EXISTS idx_templates_is_active ON public.templates(is_active);
CREATE INDEX IF NOT EXISTS idx_templates_is_featured ON public.templates(is_featured);
CREATE INDEX IF NOT EXISTS idx_templates_tags ON public.templates USING GIN(tags);
CREATE INDEX IF NOT EXISTS idx_user_templates_user_id ON public.user_templates(user_id);
CREATE INDEX IF NOT EXISTS idx_user_templates_template_id ON public.user_templates(template_id);

-- =====================================================
-- 5. Enable Row Level Security (RLS)
-- =====================================================
ALTER TABLE public.template_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_templates ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 6. Create RLS Policies
-- =====================================================

-- Template Categories: Public read access
CREATE POLICY "Anyone can view active template categories"
  ON public.template_categories
  FOR SELECT
  USING (is_active = true);

-- Templates: Public read access for active templates
CREATE POLICY "Anyone can view active templates"
  ON public.templates
  FOR SELECT
  USING (is_active = true);

-- User Templates: Users can only see their own saved templates
CREATE POLICY "Users can view their own saved templates"
  ON public.user_templates
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own saved templates"
  ON public.user_templates
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own saved templates"
  ON public.user_templates
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own saved templates"
  ON public.user_templates
  FOR DELETE
  USING (auth.uid() = user_id);

-- =====================================================
-- 7. Insert sample template categories
-- =====================================================
INSERT INTO public.template_categories (name, slug, description, icon, display_order) VALUES
  ('Düğün', 'dugun', 'Düğün davetiyeleri için özel tasarımlar', 'Heart', 1),
  ('Nişan', 'nisan', 'Nişan töreni için şık davetiyeler', 'Sparkles', 2),
  ('Doğum Günü', 'dogum-gunu', 'Doğum günü partileri için eğlenceli tasarımlar', 'Cake', 3),
  ('Baby Shower', 'baby-shower', 'Bebek partileri için sevimli davetiyeler', 'Baby', 4),
  ('Kına Gecesi', 'kina-gecesi', 'Kına gecesi için geleneksel ve modern tasarımlar', 'Palette', 5),
  ('Sünnet', 'sunnet', 'Sünnet törenleri için özel davetiyeler', 'Award', 6),
  ('Mezuniyet', 'mezuniyet', 'Mezuniyet kutlamaları için tasarımlar', 'GraduationCap', 7),
  ('Kurumsal', 'kurumsal', 'Kurumsal etkinlikler için profesyonel davetiyeler', 'Briefcase', 8)
ON CONFLICT (slug) DO NOTHING;

-- =====================================================
-- 8. Insert sample templates (Turkish wedding templates)
-- =====================================================
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
  is_featured,
  is_popular
) VALUES
  -- Wedding Templates
  (
    (SELECT id FROM public.template_categories WHERE slug = 'dugun'),
    'Klasik Zarif',
    'klasik-zarif',
    'Zamansız zarafet ve sadelik. Altın detaylar ve minimal tasarımla düğününüze şık bir başlangıç.',
    'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&h=1200&fit=crop',
    'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=600&fit=crop',
    '{"theme": "classic", "colors": {"primary": "#D4AF37", "secondary": "#FFFFFF", "text": "#2C2C2C"}, "fonts": {"heading": "Playfair Display", "body": "Lato"}}'::jsonb,
    ARRAY['klasik', 'zarif', 'minimal', 'altın'],
    ARRAY['RSVP', 'Konum Haritası', 'Geri Sayım', 'Fotoğraf Galerisi'],
    'free',
    true,
    true
  ),
  (
    (SELECT id FROM public.template_categories WHERE slug = 'dugun'),
    'Modern Botanik',
    'modern-botanik',
    'Yeşil yapraklar ve çiçek motifleriyle doğanın güzelliğini yansıtan modern bir tasarım.',
    'https://images.unsplash.com/photo-1606216794074-735e91aa2c92?w=800&h=1200&fit=crop',
    'https://images.unsplash.com/photo-1606216794074-735e91aa2c92?w=400&h=600&fit=crop',
    '{"theme": "botanical", "colors": {"primary": "#5B8C5A", "secondary": "#F8F9FA", "text": "#2C3E2F"}, "fonts": {"heading": "Cormorant Garamond", "body": "Montserrat"}}'::jsonb,
    ARRAY['modern', 'botanik', 'doğal', 'yeşil'],
    ARRAY['RSVP', 'Konum Haritası', 'Hikayemiz', 'Fotoğraf Galerisi'],
    'free',
    true,
    true
  ),
  (
    (SELECT id FROM public.template_categories WHERE slug = 'dugun'),
    'Romantik Gül',
    'romantik-gul',
    'Pembe güller ve romantik detaylarla hayalinizdeki masalsı düğün davetiyesi.',
    'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800&h=1200&fit=crop',
    'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400&h=600&fit=crop',
    '{"theme": "romantic", "colors": {"primary": "#E8B4B8", "secondary": "#FFFFFF", "text": "#5D4E5D"}, "fonts": {"heading": "Great Vibes", "body": "Raleway"}}'::jsonb,
    ARRAY['romantik', 'pembe', 'çiçekli', 'feminine'],
    ARRAY['RSVP', 'Müzik Çalar', 'Geri Sayım', 'Fotoğraf Galerisi', 'Hediye Listesi'],
    'pro',
    true,
    true
  ),
  (
    (SELECT id FROM public.template_categories WHERE slug = 'dugun'),
    'Lüks Mermer',
    'luks-mermer',
    'Mermer doku ve altın aksentlerle lüks ve sofistike bir görünüm.',
    'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=800&h=1200&fit=crop',
    'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=400&h=600&fit=crop',
    '{"theme": "luxury", "colors": {"primary": "#C9B037", "secondary": "#FFFFFF", "accent": "#1A1A1A"}, "fonts": {"heading": "Cinzel", "body": "Lato"}}'::jsonb,
    ARRAY['lüks', 'mermer', 'modern', 'altın'],
    ARRAY['RSVP', 'Konum Haritası', 'Geri Sayım', 'Video', 'Fotoğraf Galerisi'],
    'premium',
    true,
    false
  ),
  
  -- Birthday Templates
  (
    (SELECT id FROM public.template_categories WHERE slug = 'dogum-gunu'),
    'Neşeli Balonlar',
    'neseli-balonlar',
    'Renkli balonlar ve konfetilerle coşkulu bir doğum günü kutlaması.',
    'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&h=1200&fit=crop',
    'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&h=600&fit=crop',
    '{"theme": "party", "colors": {"primary": "#FF6B9D", "secondary": "#FFE66D", "accent": "#4ECDC4"}, "fonts": {"heading": "Fredoka One", "body": "Poppins"}}'::jsonb,
    ARRAY['eğlenceli', 'renkli', 'balon', 'çocuk'],
    ARRAY['RSVP', 'Konum Haritası', 'Geri Sayım'],
    'free',
    false,
    true
  ),
  
  -- Baby Shower Templates
  (
    (SELECT id FROM public.template_categories WHERE slug = 'baby-shower'),
    'Sevimli Ayıcık',
    'sevimli-ayicik',
    'Tatlı ayıcık temasıyla bebeğinizi karşılamak için mükemmel bir davetiye.',
    'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800&h=1200&fit=crop',
    'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400&h=600&fit=crop',
    '{"theme": "baby", "colors": {"primary": "#A8DADC", "secondary": "#F1FAEE", "accent": "#E63946"}, "fonts": {"heading": "Pacifico", "body": "Nunito"}}'::jsonb,
    ARRAY['bebek', 'sevimli', 'pastel', 'unisex'],
    ARRAY['RSVP', 'Konum Haritası', 'Hediye Listesi'],
    'free',
    false,
    true
  ),
  
  -- Engagement Templates
  (
    (SELECT id FROM public.template_categories WHERE slug = 'nisan'),
    'Şık Nişan',
    'sik-nisan',
    'Zarif ve modern bir nişan davetiyesi tasarımı.',
    'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800&h=1200&fit=crop',
    'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=400&h=600&fit=crop',
    '{"theme": "elegant", "colors": {"primary": "#6C5B7B", "secondary": "#F8B195", "text": "#355C7D"}, "fonts": {"heading": "Libre Baskerville", "body": "Source Sans Pro"}}'::jsonb,
    ARRAY['nişan', 'zarif', 'modern'],
    ARRAY['RSVP', 'Konum Haritası', 'Hikayemiz'],
    'free',
    false,
    false
  );

-- =====================================================
-- 9. Create function to update updated_at timestamp
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 10. Create triggers for updated_at
-- =====================================================
CREATE TRIGGER update_template_categories_updated_at
    BEFORE UPDATE ON public.template_categories
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_templates_updated_at
    BEFORE UPDATE ON public.templates
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_templates_updated_at
    BEFORE UPDATE ON public.user_templates
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 11. Create function to increment template usage count
-- =====================================================
CREATE OR REPLACE FUNCTION increment_template_usage(template_uuid UUID)
RETURNS void AS $$
BEGIN
    UPDATE public.templates
    SET usage_count = usage_count + 1
    WHERE id = template_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- Done! 🎉
-- =====================================================
-- Next steps:
-- 1. Run this SQL in your Supabase SQL Editor
-- 2. Verify tables were created successfully
-- 3. Check that sample data appears in the tables
