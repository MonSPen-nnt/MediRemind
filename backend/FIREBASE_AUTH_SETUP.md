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

## Backend environment

Tao service account trong Firebase Console:

1. Project settings -> Service accounts.
2. Generate new private key.
3. Lay `project_id`, `client_email`, `private_key` dua vao `.env`.

```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project-id.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
```

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

