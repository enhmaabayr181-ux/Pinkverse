# Pink Verse — Supabase-connected preview source

Supabase project ID: `jkfiwammkhwqunsqwgbn` (Kindertrack organization). Database tables and RLS policies already exist and the first series and three episode records were created.

**Deployment status:** Vercel project creation was denied with HTTP 403. No live deployment URL has been produced. `npm install` timed out in this environment, so a successful Next.js build is not yet verified. This archive contains updated application source, not a tested live release.

## Important changes

- Adapted series to `cover_path` and `status = published/draft`.
- Adapted episodes to `episode_number`, `status`, `published_at`, and `price_mnt`.
- Adapted pages to `page_number` and `storage_path`.
- Free panel uploads target public `pinkverse-covers` Storage, private/draft paid panel uploads target private `pinkverse-pages` Storage. Paid episodes remain locked until a secure checkout + signed-image-delivery service is implemented.
- Signup uses Supabase Auth; profile creation is handled by a database trigger. Initial admin role must be assigned by a privileged operator in SQL Editor after signup.

## Setup

1. Install Node 22 and run `npm install` in the project directory.
2. Copy `.env.example` to `.env.local`.
3. In Supabase dashboard for Pinkverse, find **Settings → API Keys** and paste the public **publishable** key (not a secret or service role key) into `.env.local`. The project URL is already set.
4. Run `npm run lint` and `npm run build`; fix any issues before deploying.
5. Create a new Vercel project for this repository, configure the two `NEXT_PUBLIC_` environment variables and deploy a **preview**.
6. Set Supabase Auth Site URL and Redirect URLs to the real preview domain; register a test user.
7. In a privileged Supabase SQL editor, set the admin role using the actual authenticated user ID. Never expose a browser admin-role selection.
8. Upload final original comic panels from the admin UI and validate free-reader access, Auth, Storage and RLS with real test accounts.

**Do not run** the bundled old `supabase/schema.sql` or `supabase/seed.sql` against this existing project. They describe an older schema and are retained only as historical source. The real Supabase database was configured separately.

## Launch blockers

Do not enable paid episodes until QPay verification and server-only entitlement checks are complete. Private paid-panel storage objects need short-lived signed URLs issued by an authenticated server after verifying episode access. The existing browser client cannot unlock them. Additional testing required for auth flows and admin upload.

## Demonstration mode

Without env vars, the app shows illustrative series and placeholder storyboard frames. Login, saving data, and admin writes do not work until Supabase is connected. Demo content is not persisted. The first episode uses explanatory storyboard SVG placeholders, **not final illustrated panels**.

## Safety / launch blockers

- Do not upload paid episode panels to the public storage bucket. Implement a separate PRIVATE bucket plus server-side verified purchases and short-lived signed URLs first.
- QPay is not implemented. The UI must not collect payments, grant entitlements, or imply paid unlock works.
- Email auth requires configured redirect URLs and SMTP limits review.
- Before selling, verify Pink Verse naming/trademark, publisher rights, terms, privacy and refund policies, and QPay merchant agreement.
- Admin grants are manual and privileged; no browser-based role escalation.

## Data

The SQL schema includes RLS for all public tables, a secure admin-role helper, user profile trigger, series, episodes, episode_pages, follows, reading_progress, and restricted admin upload. With a fresh Supabase project, demo series are replaced with the database content after loading.