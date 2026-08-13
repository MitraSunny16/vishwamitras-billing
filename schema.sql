-- Vishwamitra's Gallery - Stock & Billing App
-- Run this in Supabase SQL Editor (SQL Editor -> New query -> Run)

create table if not exists public.products (
  id bigint generated always as identity primary key,
  name text not null,
  cost_price numeric not null default 0,
  selling_price numeric not null default 0,
  stock numeric not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.bills (
  id bigint generated always as identity primary key,
  customer_name text default 'Walk-in Customer',
  total numeric not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.bill_items (
  id bigint generated always as identity primary key,
  bill_id bigint not null references public.bills(id) on delete cascade,
  product_id bigint references public.products(id),
  name text not null,
  price numeric not null,
  qty numeric not null default 1,
  subtotal numeric not null default 0
);

-- Enable RLS
alter table public.products enable row level security;
alter table public.bills enable row level security;
alter table public.bill_items enable row level security;

-- Policies for logged-in (authenticated) users only
create policy "products_authenticated" on public.products
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

create policy "bills_authenticated" on public.bills
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

create policy "bill_items_authenticated" on public.bill_items
  for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
