# Cuore

It is a mobile app that manages the OKIGUSURI.

## Getting Started

1. Install Flutter. (https://flutter.dev/docs/get-started/install)
2. Install Android studio. (https://developer.android.com/studio)
3. Get SHA Fingerprint and set Firebase. (see https://qiita.com/hiraokusky/items/8a83fd3d84e0cbe583c8#android-studio%E3%81%A7sha-%E8%A8%BC%E6%98%8E%E6%9B%B8%E3%83%95%E3%82%A3%E3%83%B3%E3%82%AC%E3%83%BC%E3%83%97%E3%83%AA%E3%83%B3%E3%83%88%E3%82%92%E5%BE%97%E3%82%8B)
4. Create secret.dart. (see below)

    1. Rename from lib/secret_tmpl.dart to lib/secret.dart.
    2. Set GoogleSheetsId to sheetId of secret.dart.
    3. Set serviceAccountKey at secret.dart by Goolge Cloud Platform.
    4. Put google-services.json to android/app.

## Build & Run

1. Connect your android devece by USB and enable debug mode.
2. Run command in ternimal.

    ```
    $ flutter run
    ```

----
Powered by AfriMedico
https://afrimedico.org/
