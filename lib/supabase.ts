import {createClient, type SupabaseClient} from '@supabase/supabase-js';
export const configured=!!(process.env.NEXT_PUBLIC_SUPABASE_URL&&process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY);
let client:SupabaseClient|null=null;
export function supabase(){if(!configured)return null;if(!client)client=createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!,process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,{auth:{persistSession:true,autoRefreshToken:true,detectSessionInUrl:true}});return client}