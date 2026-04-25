# PRD — Vesta · LTR → STR Conversion Platform

**Status:** Scoped v1.0 · MAJOR PIVOT — positioned for existing landlords converting to STR, not first-time buyers
**Working name:** Vesta (locked)
**Platform:** Web SaaS (iOS app planned for v3+)
**Target ship:** 5 weeks to first paying customer

---

## 1. One-liner

**"Should you convert your rental to an Airbnb? Vesta tells you with real data — and helps you run it after."**

Vesta is the platform for long-term rental landlords who are sitting on a property and want to know if converting to a short-term rental (Airbnb, VRBO) would make them more money. We provide the conversion decision (backed by real comp data + 10-year projections + regulation risk) AND the operational systems to set up and track the property once they pull the trigger.

**Single property in. Decision out. Setup + tracking included.**

## 2. The bottleneck

**Long-term rental landlords have no good way to evaluate the STR conversion question.**

50M+ LTR landlords in the US. Many own properties in markets where STR could 2-3x their gross income. But the conversion question is paralyzing:

- Will my specific property actually earn what AirDNA says it will?
- What are setup costs (furnishing, photos, listing optimization, compliance)?
- What's the regulation risk in my city — could it get banned?
- How do I actually run the operation day-to-day after I switch?
- How do I price it, manage guests, handle turnovers, track performance?

Existing tools answer **none** of this end-to-end. AirDNA + Mashvisor give raw data but not the conversion decision. Hospitable + Hostaway help operate STRs but only AFTER the conversion. Nobody bridges the gap between "I own a long-term rental" and "I'm running a profitable Airbnb."

**Our wedge:** the only tool built specifically for the LTR → STR conversion journey. Decision + setup + tracking, all backed by real comp data, in one place.

## 3. Target user

| Attribute | Detail |
|---|---|
| **Primary persona** | LTR landlord with 1–5 doors, sitting on at least one property in a viable STR market, considering conversion |
| **Secondary persona** | New LTR investor planning to acquire properties they'll convert to STR (the "house hack flip-to-Airbnb" play) |
| **Tertiary persona** | Property managers running other people's LTRs who want to upsell conversion services |
| **Age** | 35–60 |
| **HHI** | $100k+ |
| **Geography** | US launch — focus on tourist-adjacent markets where conversion ROI is highest (FL, TN, NC, SC, AZ, CO, TX, OR vacation regions) |
| **Pain** | Sitting on $200-800/mo of margin upside they can't unlock because they're afraid to pull the trigger |

## 4. Core value prop

**"Your rental, but as an Airbnb — should you, and how?"**

Three concrete promises:
1. **Conversion clarity** — show the landlord with real numbers whether their specific property would earn more as an STR (projected revenue, breakeven, regulation risk, all sourced and confidence-ranged)
2. **Setup roadmap** — if they decide to convert, give them the exact playbook (furnishing budget, photographer, listing copy, dynamic pricing setup, compliance checklist)
3. **Operational tracking** — once live, track real performance vs. projection. Flag underperformance, alert on regulation changes, surface optimization opportunities

**The full LTR → STR journey, end-to-end. Not just "will it work" — also "how to do it" and "how it's actually doing."**

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

Three pillars: **Conversion Analysis** + **Setup Roadmap** + **Performance Tracking** (the last one stubbed in v1, fleshed out in v1.5).

### 7.1 Conversion Analysis (the wedge)

| Component | Details |
|---|---|
| **Free tier — 1 free conversion report** | No signup. Paste address → instant 1-pager: "Your LTR earns $X. As STR, projected $Y (range $Y-low to $Y-high). Conversion verdict + key risks." |
| **Property entry** | Paste address. AI pulls property characteristics from RentCast. User confirms or adjusts. |
| **Current LTR baseline** | What is the property earning today? (User inputs current rent, or we estimate via RentCast LTR comps.) |
| **STR projection** | Projected gross + net STR revenue, occupancy, ADR — based on 5-10 verified comps within 1.5mi. Confidence-ranged. |
| **Side-by-side verdict** | "LTR: $24k/yr net. STR projection: $48k/yr net (range $38k-$58k). Conversion adds ~$24k/yr if execution is average." |
| **Setup cost estimate** | Furnishing ($8-15k typical), photographer ($500-1k), listing optimization, dynamic pricing tool subscription, additional insurance |
| **Breakeven timeline** | Months to recoup setup costs at projected occupancy |
| **Regulation risk score** | Hybrid (top 50 markets curated, long-tail AI-grounded). With source link. |
| **Red flags** | Seasonality concerns, comp thinness, regulation flags, HOA restrictions |
| **AI reasoning** | "Why we project this revenue" + sources cited |
| **Export PDF** | Branded analysis to share with partner, accountant, or just save |

### 7.2 Setup Roadmap (post-decision)

| Component | Details |
|---|---|
| **Conversion checklist** | Auto-generated, customized to property: furnishing list with budget, photographer recommendation in their city, listing title/description AI-drafted, pricing strategy (dynamic vs flat), compliance checks (city license, insurance, taxes) |
| **Vendor recommendations** | Cleaners, photographers, dynamic pricing tools (PriceLabs, Wheelhouse), local STR-friendly insurance brokers — all in their market |
| **Listing copy + photo guidance** | AI-drafted listing title, description, amenity list. Photo composition guidance per room. |
| **Compliance walkthrough** | What licenses/permits needed in their city. Direct links to forms. |
| **First-30-days operating playbook** | What to do day 1, week 1, month 1. Pricing adjustments, review responses, common pitfalls. |

### 7.3 Performance Tracking (stubbed in v1, full in v1.5)

| Component | Details |
|---|---|
| **Property profile** | User saves their converted property to dashboard |
| **Manual stats input (v1)** | User can enter monthly revenue, expenses, bookings — basic vs-projection tracking |
| **Auto-pull from Airbnb (v1.5)** | Connect Airbnb account → automatic performance data |
| **Vs projection alerts** | "Your March revenue is 18% below projection — here's likely why" |
| **Market drift alerts** | "Comps in your market shifted — your projected ADR is now $X (was $Y)" |
| **Regulation alerts** | "Your city updated STR ordinance on [date] — new compliance step required" |

### 7.4 Foundational features

| Component | Details |
|---|---|
| **Saved properties + weekly email digest** | User saves their property. Weekly email: comp shifts, regulation changes, performance notes |
| **Real-time market data panel** | Live occupancy, ADR, revenue trends in their market — sourced + timestamped |
| **Comparable listings graphs** | 5-10 nearby Airbnbs — with footnotes "based on N verified calendars" |
| **Billing** | Stripe — $39 Starter (1 property), $99 Pro (up to 5 properties), $249 Plus (unlimited + team). 14-day trial, 30-day money-back guarantee |

## 8. Pricing (hardened against concern #4)

**Per-property pricing, not per-search.** Aligns with our model — users own properties they want to convert + track.

| Tier | Price | Properties tracked | Includes |
|---|---|---|---|
| **Free** | $0 | 0 (1 free analysis) | One conversion report PDF, no login |
| **Starter** | $39/mo | 1 property | Conversion analysis + setup roadmap + manual tracking |
| **Pro** | $99/mo | Up to 5 properties | Auto-pull from Airbnb, vs-projection alerts, regulation alerts, full setup recommendations |
| **Plus (v1.5)** | $249/mo | Unlimited + team seats | Property managers, multi-portfolio tracking, API |

- **30-day money-back guarantee** (not just 14-day trial)
- Cache layer: same address within 7 days = no charge
- Per-minute rate limit (5 searches/min) prevents abuse
- AI cost monitoring per user; alert if 3x avg

## 9. Lifecycle features (hardened against concern #5 — retention)

**Reposition from "search tool" to "investment manager."** Users have reasons to come back AFTER they buy.

### v1 (week 6 launch)
- Conversion analysis (LTR baseline vs STR projection, side-by-side)
- Setup roadmap (furnishing, photographer, listing copy, compliance)
- Property profile in dashboard
- Manual performance tracking (monthly stats input vs projection)
- Free PDF conversion report (top of funnel)
- Saved properties + weekly email digest

### v1.5 (month 2-3) — Operations layer
- **Active bookings dashboard** — pull from Airbnb API: upcoming check-ins, current guests, departures
- **Auto-pull performance data** from Airbnb (revenue, occupancy, ratings) → vs projection charts
- **AI booking updates** — "Guest checking in tomorrow at 3pm. Confirm cleaning is done by noon. Last guest's review was 4.6 — here's the suggested response."
- **Expense tracking** — capture receipts via photo, AI categorizes (cleaning, repairs, supplies, mortgage, insurance, utilities, taxes)
- **Profit dashboard** — gross revenue minus expenses, per property, per month

### v2 (month 4-6) — Team + CRM layer
- **Staff/team CRM** — cleaners, photographers, handymen, co-hosts. Track contact info, services, rates, performance.
- **Task assignment** — assign turnover to a cleaner, get confirmation back, log completion. Auto-pay them.
- **Vendor billing & payments** — invoice/pay cleaners and contractors directly through Vesta. Track 1099s for year-end.
- **Multi-property portfolio view** — performance, expenses, bookings across all owned properties in one dashboard
- **AI ops assistant** — drafts guest messages, suggests review responses, handles common requests, flags anomalies (review dropping, occupancy declining, regulation changes)
- **Tax-time bundle** — Schedule E export, expense categorization audit, depreciation schedule

### v3 (month 6+) — Power user / agency
- **Property manager mode** — manage other people's properties, separate billing per owner
- **White-label option** for property managers to brand Vesta
- **Mobile app** (iOS + Android) for on-the-go ops
- **Multi-platform listings** (VRBO + Booking.com sync)
- **Renovation ROI** — "spend $30k on kitchen, revenue +$8k/yr"
- **Refi opportunity flags** — "rates dropped, save $X/mo on your Gatlinburg property"

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

## 10.5. Design system + brand identity

### Brand identity
- **Name:** Vesta — Roman goddess of hearth + home
- **Voice:** confident, honest, editorial, never bro-y. Says "walk away" when the deal is bad.
- **Logo:** V silhouette as roof, dot above as hearth flame. Single-color or amber gradient.
- **Reference vibes:** bricked.ai (editorial premium), Linear (clean tech), Vercel (minimal), Notion early (warm minimalism).
- **NOT:** chatarv-green, generic SaaS-bro, "AI startup #4,872" gradient slop.

### Design tokens (lock these in Figma)

```css
/* Colors */
--bg            #fafaf7   /* warm cream */
--bg-warm       #f5f1ea   /* deeper cream for sections */
--ink           #0a0a0a   /* near-black, primary text */
--ink-soft      #525252   /* secondary text */
--ink-muted     #737373   /* tertiary text, captions */
--line          rgba(0,0,0,0.08)  /* borders */
--accent        #d97706   /* primary amber */
--accent-light  #f59e0b   /* gradient highlight */
--accent-dark   #b45309   /* hover/dark variant */
--accent-bg     rgba(217,119,6,0.08)  /* tinted backgrounds */

/* States */
--success       #10b981  /* used sparingly — primary is amber */
--warn          #f59e0b
--danger        #ef4444
--info          #3b82f6
```

### Typography
- **Display headlines:** Instrument Serif, italic for accent words ("Know", "real address")
- **Body / UI:** Inter — weights 400, 500, 600, 700
- **Mono / numbers:** JetBrains Mono — for currency, percentages, IDs
- **Sizes:** 80–100px (hero), 48–64px (h2), 24–36px (h3), 16–18px (body), 14px (small), 11px uppercase mono (eyebrows)

### Spacing scale (strict)
4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 / 96 / 128 — no other values allowed.

### Radii
6px (small), 12px (input/button), 16px (card), 24px (hero card), full (pills, avatars).

### Shadows
- Card: `0 1px 3px rgba(0,0,0,0.04)`
- Card hover: `0 12px 30px -10px rgba(0,0,0,0.08)`
- Hero / product mock: `0 50px 100px -25px rgba(217,119,6,0.18), 0 25px 50px -15px rgba(0,0,0,0.10)`

### Component inventory (build in Figma library)

| Component | Variants | Notes |
|---|---|---|
| Button | primary (black), accent (amber gradient), secondary (white outline), tertiary (text) | 3 sizes: sm/md/lg |
| Input | default, focused, error, with-icon | 12px radius |
| Card | default, hover, selected (amber ring), dark | 16px radius |
| Stat tile | label + value + delta | mono font for numbers |
| Score badge | 0–100 circular ring + number | progress arc fill |
| Freshness badge | green/yellow/orange/red dot + label | with timestamp |
| Red flag chip | warning amber + icon | inline |
| AI reasoning panel | amber bg + icon + body + sources line | recurring pattern |
| FAQ accordion | open/closed states | smooth max-height transition |
| Pricing card | starter, pro (highlighted), plus | dark variant for Pro |
| Demo browser chrome | mac-style traffic lights + URL bar | wraps product mocks |
| Loading skeleton | shimmering placeholder bars | for every async load |
| Progress step | spinner / check / pending icon + label | streams during AI run |

### Screen inventory

**Marketing (Framer or Next.js):**
1. `/` Landing — hero + animated demo + how it works + features + pricing + FAQ + CTA + footer
2. `/pricing` — full pricing table
3. `/about` — founder story
4. `/blog/*` — content marketing
5. `/legal/*` — privacy, terms, disclaimers

**Product app (Next.js):**
1. Sign-up — email + Google OAuth
2. Onboarding — 4-stage prompt (Aspiring/New/Growing/Scaling)
3. Search dashboard — saved searches sidebar + new search
4. Search → AI thinking — progressive disclosure stream
5. Results — single property OR all-clearing-threshold
6. Property detail — full deep-dive with all viz
7. Account / billing
8. Saved searches mgmt
9. Email digest preview
10. (v1.5) Portfolio dashboard

### State coverage (every screen needs all of these)
- Empty (no searches yet)
- Loading (skeleton + progress stream)
- Error (clear message + retry)
- Partial data (e.g., comps unavailable for this zip)
- Quality-threshold-not-met ("no strong matches today" + alternatives)
- Off-market (property went under contract)

### Responsive breakpoints
- Mobile: 375–767
- Tablet: 768–1023
- Desktop: 1024+
- Max content width: 1152px

### Accessibility (non-negotiable)
- WCAG AA contrast (test with `--ink` on `--bg` = 19.5:1 ✓)
- Keyboard nav for every interactive element
- Focus rings visible (amber outline)
- Screen reader labels on icons
- Reduced motion preference respected

### Figma file structure (recommended)
```
🎨 Vesta Design System
├── 00_Foundations        ← colors, type, spacing, radii tokens
├── 01_Components         ← button, input, card, badge library
├── 02_Patterns           ← navbar, footer, hero, FAQ section
├── 03_Marketing screens  ← landing, pricing, about
├── 04_App screens        ← onboarding, search, results, detail
├── 05_States             ← loading, empty, error, partial
└── 06_Mobile             ← responsive variants
```

### Figma Make / AI design tool prompt
When using Figma Make (or v0, Galileo, etc.), feed it this brief:

> "Premium SaaS landing page for an AI rental property analysis tool. Brand: Vesta — Roman goddess of hearth. Aesthetic: editorial, warm cream background (#fafaf7), warm amber accent (#d97706), Instrument Serif headlines (italic accents on key words), Inter body. Reference vibes: bricked.ai meets Linear meets Vercel. NO emerald green, NO standard SaaS gradient slop. Component inventory: hero with single CTA address input, animated product demo card, how-it-works 3-step, feature grid, pricing 3-tier, FAQ accordion, dark final CTA. Mobile-first responsive. WCAG AA contrast."

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

## 16. The full Vesta vision (across all versions)

**Vesta is the operating system for a single-family STR landlord.** From "should I convert my LTR" all the way to "AI runs my Airbnb portfolio for me."

```
v1 (week 6)       Conversion analysis + setup roadmap + manual tracking
                  ↓
v1.5 (month 2-3)  Active bookings + AI booking updates + expense tracking + auto-pull from Airbnb
                  ↓
v2 (month 4-6)    Staff/team CRM + vendor billing + AI ops assistant + multi-property
                  ↓
v3 (month 6+)     Property manager mode + mobile app + multi-platform listings
```

Each version compounds. v1 customers stay because v1.5 unlocks active bookings + expense tracking. v1.5 customers stay because v2 adds the CRM + AI ops. v2 customers stay because v3 makes them money manageable at scale.

**Pricing scales with versions:**
- v1: $39/mo (1 prop) → $99/mo (5 prop)
- v1.5: same tiers, more value packed in
- v2: $99/mo → $249/mo (Team tier with billing/CRM)
- v3: $249/mo → $499/mo (Agency tier with multi-owner)

Net: customer LTV grows from $1,200 (1 year at $99) to $5,000+ as features accrete. Same customer, way bigger wallet.
