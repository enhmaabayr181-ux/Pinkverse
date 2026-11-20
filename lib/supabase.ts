import {createClient, type SupabaseClient} from '@supabase/supabase-js';
// Publishable key is designed for browser use. Never put service_role or sb_secret keys here.
// Vercel environment variables take precedence; fallback connects the public demo without dashboard setup.
const fallbackUrl = 'https://jkfiwammkhwqunsqwgbn.supabase.co';
const fallbackKey = "sb_publishable_k5GQ6SAcdDBIlMthZMg5jg_LkQQnIy_";
const url = process.env.NEXT_PUBLIC_SUPABASE_URL || fallbackUrl;
const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY || fallbackKey;
export const configured = Boolean(url && key);
let client: SupabaseClient | null = null;
export function supabase() {
  if (!configured) return null;
  if (!client) client = createClient(url,key,{auth:{persistSession:true,autoRefreshToken:true,detectSessionInUrl:true}});
  return client;
}
