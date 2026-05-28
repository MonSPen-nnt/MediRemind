# Flutter Firebase setup

Cac file sau **khong duoc commit** (da co trong `.gitignore`):

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist` (neu co)

## Cau hinh lan dau

1. Firebase Console -> Authentication -> Sign-in method -> bat **Email/Password**.
2. Cai FlutterFire CLI va dang nhap:

```bash
dart pub global activate flutterfire_cli
firebase login
```

3. Trong thu muc `mediremind_mobile`:

```bash
flutterfire configure
```

Lenh nay tao `lib/firebase_options.dart`, `android/app/google-services.json`, va `firebase.json`.

4. Backend: xem `backend/FIREBASE_AUTH_SETUP.md` de dat service account JSON vao `backend/secrets/`.

## Chay app

```bash
cd mediremind_mobile
flutter run -d chrome
```

Backend Docker phai chay: `docker compose up -d` (tu thu muc goc repo).

## File mau

Neu khong dung FlutterFire CLI, copy:

- `lib/firebase_options.example.dart` -> `lib/firebase_options.dart`
- `android/app/google-services.json.example` -> `android/app/google-services.json`

roi dien gia tri tu Firebase Console.
