import { supabase } from './supabase';
import toast from 'react-hot-toast';

// Types
export interface TemplateCategory {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  icon: string | null;
  display_order: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Template {
  id: string;
  category_id: string;
  name: string;
  slug: string;
  description: string | null;
  preview_image_url: string;
  thumbnail_url: string | null;
  demo_url: string | null;
  design_config: any; // JSONB
  tags: string[];
  features: string[];
  tier: 'free' | 'pro' | 'premium';
  is_premium: boolean;
  usage_count: number;
  is_popular: boolean;
  is_featured: boolean;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  
  // Joined data
  category?: TemplateCategory;
}

export interface UserTemplate {
  id: string;
  user_id: string;
  template_id: string;
  custom_name: string | null;
  custom_design_config: any;
  is_favorite: boolean;
  created_at: string;
  updated_at: string;
  
  // Joined data
  template?: Template;
}

export interface TemplateFilters {
  categorySlug?: string;
  tags?: string[];
  tier?: 'free' | 'pro' | 'premium';
  isFeatured?: boolean;
  isPopular?: boolean;
  search?: string;
}

class TemplateService {
  // =====================================================
  // Template Categories
  // =====================================================
  
  async getCategories(): Promise<TemplateCategory[]> {
    try {
      const { data, error } = await supabase
        .from('template_categories')
        .select('*')
        .eq('is_active', true)
        .order('display_order', { ascending: true });

      if (error) {
        console.error('❌ Error fetching categories:', error);
        throw error;
      }

      return data || [];
    } catch (error: any) {
      console.error('Get categories error:', error);
      toast.error('Kategoriler yüklenirken hata oluştu');
      return [];
    }
  }

  async getCategoryBySlug(slug: string): Promise<TemplateCategory | null> {
    try {
      const { data, error } = await supabase
        .from('template_categories')
        .select('*')
        .eq('slug', slug)
        .eq('is_active', true)
        .single();

      if (error) {
        if (error.code === 'PGRST116') {
          // Not found
          return null;
        }
        console.error('❌ Error fetching category:', error);
        throw error;
      }

      return data;
    } catch (error: any) {
      console.error('Get category by slug error:', error);
      return null;
    }
  }

  // =====================================================
  // Templates
  // =====================================================
  
  async getTemplates(filters?: TemplateFilters): Promise<Template[]> {
    try {
      let query = supabase
        .from('templates')
        .select(`
          *,
          category:template_categories(*)
        `)
        .eq('is_active', true);

      // Apply filters
      if (filters?.categorySlug) {
        const category = await this.getCategoryBySlug(filters.categorySlug);
        if (category) {
          query = query.eq('category_id', category.id);
        }
      }

      if (filters?.tier) {
        query = query.eq('tier', filters.tier);
      }

      if (filters?.isFeatured !== undefined) {
        query = query.eq('is_featured', filters.isFeatured);
      }

      if (filters?.isPopular !== undefined) {
        query = query.eq('is_popular', filters.isPopular);
      }

      if (filters?.tags && filters.tags.length > 0) {
        query = query.contains('tags', filters.tags);
      }

      if (filters?.search) {
        query = query.or(`name.ilike.%${filters.search}%,description.ilike.%${filters.search}%`);
      }

      // Order by featured first, then popular, then by usage
      query = query.order('is_featured', { ascending: false })
                   .order('is_popular', { ascending: false })
                   .order('usage_count', { ascending: false });

      const { data, error } = await query;

      if (error) {
        console.error('❌ Error fetching templates:', error);
        throw error;
      }

      return data || [];
    } catch (error: any) {
      console.error('Get templates error:', error);
      toast.error('Şablonlar yüklenirken hata oluştu');
      return [];
    }
  }

  async getTemplateBySlug(slug: string): Promise<Template | null> {
    try {
      const { data, error } = await supabase
        .from('templates')
        .select(`
          *,
          category:template_categories(*)
        `)
        .eq('slug', slug)
        .eq('is_active', true)
        .single();

      if (error) {
        if (error.code === 'PGRST116') {
          // Not found
          return null;
        }
        console.error('❌ Error fetching template:', error);
        throw error;
      }

      return data;
    } catch (error: any) {
      console.error('Get template by slug error:', error);
      return null;
    }
  }

  async getFeaturedTemplates(limit: number = 6): Promise<Template[]> {
    try {
      const { data, error } = await supabase
        .from('templates')
        .select(`
          *,
          category:template_categories(*)
        `)
        .eq('is_active', true)
        .eq('is_featured', true)
        .order('usage_count', { ascending: false })
        .limit(limit);

      if (error) {
        console.error('❌ Error fetching featured templates:', error);
        throw error;
      }

      return data || [];
    } catch (error: any) {
      console.error('Get featured templates error:', error);
      return [];
    }
  }

  async getPopularTemplates(limit: number = 6): Promise<Template[]> {
    try {
      const { data, error } = await supabase
        .from('templates')
        .select(`
          *,
          category:template_categories(*)
        `)
        .eq('is_active', true)
        .eq('is_popular', true)
        .order('usage_count', { ascending: false })
        .limit(limit);

      if (error) {
        console.error('❌ Error fetching popular templates:', error);
        throw error;
      }

      return data || [];
    } catch (error: any) {
      console.error('Get popular templates error:', error);
      return [];
    }
  }

  async incrementTemplateUsage(templateId: string): Promise<void> {
    try {
      const { error } = await supabase.rpc('increment_template_usage', {
        template_uuid: templateId
      });

      if (error) {
        console.error('❌ Error incrementing template usage:', error);
        throw error;
      }

      console.log('✅ Template usage incremented');
    } catch (error: any) {
      console.error('Increment template usage error:', error);
      // Don't show toast for this - it's not critical
    }
  }

  // =====================================================
  // User Templates (Saved/Favorited)
  // =====================================================
  
  async getUserTemplates(): Promise<UserTemplate[]> {
    try {
      const { data, error } = await supabase
        .from('user_templates')
        .select(`
          *,
          template:templates(
            *,
            category:template_categories(*)
          )
        `)
        .order('created_at', { ascending: false });

      if (error) {
        console.error('❌ Error fetching user templates:', error);
        throw error;
      }

      return data || [];
    } catch (error: any) {
      console.error('Get user templates error:', error);
      toast.error('Kaydedilen şablonlar yüklenirken hata oluştu');
      return [];
    }
  }

  async saveTemplate(templateId: string): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('user_templates')
        .insert({
          template_id: templateId,
          is_favorite: true
        });

      if (error) {
        if (error.code === '23505') {
          // Already saved
          toast('Bu şablon zaten kaydedilmiş');
          return false;
        }
        console.error('❌ Error saving template:', error);
        throw error;
      }

      toast.success('Şablon kaydedildi');
      return true;
    } catch (error: any) {
      console.error('Save template error:', error);
      toast.error('Şablon kaydedilirken hata oluştu');
      return false;
    }
  }

  async unsaveTemplate(templateId: string): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('user_templates')
        .delete()
        .eq('template_id', templateId);

      if (error) {
        console.error('❌ Error unsaving template:', error);
        throw error;
      }

      toast.success('Şablon kaldırıldı');
      return true;
    } catch (error: any) {
      console.error('Unsave template error:', error);
      toast.error('Şablon kaldırılırken hata oluştu');
      return false;
    }
  }

  async toggleFavorite(templateId: string, isFavorite: boolean): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('user_templates')
        .update({ is_favorite: isFavorite })
        .eq('template_id', templateId);

      if (error) {
        console.error('❌ Error toggling favorite:', error);
        throw error;
      }

      return true;
    } catch (error: any) {
      console.error('Toggle favorite error:', error);
      return false;
    }
  }
}

export const templateService = new TemplateService();
