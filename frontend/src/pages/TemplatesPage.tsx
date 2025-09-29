import React, { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { Search, Loader2 } from 'lucide-react';
import { templateService, type Template, type TemplateCategory } from '../services/templateService';
import { useAuth } from '../store/authStore';
import TemplateCard from '../components/Templates/TemplateCard';
import toast from 'react-hot-toast';

const TemplatesPage: React.FC = () => {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const { isAuthenticated } = useAuth();

  // State
  const [categories, setCategories] = useState<TemplateCategory[]>([]);
  const [templates, setTemplates] = useState<Template[]>([]);
  const [savedTemplates, setSavedTemplates] = useState<Set<string>>(new Set());
  const [isLoading, setIsLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  
  const selectedCategory = searchParams.get('category') || 'all';

  // Load categories and templates
  useEffect(() => {
    loadData();
  }, [selectedCategory, searchTerm]);

  const loadData = async () => {
    setIsLoading(true);
    
    try {
      // Load categories
      const categoriesData = await templateService.getCategories();
      setCategories(categoriesData);

      // Load templates with filters
      const filters: any = {};
      
      if (selectedCategory !== 'all') {
        filters.categorySlug = selectedCategory;
      }
      
      if (searchTerm) {
        filters.search = searchTerm;
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

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Davetiye Şablonları
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Özel günleriniz için profesyonel tasarlanmış şablonlar. 
            Hemen seçin ve kişiselleştirin!
          </p>
        </div>

        {/* Search & Filter */}
        <div className="flex flex-col lg:flex-row gap-6 mb-8">
          {/* Search */}
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
            <input
              type="text"
              placeholder="Şablon ara..."
              value={searchTerm}
              onChange={(e) => handleSearch(e.target.value)}
              className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            />
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

        {/* Loading State */}
        {isLoading && (
          <div className="flex justify-center items-center py-12">
            <Loader2 className="h-8 w-8 animate-spin text-primary-500" />
          </div>
        )}

        {/* Templates Grid */}
        {!isLoading && templates.length > 0 && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {templates.map((template) => (
              <TemplateCard
                key={template.id}
                template={template}
                onSave={handleSaveTemplate}
                isSaved={savedTemplates.has(template.id)}
              />
            ))}
          </div>
        )}

        {/* No Results */}
        {!isLoading && templates.length === 0 && (
          <div className="text-center py-12">
            <div className="text-gray-500 text-lg mb-4">
              Aradığınız kriterlere uygun şablon bulunamadı
            </div>
            <button
              onClick={() => {
                setSearchTerm('');
                handleCategoryChange('all');
              }}
              className="btn-secondary"
            >
              Filtreleri Temizle
            </button>
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
    </div>
  );
};

export default TemplatesPage;
