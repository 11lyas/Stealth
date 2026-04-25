# Contributing to Vesta

Welcome. Here's everything you need to get started + work alongside the team.

## What this project is

**Vesta** — AI rental property analysis tool (formerly placeholder name "Stealth"). One-liner:

> Know every number before you buy. AI analyzes any rental property in 90 seconds.

Read the full PRD: [`docs/PRD-A-STR-Operator.md`](docs/PRD-A-STR-Operator.md)

## Getting set up (first-time)

### 1. Get repo access
Ask the repo owner (Ilyas / @11lyas) to add you as a collaborator on `github.com/11lyas/Stealth`.

### 2. Install dev tools (one-time)
```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install everything we use
brew install git node pnpm gh
brew install --cask cursor figma 1password
```

### 3. Authenticate GitHub CLI
```bash
gh auth login
# pick: GitHub.com → HTTPS → Yes → Login with browser
```

### 4. Clone the repo
```bash
cd ~
gh repo clone 11lyas/Stealth
cd Stealth
```

### 5. Open in your editor
```bash
cursor ~/Stealth   # or open in IntelliJ
```

## Repo structure

```
Stealth/
├── docs/                           ← PRDs (read these first)
│   ├── PRD-A-STR-Operator.md       ← Active product spec (v0.6)
│   └── PRD-B-Turo-Operator.md      ← Backup direction (Turo angle)
├── mockups/                        ← Static HTML mockups
│   ├── index.html                  ← Current landing page (deployed)
│   ├── landing.html                ← Same content, alt name
│   ├── onboarding.html             ← 4-stage signup flow mockup
│   ├── logos/
│   │   ├── logos.html              ← 5 logo concept variants
│   │   └── vesta.html              ← Vesta-specific logo concepts (Concept 1 locked)
│   ├── vercel.json                 ← Deploy config
│   └── .gitignore
├── supabase/
│   └── schema.sql                  ← Database schema (already deployed)
├── .env.example                    ← Env var template (no real keys)
├── .env.local                      ← Real keys (GITIGNORED — never commit)
├── .gitignore
└── README.md
```

## Daily workflow

```bash
# Before starting work — pull latest
git pull origin main

# Make your changes, then:
git add <files-you-changed>
git commit -m "Short description of what changed"
git push origin main
```

**Vercel auto-deploys** on every push to `main` — within 30 seconds your changes are live at `stealth-ruddy.vercel.app`.

## Branch convention (when we get past v1)

For now: just push to `main`. Once we have paying customers:
- `main` = production
- `feature/short-name` = new features
- Pull request before merging

## Live infrastructure

| Service | What it's for | URL / dashboard |
|---|---|---|
| **GitHub** | Source of truth | github.com/11lyas/Stealth |
| **Vercel** | Hosting / deploys | vercel.com → 11lyas-projects → stealth |
| **Supabase** | Database + auth | supabase.com → joogmhjrulbsrbdfaoro |
| **Live site** | Public landing | https://stealth-ruddy.vercel.app |

## Brand decisions (locked)

- **Name:** Vesta (Roman goddess of hearth + home)
- **Logo:** V silhouette as roof, dot above as hearth flame (see `mockups/logos/vesta.html` Concept 1)
- **Fonts:** Inter (body) + Instrument Serif (headlines)
- **Colors:**
  - Background: `#fafaf7` (warm cream)
  - Ink: `#0a0a0a` (near-black)
  - Accent: `#d97706` (warm amber)

## Open decisions (need input)

- [ ] **Buy a domain** — likely `vesta.ai` (~$80/yr on Cloudflare or Namecheap)
- [ ] **Marketing site approach** — we may move to Framer.com for the landing, keep Next.js for the product app
- [ ] **Beta cohort source** — BiggerPockets / r/airbnb_hosts / influencer outreach

## Security rules (non-negotiable)

1. **Never commit `.env.local`** — it has real API keys. It's gitignored, keep it that way.
2. **Never paste API keys in Obsidian** — Obsidian is for notes. 1Password is for secrets.
3. **`.env.example` is safe to commit** — it's an empty template.
4. **If you accidentally commit a key:** rotate it immediately and remove from git history with `git filter-branch` or BFG Repo-Cleaner.

## Tools you might want

| Tool | What for |
|---|---|
| **TablePlus** (`brew install --cask tableplus`) | Visual DB browser for Supabase |
| **Raycast** (`brew install --cask raycast`) | Launcher, replaces Spotlight |
| **1Password** | All passwords + API keys |

## Questions

Ping in shared chat / DM. Don't be shy — small questions answered early save big bugs later.
