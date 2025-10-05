import { supabase } from './supabase';
import toast from 'react-hot-toast';

// Types
export interface Invitation {
  id: string;
  user_id: string;
  template_id: string;
  title: string;
  slug: string;
  event_type: string | null;
  event_date: string | null;
  event_time: string | null;
  event_location_name: string | null;
  event_location_address: string | null;
  event_location_coordinates: any;
  custom_design: any;
  content: any;
  settings: any;
  status: 'draft' | 'published' | 'archived';
  is_public: boolean;
  password_protected: boolean;
  view_count: number;
  rsvp_count: number;
  image_url: string | null;
  published_at: string | null;
  expires_at: string | null;
  created_at: string;
  updated_at: string;
  
  // Joined data
  template?: any;
  
  // Owner subscription info (for feature gates in public view)
  owner_subscription_tier?: 'free' | 'pro' | 'premium';
}

export interface InvitationGuest {
  id: string;
  invitation_id: string;
  full_name: string;
  email: string | null;
  phone: string | null;
  rsvp_status: 'pending' | 'attending' | 'not_attending' | 'maybe';
  rsvp_date: string | null;
  plus_one_count: number;
  dietary_requirements: string | null;
  special_requests: string | null;
  message: string | null;
  invite_sent_at: string | null;
  viewed_at: string | null;
  created_at: string;
  updated_at: string;
}

export interface CreateInvitationData {
  template_id: string;
  title: string;
  event_type?: string;
  event_date?: string;
  event_time?: string;
  event_location_name?: string;
  event_location_address?: string;
  content?: any;
  custom_design?: any;
}

export interface UpdateInvitationData {
  title?: string;
  event_date?: string;
  event_time?: string;
  event_location_name?: string;
  event_location_address?: string;
  content?: any;
  custom_design?: any;
  settings?: any;
  status?: 'draft' | 'published' | 'archived';
  is_public?: boolean;
}

class InvitationService {
  // =====================================================
  // Invitations CRUD
  // =====================================================
  
  async createInvitation(data: CreateInvitationData): Promise<Invitation | null> {
    try {
      // Get current user
      const { data: { user }, error: userError } = await supabase.auth.getUser();
      
      if (userError || !user) {
        console.error('❌ User not authenticated');
        toast.error('Giriş yapmalısınız');
        return null;
      }

      // Generate slug
      const { data: slugData, error: slugError } = await supabase
        .rpc('generate_invitation_slug', {
          invitation_title: data.title,
          user_uuid: user.id
        });

      if (slugError) {
        console.error('❌ Error generating slug:', slugError);
        throw slugError;
      }

      const insertData: any = {
        user_id: user.id, // ✅ Critical: needed for RLS policy
        template_id: data.template_id,
        title: data.title,
        slug: slugData,
        event_type: data.event_type || null,
        event_date: data.event_date || null,
        event_time: data.event_time || null,
        event_location_name: data.event_location_name || null,
        event_location_address: data.event_location_address || null,
        content: data.content || {},
        custom_design: data.custom_design || {},
        status: 'draft'
      };

      const { data: invitation, error } = await supabase
        .from('invitations')
        .insert(insertData)
        .select(`
          *,
          template:templates(*)
        `)
        .single();

      if (error) {
        console.error('❌ Error creating invitation:', error);
        throw error;
      }

      console.log('✅ Invitation created:', invitation.id);
      toast.success('Davetiye oluşturuldu!');
      return invitation;
    } catch (error: any) {
      console.error('Create invitation error:', error);
      toast.error('Davetiye oluşturulurken hata oluştu');
      return null;
    }
  }

  async getInvitation(invitationId: string): Promise<Invitation | null> {
    try {
      const { data, error } = await supabase
        .from('invitations')
        .select(`
          *,
          template:templates(*)
        `)
        .eq('id', invitationId)
        .single();

      if (error) {
        if (error.code === 'PGRST116') {
          return null;
        }
        console.error('❌ Error fetching invitation:', error);
        throw error;
      }

      return data;
    } catch (error: any) {
      console.error('Get invitation error:', error);
      return null;
    }
  }

  async getInvitationBySlug(slug: string): Promise<Invitation | null> {
    try {
      const { data, error } = await supabase
        .from('invitations')
        .select(`
          *,
          template:templates(*)
        `)
        .eq('slug', slug)
        .single();

      if (error) {
        if (error.code === 'PGRST116') {
          return null;
        }
        console.error('❌ Error fetching invitation by slug:', error);
        throw error;
      }

      return data;
    } catch (error: any) {
      console.error('Get invitation by slug error:', error);
      return null;
    }
  }

  async getInvitationById(id: string): Promise<Invitation | null> {
    try {
      const { data, error } = await supabase
        .from('invitations')
        .select(`
          *,
          template:templates(*)
        `)
        .eq('id', id)
        .single();

      if (error) {
        if (error.code === 'PGRST116') {
          return null;
        }
        console.error('❌ Error fetching invitation by id:', error);
        throw error;
      }

      return data;
    } catch (error: any) {
      console.error('Get invitation by id error:', error);
      return null;
    }
  }

  async getUserInvitations(): Promise<Invitation[]> {
    try {
      const { data, error } = await supabase
        .from('invitations')
        .select(`
          *,
          template:templates(*)
        `)
        .order('updated_at', { ascending: false });

      if (error) {
        console.error('❌ Error fetching user invitations:', error);
        throw error;
      }

      return data || [];
    } catch (error: any) {
      console.error('Get user invitations error:', error);
      toast.error('Davetiyeler yüklenirken hata oluştu');
      return [];
    }
  }

  async updateInvitation(invitationId: string, updates: UpdateInvitationData): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('invitations')
        .update(updates)
        .eq('id', invitationId);

      if (error) {
        console.error('❌ Error updating invitation:', error);
        throw error;
      }

      console.log('✅ Invitation updated');
      toast.success('Davetiye güncellendi');
      return true;
    } catch (error: any) {
      console.error('Update invitation error:', error);
      toast.error('Davetiye güncellenirken hata oluştu');
      return false;
    }
  }

  async deleteInvitation(invitationId: string): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('invitations')
        .delete()
        .eq('id', invitationId);

      if (error) {
        console.error('❌ Error deleting invitation:', error);
        throw error;
      }

      console.log('✅ Invitation deleted');
      toast.success('Davetiye silindi');
      return true;
    } catch (error: any) {
      console.error('Delete invitation error:', error);
      toast.error('Davetiye silinirken hata oluştu');
      return false;
    }
  }

  async publishInvitation(invitationId: string, isPublic: boolean = true): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('invitations')
        .update({
          status: 'published',
          is_public: isPublic,
          published_at: new Date().toISOString()
        })
        .eq('id', invitationId);

      if (error) {
        console.error('❌ Error publishing invitation:', error);
        throw error;
      }

      console.log('✅ Invitation published');
      toast.success('Davetiye yayınlandı!');
      return true;
    } catch (error: any) {
      console.error('Publish invitation error:', error);
      toast.error('Davetiye yayınlanırken hata oluştu');
      return false;
    }
  }

  // =====================================================
  // Guests & RSVP
  // =====================================================
  
  async getInvitationGuests(invitationId: string): Promise<InvitationGuest[]> {
    try {
      const { data, error } = await supabase
        .from('invitation_guests')
        .select('*')
        .eq('invitation_id', invitationId)
        .order('created_at', { ascending: false });

      if (error) {
        console.error('❌ Error fetching guests:', error);
        throw error;
      }

      return data || [];
    } catch (error: any) {
      console.error('Get invitation guests error:', error);
      return [];
    }
  }

  async addGuest(invitationId: string, guestData: Partial<InvitationGuest>): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('invitation_guests')
        .insert({
          invitation_id: invitationId,
          ...guestData
        });

      if (error) {
        console.error('❌ Error adding guest:', error);
        throw error;
      }

      toast.success('Davetli eklendi');
      return true;
    } catch (error: any) {
      console.error('Add guest error:', error);
      toast.error('Davetli eklenirken hata oluştu');
      return false;
    }
  }

  async updateGuestRSVP(
    guestId: string, 
    rsvpStatus: 'attending' | 'not_attending' | 'maybe',
    additionalData?: Partial<InvitationGuest>
  ): Promise<boolean> {
    try {
      const { error } = await supabase
        .from('invitation_guests')
        .update({
          rsvp_status: rsvpStatus,
          rsvp_date: new Date().toISOString(),
          ...additionalData
        })
        .eq('id', guestId);

      if (error) {
        console.error('❌ Error updating RSVP:', error);
        throw error;
      }

      toast.success('RSVP güncellendi');
      return true;
    } catch (error: any) {
      console.error('Update RSVP error:', error);
      toast.error('RSVP güncellenirken hata oluştu');
      return false;
    }
  }

  // Increment view count for public invitation
  async incrementViewCount(invitationId: string): Promise<boolean> {
    try {
      const { error } = await supabase.rpc('increment_invitation_views', {
        invitation_id: invitationId
      });

      if (error) {
        console.error('❌ Error incrementing view count:', error);
        // Don't throw - just log, this is not critical
        return false;
      }

      return true;
    } catch (error: any) {
      console.error('Increment view count error:', error);
      return false;
    }
  }
}

export const invitationService = new InvitationService();
