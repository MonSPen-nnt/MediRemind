# MediRemind Mobile

Flutter app cho MediRemind.

## Thiet lap

1. Cau hinh Firebase: xem [FIREBASE_AUTH_SETUP.md](FIREBASE_AUTH_SETUP.md).
2. Chay backend (tu thu muc goc repo): `docker compose up -d`.
3. Chay app:

```bash
flutter pub get
flutter run -d chrome
```

Tren may Android that: `flutter run --dart-define=DEV_HOST=<IP-LAN-cua-PC>`.
