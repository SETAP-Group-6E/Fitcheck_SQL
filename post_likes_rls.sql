-- Prevent duplicate likes and enforce that only the liking user can insert/delete their like.

BEGIN;

-- Unique index on storage_key + user_id to prevent duplicate likes for same storage_key
CREATE UNIQUE INDEX IF NOT EXISTS post_likes_storage_user_idx ON public.post_likes (storage_key, user_id);

-- Enable Row Level Security
ALTER TABLE IF EXISTS public.post_likes ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read likes (adjust if you want to restrict)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'post_likes' AND policyname = 'select_post_likes'
  ) THEN
    CREATE POLICY select_post_likes ON public.post_likes FOR SELECT USING (true);
  END IF;
END$$;

-- Allow insert only when the inserted user_id equals the authenticated user
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'post_likes' AND policyname = 'insert_post_likes'
  ) THEN
    CREATE POLICY insert_post_likes ON public.post_likes FOR INSERT WITH CHECK (user_id = auth.uid()::uuid);
  END IF;
END$$;

-- Allow delete only by the owner (user_id matches auth.uid())
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'post_likes' AND policyname = 'delete_post_likes'
  ) THEN
    CREATE POLICY delete_post_likes ON public.post_likes FOR DELETE USING (user_id = auth.uid()::uuid);
  END IF;
END$$;

COMMIT;

