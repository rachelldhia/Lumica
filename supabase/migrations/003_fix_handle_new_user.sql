-- Migration: Fix handle_new_user trigger
-- Description: Maps 'name' metadata to 'display_name' column instead of 'username' to prevent unique constraint violations.
-- Date: 2025-12-15

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name, avatar_url, created_at)
  VALUES (
    new.id, 
    -- Map 'name' or 'full_name' from metadata to display_name
    COALESCE(new.raw_user_meta_data->>'name', new.raw_user_meta_data->>'full_name'),
    new.raw_user_meta_data->>'avatar_url',
    NOW()
  )
  -- Use ON CONFLICT to act as an upsert, just in case
  ON CONFLICT (id) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    avatar_url = EXCLUDED.avatar_url;
    
  RETURN new;
END;
$$;
