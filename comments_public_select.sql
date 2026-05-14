-- Allow public (anonymous) SELECT on comments so non-authenticated users can view comments

BEGIN;

-- drop existing select policy if present
DROP POLICY IF EXISTS select_comments ON comments;

-- create a policy that allows anyone (including anon) to SELECT from comments
CREATE POLICY select_comments ON comments
  FOR SELECT
  USING (true);

COMMIT;
