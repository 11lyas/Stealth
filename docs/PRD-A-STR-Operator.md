# PRD — AI Property Finder for Rental Investors

**Status:** Scoped v0.6 · Hardened against trust + scale concerns
**Working name:** TBD (shortlist: Roost · Longview · Compound · Forge · Harbor)
**Platform:** Web SaaS (iOS app planned for v3+)
**Target ship:** 5 weeks to first paying customer

---

## 1. One-liner

**"Know every number before you buy."**

AI analyzes any rental property — comps, 10-year cash flow, regulation risk, projected ROI — with confidence intervals, sources cited, and zero financial advice claims. Built for the short-term rental market first (Airbnb, VRBO), expanding to long-term rentals next.

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
| **Regulation data** | Custom curation of city ordinances | $0 | Outsource to research firm at scale |
| **Property characteristics** | RentCast | Included | — |

**Multi-source verification:** every key data point cross-referenced across 2+ sources. Conflicts flagged, not hidden.

**Data quality gating:** properties with insufficient data (e.g., <2 comparable sales in 6 mo) are explicitly excluded with reason — not ranked low.

## 7. Iteration 1 scope (web v1)

| Component | Details |
|---|---|
| **Free tier — 1 free PDF report** | No signup. Type address → instant 1-pager with confidence-scored analysis. Captures emails, builds trust. |
| **4-stage onboarding prompt** | Aspiring / New / Growing / Scaling. Tailors UX. |
| **Search form** | Market, budget, property type, target cash-on-cash return |
| **5-factor AI ranking** | (1) Budget fit, (2) Comp price validation, (3) Area demand+regulation, (4) Operating costs, (5) Long-term profit. Top 5 default, expandable. |
| **Property result card** | Photos, price, 10-yr projection w/ confidence bands, AI reasoning, red flags, source citations |
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
- Property finder (the hook)
- Free PDF report (top of funnel)
- Saved searches → email when new matches drop ("deal alerts")

### v1.5 (month 2-3)
- **Portfolio tracker** — user enters their bought property; we benchmark monthly performance vs. comps
- **Market pulse** — weekly email of trends in their market
- **Refi opportunity flags** — "rates dropped, you could save $X/mo on your Gatlinburg property"

### v2 (month 4-6)
- **Tax-time bundle** — Schedule E export
- **Renovation ROI** — "spend $30k on this, revenue +$8k/yr"
- **Performance dashboards** — month-over-month per property
- **Deal alerts on saved searches** — push notifications

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

## 14. Timeline (5 weeks to paying customer)

| Week | Deliverable |
|---|---|
| **1** | Foundation: Next.js + Supabase + auth + Stripe + design system + landing + onboarding + 4-stage prompt |
| **2** | Data integration: RentCast + Rabbu APIs + regulation DB + multi-source cross-verification |
| **3** | AI engine: 5-factor scoring + confidence intervals + source citations + Claude reasoning prompts |
| **4** | UI polish: result cards, expandable views, real-time market panel, comp graphs, 10-yr ROI table, PDF export |
| **5** | Free tier launch + 5-user private beta + bug fixes + Stripe billing + public launch |

**Week 6: first paying customers.**

## 15. Decisions to lock before week 1

- [ ] Brand name (Roost / Longview / Compound / Forge / Harbor / other)
- [ ] Domain purchased
- [ ] Data provider confirmed (RentCast → AirDNA path)
- [ ] Markets at launch (10 top US or national)
- [ ] Beta cohort source
- [ ] Legal entity (sole prop or LLC)

## 16. v2+ roadmap (NOT in v1)

Portfolio tracker · Market pulse alerts · Refi opportunity flags · Tax-time export · Renovation ROI · Deal alerts push notifications · Long-term rental mode · International markets · Team/realtor seats · iOS app
