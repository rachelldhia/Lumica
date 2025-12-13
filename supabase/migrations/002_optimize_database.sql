-- Migration: Optimize Database Performance and Security
-- Description: Fixes security vulnerabilities, performance issues, and adds missing constraints
-- Date: 2024-12-14

-- =============================================================================
-- 1. ADD MISSING INDEX ON CHATS TABLE
-- =============================================================================
-- This fixes the "unindexed foreign keys" warning for better query performance
CREATE INDEX IF NOT EXISTS idx_chats_user_id ON public.chats(user_id);
CREATE INDEX IF NOT EXISTS idx_chats_created_at ON public.chats(created_at DESC);

-- =============================================================================
-- 2. UPDATE MOOD ENTRIES CONSTRAINT TO INCLUDE 'DESPAIR'
-- =============================================================================
-- The app supports 'despair' emotion but the DB constraint doesn't include it
ALTER TABLE public.mood_entries 
DROP CONSTRAINT IF EXISTS mood_entries_mood_check;

ALTER TABLE public.mood_entries 
ADD CONSTRAINT mood_entries_mood_check 
CHECK (mood::text = ANY (ARRAY['happy', 'calm', 'excited', 'angry', 'sad', 'stress', 'despair']::text[]));

-- =============================================================================
-- 3. FIX FUNCTION SEARCH_PATH SECURITY VULNERABILITIES
-- =============================================================================
-- Setting search_path prevents SQL injection via search_path manipulation

-- Fix handle_new_user function
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, username, avatar_url, created_at)
  VALUES (
    new.id, 
    COALESCE(new.raw_user_meta_data->>'name', new.raw_user_meta_data->>'full_name'),
    new.raw_user_meta_data->>'avatar_url',
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN new;
END;
$$;

-- Fix handle_updated_at function
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- Fix update_updated_at_column function
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- =============================================================================
-- 4. CONSOLIDATE DUPLICATE RLS POLICIES ON PROFILES TABLE
-- =============================================================================
-- Remove duplicate policies and recreate with optimized (select auth.uid()) pattern

-- Drop all existing policies on profiles
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile." ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile." ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON public.profiles;

-- Recreate with optimized pattern using (select auth.uid())
-- This prevents re-evaluation for each row, improving performance

-- Allow users to view all profiles (for displaying other users' info)
CREATE POLICY "profiles_select_policy" ON public.profiles
FOR SELECT USING (true);

-- Users can only insert their own profile
CREATE POLICY "profiles_insert_policy" ON public.profiles
FOR INSERT WITH CHECK ((select auth.uid()) = id);

-- Users can only update their own profile
CREATE POLICY "profiles_update_policy" ON public.profiles
FOR UPDATE USING ((select auth.uid()) = id);

-- Users can only delete their own profile
CREATE POLICY "profiles_delete_policy" ON public.profiles
FOR DELETE USING ((select auth.uid()) = id);

-- =============================================================================
-- 5. OPTIMIZE OTHER TABLE RLS POLICIES (Optional - for consistency)
-- =============================================================================

-- Optimize journals table policies
DROP POLICY IF EXISTS "Users can view their own journals" ON public.journals;
DROP POLICY IF EXISTS "Users can insert their own journals" ON public.journals;
DROP POLICY IF EXISTS "Users can update their own journals" ON public.journals;
DROP POLICY IF EXISTS "Users can delete their own journals" ON public.journals;

CREATE POLICY "journals_select_policy" ON public.journals
FOR SELECT USING ((select auth.uid()) = user_id);

CREATE POLICY "journals_insert_policy" ON public.journals
FOR INSERT WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY "journals_update_policy" ON public.journals
FOR UPDATE USING ((select auth.uid()) = user_id);

CREATE POLICY "journals_delete_policy" ON public.journals
FOR DELETE USING ((select auth.uid()) = user_id);

-- Optimize chats table policies
DROP POLICY IF EXISTS "Users can view their own chats" ON public.chats;
DROP POLICY IF EXISTS "Users can insert their own chats" ON public.chats;
DROP POLICY IF EXISTS "Users can delete their own chats" ON public.chats;

CREATE POLICY "chats_select_policy" ON public.chats
FOR SELECT USING ((select auth.uid()) = user_id);

CREATE POLICY "chats_insert_policy" ON public.chats
FOR INSERT WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY "chats_delete_policy" ON public.chats
FOR DELETE USING ((select auth.uid()) = user_id);

-- =============================================================================
-- 6. VERIFY CHANGES
-- =============================================================================
-- Run these queries to verify the migration was successful:
-- SELECT indexname FROM pg_indexes WHERE tablename = 'chats';
-- SELECT polname FROM pg_policies WHERE tablename = 'profiles';
-- SELECT proname, prosecdef FROM pg_proc WHERE proname LIKE 'handle%';
