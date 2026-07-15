-- ============================================================
-- SIHAGO - Sistem Keuangan Pribadi
-- Jalankan SQL ini di Supabase SQL Editor
-- ============================================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ============================================================
-- TABEL PROFILES (data tambahan user setelah daftar)
-- Supabase sudah menangani auth (email/password) secara otomatis
-- di tabel auth.users — tabel ini menyimpan data profil tambahan
-- ============================================================
create table if not exists profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  full_name text,
  avatar_url text,
  currency text default 'IDR',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Aktifkan RLS untuk profiles
alter table profiles enable row level security;

-- Policies untuk profiles
create policy "Users can view own profile"
  on profiles for select using (auth.uid() = id);

create policy "Users can insert own profile"
  on profiles for insert with check (auth.uid() = id);

create policy "Users can update own profile"
  on profiles for update using (auth.uid() = id);

-- Trigger: otomatis buat profil saat user baru daftar
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1))
  );
  return new;
end;
$$;

-- Pasang trigger ke auth.users
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ============================================================
-- TABEL TRANSAKSI
-- ============================================================
create table if not exists transactions (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  type text check (type in ('income', 'expense')) not null,
  amount numeric(15, 2) not null check (amount > 0),
  category text not null,
  description text,
  date date not null,
  created_at timestamptz default now()
);

-- ============================================================
-- TABEL ANGGARAN (BUDGET)
-- ============================================================
create table if not exists budgets (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  category text not null,
  monthly_limit numeric(15, 2) not null check (monthly_limit > 0),
  month int not null check (month between 1 and 12),
  year int not null,
  created_at timestamptz default now(),
  unique (user_id, category, month, year)
);

-- ============================================================
-- TABEL WISHLIST / TARGET TABUNGAN
-- ============================================================
create table if not exists savings_goals (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  target_amount numeric(15, 2) not null check (target_amount > 0),
  current_amount numeric(15, 2) default 0 check (current_amount >= 0),
  target_date date,
  icon text default '🎯',
  color text default '#6366f1',
  status text check (status in ('active', 'completed', 'cancelled')) default 'active',
  created_at timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
alter table transactions enable row level security;
alter table budgets enable row level security;
alter table savings_goals enable row level security;

-- Policies untuk transactions
create policy "Users can view own transactions"
  on transactions for select using (auth.uid() = user_id);

create policy "Users can insert own transactions"
  on transactions for insert with check (auth.uid() = user_id);

create policy "Users can update own transactions"
  on transactions for update using (auth.uid() = user_id);

create policy "Users can delete own transactions"
  on transactions for delete using (auth.uid() = user_id);

-- Policies untuk budgets
create policy "Users can view own budgets"
  on budgets for select using (auth.uid() = user_id);

create policy "Users can insert own budgets"
  on budgets for insert with check (auth.uid() = user_id);

create policy "Users can update own budgets"
  on budgets for update using (auth.uid() = user_id);

create policy "Users can delete own budgets"
  on budgets for delete using (auth.uid() = user_id);

-- Policies untuk savings_goals
create policy "Users can view own savings goals"
  on savings_goals for select using (auth.uid() = user_id);

create policy "Users can insert own savings goals"
  on savings_goals for insert with check (auth.uid() = user_id);

create policy "Users can update own savings goals"
  on savings_goals for update using (auth.uid() = user_id);

create policy "Users can delete own savings goals"
  on savings_goals for delete using (auth.uid() = user_id);

-- ============================================================
-- INDEX untuk performa
-- ============================================================
create index if not exists idx_transactions_user_date on transactions(user_id, date desc);
create index if not exists idx_transactions_user_type on transactions(user_id, type);
create index if not exists idx_budgets_user_month on budgets(user_id, year, month);
create index if not exists idx_savings_goals_user on savings_goals(user_id);
