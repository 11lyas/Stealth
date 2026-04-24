# PRD B — Turo / Car Rental Operator AI

**Status:** Draft v0.2 · 2026-04-23
**Working name:** Keyless (placeholder)
**Platform:** Web SaaS (iOS app planned for v2, 3–6 months post-launch)
**Target ship:** Web MVP in 5 weeks

---

## 1. One-liner
The operator dashboard Turo hosts have been begging for — AI pricing, renter messages, trip coordination, damage tracking — all in one mobile app.

## 2. Problem
Turo hosts running 2–20 cars treat it as a real business, but have **zero real tools**. They manage in:
- Spreadsheets
- Group texts with their detailer / gas runner / key swapper
- Notes app reminders
- Paper damage logs

Reasons nothing exists:
- Turo has no public API → every would-be tool has to work around it
- Market only recently big enough (exploded 2022–2026)
- SaaS builders are all chasing Airbnb, ignoring this community

**This is a blue ocean.** First real AI-native tool wins the category.

## 3. Target user

| Attribute | Detail |
|---|---|
| **Primary persona** | "Turo side hustler" — 2–5 cars, $3k–$15k/mo gross, part-time operator |
| **Secondary persona** | "Small fleet operator" — 6–30 cars, full-time business, often an LLC |
| **Age** | 22–45 (younger than Airbnb hosts — this is a new category) |
| **Tech comfort** | High — digitally native, runs ops on their phone, active on TikTok/YouTube |
| **Geography** | US first (TX, FL, CA, AZ, GA, NV are top Turo markets) |
| **Community** | r/turo, "Turo Gods" YouTube, TikTok creators (Car Dealership Guy, Turo-focused accounts) |
| **Buying pattern** | Will pay for tools that directly make them money; impatient with dashboards that don't |

## 4. Core value prop
**"Run your Turo fleet like Hertz — from one web dashboard."**

1. **Revenue lift** — AI dynamic pricing + utilization optimization (hosts currently under-price by ~15–25%)
2. **Time back** — AI messaging + dispatch automation saves 8–15 hrs/wk
3. **Protection** — damage photo log + AI-assisted claim drafting (Turo claim disputes cost hosts thousands)

**Why web-first:** Ships faster (no App Store gatekeeping), ChatARV-style positioning (pro tool, clearly a business product), and fleet operators manage from laptops more than phones. iOS app in v2 captures mobile-only workflows (damage photo capture on pickup/return).

## 5. MVP feature set (v1, ship in 6 weeks)

### 5.1 AI Dynamic Pricing (priority 1)
- Daily AI price recalculation per car per day for next 90 days
- Inputs: local events (sports, concerts, conferences), competitor Turo cars in same zip, weekend vs. weekday, season, holidays, car type (luxury vs. economy)
- Floor / ceiling guardrails set by host
- One-tap apply → updates Turo calendar via browser automation (Playwright worker)
- Shows projected monthly revenue delta vs. current pricing

### 5.2 AI Renter Messaging
- Inbound Turo message → AI draft response in host's tone
- Top 20 message categories: pickup time/location, fuel policy, extensions, damage questions, late returns, accident report, lockout, cleaning, delivery, parking
- Host approves with one tap, or edits + approves
- Safe categories auto-send (pickup address, fuel policy, wifi)

### 5.3 Trip Dispatch Console
- Every trip: upcoming pickup, active trip, return
- Auto-SMS to detailer before pickup
- Auto-SMS to gas attendant before pickup (or renter after return if "return same level")
- Key handoff logistics (airport lot spot, lockbox code, in-person)
- One-tap "delay pickup" sends updated message to renter

### 5.4 Damage Tracker + AI Claim Drafter
- On pickup/return, host uploads 8 photos via web (drag-and-drop) or web camera capture
- **Mobile-web upload works today** — no native iOS app needed. QR code on dashboard → scan on phone → mobile web uploads photos to the session.
- AI diffs pickup vs. return photos
- AI flags: "passenger fender shows new scratch, ~6 inches, not in pickup photos"
- Auto-generate Turo claim draft with photo evidence + dashboard narrative (hosts lose thousands by under-documenting claims)
- iOS app in v2 will upgrade this to native guided camera capture with AR framing guides

### 5.5 Revenue + Utilization Dashboard
- Gross revenue per car, per month
- Utilization % (days rented / days available)
- Profit per car (revenue − Turo fee − fuel − cleaning − maintenance)
- Which cars to buy more of / sell (AI suggestion: "Car 3 is your highest ROI, consider buying another Camry")

### 5.6 Fleet Operations Log
- Maintenance schedule (oil changes, tires, registration)
- Auto-reminders before each
- Receipt photo capture → AI categorizes expense
- Year-end Schedule C export

## 6. User flows (happy path)

### 6.1 Onboarding (new host)
1. Visit keyless.app (or whatever) → sign up with email
2. Log into Turo (credentials encrypted, browser automation worker runs in our infra)
3. App imports existing fleet + bookings
4. Host sets floor/ceiling price per car
5. Adds detailer + gas runner phone numbers
6. Sets tone profile for messages
7. Done in 15 min

### 6.2 Daily check-in (existing host)
1. Open keyless.app dashboard (mobile-web works fine for phone users):
   - "3 pickups today"
   - "+$140 pricing lifts applied overnight"
   - "2 renter messages to approve"
   - "Car 4 returned — damage check needed"
2. Click damage check → review AI diff → confirm "clean return" or "file claim"
3. Click through message approvals
4. Close tab. Back to real life.

## 7. Tech stack (web v1)

| Layer | Pick | Notes |
|---|---|---|
| **Frontend** | Next.js 15 + TypeScript + Tailwind + shadcn/ui | App Router, Server Components, Geist font for polish |
| **Marketing site** | Same Next.js app | One domain — `/` = landing, `/app/*` = product |
| **Backend** | Supabase (Postgres + auth + storage) | Speed to MVP, zero infra work |
| **AI** | Claude Sonnet 4.6 (messages, pricing, damage analysis) + Claude Vision (photo diff) | Vision is the unlock for damage |
| **Turo integration** | **Playwright worker on Fly.io** — scrapes + automates Turo on host's behalf | THE HARD PART. Requires IP rotation + session management. |
| **Events data** | SerpAPI + Ticketmaster API | City-level demand signals |
| **SMS** | Twilio | Detailer / gas runner dispatch |
| **Payments** | Stripe subscriptions + Stripe Tax | Checkout, not embedded |
| **Hosting** | Vercel (Next.js) + Fly.io (Playwright workers) | Two deploys, separate concerns |
| **Error tracking** | Sentry (free tier) | Day 1 |
| **Analytics** | PostHog | Day 1 |
| **Photo upload** | Mobile web via QR → session upload to Supabase Storage | No native app needed for this in v1 |

### iOS app (v2 — 3-6 months post-launch)
- SwiftUI, iOS 17+
- Same Supabase backend — shared API, shared auth
- Killer feature: native guided camera with AR framing guides for pickup/return photos
- Offline mode for no-signal pickup/return locations

## 8. Monetization

| Tier | Price | Includes |
|---|---|---|
| **Solo** | $39/mo | 1–2 cars, all features |
| **Operator** | $99/mo | 3–10 cars |
| **Fleet** | $249/mo | Unlimited cars + 3 team seats + priority support |

- **Why slightly higher than STR pricing:** zero competition, higher revenue per asset (cars rent for $80–$400/day vs. $100–$500/night), Turo hosts have stronger ROI math
- 14-day free trial
- Annual: 2 months free
- Referral: host gets 1 month free per referred host who pays 60 days

## 9. GTM

### 9.1 Launch motion
1. **Private beta** (weeks 1–4): recruit 10 Turo hosts via r/turo + YouTube DMs. Free for 90 days + testimonials.
2. **Soft launch** (week 5): Reddit r/turo post with real numbers from beta
3. **Influencer wave** (week 6+): sponsor 5 Turo YouTubers at $500–$2k + 30% affiliate

### 9.2 Content engine
- TikTok: "this app made me $2,300 more last month" daily hook
- YouTube: "we tested AI Turo pricing across 50 cars" case studies
- Reddit r/turo: transparent progress updates — this community rewards founders who show up

### 9.3 Why this goes viral
- Turo hosts **already have no tools** → word-of-mouth moves fast when one finally works
- Fleet economics pay for the tool 10x over — easy pitch
- Community is tight-knit (r/turo, specific YouTubers) — 10 advocates = massive reach

## 10. Out of scope for v1
❌ **iOS app** (planned v2 — 3–6 months after web launch)
❌ Getaround integration (Turo only, 90% market share)
❌ Insurance shopping / recommendation
❌ Car purchase recommendation engine
❌ Renter verification / ID checking (Turo handles)
❌ Payment processing (Turo handles)
❌ Maintenance vendor marketplace

## 11. Risks + mitigations (critical — this has more than PRD A)

| Risk | Mitigation |
|---|---|
| **Turo blocks our automation / sends C&D** | HIGHEST RISK. Mitigation: rotate IPs, throttle requests, run as logged-in user (not scraper). Also: position as "we manage YOUR account on YOUR behalf, we are not a competitor" — harder to block legally. |
| **Turo launches official API** | Embrace it instantly, save engineering effort. Low probability short-term. |
| **Turo launches competing features** | They have, they're bad at it. We go 10x deeper on ops tooling they won't prioritize. |
| **Pricing AI mis-sets, host loses rental** | Conservative floor prices, always show "before apply", opt-in auto-apply |
| **Damage claim advice leads to wrongful claim** | Frame as "assisted drafting" not legal advice; host reviews every claim before submit |
| **AI messages offend renter → bad review** | Default draft+review; auto-send only for safe categories |

## 12. Success metrics (90 days post-launch)

| Metric | Target |
|---|---|
| Paid customers | 40 |
| MRR | $4,000 |
| Trial → paid | ≥ 30% (no alternative tools = higher conversion) |
| Avg revenue lift delivered | ≥ 12% |
| Damage claims filed via app | ≥ 1.5 per host per month |
| NPS | ≥ 50 |

## 13. Timeline (web-first MVP)

| Week | Milestone |
|---|---|
| 1 | Next.js + Supabase schema. Turo login + Playwright scraping worker prototype. Landing page. |
| 2 | Fleet import from Turo + calendar sync. Basic dashboard. |
| 3 | AI Dynamic Pricing engine + one-tap apply to Turo |
| 4 | AI Messaging inbox + draft + approve + send |
| 5 | Damage Tracker (mobile-web photo upload + Claude Vision diff) + Revenue Dashboard + Trip Dispatch |
| 6 | Beta polish + 10-host private beta on live web app |
| 7 | Public launch — Reddit r/turo, YouTube partners |

**No App Store gatekeeping. Live to paying customers in 7 weeks.**

## 14. Open questions for the founder
- [ ] Turo automation — roll our own Playwright worker or partner with an existing automation provider?
- [ ] Start US-only (where Turo is concentrated)?
- [ ] Pricing: $39/$99/$249 as proposed or more aggressive ($29/$79/$199)?
- [ ] Beta cohort source: Reddit DMs, YouTube outreach, or Turo Facebook groups?
- [ ] Do we build damage tracker v1 or defer to v2? (It's the most complex feature but the highest moat.)
- [ ] Legal / Terms: how do we position the Turo relationship? (Partnership pitch vs. "we work for you as your agent")
