import React, { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { Search, Loader2, X } from 'lucide-react';
import { templateService, type Template, type TemplateCategory } from '../services/templateService';
import { useAuth } from '../store/authStore';
import { useSubscription } from '../hooks/useSubscription';
import TemplateCard from '../components/Templates/TemplateCard';
import UpgradeModal from '../components/Subscription/UpgradeModal';
import { TemplatesPageSkeleton } from '../components/Skeleton/Skeleton';
import toast from 'react-hot-toast';

const TemplatesPage: React.FC = () => {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const { isAuthenticated } = useAuth();
  const subscription = useSubscription();

  // State
  const [categories, setCategories] = useState<TemplateCategory[]>([]);
  const [templates, setTemplates] = useState<Template[]>([]);
  const [savedTemplates, setSavedTemplates] = useState<Set<string>>(new Set());
  const [isLoading, setIsLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [debouncedSearchTerm, setDebouncedSearchTerm] = useState('');
  const [showUpgradeModal, setShowUpgradeModal] = useState(false);
  const [upgradeTemplateTier, setUpgradeTemplateTier] = useState<'pro' | 'premium'>('pro');
  
  const selectedCategory = searchParams.get('category') || 'all';

  // Debounce search term
  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedSearchTerm(searchTerm);
    }, 800); // Wait 800ms after user stops typing

    return () => clearTimeout(timer);
  }, [searchTerm]);

  // Load categories and templates
  useEffect(() => {
    loadData();
  }, [selectedCategory, debouncedSearchTerm]);

  const loadData = async (overrideSearch?: string, overrideCategory?: string) => {
    setIsLoading(true);
    
    try {
      // Load categories
      const categoriesData = await templateService.getCategories();
      setCategories(categoriesData);

      // Load templates with filters
      const filters: any = {};
      
      const categoryToUse = overrideCategory !== undefined ? overrideCategory : selectedCategory;
      const searchToUse = overrideSearch !== undefined ? overrideSearch : debouncedSearchTerm;
      
      if (categoryToUse !== 'all') {
        filters.categorySlug = categoryToUse;
      }
      
      if (searchToUse) {
        filters.search = searchToUse;
      }

      const templatesData = await templateService.getTemplates(filters);
      setTemplates(templatesData);

      // Load saved templates if authenticated
      if (isAuthenticated) {
        const userTemplates = await templateService.getUserTemplates();
        const savedIds = new Set(userTemplates.map(ut => ut.template_id));
        setSavedTemplates(savedIds);
      }
    } catch (error) {
      console.error('Error loading templates:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleCategoryChange = (categorySlug: string) => {
    if (categorySlug === 'all') {
      searchParams.delete('category');
    } else {
      searchParams.set('category', categorySlug);
    }
    setSearchParams(searchParams);
  };

  const handleSaveTemplate = async (templateId: string) => {
    if (!isAuthenticated) {
      toast.error('Şablon kaydetmek için giriş yapmalısınız');
      navigate('/auth');
      return;
    }

    const isSaved = savedTemplates.has(templateId);
    
    if (isSaved) {
      const success = await templateService.unsaveTemplate(templateId);
      if (success) {
        setSavedTemplates(prev => {
          const next = new Set(prev);
          next.delete(templateId);
          return next;
        });
      }
    } else {
      const success = await templateService.saveTemplate(templateId);
      if (success) {
        setSavedTemplates(prev => new Set(prev).add(templateId));
      }
    }
  };

  const handleSearch = (value: string) => {
    setSearchTerm(value);
  };
  
  const handleClearSearch = () => {
    setSearchTerm('');
    setDebouncedSearchTerm('');
    // Immediately reload with empty search
    loadData('', selectedCategory);
  };
  
  const handleClearAllFilters = () => {
    setSearchTerm('');
    setDebouncedSearchTerm('');
    handleCategoryChange('all');
    // Immediately reload with empty search and all categories
    loadData('', 'all');
  };
  
  const handleUpgradeNeeded = (templateTier: 'pro' | 'premium') => {
    setUpgradeTemplateTier(templateTier);
    setShowUpgradeModal(true);
  };

  // Calculate search state
  const isSearching = searchTerm !== debouncedSearchTerm;
  const hasActiveSearch = debouncedSearchTerm.trim().length > 0;
  const hasActiveFilters = selectedCategory !== 'all' || hasActiveSearch;

  // Show skeleton while loading
  if (isLoading) {
    return <TemplatesPageSkeleton />;
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center mb-12 animate-fade-in">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Davetiye Şablonları
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Özel günleriniz için profesyonel tasarlanmış şablonlar. 
            Hemen seçin ve kişiselleştirin!
          </p>
        </div>

        {/* Search & Filter */}
        <div className="flex flex-col lg:flex-row gap-6 mb-8 animate-fade-in">
          {/* Search */}
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
            <input
              type="text"
              placeholder="Düğün, doğum günü, nişan gibi anahtar kelimeler girin..."
              value={searchTerm}
              onChange={(e) => handleSearch(e.target.value)}
              className={`w-full pl-10 pr-20 py-3 border rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent transition-all ${
                isSearching ? 'border-primary-300 bg-primary-50/30' : 'border-gray-300 bg-white'
              }`}
            />
            
            {/* Right side icons */}
            <div className="absolute right-3 top-1/2 transform -translate-y-1/2 flex items-center gap-2">
              {isSearching && (
                <Loader2 className="text-primary-500 h-5 w-5 animate-spin" />
              )}
              {searchTerm && !isSearching && (
                <button
                  onClick={handleClearSearch}
                  className="text-gray-400 hover:text-gray-600 transition-colors p-1 hover:bg-gray-100 rounded"
                  title="Aramayı temizle"
                >
                  <X className="h-5 w-5" />
                </button>
              )}
            </div>
          </div>

          {/* Category Filter */}
          <div className="flex flex-wrap gap-2">
            <button
              onClick={() => handleCategoryChange('all')}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                selectedCategory === 'all'
                  ? 'bg-primary-500 text-white'
                  : 'bg-white text-gray-700 hover:bg-primary-50 border border-gray-300'
              }`}
            >
              Tümü
            </button>
            {categories.map((category) => (
              <button
                key={category.id}
                onClick={() => handleCategoryChange(category.slug)}
                className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                  selectedCategory === category.slug
                    ? 'bg-primary-500 text-white'
                    : 'bg-white text-gray-700 hover:bg-primary-50 border border-gray-300'
                }`}
              >
                {category.name}
              </button>
            ))}
          </div>
        </div>

        {/* Results Count */}
        {!isSearching && templates.length > 0 && (
          <div className="mb-6 flex items-center justify-between animate-fade-in">
            <p className="text-sm text-gray-600">
              <span className="font-semibold text-gray-900">{templates.length}</span> şablon bulundu
              {hasActiveSearch && (
                <span className="ml-2">
                  "<span className="font-medium text-primary-600">{debouncedSearchTerm}</span>" için
                </span>
              )}
            </p>
            {hasActiveFilters && (
              <button
                onClick={handleClearAllFilters}
                className="text-sm text-primary-600 hover:text-primary-700 font-medium flex items-center gap-1"
              >
                <X className="h-4 w-4" />
                Filtreleri Temizle
              </button>
            )}
          </div>
        )}

        {/* Templates Grid */}
        {templates.length > 0 && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 animate-fade-in">
            {templates.map((template, index) => (
              <div
                key={template.id}
                style={{ animationDelay: `${index * 50}ms` }}
                className="animate-fade-in"
              >
                <TemplateCard
                  template={template}
                  onSave={handleSaveTemplate}
                  isSaved={savedTemplates.has(template.id)}
                  onUpgradeNeeded={handleUpgradeNeeded}
                />
              </div>
            ))}
          </div>
        )}

        {/* No Results */}
        {!isSearching && templates.length === 0 && (
          <div className="bg-white rounded-lg shadow-md p-12 text-center animate-fade-in">
            <div className="max-w-md mx-auto">
              <div className="bg-gradient-to-br from-primary-50 to-primary-100 w-24 h-24 rounded-full flex items-center justify-center mx-auto mb-6">
                <Search className="h-12 w-12 text-primary-500" />
              </div>
              <h3 className="text-2xl font-bold text-gray-900 mb-3">
                {hasActiveSearch ? 'Sonuç Bulunamadı' : 'Şablon Bulunamadı'}
              </h3>
              <p className="text-gray-600 mb-2">
                {hasActiveSearch ? (
                  <>
                    "<span className="font-semibold text-gray-900">{debouncedSearchTerm}</span>" için sonuç bulunamadı.
                  </>
                ) : (
                  'Bu kategoride henüz şablon bulunmuyor.'
                )}
              </p>
              <p className="text-sm text-gray-500 mb-8">
                {hasActiveFilters ? (
                  'Farklı anahtar kelimeler veya kategoriler deneyebilir, ya da tüm şablonları görüntüleyebilirsiniz.'
                ) : (
                  'Yakında yeni şablonlar eklenecek. Şimdilik diğer kategorilere göz atabilirsiniz.'
                )}
              </p>
              <div className="flex flex-col sm:flex-row gap-3 justify-center">
                {hasActiveFilters && (
                  <button
                    onClick={handleClearAllFilters}
                    className="btn-primary"
                  >
                    Tüm Şablonları Göster
                  </button>
                )}
                {hasActiveSearch && !hasActiveFilters && (
                  <button
                    onClick={handleClearSearch}
                    className="btn-primary"
                  >
                    Aramayı Temizle
                  </button>
                )}
              </div>
            </div>
          </div>
        )}

        {/* CTA Section */}
        <div className="bg-primary-50 rounded-2xl p-8 mt-16 text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            Özel Şablon İsteğiniz Var mı?
          </h2>
          <p className="text-gray-600 mb-6">
            Premium planla özel tasarım taleplerinde bulunabilir, 
            kendi şablonlarınızı yükleyebilirsiniz.
          </p>
          <button
            onClick={() => navigate('/pricing')}
            className="btn-primary"
          >
            Premium'a Yükseltin
          </button>
        </div>
      </div>
      
      {/* Upgrade Modal */}
      <UpgradeModal
        isOpen={showUpgradeModal}
        onClose={() => setShowUpgradeModal(false)}
        feature="premium_templates"
        featureDescription={
          upgradeTemplateTier === 'premium' 
            ? "Premium şablonlara erişmek için PREMIUM plana yükseltin!"
            : "PRO şablonlara erişmek için PRO plana yükseltin!"
        }
        currentPlan={subscription.currentPlan}
        recommendedPlan={upgradeTemplateTier === 'premium' ? 'premium' : 'pro'}
      />
    </div>
  );
};

export default TemplatesPage;
