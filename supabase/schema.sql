-- Pink Verse MVP: run on a new dedicated Supabase project only.
create extension if not exists pgcrypto;
create table if not exists public.profiles(id uuid primary key references auth.users(id) on delete cascade,display_name text,role text not null default 'reader' check(role in ('reader','admin')),created_at timestamptz not null default now());
create table if not exists public.series(id uuid primary key default gen_random_uuid(),slug text unique not null,title text not null,description text not null default '',genre text not null default 'Романтик',cover_url text not null default '',status text not null default 'ongoing' check(status in ('ongoing','completed','coming')),created_at timestamptz not null default now());
create table if not exists public.episodes(id uuid primary key default gen_random_uuid(),series_id uuid not null references public.series(id) on delete cascade,number int not null check(number>0),title text not null,is_free boolean not null default true,published boolean not null default false,created_at timestamptz not null default now(),unique(series_id,number));
create table if not exists public.episode_pages(id uuid primary key default gen_random_uuid(),episode_id uuid not null references public.episodes(id) on delete cascade,position int not null check(position>0),image_url text not null,caption text,unique(episode_id,position));
create table if not exists public.follows(user_id uuid not null references auth.users(id) on delete cascade,series_id uuid not null references public.series(id) on delete cascade,primary key(user_id,series_id));
create table if not exists public.reading_progress(user_id uuid not null references auth.users(id) on delete cascade,episode_id uuid not null references public.episodes(id) on delete cascade,last_page int not null default 1,updated_at timestamptz not null default now(),primary key(user_id,episode_id));
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path='' as $$ select exists(select 1 from public.profiles where id=(select auth.uid()) and role='admin') $$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;
create or replace function public.create_user_profile() returns trigger language plpgsql security definer set search_path='' as $$ begin insert into public.profiles(id,display_name,role) values(new.id,coalesce(new.raw_user_meta_data->>'name',''),'reader');return new;end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.create_user_profile();
alter table public.profiles enable row level security;
alter table public.series enable row level security;
alter table public.episodes enable row level security;
alter table public.episode_pages enable row level security;
alter table public.follows enable row level security;
alter table public.reading_progress enable row level security;
create policy profiles_select_self on public.profiles for select to authenticated using (id=(select auth.uid()));
create policy series_read_public on public.series for select to anon,authenticated using (true);
create policy series_admin_write on public.series for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));
create policy episodes_read_public on public.episodes for select to anon,authenticated using(published=true);
create policy episodes_read_admin on public.episodes for select to authenticated using ((select public.is_admin()));
create policy episodes_admin_write on public.episodes for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));
create policy pages_read_free on public.episode_pages for select to anon,authenticated using (exists(select 1 from public.episodes e where e.id=episode_id and e.published=true and e.is_free=true));
create policy pages_read_admin on public.episode_pages for select to authenticated using ((select public.is_admin()));
create policy pages_admin_write on public.episode_pages for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));
create policy follows_select on public.follows for select to authenticated using(user_id=(select auth.uid()));
create policy follows_insert on public.follows for insert to authenticated with check(user_id=(select auth.uid()));
create policy follows_delete on public.follows for delete to authenticated using(user_id=(select auth.uid()));
create policy progress_select on public.reading_progress for select to authenticated using(user_id=(select auth.uid()));
create policy progress_insert on public.reading_progress for insert to authenticated with check(user_id=(select auth.uid()));
create policy progress_update on public.reading_progress for update to authenticated using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));
grant select on public.series,public.episodes,public.episode_pages to anon;
grant select on public.series,public.episodes,public.episode_pages,public.profiles,public.follows,public.reading_progress to authenticated;
grant insert,update,delete on public.series,public.episodes,public.episode_pages,public.follows,public.reading_progress to authenticated;
-- WARNING: This bucket is PUBLIC. Use only for free published panels and covers.
-- Paid panels must use a PRIVATE bucket with verified entitlements before launch.
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('comic-pages','comic-pages',true,10485760,array['image/jpeg','image/png','image/webp']) on conflict(id) do nothing;
create policy comic_pages_upload_admin on storage.objects for insert to authenticated with check(bucket_id='comic-pages' and (select public.is_admin()));
create policy comic_pages_delete_admin on storage.objects for delete to authenticated using(bucket_id='comic-pages' and (select public.is_admin()));
-- Bootstrap admin manually with the user's UUID after signup, in SQL editor using privileged access:
-- update public.profiles set role='admin' where id='YOUR-USER-UUID';