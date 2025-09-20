# android_intent

A Flutter plugin demonstrating how to use [jnigen](https://pub.dev/packages/jnigen) to create Dart bindings for Android Intent functionality. This plugin allows you to send Android Intents directly from Flutter using auto-generated Dart bindings for native Android classes.

This project is featured in the blog post: [**Calling Android APIs from Flutter using jnigen**](https://roszkowski.dev/2025/android-jnigen/) which provides a detailed walkthrough of how this plugin was created using jnigen to generate Dart bindings for Android Intent APIs.

## Features

- Send email intents with pre-filled recipients, subject, and body
- Launch Android's contact picker and handle results
- Direct access to Android Intent, Context, Activity, and Uri classes through Dart bindings

## Example

The example app demonstrates two main use cases:

### 1. Opening Email with Pre-filled Data

```dart
void openEmailRaw() {
  final intent = a.Intent.new$2(a.Intent.ACTION_SENDTO);
  intent.setData(a.Uri.parse("mailto:".toJString()));

  intent.putExtra$21(
    a.Intent.EXTRA_EMAIL,
    JArray.of<JString>(JString.type, ["example@example.com".toJString()]),
  );
  intent.putExtra$8(a.Intent.EXTRA_SUBJECT, "Subject".toJString());
  intent.putExtra$8(a.Intent.EXTRA_TEXT, "Email body".toJString());

  final contextInstance = a.Context.fromReference(Jni.getCachedApplicationContext());
  contextInstance.startActivity(intent);
}
```

### 2. Contact Picker with Result Handling

```dart
void selectContact() {
  final intent = a.Intent.new$2(a.Intent.ACTION_PICK);
  intent.setType(a.ContactsContract$Contacts.CONTENT_TYPE);

  final listener = a.ActivityResultListenerProxy.Companion.getInstance();
  listener.setOnResultListener(/* handle result */);

  final activity = a.Activity.fromReference(Jni.getCurrentActivity());
  activity.startActivityForResult(intent, 1);
}
```

## Usage

Add this plugin to your `pubspec.yaml`:

```yaml
dependencies:
  android_intent: ^0.0.1
  jni: ^0.14.2
```

Then import and use the generated bindings:

```dart
import 'package:android_intent/android_intent.dart' as android_intent;
import 'package:jni/jni.dart';

// Create and send an Intent
final intent = android_intent.Intent.new$2(android_intent.Intent.ACTION_VIEW);
intent.setData(android_intent.Uri.parse("https://flutter.dev".toJString()));

final context = android_intent.Context.fromReference(Jni.getCachedApplicationContext());
context.startActivity(intent);
```

## Contributing

### Regenerating Bindings

Before regenerating bindings you need to build the example app in release at lest once.

```
cd example
flutter build apk --release
```

Then you can regenerate bindings with:

```
dart run jnigen --config jnigen.yaml
```
