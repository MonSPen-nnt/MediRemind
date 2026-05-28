ALTER TABLE users
  ADD COLUMN IF NOT EXISTS firebase_uid VARCHAR(128),
  ADD COLUMN IF NOT EXISTS email_verified BOOLEAN DEFAULT FALSE;

CREATE UNIQUE INDEX IF NOT EXISTS users_firebase_uid_unique
  ON users(firebase_uid)
  WHERE firebase_uid IS NOT NULL;

UPDATE users
SET email_verified = COALESCE(is_verified, FALSE)
WHERE email_verified IS NULL;

