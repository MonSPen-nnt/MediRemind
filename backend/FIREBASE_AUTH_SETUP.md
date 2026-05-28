# Firebase Auth setup

Luong dang nhap hien tai:

1. Flutter dang ky/dang nhap bang Firebase Auth.
2. Flutter lay Firebase ID token.
3. Flutter gui token toi `POST /api/auth/firebase`.
4. Backend verify token bang Firebase Admin SDK.
5. Backend tao hoac cap nhat user trong PostgreSQL.

## Database

Neu bang `users` da ton tai, chay migration:

```bash
psql -U postgres -d duanflutter -f firebase_auth_users.sql
```

Voi Firebase Auth, backend khong nhan hoac luu mat khau that. Cot
`password_hash` duoc giu lai de tuong thich schema hien tai va nhan gia tri
`FIREBASE_AUTH`.

## Backend environment (project: mediremind-79)

### Cach nhanh (khuyen dung)

1. Mo [Firebase Console](https://console.firebase.google.com/) -> project **mediremind-79**.
2. Project settings (bánh răng) -> tab **Service accounts**.
3. **Generate new private key** -> tai file `.json`.
4. Doi ten file thanh `firebase-service-account.json` va copy vao `backend/secrets/`.
5. Khoi dong lai backend:

```bash
docker compose restart backend
```

Docker mount thu muc `backend/secrets` vao container.

### Cach thay the: bien moi truong

Copy `project_id`, `client_email`, `private_key` tu file JSON vao `backend/.env`:

```env
FIREBASE_PROJECT_ID=mediremind-79
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@mediremind-79.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
```

Xem mau day du trong `backend/.env.example`.

## Endpoint

```text
POST http://localhost:3001/api/auth/firebase
```

```json
{
  "idToken": "firebase-id-token-from-client",
  "fullName": "Nguyen Van A"
}
```

