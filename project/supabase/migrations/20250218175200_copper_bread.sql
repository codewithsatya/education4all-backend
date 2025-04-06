/*
  # Create videos table and security policies

  1. New Tables
    - `videos`
      - `id` (uuid, primary key)
      - `title` (text) - video title
      - `description` (text) - video description
      - `url` (text) - video URL
      - `tutor_id` (uuid) - reference to profiles table
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on `videos` table
    - Add policies for:
      - All authenticated users can view videos
      - Only tutors can create/update their own videos
*/

CREATE TABLE IF NOT EXISTS videos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  url text NOT NULL,
  tutor_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE videos ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "All authenticated users can view videos"
  ON videos
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Tutors can create videos"
  ON videos
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'tutor'
    )
  );

CREATE POLICY "Tutors can update their own videos"
  ON videos
  FOR UPDATE
  TO authenticated
  USING (tutor_id = auth.uid())
  WITH CHECK (tutor_id = auth.uid());