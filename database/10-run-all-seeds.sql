-- =====================================================
-- MASTER SEED RUNNER
-- =====================================================
-- Tüm template seed dosyalarını çalıştırır
-- =====================================================

-- 1. Schema güncellemelerini uygula
\i database/08-templates-v2-schema.sql

-- 2. Wedding templates (20 şablon)
\i database/seeds/01-wedding-templates.sql

-- 3. Engagement templates (12 şablon)  
-- \i database/seeds/02-engagement-templates.sql

-- 4. Birthday templates (18 şablon)
-- \i database/seeds/03-birthday-templates.sql

-- 5. Baby Shower templates (10 şablon)
-- \i database/seeds/04-baby-shower-templates.sql

-- 6. Graduation templates (8 şablon)
-- \i database/seeds/05-graduation-templates.sql

-- 7. Corporate templates (8 şablon)
-- \i database/seeds/06-corporate-templates.sql

-- 8. Anniversary templates (8 şablon)
-- \i database/seeds/07-anniversary-templates.sql

-- 9. Henna Night templates (8 şablon)
-- \i database/seeds/08-henna-night-templates.sql

-- 10. Circumcision templates (6 şablon)
-- \i database/seeds/09-circumcision-templates.sql

-- 11. Celebrations templates (7 şablon)
-- \i database/seeds/10-celebrations-templates.sql

-- 12. Engagement Dinner templates (5 şablon)
-- \i database/seeds/11-engagement-dinner-templates.sql

-- 13. Bachelor/Bachelorette templates (5 şablon)
-- \i database/seeds/12-bachelor-templates.sql

-- =====================================================
-- TOPLAM: 115 PROFESYONEL ŞABLON
-- =====================================================

SELECT 
  category,
  tier,
  COUNT(*) as count
FROM templates
GROUP BY category, tier
ORDER BY category, tier;

SELECT 
  'TOPLAM ŞABLON SAYISI: ' || COUNT(*) as summary
FROM templates;

