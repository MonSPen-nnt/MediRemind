# Flutter Firebase Auth setup

Bat provider Email/Password trong Firebase Console:

1. Firebase Console -> Authentication.
2. Sign-in method.
3. Enable Email/Password.

App dang khoi tao Firebase bang `--dart-define`, vi vay khi chay app can truyen
cac gia tri lay tu Firebase app config:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=your-api-key \
  --dart-define=FIREBASE_APP_ID=your-app-id \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id \
  --dart-define=FIREBASE_PROJECT_ID=your-project-id \
  --dart-define=FIREBASE_AUTH_DOMAIN=your-project-id.firebaseapp.com \
  --dart-define=FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
```

Ban cung co the dung FlutterFire CLI theo huong dan chinh thuc:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Neu dung FlutterFire CLI, co the doi `lib/main.dart` sang:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

va import file `firebase_options.dart` duoc CLI sinh ra.

