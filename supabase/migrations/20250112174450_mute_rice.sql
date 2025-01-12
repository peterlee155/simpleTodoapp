/*
  # Create todos table for the Todo application

  1. New Tables
    - `todos`
      - `id` (uuid, primary key)
      - `task` (text, the todo item text)
      - `user_id` (uuid, references auth.users)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on `todos` table
    - Add policies for CRUD operations
*/

CREATE TABLE IF NOT EXISTS todos (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task text NOT NULL,
    user_id uuid REFERENCES auth.users(id),
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

ALTER TABLE todos ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to read their own todos
CREATE POLICY "Users can read own todos" 
    ON todos 
    FOR SELECT 
    TO authenticated 
    USING (auth.uid() = user_id);

-- Policy to allow users to insert their own todos
CREATE POLICY "Users can insert own todos" 
    ON todos 
    FOR INSERT 
    TO authenticated 
    WITH CHECK (auth.uid() = user_id);

-- Policy to allow users to update their own todos
CREATE POLICY "Users can update own todos" 
    ON todos 
    FOR UPDATE 
    TO authenticated 
    USING (auth.uid() = user_id);

-- Policy to allow users to delete their own todos
CREATE POLICY "Users can delete own todos" 
    ON todos 
    FOR DELETE 
    TO authenticated 
    USING (auth.uid() = user_id);