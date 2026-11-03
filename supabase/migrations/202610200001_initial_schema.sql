-- FinWise initial schema. Apply in Supabase SQL Editor or via Supabase CLI.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  currency text not null default 'INR' check (currency in ('INR','USD','EUR','GBP')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  name text not null,
  type text not null check (type in ('income','expense')),
  color text not null default '#a78bfa',
  icon text not null default 'circle',
  created_at timestamptz not null default now(),
  constraint categories_owner_name_type_unique unique (user_id, name, type)
);

create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null check (length(trim(title)) between 1 and 140),
  amount numeric(12,2) not null check (amount > 0),
  type text not null check (type in ('income','expense')),
  category text not null check (length(trim(category)) between 1 and 80),
  date date not null default current_date,
  notes text check (notes is null or length(notes) <= 1000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  category text not null check (length(trim(category)) between 1 and 80),
  amount numeric(12,2) not null check (amount > 0),
  month date not null check (extract(day from month) = 1),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, category, month)
);

create table if not exists public.savings_goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null check (length(trim(name)) between 1 and 120),
  target_amount numeric(12,2) not null check (target_amount > 0),
  saved_amount numeric(12,2) not null default 0 check (saved_amount >= 0),
  deadline date not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.recurring_bills (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null check (length(trim(name)) between 1 and 140),
  amount numeric(12,2) not null check (amount > 0),
  due_date date not null,
  category text not null default 'Other',
  is_paid boolean not null default false,
  recurrence text not null default 'none' check (recurrence in ('none','weekly','monthly','yearly')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists transactions_user_date_idx on public.transactions(user_id, date desc);
create index if not exists transactions_user_type_date_idx on public.transactions(user_id, type, date desc);
create index if not exists transactions_user_category_idx on public.transactions(user_id, category);
create index if not exists budgets_user_month_idx on public.budgets(user_id, month);
create index if not exists goals_user_deadline_idx on public.savings_goals(user_id, deadline);
create index if not exists bills_user_due_date_idx on public.recurring_bills(user_id, due_date) where is_paid = false;
create index if not exists categories_user_type_idx on public.categories(user_id, type);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$ begin new.updated_at = now(); return new; end; $$;

drop trigger if exists profiles_updated_at on public.profiles;
create trigger profiles_updated_at before update on public.profiles for each row execute function public.set_updated_at();
drop trigger if exists transactions_updated_at on public.transactions;
create trigger transactions_updated_at before update on public.transactions for each row execute function public.set_updated_at();
drop trigger if exists budgets_updated_at on public.budgets;
create trigger budgets_updated_at before update on public.budgets for each row execute function public.set_updated_at();
drop trigger if exists savings_goals_updated_at on public.savings_goals;
create trigger savings_goals_updated_at before update on public.savings_goals for each row execute function public.set_updated_at();
drop trigger if exists recurring_bills_updated_at on public.recurring_bills;
create trigger recurring_bills_updated_at before update on public.recurring_bills for each row execute function public.set_updated_at();

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, full_name) values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name','')) on conflict (id) do nothing;
  return new;
end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.transactions enable row level security;
alter table public.budgets enable row level security;
alter table public.savings_goals enable row level security;
alter table public.recurring_bills enable row level security;

drop policy if exists "Users can view own profile" on public.profiles;
create policy "Users can view own profile" on public.profiles for select to authenticated using (auth.uid() = id);
drop policy if exists "Users can insert own profile" on public.profiles;
create policy "Users can insert own profile" on public.profiles for insert to authenticated with check (auth.uid() = id);
drop policy if exists "Users can update own profile" on public.profiles;
create policy "Users can update own profile" on public.profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "Users can view global or own categories" on public.categories;
create policy "Users can view global or own categories" on public.categories for select to authenticated using (user_id is null or user_id = auth.uid());
drop policy if exists "Users can create own categories" on public.categories;
create policy "Users can create own categories" on public.categories for insert to authenticated with check (user_id = auth.uid());
drop policy if exists "Users can update own categories" on public.categories;
create policy "Users can update own categories" on public.categories for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists "Users can delete own categories" on public.categories;
create policy "Users can delete own categories" on public.categories for delete to authenticated using (user_id = auth.uid());

-- All user-owned tables: ownership is enforced in PostgreSQL, not just in the UI.
do $$ declare tbl text; begin foreach tbl in array array['transactions','budgets','savings_goals','recurring_bills'] loop
  execute format('drop policy if exists %I on public.%I', 'Users manage own '||tbl, tbl);
  execute format('create policy %I on public.%I for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid())', 'Users manage own '||tbl, tbl);
end loop; end $$;

-- Global starter categories are readable by authenticated users; user-specific category inserts use user_id=auth.uid().
insert into public.categories (user_id,name,type,color,icon) values
(null,'Food','expense','#f3a6c8','utensils'),
(null,'Transport','expense','#a78bfa','train'),
(null,'Bills','expense','#7c83fd','receipt'),
(null,'Education','expense','#80cbc4','book-open'),
(null,'Shopping','expense','#f6c177','shopping-bag'),
(null,'Health','expense','#f28b82','heart-pulse'),
(null,'Entertainment','expense','#9da8f5','sparkles'),
(null,'Allowance','income','#80cbc4','wallet'),
(null,'Salary','income','#a78bfa','briefcase'),
(null,'Freelance','income','#f6c177','laptop'),
(null,'Gift','income','#f3a6c8','gift'),
(null,'Other','expense','#c8bfd7','circle')
on conflict do nothing;
