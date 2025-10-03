-- ============================================
-- Guests Table for Invitation Management
-- ============================================
-- This table stores guest information and RSVP responses

CREATE TABLE IF NOT EXISTS guests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  invitation_id UUID NOT NULL REFERENCES invitations(id) ON DELETE CASCADE,
  
  -- Guest Information
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(255),
  phone VARCHAR(20),
  
  -- RSVP Information
  rsvp_status VARCHAR(20) NOT NULL DEFAULT 'pending',
  -- Options: 'pending', 'attending', 'declined'
  
  companion_count INTEGER DEFAULT 0,
  -- Number of additional guests (e.g., +1, +2)
  
  dietary_restrictions TEXT,
  -- Any dietary requirements or allergies
  
  notes TEXT,
  -- Additional notes or special requests
  
  -- RSVP Response
  rsvp_responded_at TIMESTAMP WITH TIME ZONE,
  -- When the guest responded to RSVP
  
  -- Tracking
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Unique guest token for RSVP link
  guest_token UUID UNIQUE DEFAULT uuid_generate_v4(),
  
  -- Constraints
  CONSTRAINT valid_rsvp_status CHECK (rsvp_status IN ('pending', 'attending', 'declined')),
  CONSTRAINT valid_companion_count CHECK (companion_count >= 0 AND companion_count <= 10)
);

-- Indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_guests_invitation_id ON guests(invitation_id);
CREATE INDEX IF NOT EXISTS idx_guests_rsvp_status ON guests(rsvp_status);
CREATE INDEX IF NOT EXISTS idx_guests_guest_token ON guests(guest_token);
CREATE INDEX IF NOT EXISTS idx_guests_email ON guests(email);

-- Row Level Security (RLS)
ALTER TABLE guests ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view guests for their own invitations
CREATE POLICY "Users can view their invitation guests"
ON guests FOR SELECT
TO authenticated
USING (
  invitation_id IN (
    SELECT id FROM invitations WHERE user_id = auth.uid()
  )
);

-- Policy: Users can insert guests for their own invitations
CREATE POLICY "Users can add guests to their invitations"
ON guests FOR INSERT
TO authenticated
WITH CHECK (
  invitation_id IN (
    SELECT id FROM invitations WHERE user_id = auth.uid()
  )
);

-- Policy: Users can update guests for their own invitations
CREATE POLICY "Users can update their invitation guests"
ON guests FOR UPDATE
TO authenticated
USING (
  invitation_id IN (
    SELECT id FROM invitations WHERE user_id = auth.uid()
  )
);

-- Policy: Users can delete guests from their own invitations
CREATE POLICY "Users can delete their invitation guests"
ON guests FOR DELETE
TO authenticated
USING (
  invitation_id IN (
    SELECT id FROM invitations WHERE user_id = auth.uid()
  )
);

-- Policy: Public can view and update guests by token (for RSVP)
CREATE POLICY "Public can RSVP with guest token"
ON guests FOR SELECT
TO public
USING (guest_token IS NOT NULL);

CREATE POLICY "Public can update RSVP with guest token"
ON guests FOR UPDATE
TO public
USING (guest_token IS NOT NULL)
WITH CHECK (guest_token IS NOT NULL);

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_guests_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER guests_updated_at
BEFORE UPDATE ON guests
FOR EACH ROW
EXECUTE FUNCTION update_guests_updated_at();

-- ============================================
-- Helper Function: Get Guest Statistics
-- ============================================
CREATE OR REPLACE FUNCTION get_invitation_guest_stats(invitation_uuid UUID)
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_build_object(
    'total', COUNT(*),
    'pending', COUNT(*) FILTER (WHERE rsvp_status = 'pending'),
    'attending', COUNT(*) FILTER (WHERE rsvp_status = 'attending'),
    'declined', COUNT(*) FILTER (WHERE rsvp_status = 'declined'),
    'total_companions', COALESCE(SUM(companion_count), 0),
    'total_attending', COUNT(*) FILTER (WHERE rsvp_status = 'attending') + COALESCE(SUM(companion_count) FILTER (WHERE rsvp_status = 'attending'), 0)
  ) INTO result
  FROM guests
  WHERE invitation_id = invitation_uuid;
  
  RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Example usage:
-- SELECT get_invitation_guest_stats('your-invitation-id-here');

-- ============================================
-- Sample Data (optional - for testing)
-- ============================================
-- Uncomment to add sample data
/*
INSERT INTO guests (invitation_id, full_name, email, phone, rsvp_status, companion_count)
VALUES 
  ('your-invitation-id', 'Ahmet Yılmaz', 'ahmet@example.com', '+90 555 123 4567', 'attending', 1),
  ('your-invitation-id', 'Ayşe Demir', 'ayse@example.com', '+90 555 987 6543', 'pending', 0),
  ('your-invitation-id', 'Mehmet Kaya', 'mehmet@example.com', '+90 555 456 7890', 'declined', 0);
*/

COMMENT ON TABLE guests IS 'Guest list and RSVP responses for invitations';
COMMENT ON COLUMN guests.rsvp_status IS 'RSVP status: pending, attending, declined';
COMMENT ON COLUMN guests.companion_count IS 'Number of additional guests (+1, +2, etc.)';
COMMENT ON COLUMN guests.guest_token IS 'Unique token for RSVP link';

