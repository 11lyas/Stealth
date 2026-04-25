# PRD — Vesta · AI Rental Property Comping

**Status:** Scoped v0.8 · Quality threshold + freshness guarantee + regulation strategy + alerts in v1
**Working name:** Vesta (locked)
**Platform:** Web SaaS (iOS app planned for v3+)
**Target ship:** 5 weeks to first paying customer

---

## 1. One-liner

**"Know every number before you buy."**

AI comps any STR or Airbnb property — comps, 10-year cash flow, regulation risk, projected ROI — with confidence intervals, sources cited, and zero financial advice claims. Built for short-term rentals first (Airbnb, VRBO), expanding to long-term rentals next. **Single property in, full analysis out — no curated lists, no force-ranked filler.**

## 2. The bottleneck

**Aspiring and growing rental investors don't have a research assistant.**

They burn 2–6 months manually:
- Scrolling Zillow/Redfin at night
- Plugging addresses into static calculators
- Modeling cash flow in spreadsheets
- Still making decisions on $300k+ purchases with incomplete data

Existing tools (AirDNA, Mashvisor, BiggerPockets calculator) give analytics on properties YOU find — they don't find for you, don't reason, and don't show their sources.

**Our wedge:** AI synthesizes multi-source data into a clear analysis with citations, confidence intervals, and red flags. Not a stock-tipper. A research assistant.

## 3. Target user

| Attribute | Detail |
|---|---|
| **Primary persona** | First-time buyer — $50k–$200k saved, researching 3–6 months |
| **Secondary persona** | Growing investor — owns 1–3 rentals, hunting #2/#3 |
| **Age** | 30–55 |
| **HHI** | $120k+ |
| **Geography** | US launch (FL, TN, NC, SC, AZ, CO, TX) |
| **Pain** | Decision paralysis from 20 browser tabs and incomplete data |

## 4. Core value prop

**"AI-organized research with sources and confidence intervals — not a tipster."**

Three honest promises:
1. **Time saved** — replace 20+ hours/month of manual research
2. **Better decisions** — AI synthesizes signals no spreadsheet can (seasonality, regulation, long-term profitability) with stated confidence
3. **Trustworthy output** — every number cited, every projection ranged, every uncertainty surfaced

## 4.5. UX principles (non-negotiable)

These shape every decision in the product:

| Principle | What it means in practice |
|---|---|
| **Show your work, always** | Every number carries a source + confidence range. No black-box outputs. |
| **Honest beats confident** | If data is thin, AI says so. If a deal is bad, AI says walk away. No force-ranked filler. |
| **Progressive disclosure during analysis** | Long-running operations stream live progress via Supabase Realtime. Users see step-by-step status (RentCast pulled ✓, comps fetched ✓, ordinance checked ✓, projection running…). Never more than 10s of silence. Skeleton screens prefilled. |
| **Quality threshold over output count** | If no property hits defensible thresholds (≥8% CoC, no major regulation flags, comps verifiable), we say "skip this market today" + offer alternatives. Better to surface 0 properties than rank junk. |
| **Recommend human validation** | Every report ends with "verify before offer" checklist. We're a research assistant, not a tipster. |

## 5. Trust architecture (hardened against concern #1)

Every output the user sees has these properties:

| Element | Purpose |
|---|---|
| **Confidence intervals** on every projection | "$48k–$58k Y1 revenue (75% confidence)" — not single-point estimates |
| **Source citations** per data point | "Avg from 8 comps within 1.5mi · AirDNA + 14 verified Airbnb calendars" |
| **Red flags** automatically surfaced | "⚠ Zoning review pending — verify with city" |
| **Data quality scoring** per property | Reject low-confidence properties from rankings |
| **"Verify before offer" checklist** on every report | "Get inspection · confirm ordinance · request HOA docs" |
| **Disclaimers** everywhere | "Estimates based on public data. Not financial advice." |
| **User override** | "Have inside info? Adjust rehab budget here." |

## 6. Data architecture (hardened against concerns #2 + #3)

**No more scraping.** All data via legitimate APIs to avoid IP bans, CAPTCHAs, lawsuits, and inconsistent data.

| Data type | Source | Cost (v1) | Cost (scale) |
|---|---|---|---|
| **Active listings** | RentCast API | $99/mo | Upgrade to ATTOM at 200+ users |
| **Sold comps** | RentCast + Realtor.com API | Included | — |
| **STR revenue estimates** | Rabbu free tier → AirDNA | $0–$99/mo | $299/mo at 100+ users |
| **Regulation data** | Hybrid curation (see §6.5) | $5-10k upfront | $2k/quarter |
| **Property characteristics** | RentCast | Included | — |
| **News monitoring** (regulation changes) | NewsAPI/Google News | $50/mo | $200/mo |

**Multi-source verification:** every key data point cross-referenced across 2+ sources. Conflicts flagged, not hidden.

**Data quality gating:** properties with insufficient data (e.g., <2 comparable sales in 6 mo) are explicitly excluded with reason — not ranked low.

### 6.5. Regulation strategy (hybrid — never pure AI)

**Top 50 STR markets** (covers ~80% of investor demand): hand-curated by a paralegal/research firm. Each market stores: ordinance ruling, last-verified date, source PDF link, key rules. Quarterly re-verification.

**Long tail (any other US city):** AI parses the actual public ordinance PDF using **strict grounding** — Claude only references text it can directly quote from the source document, never makes up rules. If the AI can't find specific language, it says *"Regulation status unclear — verify with city"* instead of guessing.

**Active monitoring:** NewsAPI + Google News watch for terms like *"[city] STR ban"*, *"short-term rental ordinance change"*. Hits flag affected markets for re-verification within 48h.

**User-visible:** every regulation card shows `Last verified: 2026-03-15 · Source: Hamilton County Code §8.24` + PDF link. Permanent disclaimer: *"Regulations change — confirm with city before offer."*

### 6.6. Freshness Guarantee (defensible trust signal)

**The promise:** *"If a property in your analysis went under contract more than 1 hour before your search, we credit your account."*

**How we deliver:**
- **Cache TTL** — 4hr for full property data, 1hr for status
- **Visible freshness badge** per property:
  - 🟢 Fresh (verified < 1h)
  - 🟡 Warm (1-4h, re-checks on click)
  - 🟠 Stale (> 4h, "verify with realtor" warning)
  - 🔴 Off-market (with alternatives shown)
- **Async re-verify on report generation** — last-mile status check via API
- **Multi-source cross-check** detects status conflicts automatically
- **Webhook subscriptions** to RentCast → push status changes into our cache instantly

**Operational cost** at 1k users running 5 searches/mo each = ~1.3% of revenue. Cheap insurance.

### 6.7. Parallel build with seed data (no waiting on data pipeline)

**Week 1 of build:** AI ranking engine builds against a **JSON fixture of 50 realistic properties** (mixed types across our top markets — real-looking addresses, plausible prices, comp data, occupancy). Full UI flows work end-to-end on seed data.

**Week 2:** swap data layer from fixture → RentCast API. Same internal `PropertyData` interface — AI engine doesn't change.

**Fixture stays useful forever:** automated tests, demo mode (free-tier), AI prompt iteration without burning live API costs.

## 7. Iteration 1 scope (web v1)

| Component | Details |
|---|---|
| **Free tier — 1 free PDF report** | No signup. Type address → instant 1-pager with confidence-scored analysis. Captures emails, builds trust. |
| **4-stage onboarding prompt** | Aspiring / New / Growing / Scaling. Tailors UX. |
| **Search form** | Market, budget, property type, target cash-on-cash return |
| **Single-property analysis** | Address in → full report out. No curated lists. If user runs a market search, returns ALL properties that clear quality threshold (≥8% CoC, comps verifiable, no red-flag regs). 0 if none qualify. No filler. |
| **5-factor scoring** | (1) Budget fit, (2) Comp price validation, (3) Area demand+regulation, (4) Operating costs, (5) Long-term profit. Score 0-100 per property. |
| **Property result card** | Photos, price, 10-yr projection w/ confidence bands, AI reasoning, red flags, source citations |
| **Saved searches + weekly email digest** | User saves "cabins under $500k in Gatlinburg" → weekly email of new matches. Brings users back day 7 even without push alerts. |
| **Real-time market data panel** | Live occupancy, ADR, revenue trends — sourced + timestamped |
| **Comparable listings graphs** | 5–10 nearby Airbnbs — with footnotes "based on N verified calendars" |
| **Price vs comp graph** | Asking price vs recent sales overlay |
| **10-year ROI projection** | Year-by-year with confidence ranges. Cumulative return with assumptions exposed. |
| **Export + share** | PDF report (full citations + disclaimers), shareable link |
| **Billing** | Stripe — $39 Starter, $99 Pro, 14-day trial, 30-day money-back guarantee |

## 8. Pricing (hardened against concern #4)

**No more "unlimited" — replaced with transparent caps.**

| Tier | Price | Searches | Other |
|---|---|---|---|
| **Free** | $0 | 1 PDF report (1 address) | No login required, just email |
| **Starter** | $39/mo | 10 searches/mo | Top 5 per search, basic features |
| **Pro** | $99/mo | **200 searches/mo** ("fair use") | Full ranked list, alerts, advanced viz, priority |
| **Plus (v1.5)** | $249/mo | 1000 searches/mo | Team seats, API, bulk ops |

- **30-day money-back guarantee** (not just 14-day trial)
- Cache layer: same address within 7 days = no charge
- Per-minute rate limit (5 searches/min) prevents abuse
- AI cost monitoring per user; alert if 3x avg

## 9. Lifecycle features (hardened against concern #5 — retention)

**Reposition from "search tool" to "investment manager."** Users have reasons to come back AFTER they buy.

### v1 (week 6 launch)
- Single-property analysis (the wedge)
- Market search (returns all properties clearing threshold, 0 if none qualify)
- Free PDF report (top of funnel)
- **Saved searches + weekly email digest** (deal alerts moved into v1 — retention can't wait)

### v1.5 (month 2-3)
- **Portfolio tracker** — user enters their bought property; we benchmark monthly performance vs. comps
- **Market pulse** — weekly email of trends in their market
- **Refi opportunity flags** — "rates dropped, you could save $X/mo on your Gatlinburg property"
- **Push notifications** for high-priority deal alerts (browser + email)

### v2 (month 4-6)
- **Tax-time bundle** — Schedule E export
- **Renovation ROI** — "spend $30k on this, revenue +$8k/yr"
- **Performance dashboards** — month-over-month per property
- **AI optimization recommendations** for owned properties

**Result:** users keep paying $99/mo even after their purchase, because the tool helps them MANAGE the property too.

## 10. Cold start playbook (hardened against concern #6)

**First 6 months: trust > revenue. Plan for it.**

### Pre-launch (week 0)
- Lock name + buy domain
- Build landing with free PDF report tier
- Founder visible (LinkedIn, Twitter — your real name on the brand)

### Launch month 1
- Recruit 10 lighthouse beta users (free 90 days, weekly feedback calls)
- Goal: 3 documented case studies with real numbers + permission to share
- "Build in public" content cadence — Twitter/LinkedIn weekly post

### Month 2-3
- Soft launch with case studies on landing
- Money-back guarantee front-and-center
- BiggerPockets / r/airbnb_hosts genuine participation (no pitching)

### Month 3-6
- Affiliate partnerships with 2-3 STR YouTubers (30% rev share)
- First paid ad spend (only after testimonials in hand)
- Annual plans introduced (lock in $999/yr instead of $99 × 12)

**Zero paid ads until 3 testimonials.** They don't work without proof.

## 11. Tech stack

| Layer | Pick | Notes |
|---|---|---|
| **Frontend** | Next.js 15 + TypeScript + Tailwind + shadcn/ui | One app: `/` landing, `/app/*` product |
| **Backend** | **Supabase** (Postgres + auth + storage + edge functions + RLS) | All-in-one |
| **AI** | Claude Sonnet 4.6 | Reasoning + scoring + report generation |
| **Property data** | RentCast API ($99/mo) | Listings, comps, characteristics |
| **STR revenue** | Rabbu (free) → AirDNA ($299) | Cross-validate |
| **Regulation** | Custom curation | Stored in Supabase |
| **Payments** | Stripe + Stripe Tax | Subscriptions |
| **Email** | Resend | Transactional + marketing |
| **Hosting** | Vercel (Next.js) | Already deployed |
| **Error tracking** | Sentry (free tier) | Day 1 |
| **Analytics** | PostHog (free tier) | Day 1 |
| **Typography** | Geist | Free premium font |

## 12. Foundation — architecture that scales

v1 ships ONE feature; the architecture carries 10 features without rewrites.

| Foundation | v1 | v2+ |
|---|---|---|
| **Supabase Auth** | Email + Google OAuth | Team accounts, realtor seats |
| **Generic "asset" data model** | Properties only | LTR, commercial, boats, RVs |
| **Generic data provider layer** | RentCast in v1 | Add ATTOM, MLS, Redfin partnership |
| **AI service abstraction** | Property scoring | Portfolio analysis, market predictions |
| **Confidence + sourcing primitives** | Per-data-point | Powers every future feature |
| **Stripe + Webhook infra** | $39/$99 tiers | Tiers, team plans, usage-based |

## 13. Success criteria — v1 done when

1. ✅ Free tier converts 5%+ to paid trial
2. ✅ Trial → paid conversion ≥ 20%
3. ✅ Property data accuracy ≥ 90% (multi-source verified)
4. ✅ AI projections within ±20% of actual market data
5. ✅ ≥ 25 paying customers
6. ✅ 3 documented case studies
7. ✅ NPS ≥ 40
8. ✅ Monthly churn <10%

## 14. Timeline (5 weeks to paying customer · parallel tracks)

| Week | Track A — Product (AI + UI) | Track B — Data (APIs + regulation) |
|---|---|---|
| **1** | Next.js + Supabase + auth + Stripe + design system + landing + onboarding | Apply for RentCast/Rabbu API access. Generate 50-property JSON fixture. |
| **2** | AI engine v0 against fixture: 5-factor scoring + confidence intervals + reasoning prompts | RentCast integration. Multi-source cross-verification. |
| **3** | UI polish: result cards, comp graphs, 10-yr ROI, freshness badges, progressive disclosure stream | Curate top 50 markets regulation DB. NewsAPI monitoring online. |
| **4** | Saved searches + weekly email digest. PDF export. Quality threshold logic. | Swap fixture → live data. Async status re-verification. |
| **5** | 5-user private beta. Stripe billing. Bug fixes. Freshness Guarantee live. | Operational dashboard for monitoring data freshness + accuracy. |

**Week 6: first paying customers.** Tracks A + B merge in week 4 — by then UI works on real data.

## 15. Decisions to lock before week 1

- [x] **Brand name: Vesta** ✅
- [x] **Database: Supabase provisioned + schema deployed** ✅
- [x] **Hosting: Vercel deployed** ✅
- [x] **Repo: github.com/11lyas/Stealth** ✅
- [ ] Domain purchased (likely vesta.ai)
- [ ] Data provider confirmed (RentCast → AirDNA path)
- [ ] Markets at launch (10 top US or national)
- [ ] Beta cohort source (BiggerPockets / r/airbnb_hosts / influencers)
- [ ] Legal entity (sole prop or LLC)
- [ ] Marketing site approach (Framer for marketing, Next.js for product app — likely)

## 16. v2+ roadmap (NOT in v1)

Portfolio tracker · Market pulse alerts · Refi opportunity flags · Tax-time export · Renovation ROI · Deal alerts push notifications · Long-term rental mode · International markets · Team/realtor seats · iOS app
