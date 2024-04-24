# anki_progress

This README file is intended for developers who want to contribute to this project

## FAQ

### Assessing Anki database

refer to https://docs.ankiweb.net/files.html

### Anki database structure

doc exists for AnkiDroid: https://github.com/ankidroid/Anki-Android/wiki/Database-Structure  
but not available for Anki

### Build windows app

run `flutter build windows`
put [sqlite3.dll](https://github.com/tekartik/sqflite/raw/master/sqflite_common_ffi/lib/src/windows/sqlite3.dll)
in the same folder
ref: https://pub.dev/packages/sqflite_common_ffi

### rename app

ref: https://pub.dev/packages/rename
run

```bash
flutter pub global activate rename
flutter pub global run rename getAppName --targets android,ios,web,windows,macos,linux
flutter pub global run rename setAppName --targets android,ios,web,windows,macos,linux --value "Anki Visualizer"
flutter pub global run rename getBundleId  --targets android,ios,web,windows,macos,linux
flutter pub global run rename setBundleId  --targets android --value "com.rapid_rabbit.anki_visualizer"
flutter pub global run rename setBundleId  --targets ios,macos --value "com.rapidrabbit.anki_visualizer"
flutter pub global run rename setBundleId  --targets windows --value "anki-visualizer"
```

### change icon

run `dart run flutter_launcher_icons`
ref: https://pub.dev/packages/flutter_launcher_icons