# PRD — AI Property Finder for Airbnb Investors

**Status:** Scoped v0.5 · 2026-04-24
**Working name:** TBD (shortlist: Roost · Longview · Compound · Forge · Harbor)
**Platform:** Web SaaS (iOS app planned for v3+)
**Target ship:** 5 weeks to first paying customer

---

## 1. One-liner
Tell us what you want. AI ranks every listing in your market and gives you the 5 best Airbnb properties to buy — with a 10-year profit projection for each.

## 2. The bottleneck (the ONE thing we're solving)

**Finding the right Airbnb property to acquire.**

Aspiring and growing Airbnb investors burn 2–6 months manually:
- Scrolling Zillow/Redfin at night
- Plugging addresses into calculators one at a time
- Making spreadsheets of 40 properties
- Modeling cash-on-cash return in generic tools
- Still making bad guesses

**What's broken about the current toolchain:**
- Data dashboards show analytics but don't find properties for you
- Generic calculators assume you already picked the address
- Nothing combines discovery + ranking + full projection in one flow
- All tools predate AI — no reasoning, just numbers

**Our wedge:** compress "I want to start investing" → "here are the 5 properties to buy" into one AI-powered workflow.

## 3. Target user

| Attribute | Detail |
|---|---|
| **Primary persona** | "First-time buyer" — has $50k–$200k saved, wants their first Airbnb, actively researching 3–6 months |
| **Secondary persona** | "Growing investor" — owns 1–3 Airbnbs, hunting for property #2/#3/#4 |
| **Age** | 30–55 |
| **Household income** | $120k+ |
| **Current behavior** | Researches on BiggerPockets, watches STR YouTube, has spreadsheets of 20+ properties |
| **Geography** | US launch (vacation markets: FL, TN, NC, SC, AZ, CO, TX) |
| **Pain** | Decision paralysis — too much data, not enough direction |

## 4. Core value prop

**"Data dashboards make you work harder. AI that reasons makes you work smarter."**

Three honest promises:
1. **Time saved** — replaces 20+ hours/month of manual research
2. **Better decisions** — AI synthesizes variables no spreadsheet can (seasonality, regulation, neighborhood trend, operational friction, long-term profitability)
3. **Clear action** — every report ends with "buy this one first, here's why"

## 5. Iteration 1 scope — EXACTLY what ships

**Property Finder + real data visualization. Ship the decision engine with receipts.**

| Component | What it does | What it doesn't do |
|---|---|---|
| **4-stage onboarding prompt** | First screen: "Where are you in your journey?" — Aspiring / New host / Growing / Scaling. Branches UX. | No full portfolio import (v2) |
| **Search form** | User inputs: market, budget, property type, target cash-on-cash return | No map drawing, no saved searches (v2) |
| **Property scanner** | AI scans Zillow + Redfin + Realtor.com listings matching criteria | No MLS direct access (v2), no off-market (v3) |
| **5-factor AI ranking** | Scores each on: (1) Budget fit, (2) Comps — price vs recent sales, (3) Area — demand + regulation, (4) Utilities/operating costs, (5) Long-term profitability. Top 5 default, expandable to full list. | No personalized ML (v2), no deal alerts (v2) |
| **Property result card** | Photos, asking price, 10-year profit projection table, cumulative ROI, "why this ranks #1" AI reasoning, red flags | No due diligence workflow (v3) |
| **Real-time market data** | Live occupancy %, ADR, revenue trends — refreshed daily | No historical deep-dive (v2) |
| **Comparable listings graphs** | Scatter + bar charts of 5–10 similar Airbnbs nearby — estimated revenue, occupancy, nightly rates | No competitor drill-down (v2) |
| **Price vs comp graph** | Visual overlay: asking price vs recent sales — "overpriced or a steal?" | — |
| **10-year ROI projection** | Year-by-year net income + cumulative return, factoring seasonality, maintenance, appreciation, refi at year 5 | No Monte Carlo (v2) |
| **Export + share** | PDF report per property, shareable link for realtors/partners | No collaboration tools (v2) |
| **Billing** | Stripe subscription, $39 Starter / $99 Pro, 14-day trial | No credit system |

## 6. Foundation — architecture that scales

v1 ships ONE feature, but the architecture carries future features without rewrites.

| Foundation layer | v1 usage | v2+ enables |
|---|---|---|
| **Auth + user system** (Supabase) | Users log in, search history saved | Team accounts, realtor seats |
| **Generic "market" data model** | US listings in v1 | Add international, LTR markets |
| **Generic "data provider" layer** | Zillow/Redfin/Realtor in v1 | Add AirDNA, Rabbu, MLS partnerships |
| **AI service abstraction** | Ranking uses Claude | Deal alerts, portfolio analysis, predictive analytics |
| **Scoring rubric engine** | Per-property scoring | User-customized weights, portfolio scoring |
| **Event bus** (Supabase Realtime) | Publishes events | Deal alerts, saved search notifications |
| **Design system** (shadcn + Geist) | Cards inherit tokens | Every new feature ships polished |
| **Stripe infrastructure** | $39 / $99 tiers in v1 | Premium, team plans, annual — no rework |

**Principle:** every foundational piece is generic; only the "find + rank 5" feature on top is specific.

## 7. Tech stack

| Layer | Pick | Notes |
|---|---|---|
| **Frontend + marketing site** | Next.js 15 + TypeScript + Tailwind + shadcn/ui | One app: `/` landing, `/app/*` product |
| **Backend** | Supabase (Postgres + auth + storage + edge functions) | Zero infra work |
| **AI** | Claude Sonnet 4.6 | Multi-source reasoning, property scoring |
| **Property data** | Zillow/Redfin/Realtor scraping (Playwright on Fly.io) | DIY v1; swap to MLS API at scale |
| **Market data (rent/revenue)** | Rabbu API ($99/mo) → AirDNA ($299/mo) at scale | Table stakes |
| **Regulation data** | Custom scraping of city ordinance pages | Key differentiator |
| **Payments** | Stripe | Standard |
| **Hosting** | Vercel (Next.js) + Fly.io (workers) | Two deploys, separate concerns |
| **Error tracking** | Sentry | Day 1 |
| **Analytics** | PostHog | Day 1 |
| **Typography** | Geist font | Free premium |
| **Design baseline** | Dark + light mode day 1, 4/8/16/24/32 spacing scale, one accent color | Non-negotiable |

## 8. User flow (happy path)

### First search → recommendation (~90 seconds)
1. Visit yourbrand.com → sign up (email / Google OAuth)
2. Answer 5 onboarding questions:
   - Where are you in your journey? (Aspiring / New / Growing / Scaling)
   - What market?
   - What budget?
   - Property type?
   - Target cash-on-cash return?
3. "Finding properties…" (20–60 sec AI scan)
4. Top 5 results:
   - Photos + address + key stats
   - Projected 10-year revenue
   - Cash-on-cash return
   - "Why this ranks #1" AI reasoning
   - Red flags (regulation, HOA, seasonality)
   - Export PDF
5. Done.

## 9. Monetization

**Two tiers. No credits. Subscription only.**

| Tier | Price | Includes |
|---|---|---|
| **Starter** | **$39/mo** | 10 searches/mo, top 5 per search, basic AI reasoning |
| **Pro** | **$99/mo** | Unlimited searches, full ranked list, weekly deal alerts, advanced analytics, PDF exports, priority support |

- 14-day free trial, card required
- Annual: 2 months free (17% off)
- Affiliate: 30% recurring for 12 months

## 10. Out of scope for iteration 1 (ruthlessly)

❌ iOS app (v3+)
❌ Portfolio management / tracking (v2)
❌ Deal alerts (v1.5)
❌ Predictive seasonal analytics (v2)
❌ Team/co-investor seats (v2)
❌ Off-market / pre-MLS deals (v3)
❌ Loan pre-qualification (v3)
❌ Inspection/due diligence workflow (v3)
❌ Renovation ROI calculator (v2)
❌ Long-term rental mode (stays Airbnb-only)
❌ International markets (v3)

## 11. Risks + mitigations

| Risk | Mitigation |
|---|---|
| Zillow/Redfin TOS — scraping blocked | Rotating IPs, caching, fallback partner APIs (Realtor.com), MLS at scale |
| Data provider cost eats margin | Start with Rabbu ($99/mo); AirDNA only at 100+ customers |
| AI misprojects revenue → bad recommendations | Conservative confidence intervals, 80/50/20 percentile range, clear disclaimers |
| First-time buyers don't convert (low trust) | Free PDF per search for non-paid users = top-of-funnel; 14-day paid trial captures serious buyers |

## 12. Success criteria — v1 is "done" when

1. ✅ User signs up → first 5 properties in <2 min
2. ✅ Property data accuracy ≥ 90% (verified against listings)
3. ✅ AI revenue projections within ±20% of actual market data
4. ✅ ≥ 25 paying customers
5. ✅ Trial → paid conversion ≥ 20%
6. ✅ At least 3 documented case studies ("I bought this property with [app]")
7. ✅ NPS ≥ 40

## 13. Timeline (5 weeks to paying customer)

| Week | Deliverable |
|---|---|
| **1** | Foundation: Next.js scaffold + Supabase + auth + Stripe + design system + landing + 4-stage onboarding |
| **2** | Data pipeline: Zillow/Redfin scrapers on Fly.io, Rabbu API integration, regulation data, Airbnb comp scraping |
| **3** | AI ranking engine: 5-factor scoring, Claude reasoning prompts, top-5 + expandable output |
| **4** | Data viz: real-time market panel, comp graphs, price-vs-comp overlay, 10-year ROI projection |
| **5** | Polish + private beta with 5 users → feedback → fixes → public launch |

**Week 6: first paying customers.**

## 14. Decisions to lock before week 1

- [ ] **Brand name** (Roost / Longview / Compound / Forge / Harbor / other)
- [ ] **Domain purchased** (Cloudflare, ~$10)
- [ ] **Data provider** (Rabbu, AirDNA, or DIY)
- [ ] **Markets at launch** (10 top US markets, or national)
- [ ] **Beta cohort source** (BiggerPockets, r/airbnb_hosts, YouTube outreach)
- [ ] **Legal entity** (sole prop for v1 or LLC first)

## 15. v2+ roadmap (DO NOT build in v1)

For reference only — do not let this bleed into iteration 1.

- **Deal alerts** — weekly email of new matches per saved search
- **Regulation intelligence deep-dive** — ordinance tracking + alerts
- **Portfolio tracker** — for users who've bought, track performance
- **Predictive seasonal analytics** — "rent this for $X in July, $Y in January"
- **Team seats** — realtors + investors collaborate
- **Off-market** — partner with wholesalers
- **Renovation ROI** — "spend $30k here, revenue jumps from $42k to $64k/yr"
- **Loan pre-qualification** — instant DSCR pre-quals
- **iOS app** — deal alert push, mobile property viewing
