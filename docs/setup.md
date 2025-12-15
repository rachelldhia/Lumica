# Lumica Setup Guide

## Prerequisites

- Flutter SDK 3.10.1 or higher
- Dart SDK 3.10.1 or higher
- Android Studio / Xcode (for mobile development)
- A Supabase account
- A Google AI (Gemini) API key

---

## 1. Clone the Repository

```bash
git clone <repository-url>
cd lumica_app
```

---

## 2. Install Dependencies

```bash
flutter pub get
```

---

## 3. Environment Configuration

### Create `.env` File

Copy the example environment file:

```bash
cp .env.example .env
```

### Configure API Keys

Open `.env` and fill in your credentials:

#### **Supabase Setup**

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Create a new project or select existing one
3. Navigate to **Settings** → **API**
4. Copy the following:
   - **Project URL** → `SUPABASE_URL`
   - **anon/public key** → `SUPABASE_ANON_KEY`

#### **Google Gemini AI Setup**

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Copy the key → `GEMINI_API_KEY`

#### **Example `.env` File**

```env
SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
GEMINI_API_KEY=AIzaSyxxxxxxxxxxxxxxxxxxxxxxxxxx
```

> ⚠️ **IMPORTANT**: Never commit `.env` to version control!

---

## 4. Supabase Database Setup

### Run Migrations

Navigate to your Supabase project dashboard:

1. Go to **SQL Editor**
2. Run the migration files from `supabase/migrations/`

**Required Tables:**

- `public.users` - User profiles
- `public.notes` - Journal entries
- `public.mood_entries` - Mood tracking data

### Enable Row Level Security (RLS)

Make sure RLS is enabled for all tables:

```sql
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mood_entries ENABLE ROW LEVEL SECURITY;
```

---

## 5. Run the App

### Debug Mode

```bash
flutter run
```

### Release Mode (Android)

```bash
flutter build apk --release
```

### Release Mode (iOS)

```bash
flutter build ios --release
```

---

## 6. Troubleshooting

### Issue: "API Key not found"

**Solution:** Ensure `.env` file exists in the project root and contains valid keys.

### Issue: "Supabase connection failed"

**Solution:**

- Check internet connection
- Verify `SUPABASE_URL` and `SUPABASE_ANON_KEY` are correct
- Ensure Supabase project is not paused

### Issue: "Gemini API quota exceeded"

**Solution:**

- Check API usage at [Google AI Studio](https://makersuite.google.com)
- Wait for quota reset or upgrade plan
- The app has fallback models configured

---

## 7. Development Tips

### Hot Reload

- Press `r` in terminal to hot reload
- Press `R` for hot restart

### Debugging

- Use `debugPrint()` instead of `print()`
- Check Flutter DevTools for performance profiling

### Code Quality

```bash
# Run analyzer
flutter analyze

# Run tests
flutter test

# Format code
dart format .
```

---

## 8. Project Structure

```
lib/
├── core/           # Shared utilities, widgets, config
├── data/           # Data layer (repositories, services)
├── domain/         # Domain layer (entities, interfaces)
├── features/       # Feature modules
├── routes/         # Navigation
└── main.dart       # Entry point
```

---

## Need Help?

- Check the [Architecture Documentation](architecture.md)
- Review the [Audit Report](../audit_report.md)
- Create an issue in the repository

---

**Happy Coding! 🚀**
