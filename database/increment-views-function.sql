-- Create RPC function to increment invitation view count
-- This function is called when someone views a public invitation

CREATE OR REPLACE FUNCTION increment_invitation_views(invitation_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE invitations
  SET view_count = view_count + 1
  WHERE id = invitation_id;
END;
$$;

-- Grant execute permission to authenticated and anonymous users
GRANT EXECUTE ON FUNCTION increment_invitation_views(uuid) TO authenticated, anon;
