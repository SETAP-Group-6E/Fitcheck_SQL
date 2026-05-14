-- create post_comments table and migrate existing comments


BEGIN;

-- Create post_comments table expected by the app
CREATE TABLE IF NOT EXISTS public.post_comments (
  id serial PRIMARY KEY,
  post_key text NOT NULL,
  user_id text,
  body text NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_post_comments_post_key ON public.post_comments(post_key);

-- If an older 'comments' table exists, copy rows into post_comments
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='comments')
     AND (SELECT count(*) FROM public.post_comments) = 0 THEN
    INSERT INTO public.post_comments (post_key, user_id, body, created_at)
    SELECT post_id::text, user_id::text, body, created_at
    FROM public.comments;
  END IF;
END
$$;

COMMIT;

