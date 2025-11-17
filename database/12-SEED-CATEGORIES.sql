-- =====================================================
-- SEED 12 TEMPLATE CATEGORIES
-- =====================================================

-- Delete existing categories
DELETE FROM public.template_categories;

-- Insert 12 categories
INSERT INTO public.template_categories (id, name, slug, description, icon, display_order, is_active, created_at, updated_at) VALUES
(gen_random_uuid(), 'Düğün', 'wedding', 'Klasik, modern ve lüks düğün davetiyeleri. Hayatınızın en özel gününü unutulmaz kılın.', '💍', 1, true, now(), now()),
(gen_random_uuid(), 'Nişan', 'engagement', 'Romantik ve şık nişan davetiyeleri. Aşkınızı paylaşın, sevdiklerinizi bir araya getirin.', '💝', 2, true, now(), now()),
(gen_random_uuid(), 'Doğum Günü', 'birthday', 'Neşeli ve renkli doğum günü davetiyeleri. Her yaş için özel tasarımlar.', '🎂', 3, true, now(), now()),
(gen_random_uuid(), 'Bebek Şöleni', 'baby_shower', 'Sevimli bebek karşılama partileri için özel tasarımlar. Yeni aile ferdinizi kutlayın.', '👶', 4, true, now(), now()),
(gen_random_uuid(), 'Mezuniyet', 'graduation', 'Başarıyı kutlayan mezuniyet töreni davetiyeleri. Eğitim başarınızı paylaşın.', '🎓', 5, true, now(), now()),
(gen_random_uuid(), 'İş Etkinliği', 'corporate', 'Profesyonel kurumsal etkinlikler için davetiyeler. Gala, konferans, lansman.', '💼', 6, true, now(), now()),
(gen_random_uuid(), 'Yıldönümü', 'anniversary', 'Evlilik yıldönümü kutlamaları için özel tasarımlar. Aşkınızı yeniden kutlayın.', '💕', 7, true, now(), now()),
(gen_random_uuid(), 'Kına Gecesi', 'henna', 'Geleneksel ve modern kına gecesi davetiyeleri. Türk düğün geleneği.', '💃', 8, true, now(), now()),
(gen_random_uuid(), 'Sünnet', 'circumcision', 'Sünnet düğünleri için renkli ve neşeli davetiyeler. Çocuğunuzun özel günü.', '🎊', 9, true, now(), now()),
(gen_random_uuid(), 'Kutlamalar', 'celebration', 'Özel günler ve bayramlar için kutlama davetiyeleri. Her türlü özel an.', '🎉', 10, true, now(), now()),
(gen_random_uuid(), 'Nişan Yemeği', 'engagement_dinner', 'İntim nişan yemekleri için zarif davetiyeler. Yakın çevrenizle özel akşam.', '🍽️', 11, true, now(), now()),
(gen_random_uuid(), 'Bekarlığa Veda', 'bachelor_party', 'Eğlenceli bekarlığa veda partileri için davetiyeler. Son özgürlük partisi.', '🎈', 12, true, now(), now());

-- Notify schema reload
NOTIFY pgrst, 'reload schema';
SELECT pg_notify('pgrst', 'reload schema');

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ 12 categories created successfully!';
END $$;

COMMIT;

