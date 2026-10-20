# FinWise — Intelligent Personal Finance & Spending Analytics System

A responsive B.Tech 2nd-year Advanced Data Structures PBL. FinWise combines personal finance tracking with genuine implementations of classic data structures and algorithms. It defaults to INR and includes clearly labelled sample records for a classroom demonstration.

## Features

- Dashboard with current-month balance, income, expenses, savings rate, category chart, trend chart, budgets, reminders and rule-based insights.
- Transaction create/read/update/delete, text search, type filters, sorting and CSV export.
- Monthly category budgets, savings goals, recurring bill reminders, mark-paid status and analytics.
- ADS Lab with merge sort, binary search, min-heap, trie, graph BFS, sliding window, stack and dynamic-programming budget allocation.
- Responsive pastel pink/lilac/white/navy interface, keyboard focus states, reduced-motion support and mobile navigation.
- Optional Supabase email/password authentication and PostgreSQL transaction persistence; migration provisions user-owned tables, indexes, constraints and RLS policies.
- Browser-only demo mode when Supabase environment variables are not configured.

> Important status note: browser demo records are stored in localStorage. In this starter build, cloud authentication and transaction CRUD are wired to Supabase when configured; budgets, goals and bills currently use browser storage and are not yet synchronized to cloud tables. The SQL schema and RLS for those modules are included for the next integration pass. Do not describe those modules as cloud-persistent until their CRUD services are connected and tested.

## Quick start

Requirements: Node.js 20+ and npm.

```bash
npm install
cp .env.example .env.local
npm run dev
```

Open the local URL printed by Vite (usually `http://localhost:5173`). Without Supabase values, the app opens in demo mode. Demo records are examples, not a real user's financial history.

## Enable Supabase

1. Create a project at https://supabase.com.
2. Open **Project Settings → API** and copy the Project URL and publishable/anon key.
3. Put them in `.env.local` as `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`.
4. In Supabase SQL Editor, run `supabase/migrations/202610200001_initial_schema.sql`.
5. In Authentication settings, choose the email confirmation policy appropriate for your demo. Never place a service-role key in `.env.local` or browser code.
6. Restart `npm run dev`. Create an account, then test a transaction. Confirm that user A cannot read user B's records.

The publishable/anon key is intended for browser use only with correctly configured RLS. Never expose a service-role key.

## Scripts

```bash
npm run dev       # development server
npm run build     # TypeScript check + production Vite build
npm run preview   # preview production output
npm test          # automated ADS unit tests
```

## GitHub

Create a repository named `personal-finance-tracker-ads-pbl`, then from this folder:

```bash
git init
git add .
git commit -m "Build FinWise ADS personal finance tracker"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/personal-finance-tracker-ads-pbl.git
git push -u origin main
```

If the repository already exists locally, do not re-run `git init`; set or inspect the remote with `git remote -v` first. `.env*` files are ignored except `.env.example`.

## Deployment

Vercel or Netlify can build this Vite app with build command `npm run build` and output directory `dist`. Add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` in the host's environment-variable settings, then redeploy. Apply the SQL migration to Supabase before enabling real accounts. A deployment URL is not included because this package has not been deployed from this environment.

## Project structure

```text
src/
  App.tsx                 Main pages, forms, chart views and interactions
  styles.css              Responsive pastel design system
  lib/finance.ts          Financial calculations and deterministic insights
  lib/supabase.ts         Optional Supabase client
  algorithms/             Independent ADS implementations and unit tests
supabase/migrations/      PostgreSQL schema, constraints, indexes and RLS
 docs/                    Project and viva documentation
```

## Security and scope

- No bank integrations, card PINs, OTPs or real payment processing.
- Financial insights are simple rules, not investment/tax/legal advice.
- Browser demo data is device/browser-specific and is not secure cloud storage.
- Production cloud mode needs Supabase project setup and RLS verification. Complete cloud CRUD for budgets, goals and bills before relying on cross-device persistence.
- Sample transactions are static demonstration fixtures and labelled as examples in the interface.
