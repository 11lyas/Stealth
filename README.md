# Vesta

> **Should you turn your rental into an Airbnb?** Vesta runs your specific property's numbers, gives you the playbook to convert, and tracks performance after.

**Status:** pre-launch · v1.2 PRD locked · landing live · Supabase provisioned · Vercel deployed

## What it is

The only tool built specifically for **long-term rental landlords considering an STR conversion**. Three pillars:

1. **Conversion analysis** — paste your address, see LTR baseline vs STR projection side-by-side
2. **Setup roadmap** — furnishing, photographer, listing copy, compliance, first-30-days playbook
3. **Performance tracking** — once converted, track real performance vs. our projection

## Live

- **Landing:** https://stealth-ruddy.vercel.app
- **GitHub:** https://github.com/11lyas/Stealth
- **Database:** Supabase (provisioned + schema deployed)

## What's in this repo

| Folder | What |
|---|---|
| `docs/` | PRD v1.2 — active product spec (read this first) |
| `mockups/` | Live landing page + onboarding mockup + logo concepts |
| `supabase/` | Database schema (already deployed to live DB) |

## Brand

- **Name:** Vesta — Roman goddess of hearth + home
- **Logo:** V silhouette as roof, dot above as hearth flame
- **Palette:** warm cream `#fafaf7` + amber accent `#d97706`
- **Typography:** Inter (body) + Instrument Serif (headlines)
- **Reference vibes:** bricked.ai meets Linear meets Vercel

## Stack (planned for v1 product)

| Layer | Pick |
|---|---|
| Frontend | Next.js 15 + TypeScript + Tailwind + shadcn/ui |
| Backend | Supabase (Postgres + auth + storage + RLS) |
| AI | Claude Sonnet 4.6 |
| Property data | RentCast API → AirDNA at scale |
| Regulation | Hybrid — paralegal-curated top 50 + AI-grounded long tail |
| Payments | Stripe + Stripe Tax |
| Email | Resend |
| Hosting | Vercel (Next.js) |
| Error tracking | Sentry |
| Analytics | PostHog |

## Pricing

| Tier | Price | What |
|---|---|---|
| Free | $0 | 1 free conversion analysis, no signup |
| **Starter** | $39/mo | 1 property — conversion + setup + manual tracking |
| **Pro** | $99/mo | Up to 5 properties — auto-pull from Airbnb, alerts |
| Plus (v1.5) | $249/mo | Unlimited + team seats — for property managers |

14-day trial · 30-day money-back guarantee.

## Roadmap

```
v1   (week 6)     Conversion + setup + manual tracking
v1.5 (month 2-3)  Active bookings + AI updates + expense tracking
v2   (month 4-6)  Staff CRM + vendor billing + AI ops assistant
v3   (month 6+)   Property manager mode + mobile app + multi-platform
```

## Working on this?

Read [`CONTRIBUTING.md`](CONTRIBUTING.md) — covers setup, repo structure, daily workflow, security rules.
