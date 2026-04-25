# Vesta

> Know every number before you buy. AI analyzes any rental property in 90 seconds.

**Status:** pre-launch · v0.6 PRD scoped · landing live

## Live

- **Landing:** https://stealth-ruddy.vercel.app
- **GitHub:** https://github.com/11lyas/Stealth
- **Database:** Supabase (provisioned + schema deployed)

## What's in this repo

| Folder | What |
|---|---|
| `docs/` | Product specs (PRD-A is the active product) |
| `mockups/` | Static HTML mockups + logo concepts (currently deployed) |
| `supabase/` | Database schema (already applied to live DB) |

## Working on this?

Read [`CONTRIBUTING.md`](CONTRIBUTING.md) — covers setup, repo structure, daily workflow, brand decisions, security rules.

## Stack (planned for v1 product)

- **Frontend:** Next.js 15 + TypeScript + Tailwind + shadcn/ui
- **Backend:** Supabase (Postgres + auth + storage)
- **AI:** Claude Sonnet 4.6
- **Property data:** RentCast API → AirDNA at scale
- **Payments:** Stripe
- **Hosting:** Vercel
