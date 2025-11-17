-- =====================================================
-- USER TEMPLATES TABLE
-- =====================================================
-- Kullanıcıların kaydettiği/favori şablonları takip eder
-- =====================================================

-- Tablo oluştur
CREATE TABLE IF NOT EXISTS user_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  template_id UUID NOT NULL REFERENCES templates(id) ON DELETE CASCADE,
  is_favorite BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Bir kullanıcı aynı şablonu birden fazla kez kaydedemez
  UNIQUE(user_id, template_id)
);

-- Index'ler
CREATE INDEX IF NOT EXISTS idx_user_templates_user_id ON user_templates(user_id);
CREATE INDEX IF NOT EXISTS idx_user_templates_template_id ON user_templates(template_id);
CREATE INDEX IF NOT EXISTS idx_user_templates_favorite ON user_templates(is_favorite);

-- RLS Politikaları
ALTER TABLE user_templates ENABLE ROW LEVEL SECURITY;

-- Kullanıcılar sadece kendi kayıtlarını görebilir
CREATE POLICY "Users can view their own saved templates"
  ON user_templates FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Kullanıcılar kendi kayıtlarını oluşturabilir
CREATE POLICY "Users can save templates"
  ON user_templates FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Kullanıcılar kendi kayıtlarını güncelleyebilir
CREATE POLICY "Users can update their saved templates"
  ON user_templates FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Kullanıcılar kendi kayıtlarını silebilir
CREATE POLICY "Users can delete their saved templates"
  ON user_templates FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Trigger: updated_at otomatik güncelleme
CREATE OR REPLACE FUNCTION update_user_templates_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_templates_updated_at
  BEFORE UPDATE ON user_templates
  FOR EACH ROW
  EXECUTE FUNCTION update_user_templates_updated_at();

-- =====================================================
-- BAŞARILI!
-- =====================================================
-- user_templates tablosu oluşturuldu
-- RLS politikaları ayarlandı
-- Trigger'lar eklendi
-- =====================================================

