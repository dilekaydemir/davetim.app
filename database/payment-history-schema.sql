-- ============================================
-- Payment History Table
-- ============================================

-- Create payment_history table
CREATE TABLE IF NOT EXISTS payment_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Transaction details
  transaction_id VARCHAR(255) NOT NULL UNIQUE,
  provider_transaction_id VARCHAR(255),
  provider VARCHAR(50) DEFAULT 'iyzico',
  
  -- Payment details
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'TRY',
  status VARCHAR(20) NOT NULL,
  
  -- Subscription details
  plan_tier VARCHAR(20) NOT NULL CHECK (plan_tier IN ('pro', 'premium')),
  billing_period VARCHAR(10) NOT NULL CHECK (billing_period IN ('monthly', 'yearly')),
  
  -- Additional info
  description TEXT,
  error_message TEXT,
  
  -- Timestamps
  processed_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_payment_history_user_id ON payment_history(user_id);
CREATE INDEX IF NOT EXISTS idx_payment_history_transaction_id ON payment_history(transaction_id);
CREATE INDEX IF NOT EXISTS idx_payment_history_status ON payment_history(status);
CREATE INDEX IF NOT EXISTS idx_payment_history_created_at ON payment_history(created_at DESC);

-- RLS Policies
ALTER TABLE payment_history ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view own payment history" ON payment_history;
CREATE POLICY "Users can view own payment history"
  ON payment_history FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own payment history" ON payment_history;
CREATE POLICY "Users can insert own payment history"
  ON payment_history FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Function to increment invitation counters
CREATE OR REPLACE FUNCTION increment_invitation_count(p_user_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE subscriptions
  SET 
    invitations_created_this_month = invitations_created_this_month + 1,
    invitations_created_lifetime = invitations_created_lifetime + 1
  WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Comment
COMMENT ON TABLE payment_history IS 'Payment transaction history for subscription purchases';

