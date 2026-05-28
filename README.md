# MediRemind

Ung dung nhac uong thuoc — Flutter mobile/web + Express backend + PostgreSQL.

## Clone & chay nhanh

```bash
docker compose up -d
```

### Backend

1. `cp backend/.env.example backend/.env` (chinh sua neu can).
2. Dat Firebase service account JSON vao `backend/secrets/` — xem [backend/FIREBASE_AUTH_SETUP.md](backend/FIREBASE_AUTH_SETUP.md).
3. Migration (lan dau): `docker exec -i mediremind-postgres-1 psql -U postgres -d duanflutter < backend/firebase_auth_users.sql`

### Mobile / Web

1. Cau hinh Firebase client — xem [mediremind_mobile/FIREBASE_AUTH_SETUP.md](mediremind_mobile/FIREBASE_AUTH_SETUP.md).
2. `cd mediremind_mobile && flutter pub get && flutter run -d chrome`

## Khong commit len GitHub

| File / thu muc | Ly do |
|----------------|--------|
| `backend/.env` | Mat khau DB, Firebase Admin |
| `backend/secrets/*.json` | Service account (quyen admin) |
| `mediremind_mobile/lib/firebase_options.dart` | API keys Firebase client |
| `mediremind_mobile/android/app/google-services.json` | Cau hinh Firebase Android |
| `.codex_appdata/` | Du lieu local IDE |

Dung file `.example` va huong dan trong `FIREBASE_AUTH_SETUP.md` de cau hinh lai sau khi clone.
