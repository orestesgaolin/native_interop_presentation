# PackageList

A Flutter application that demonstrates native Android interoperability using `JNI` (Java Native Interface) and `jnigen` to retrieve and display installed packages on an Android device.

## Features

- **Package Discovery**: Fetches all installed packages from the Android system using native platform APIs
- **Icon Retrieval**: Displays package icons by accessing native Android drawable resources
- **JNI Integration**: Demonstrates seamless communication between Dart/Flutter and native Android code using the `jni` package
- **Real-time Updates**: Refresh functionality to get the latest list of installed packages

## Technical Implementation

This project showcases:

- **Native Android Integration**: Uses a custom Kotlin class (`PackageRetriever`) to access Android PackageManager APIs
- **JNI Bindings**: Utilizes `jnigen` to automatically generate Dart bindings for the native Kotlin code
- **Image Processing**: Converts native Android drawables to byte arrays and displays them as Flutter Image widgets
- **State Management**: Implements stateful widgets to manage package data and loading states

## Dependencies

- `flutter`: Flutter framework
- `jni`: Java Native Interface for Dart
- `jnigen`: Code generator for JNI bindings

## Architecture

The app consists of:
- **Dart Layer**: Flutter UI with package list display (`main.dart`)
- **Native Layer**: Kotlin class for Android package operations (`PackageRetriever.kt`)
- **Bridge Layer**: Auto-generated JNI bindings (`package_retriever.dart`)

## Usage

1. Launch the app on an Android device or emulator
2. Tap the refresh button to load installed packages
3. Tap on any package item to load its icon
4. Scroll through the list to see all installed applications

## Screenshots

_Screenshots will be added here._
