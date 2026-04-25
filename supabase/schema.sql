-- ============================================================================
-- Stealth — Database Schema v1
-- Run in Supabase Studio → SQL Editor → New Query → paste this → Run
-- ============================================================================

-- USERS profile (extends auth.users)
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  stage TEXT CHECK (stage IN ('aspiring', 'new', 'growing', 'scaling')),
  subscription_tier TEXT DEFAULT 'free' CHECK (subscription_tier IN ('free', 'starter', 'pro', 'plus')),
  stripe_customer_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- SEARCHES — every property search the user runs
CREATE TABLE IF NOT EXISTS public.searches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  market TEXT NOT NULL,                  -- "Gatlinburg, TN"
  budget_min INT NOT NULL,
  budget_max INT NOT NULL,
  property_type TEXT,                    -- "cabin", "single_family", etc.
  target_coc NUMERIC,                    -- target cash-on-cash return %
  activity_level TEXT,                   -- "turnkey", "light_reno", "heavy_reno"
  status TEXT DEFAULT 'pending',         -- pending | running | complete | error
  results_count INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- PROPERTIES — properties scraped/imported from data sources, deduplicated
CREATE TABLE IF NOT EXISTS public.properties (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  external_id TEXT UNIQUE,               -- ID from RentCast/Zillow
  source TEXT NOT NULL,                  -- "rentcast", "zillow", "redfin"
  address TEXT NOT NULL,
  city TEXT,
  state TEXT,
  zip TEXT,
  latitude NUMERIC,
  longitude NUMERIC,
  asking_price INT,
  property_type TEXT,
  beds INT,
  baths NUMERIC,
  sqft INT,
  year_built INT,
  hoa_monthly INT,
  raw_data JSONB,                        -- full API response cached
  fetched_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS properties_city_idx ON public.properties (city, state);
CREATE INDEX IF NOT EXISTS properties_external_id_idx ON public.properties (external_id);

-- ANALYSES — AI scoring + projection per property per search
CREATE TABLE IF NOT EXISTS public.analyses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  search_id UUID NOT NULL REFERENCES public.searches(id) ON DELETE CASCADE,
  property_id UUID NOT NULL REFERENCES public.properties(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  rank INT,                              -- 1-N where it ranks in this search
  ai_score INT,                          -- 0-100
  confidence TEXT,                       -- 'high' | 'medium' | 'low'
  ai_reasoning TEXT,                     -- Claude-generated reasoning paragraph
  red_flags JSONB,                       -- array of flag objects with reason
  projection JSONB,                      -- 10-year cash flow data
  comp_revenue_low INT,
  comp_revenue_mid INT,
  comp_revenue_high INT,
  cash_on_cash_y1 NUMERIC,
  ten_year_roi NUMERIC,
  data_sources JSONB,                    -- array of {field, source, fetched_at}
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS analyses_search_idx ON public.analyses (search_id, rank);
CREATE INDEX IF NOT EXISTS analyses_user_idx ON public.analyses (user_id);

-- SAVED_SEARCHES — for deal alerts in v1.5
CREATE TABLE IF NOT EXISTS public.saved_searches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT,
  market TEXT NOT NULL,
  budget_min INT,
  budget_max INT,
  property_type TEXT,
  target_coc NUMERIC,
  alert_frequency TEXT DEFAULT 'weekly', -- 'daily' | 'weekly' | 'never'
  last_alerted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- SUBSCRIPTIONS — Stripe subscription state
CREATE TABLE IF NOT EXISTS public.subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
  stripe_subscription_id TEXT UNIQUE,
  stripe_price_id TEXT,
  tier TEXT NOT NULL,                    -- 'starter' | 'pro' | 'plus'
  status TEXT NOT NULL,                  -- 'trialing' | 'active' | 'past_due' | 'canceled'
  trial_ends_at TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  cancel_at_period_end BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- WAITLIST — pre-launch email capture
CREATE TABLE IF NOT EXISTS public.waitlist (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL UNIQUE,
  source TEXT,                           -- "landing", "free_pdf", "twitter"
  metadata JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- FREE_REPORTS — anonymous free-tier PDFs (cold-start funnel)
CREATE TABLE IF NOT EXISTS public.free_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL,
  address TEXT NOT NULL,
  report_data JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.searches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.analyses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_searches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
-- properties stays open-read (data is public listings) but writes are server-only
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.waitlist ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.free_reports ENABLE ROW LEVEL SECURITY;

-- PROFILES — users see + edit their own
CREATE POLICY "profiles_self_select" ON public.profiles FOR SELECT
  USING (auth.uid() = id);
CREATE POLICY "profiles_self_update" ON public.profiles FOR UPDATE
  USING (auth.uid() = id);
CREATE POLICY "profiles_self_insert" ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- SEARCHES — users see + manage their own
CREATE POLICY "searches_owner" ON public.searches FOR ALL
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- ANALYSES — users see their own
CREATE POLICY "analyses_owner" ON public.analyses FOR ALL
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- SAVED_SEARCHES — users own
CREATE POLICY "saved_searches_owner" ON public.saved_searches FOR ALL
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- SUBSCRIPTIONS — users see their own (only server writes via service_role)
CREATE POLICY "subscriptions_self_read" ON public.subscriptions FOR SELECT
  USING (auth.uid() = user_id);

-- PROPERTIES — anyone authenticated can read (data is public listings anyway)
CREATE POLICY "properties_read_auth" ON public.properties FOR SELECT
  USING (auth.role() = 'authenticated');

-- WAITLIST — anyone can insert; only service_role reads
CREATE POLICY "waitlist_public_insert" ON public.waitlist FOR INSERT
  WITH CHECK (true);

-- FREE_REPORTS — anyone can insert; only service_role reads
CREATE POLICY "free_reports_public_insert" ON public.free_reports FOR INSERT
  WITH CHECK (true);

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- updated_at auto-bumper
CREATE OR REPLACE FUNCTION public.touch_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS profiles_touch ON public.profiles;
CREATE TRIGGER profiles_touch BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();

DROP TRIGGER IF EXISTS subscriptions_touch ON public.subscriptions;
CREATE TRIGGER subscriptions_touch BEFORE UPDATE ON public.subscriptions
  FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();

-- ============================================================================
-- DONE
-- ============================================================================
