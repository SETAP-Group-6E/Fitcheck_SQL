-- Enable RLS and add policies for comments table
-- Allows authenticated users to select comments and insert/delete their own comments

BEGIN;

-- create an index for storage_key lookups
CREATE INDEX IF NOT EXISTS comments_storage_key_idx ON comments USING btree (storage_key);

-- enable row level security
ALTER TABLE IF EXISTS comments ENABLE ROW LEVEL SECURITY;

-- allow authenticated users to select comments (readable by all authenticated users)
CREATE POLICY select_comments ON comments
  FOR SELECT
  USING (auth.role() = 'authenticated');

-- allow authenticated users to insert comments; ensure user_id matches auth.uid()
CREATE POLICY insert_comments ON comments
  FOR INSERT
  WITH CHECK (user_id = auth.uid()::uuid);

-- allow users to delete their own comments
CREATE POLICY delete_own_comments ON comments
  FOR DELETE
  USING (user_id = auth.uid()::uuid);

COMMIT;
