import { createClient } from '@supabase/supabase-js';

// Ensure environment variables are defined
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  throw new Error(
    'Please click "Connect to Supabase" button in the top right to set up your database connection.'
  );
}

export const supabase = createClient(supabaseUrl, supabaseKey);