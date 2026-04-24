# PRD — AI Property Finder for Airbnb Investors

**Status:** Scoped v0.4 · 2026-04-24
**Working name:** TBD (candidates: Nest, Rabbit, BuyBnb, Finder, PropAI)
**Platform:** Web SaaS (iOS app planned for v3+)
**Target ship:** 5 weeks to first paying customer

---

## 1. One-liner
Tell us what you want. We find the 5 best Airbnb properties to buy.

## 2. The bottleneck (the ONE thing we're solving)

**Finding the right STR property to acquire.**

Aspiring and growing Airbnb investors burn 2-6 months manually:
- Scrolling Zillow/Redfin at night
- Plugging addresses into AirDNA Rentalizer one at a time
- Making spreadsheets of 40 properties
- Trying to model cash-on-cash return in BiggerPockets' calculator
- Still making bad guesses

**Why discovery is the real bottleneck (not operations, not pricing, not tools for existing hosts):**

Current tools solve the wrong problem:
- **AirDNA** = data dashboard, doesn't find properties
- **Mashvisor** = has discovery but weak AI, noisy output
- **BiggerPockets calculator** = you already have to know which property to analyze
- **Rabbu** = closest competitor, still missing the AI-curated top-5 layer
- **PMS tools (Hospitable, Guesty, Hostaway)** = only useful AFTER you own a property

**The gap:** nobody compresses "I want to start investing" → "here are the 5 properties to buy" into a clean AI-powered workflow.

## 3. Target user

| Attribute | Detail |
|---|---|
| **Primary persona** | "First STR buyer" — has $50k–$200k saved, wants first Airbnb, actively researching 3-6 months |
| **Secondary persona** | "Growing investor" — owns 1-3 STRs, looking for property #2/#3/#4 |
| **Age** | 30-55 |
| **Financial profile** | Household income $120k+, investable savings $50k+ |
| **Current behavior** | Subscribes to AirDNA / Mashvisor ($50-299/mo), member of BiggerPockets, watches STR Ron / Robuilt / Rob Abasolo |
| **Geography** | US first (vacation markets: FL, TN, NC, SC, AZ, CO, TX) |
| **Pain** | Decision paralysis — too much data, not enough direction |

## 4. Core value prop

**"AirDNA shows you data. We tell you which property to buy."**

Three honest promises:
1. **Time saved** — replaces 20+ hours/month of manual research
2. **Better decisions** — AI synthesizes variables no spreadsheet can (seasonality, regulation, neighborhood trend, operational friction)
3. **Clear action** — every report ends with "buy this one first, here's why"

## 5. Iteration 1 scope — EXACTLY what ships

**Property Finder + real data visualization. Ship the decision engine with receipts.**

| Component | What it does | What it doesn't do |
|---|---|---|
| **4-stage onboarding prompt** | First screen asks: "Where are you in your STR journey?" — Aspiring / New / Growing / Scaling. Branches UX accordingly. | No full portfolio import (v2) |
| **Search form** | User inputs: market (city/region), budget range, property type (SFH/condo/cabin), target return | No complex filters, no map drawing, no saved searches (v2) |
| **Property scanner** | AI scans Zillow + Redfin + Realtor.com listings matching criteria | No MLS direct access (v2), no off-market (v3) |
| **5-factor AI ranking** | Scores each property on: (1) Budget fit, (2) Comps — price vs recent sales, (3) Area — STR demand + regulation, (4) Utilities/operating costs, (5) Long-term profitability. Top 5 by default, expandable to full ranked list. | No personalized ML (v2), no deal alerts (v2) |
| **Property result card** | Photos, asking price, 10-year profit projection table, cumulative ROI, "why this ranks #1" AI reasoning, red flags | No due diligence workflow (v3) |
| **Real-time market data panel** | Live occupancy %, ADR, revenue trends for the market (refreshed daily from AirDNA/Rabbu + Airbnb scraping) | No historical trend deep-dive (v2) |
| **Comparable listings graphs** | Scatter plot + bar charts of 5-10 similar Airbnb listings nearby — estimated revenue, occupancy, nightly rates | No competitor-specific drill-down (v2) |
| **Price vs comp graph** | Visual overlay: asking price vs recent comparable sales — "is this overpriced or a steal?" | — |
| **10-year ROI projection** | Year-by-year net income + cumulative return, factoring seasonality, maintenance cycles, appreciation, refi opportunity at year 5 | No Monte Carlo / scenario modeling (v2) |
| **Export + share** | PDF report per property, shareable link for realtors/partners | No collaboration tools (v2) |
| **Billing** | Stripe subscription, $39 Starter / $99 Pro, 14-day trial | No credit system, no one-time purchases |

**That's it. Everything else is v2+.**

## 6. Foundation — what's underneath (scaffolds for v2+)

Iteration 1 ships ONE feature but the architecture carries future features without rewrites.

| Foundation layer | v1 usage | v2+ enables |
|---|---|---|
| **Auth + user system** (Supabase) | Users log in, search history saved | Team accounts, realtor seats |
| **Generic "market" data model** | Pulls US listings in v1 | Add international markets, LTR markets, other investment types |
| **Generic "data provider" layer** | Zillow/Redfin/Realtor scraping in v1 | Add AirDNA, Rabbu, MLS partnerships |
| **AI service abstraction** | Ranking uses Claude reasoning | Future: deal alerts, portfolio analysis, predictive analytics |
| **Scoring rubric engine** | Per-property scoring (profitability, risk, etc) | Future: user-customized scoring weights, portfolio scoring |
| **Event bus** (Supabase Realtime) | Publishes `search_completed` events | Future: deal alerts, saved search notifications |
| **Design system** (shadcn + Geist) | Result cards inherit tokens | Every new feature ships polished by default |
| **Stripe infrastructure** | $39/$99 tiers in v1 | Add premium, team plans, annual without rework |

**Principle:** *every foundational piece is generic; only the "find + rank 5" feature on top is specific.*

## 7. Tech stack

| Layer | Pick | Notes |
|---|---|---|
| **Frontend + marketing site** | Next.js 15 + TypeScript + Tailwind + shadcn/ui | One Next.js app: `/` = landing, `/app/*` = product |
| **Backend** | Supabase (Postgres + auth + storage + edge functions) | Zero infra work |
| **AI** | Claude Sonnet 4.6 | Multi-source reasoning, property scoring |
| **Property data** | Zillow/Redfin/Realtor scraping (headless Playwright workers on Fly.io) | Legal gray; throttled, cached aggressively. Swap to MLS partnership at scale. |
| **Market data (rent/revenue)** | AirDNA or Rabbu API ($99-299/mo) | Table stakes — they're data providers, not competitors |
| **Regulation data** | Custom scraping of city STR ordinance pages | Key differentiator — no tool tracks this well |
| **Payments** | Stripe subscriptions | Standard |
| **Hosting** | Vercel (Next.js) + Fly.io (scraper workers) | Two deploys, separate concerns |
| **Error tracking** | Sentry | Day 1 |
| **Analytics** | PostHog | Day 1 |
| **Typography** | Geist font | Free premium look |
| **Design baseline** | Dark + light mode day 1, 4/8/16/24/32 spacing scale, one accent color | Non-negotiable to not look "vibe-coded" |

## 8. User flow (happy path, iteration 1)

### First search to recommendation (~90 seconds)
1. User visits [app].com → signs up (email + Google OAuth)
2. Answers 5 questions in onboarding:
   - "Where are you investing?" (market selector — 50 pre-loaded US STR markets)
   - "What's your budget?" (slider, $100k-$1.5M)
   - "What property type?" (SFH / cabin / condo / multi-unit)
   - "What target cash-on-cash return?" (slider, 4-20%)
   - "How active do you want to be?" (turnkey vs. renovation OK)
3. "Finding properties…" (20-60 sec AI scan)
4. Top 5 results delivered as cards:
   - Photo carousel
   - Price
   - Projected monthly revenue (80th / 50th / 20th percentile)
   - Est. cash-on-cash return
   - "Why this ranks #1" — short AI reasoning (2-3 sentences)
   - "Red flags" — regulation risk, HOA, seasonality concerns
   - Link to original listing + "export PDF for my realtor"
5. Done.

### Subsequent daily/weekly usage
- User saves searches → gets weekly email: "3 new properties match your criteria"
- User uploads/enters a custom address → AI runs same scoring on demand

## 9. Monetization

**Two tiers. No credits. Subscription only.**

| Tier | Price | Includes |
|---|---|---|
| **Starter** | **$39/mo** | 10 searches/month, 5 results per search, basic AI reasoning |
| **Pro** | **$99/mo** | Unlimited searches, weekly deal alerts, advanced analytics, PDF exports, priority support |

- 14-day free trial (card required) — catches serious buyers, filters tire-kickers
- Annual: 2 months free (17% off)
- Affiliate: 30% recurring for 12 months (BiggerPockets / YouTube creators)

## 10. Out of scope for iteration 1 (ruthlessly)

❌ iOS app (v3+)
❌ Portfolio management / tracking (v2)
❌ Deal alerts (v1.5)
❌ Predictive seasonal analytics (v2)
❌ Team/co-investor seats (v2)
❌ Airbnb API integration for owned properties (v2)
❌ Off-market / pre-MLS deals (v3)
❌ Loan pre-qualification / financing (v3)
❌ Inspection/due diligence workflow (v3)
❌ Renovation ROI calculator (v2)
❌ LTR mode (we're STR-only)
❌ International markets (v3)

## 11. Risks + mitigations

| Risk | Mitigation |
|---|---|
| Zillow/Redfin TOS — scraping blocked | Headless, rotating IPs, aggressive caching; fallback: partner APIs (Realtor.com has one), MLS partnership at scale |
| AirDNA charges us $299/mo for data | Use Rabbu or KeyData as cheaper alternatives; build our own baseline from Airbnb public listings |
| AI misprojects revenue → bad recommendations | Conservative confidence intervals, always show 80/50/20 percentile range, big "estimate not guarantee" disclaimer |
| AirDNA / Mashvisor copies us | They can't — their architecture is built for analytics, not discovery. Would take them 18 months. |
| First-time buyers don't convert (low trust) | Free PDF report per search for non-paid users = top-of-funnel. 14-day paid trial captures serious buyers. |

## 12. Success criteria — v1 is "done" when

1. ✅ User signs up → first 5 properties in <2 min
2. ✅ Property data accuracy ≥ 90% (verified against listings)
3. ✅ AI revenue projections within ±20% of actual AirDNA data on spot-checks
4. ✅ ≥ 25 paying customers
5. ✅ Trial → paid conversion ≥ 20%
6. ✅ At least 3 documented case studies: "I bought this property with help from [app]"
7. ✅ NPS ≥ 40

## 13. Timeline (5 weeks to paying customer)

| Week | Deliverable |
|---|---|
| **1** | **Foundation:** Next.js scaffold + Supabase schema + auth + Stripe + design system + landing page + 4-stage onboarding prompt |
| **2** | **Data pipeline:** Zillow/Redfin scrapers on Fly.io, Airbnb comp scraping, Rabbu/AirDNA API integration, regulation data scraping |
| **3** | **AI ranking engine:** 5-factor scoring (budget, comps, area, utilities, long-term profit), Claude reasoning prompts, top-5 + expandable output |
| **4** | **Data viz layer:** real-time market panel, comp listing graphs, price-vs-comp overlay, 10-year ROI projection tables |
| **5** | **Polish + beta:** 5 beta users recruited from BiggerPockets for free 30 days → feedback → fixes → public launch |

**Week 6: first paying customers.**

## 14. Decisions to lock before week 1

- [ ] **Data provider:** AirDNA ($299/mo), Rabbu, KeyData, or DIY from Airbnb scrapes?
- [ ] **Which markets at launch:** 10 top US STR markets, or national from day 1?
- [ ] **Domain name:** candidates — nest.ai, buybnb.com, finder.ai, strfinder.com
- [ ] **Beta cohort:** BiggerPockets DMs, r/airbnb_hosts, or influencer outreach?
- [ ] **Legal entity:** operate as sole prop for v1 or form LLC before launch?

## 15. What v2 looks like (DO NOT build in v1)

For reference only — do not let this bleed into iteration 1.

- **Deal alerts**: weekly email of new matches per saved search
- **Portfolio tracker**: for users who've bought, track performance
- **Predictive seasonal analytics**: "rent this car for $140/night in July, $60 in January"
- **Team seats**: realtors + investors collaborate
- **Off-market**: partner with wholesalers for pre-MLS deals
- **Renovation ROI calculator**: "spend $30k on this, revenue goes from $4k to $6k/mo"
- **Loan pre-qualification**: partner with lenders for instant DSCR pre-quals
- **iOS app**: deal alert push, on-the-go property viewing
