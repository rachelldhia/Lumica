# Database Setup - Lumica App

## Mood Entries Table Setup

### Option 1: Using Supabase Dashboard (Recommended for Quick Setup)

1. **Login ke Supabase Dashboard**
   - Buka [https://supabase.com](https://supabase.com)
   - Login dan pilih project Lumica

2. **Buka SQL Editor**
   - Di sidebar kiri, klik **SQL Editor**
   - Klik **New Query**

3. **Copy & Paste Migration Script**
   - Buka file `supabase/migrations/001_create_mood_entries_table.sql`
   - Copy seluruh konten file
   - Paste di SQL Editor
   - Klik **Run** (atau press Ctrl+Enter)

4. **Verifikasi Table**
   - Di sidebar, klik **Table Editor**
   - Cari table `mood_entries`
   - Pastikan struktur table sesuai dengan yang diharapkan

### Option 2: Using Supabase CLI (Recommended for Version Control)

1. **Install Supabase CLI** (jika belum)
   ```bash
   npm install -g supabase
   ```

2. **Login ke Supabase**
   ```bash
   supabase login
   ```

3. **Link Project**
   ```bash
   cd c:\Users\Aziz Yuwono\Documents\Projects\Mobile\Lumica
   supabase link --project-ref <your-project-ref>
   ```

4. **Apply Migration**
   ```bash
   supabase db push
   ```

### Table Structure

```sql
Table: mood_entries
├── id (UUID, Primary Key)
├── user_id (UUID, Foreign Key → auth.users)
├── mood (VARCHAR) - Values: happy, calm, excited, angry, sad, stress
├── timestamp (TIMESTAMPTZ)
├── notes (TEXT, Optional)
├── created_at (TIMESTAMPTZ)
└── updated_at (TIMESTAMPTZ)
```

### Security Features

✅ **Row Level Security (RLS) Enabled**
- Users can only view/insert/update/delete their own mood entries
- Prevents unauthorized access to other users' data

✅ **Indexes Created**
- Optimized queries for user_id and timestamp
- Faster mood statistics calculation

✅ **Auto-updated Timestamps**
- `created_at` auto-fills on insert
- `updated_at` auto-updates on modification

### Testing the Setup

After running the migration, test dengan:

```sql
-- Insert test data (ganti <your-user-id> dengan user ID dari auth.users)
INSERT INTO mood_entries (user_id, mood, notes)
VALUES ('<your-user-id>', 'happy', 'Feeling great today!');

-- Query test
SELECT * FROM mood_entries WHERE user_id = '<your-user-id>';
```

### Troubleshooting

**Error: "permission denied for schema public"**
- Solution: Run the GRANT commands dari migration script

**Error: "relation already exists"**
- Solution: Table sudah ada, skip migration atau drop table dulu

**RLS Policy Error**
- Solution: Pastikan user sudah authenticated di Supabase

## Next Steps

Setelah database setup:
1. ✅ Test navigation ke Mood Track page dari Home
2. ✅ Test mood selection di Home page
3. ✅ Verify mood statistics display correctly
4. ✅ Test mood saving functionality
