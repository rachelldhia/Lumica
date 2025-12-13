-- Migration: Create mood_entries table
-- Description: Stores user mood entries with timestamp for tracking emotional wellness

-- Create mood_entries table
CREATE TABLE IF NOT EXISTS public.mood_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    mood VARCHAR(20) NOT NULL CHECK (mood IN ('happy', 'calm', 'excited', 'angry', 'sad', 'stress')),
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_mood_entries_user_id ON public.mood_entries(user_id);
CREATE INDEX IF NOT EXISTS idx_mood_entries_timestamp ON public.mood_entries(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_mood_entries_user_timestamp ON public.mood_entries(user_id, timestamp DESC);

-- Enable Row Level Security (RLS)
ALTER TABLE public.mood_entries ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own mood entries" ON public.mood_entries;
DROP POLICY IF EXISTS "Users can insert their own mood entries" ON public.mood_entries;
DROP POLICY IF EXISTS "Users can update their own mood entries" ON public.mood_entries;
DROP POLICY IF EXISTS "Users can delete their own mood entries" ON public.mood_entries;

-- Create RLS policies
-- Policy: Users can only view their own mood entries
CREATE POLICY "Users can view their own mood entries"
    ON public.mood_entries
    FOR SELECT
    USING (auth.uid() = user_id);

-- Policy: Users can only insert their own mood entries
CREATE POLICY "Users can insert their own mood entries"
    ON public.mood_entries
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Policy: Users can only update their own mood entries
CREATE POLICY "Users can update their own mood entries"
    ON public.mood_entries
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Policy: Users can only delete their own mood entries
CREATE POLICY "Users can delete their own mood entries"
    ON public.mood_entries
    FOR DELETE
    USING (auth.uid() = user_id);

-- Create updated_at trigger function (if not exists)
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to auto-update updated_at
DROP TRIGGER IF EXISTS update_mood_entries_updated_at ON public.mood_entries;
CREATE TRIGGER update_mood_entries_updated_at
    BEFORE UPDATE ON public.mood_entries
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- Grant necessary permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.mood_entries TO authenticated;
GRANT USAGE ON SCHEMA public TO authenticated;
