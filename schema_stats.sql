-- Kör detta i Supabase > SQL Editor

-- SIDVISNINGAR
create table page_views (
  id uuid default gen_random_uuid() primary key,
  page text not null,
  referrer text,
  created_at timestamp with time zone default now()
);

-- SÖKNINGAR / FILTERKLICK
create table search_queries (
  id uuid default gen_random_uuid() primary key,
  query text not null,
  results_count int default 0,
  created_at timestamp with time zone default now()
);

-- RLS: Alla kan logga, bara inloggade kan läsa
alter table page_views enable row level security;
alter table search_queries enable row level security;

create policy "Public insert page_views" on page_views for insert with check (true);
create policy "Public insert search_queries" on search_queries for insert with check (true);
create policy "Auth read page_views" on page_views for select using (auth.role() = 'authenticated');
create policy "Auth read search_queries" on search_queries for select using (auth.role() = 'authenticated');
