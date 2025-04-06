/*
  # Fix profile creation trigger and add delete policy

  1. Changes
    - Update handle_new_user function to properly handle metadata
    - Add delete policy for profiles
    - Add indexes for better performance

  2. Security
    - Ensure proper RLS policies are in place
    - Add missing delete policy
*/

-- Drop existing trigger and function to recreate them
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS handle_new_user();

-- Recreate function with proper metadata handling
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(
      (NEW.raw_user_meta_data->>'role')::text,
      'student'
    )
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Add missing delete policy
CREATE POLICY "Users can delete own profile"
  ON profiles
  FOR DELETE
  TO authenticated
  USING (auth.uid() = id);

-- Add helpful indexes
CREATE INDEX IF NOT EXISTS profiles_email_idx ON profiles(email);
CREATE INDEX IF NOT EXISTS profiles_role_idx ON profiles(role);