-- Adds storage_key text columns and indexes to Post-related tables so the app
-- can use storage folder keys like "<userId>/<timestamp>" without UUID casts.

BEGIN;

ALTER TABLE IF EXISTS post ADD COLUMN IF NOT EXISTS storage_key text;
CREATE INDEX IF NOT EXISTS idx_post_storage_key ON post(storage_key);

ALTER TABLE IF EXISTS post_likes ADD COLUMN IF NOT EXISTS storage_key text;
CREATE INDEX IF NOT EXISTS idx_post_likes_storage_key ON post_likes(storage_key);

ALTER TABLE IF EXISTS comments ADD COLUMN IF NOT EXISTS storage_key text;
CREATE INDEX IF NOT EXISTS idx_comments_storage_key ON comments(storage_key);

ALTER TABLE IF EXISTS post_images ADD COLUMN IF NOT EXISTS storage_key text;
CREATE INDEX IF NOT EXISTS idx_post_images_storage_key ON post_images(storage_key);

COMMIT;

