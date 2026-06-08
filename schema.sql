-- Kör detta i Supabase > SQL Editor

-- KATEGORIER
create table categories (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  slug text not null unique,
  created_at timestamp with time zone default now()
);

-- PRODUKTER
create table products (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  description text,
  price text not null,
  price_suffix text default '/ st',
  category_id uuid references categories(id) on delete set null,
  image_url text,
  badge text,
  badge_type text default 'default', -- default | new | sale | popular
  active boolean default true,
  created_at timestamp with time zone default now()
);

-- ORDRAR / KONTAKTFÖRFRÅGNINGAR
create table orders (
  id uuid default gen_random_uuid() primary key,
  customer_name text not null,
  customer_email text not null,
  customer_phone text,
  product_id uuid references products(id) on delete set null,
  product_name text,
  message text,
  status text default 'ny', -- ny | hanterad | stängd
  created_at timestamp with time zone default now()
);

-- RLS: Produkter och kategorier är publikt läsbara
alter table products enable row level security;
alter table categories enable row level security;
alter table orders enable row level security;

create policy "Public read products" on products for select using (true);
create policy "Public read categories" on categories for select using (true);
create policy "Public insert orders" on orders for insert with check (true);
create policy "Auth full access products" on products for all using (auth.role() = 'authenticated');
create policy "Auth full access categories" on categories for all using (auth.role() = 'authenticated');
create policy "Auth full access orders" on orders for all using (auth.role() = 'authenticated');

-- STANDARDKATEGORIER
insert into categories (name, slug) values
  ('Belysning', 'belysning'),
  ('EV-Laddning', 'laddning'),
  ('Säkerhet', 'sakerhet'),
  ('Smart Hem', 'smarthome'),
  ('Installation', 'installation');

-- EXEMPELPRODUKTER
insert into products (name, description, price, price_suffix, image_url, badge, badge_type, category_id)
select 'LED Panelbelysning Pro', 'Energieffektiv LED-panel för kontor och hem. 60×60 cm, 40W, 4000K neutral vit. Upp till 50 000 h livslängd och 60% energibesparing.', '895', '/ st', 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?w=600&q=80', 'Belysning', 'default', id from categories where slug='belysning'
union all
select 'Dimbar Spotlight GU10', 'Stilren infälld spotlight med dimfunktion. Vridbar 35°, 7W LED, varmvit 2700K. Perfekt för accentbelysning.', '349', '/ st', 'https://images.unsplash.com/photo-1565814329452-e1efa11c5b89?w=600&q=80', 'Nyhet', 'new', id from categories where slug='belysning'
union all
select 'Wallbox Pulsar Plus 22kW', 'Snabbladdare med app-styrning. Upp till 22 kW, Type 2-kontakt, BRF-kompatibel med inbyggd lastbalansering.', '8490', '/ inkl. inst.', 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=600&q=80', 'EV-Laddning', 'default', id from categories where slug='laddning'
union all
select 'BRF Laddpaket – 4 platser', 'Komplett laddlösning för bostadsrättsföreningar med lastbalansering och automatisk debitering.', 'Offert', '', 'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=600&q=80', 'Populär', 'popular', id from categories where slug='laddning'
union all
select 'Smart Rökdetektor WiFi', 'Uppkopplad rökdetektor med mobilnotis och 10 års batteri. CE-godkänd och brandcertifierad.', '649', '/ st', 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=80', 'Säkerhet', 'default', id from categories where slug='sakerhet'
union all
select 'Smart Strömbrytare Z-Wave', 'Kompatibel med HomeKit, Google Home och Alexa. Schemaläggning och energimätning ingår.', '1195', '/ st', 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=80', 'Smart Hem', 'new', id from categories where slug='smarthome'
union all
select 'Elcentral 16-grupper', 'Modern elcentral med jordfelsbrytare och överspänningsskydd. Enkel montage med tydlig märkning.', '4290', '/ inkl. inst.', 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=600&q=80', 'Installation', 'default', id from categories where slug='installation';
