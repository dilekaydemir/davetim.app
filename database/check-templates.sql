-- Check if templates are loaded with design_config
SELECT 
  name, 
  tier, 
  design_config->'backgroundImage' as background_image,
  design_config->'imagePosition' as image_position,
  design_config->'colors' as colors
FROM templates
WHERE tier = 'free'
LIMIT 3;

-- If empty, templates are not loaded yet
-- Run database/templates-seed.sql first

