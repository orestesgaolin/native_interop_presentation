import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/code_highlight_slide.dart';
import 'package:slides/terminal_slide.dart';
import 'package:video_player/video_player.dart';

class AndroidEmulatorRunSlide extends FlutterDeckSlideWidget {
  const AndroidEmulatorRunSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/android-emulator-run',
          title: 'Running the app',
          speakerNotes: '',
          steps: 1,
          header: FlutterDeckHeaderConfiguration(
            title: 'Running the app',
            showHeader: true,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlideStepsBuilder(
      builder: (context, stepNumber) {
        return FlutterDeckSlide.blank(
          builder: (context) {
            return Center(child: MyVideoPlayer());
          },
        );
      },
    );
  }
}

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({
    super.key,
  });

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/android.mp4', viewType: VideoViewType.platformView);
    
    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initialize();
    _controller.play();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: -20,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: VideoPlayer(
        _controller,
      ),
    );
  }
}

get dartSlides {
  final dartLines = '|23-38|32-33|61-70|41-47';
  final jniLines = '|40|108-120';
  return [
    (dartCode, 1, dartLines, dartFileName, 'dart'),
    (dartCode, 2, dartLines, dartFileName, 'dart'),
    (dartCode, 3, dartLines, dartFileName, 'dart'),
    (dartCode, 4, dartLines, dartFileName, 'dart'),
    (dartCode, 5, dartLines, dartFileName, 'dart'),
    (jniGeneratedCode, 1, jniLines, jniFileName, 'dart'),
    (jniGeneratedCode, 2, jniLines, jniFileName, 'dart'),
    (jniGeneratedCode, 3, jniLines, jniFileName, 'dart'),
  ];
}

class DartInteropCodeSlide extends FlutterDeckSlideWidget {
  DartInteropCodeSlide({super.key})
    : super(
        configuration: FlutterDeckSlideConfiguration(
          route: '/dart-interop-code',
          title: 'Dart interop code',
          speakerNotes: '',
          steps: dartSlides.length,
          header: FlutterDeckHeaderConfiguration(
            title: 'On the Dart side',
            showHeader: true,
          ),
        ),
      );

  static List<List<int>> _parseHighlights(String data) {
    try {
      if (data.isEmpty) return [[]];
      return data.split('|').map((step) {
        List<int> lines = [];
        for (String range in step.split(',')) {
          if (range.contains('-')) {
            var parts = range.split('-').map(int.parse).toList();
            for (int i = parts[0]; i <= parts[1]; i++) {
              lines.add(i);
            }
          } else {
            final parsed = int.tryParse(range);
            if (parsed != null) {
              lines.add(parsed);
            }
          }
        }
        return lines;
      }).toList();
    } catch (e) {
      print('Error parsing highlights: $e');
      return [[]];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlideStepsBuilder(
      builder: (context, stepNumber) {
        final slidesForStep = dartSlides[stepNumber - 1];
        final highlightsForStep = _parseHighlights(slidesForStep.$3);
        final step = slidesForStep.$2;
        final path = slidesForStep.$4;
        final lang = slidesForStep.$5;

        return FlutterDeckSlide.blank(
          builder: (context) {
            var code = slidesForStep.$1;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: CodeViewer(
                key: ValueKey(code.length),
                code: code,
                highlightSteps: highlightsForStep,
                language: lang,
                stepNumber: step,
                fileName: path,
              ),
            );
          },
        );
      },
    );
  }
}

class KotlinRunSlide extends FlutterDeckSlideWidget {
  const KotlinRunSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/kotlin-run',
          title: 'Running jnigen',
          speakerNotes: '',
          steps: 3,
          header: FlutterDeckHeaderConfiguration(
            title: 'Running jnigen',
            showHeader: true,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TerminalSlide(
      commands: [
        TerminalCommand(
          command: 'flutter build apk',
          output: [
            'Resolving dependencies...',
            'Running Gradle task \'assembleRelease\'...',
            '✓ Built build/app/outputs/flutter-apk/app-release.apk (42.7MB)',
          ],
        ),
        TerminalCommand(
          command: 'dart run jnigen --config jnigen.yaml',
          output: [
            '(jnigen) INFO: Parsing inputs took 397 ms',
            '(jnigen) INFO: Generating bindings',
            '(jnigen) INFO: Completed',
          ],
        ),
        TerminalCommand(
          command: 'ls -l lib',
          output: [
            '-rw-r--r--  2217 main.dart',
            '-rw-r--r--  7540 package_retriever.dart',
          ],
        ),
      ],
      title: 'Running jnigen',
    );
  }
}

get slides => [
  (kotlinInteropCode, 1, dataLineNumbers, kotlinInteropPath, 'kotlin'),
  (kotlinInteropCode, 2, dataLineNumbers, kotlinInteropPath, 'kotlin'),
  (kotlinInteropCode, 3, dataLineNumbers, kotlinInteropPath, 'kotlin'),
  (kotlinInteropCode, 4, dataLineNumbers, kotlinInteropPath, 'kotlin'),
  (proguardCode, 1, '1', proguardName, 'yaml'),
  (jniGenConfigCode, 1, '', jniGenConfigName, 'yaml'),
];

class KotlinInteropCodeSlide extends FlutterDeckSlideWidget {
  KotlinInteropCodeSlide({super.key})
    : super(
        configuration: FlutterDeckSlideConfiguration(
          route: '/kotlin-interop-code',
          title: 'Kotlin interop code',
          speakerNotes: '',
          steps: slides.length,
          header: FlutterDeckHeaderConfiguration(
            title: 'Necessary code on the Android/Kotlin side',
            showHeader: true,
          ),
        ),
      );

  static List<List<int>> _parseHighlights(String data) {
    try {
      if (data.isEmpty) return [[]];
      return data.split('|').map((step) {
        List<int> lines = [];
        for (String range in step.split(',')) {
          if (range.contains('-')) {
            var parts = range.split('-').map(int.parse).toList();
            for (int i = parts[0]; i <= parts[1]; i++) {
              lines.add(i);
            }
          } else {
            final parsed = int.tryParse(range);
            if (parsed != null) {
              lines.add(parsed);
            }
          }
        }
        return lines;
      }).toList();
    } catch (e) {
      print('Error parsing highlights: $e');
      return [[]];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlideStepsBuilder(
      builder: (context, stepNumber) {
        final slidesForStep = slides[stepNumber - 1];
        final highlightsForStep = _parseHighlights(slidesForStep.$3);
        final step = slidesForStep.$2;
        final path = slidesForStep.$4;
        final lang = slidesForStep.$5;

        return FlutterDeckSlide.blank(
          builder: (context) {
            var code = slidesForStep.$1;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: CodeViewer(
                key: ValueKey(code.length),
                code: code,
                highlightSteps: highlightsForStep,
                language: lang,
                stepNumber: step,
                fileName: path,
              ),
            );
          },
        );
      },
    );
  }
}

class KotlinInteropSlide extends FlutterDeckSlideWidget {
  const KotlinInteropSlide({
    super.key,
  }) : super(
         configuration: const FlutterDeckSlideConfiguration(
           route: '/kotlin-interop',
           title: 'Kotlin interop',
           speakerNotes: '',
           steps: 3,
           header: FlutterDeckHeaderConfiguration(
             title: 'Setting up jnigen',
             showHeader: true,
           ),
         ),
       );

  @override
  Widget build(BuildContext context) {
    return TerminalSlide(
      title: 'Setting up jnigen',
      commands: [
        TerminalCommand(
          command: 'flutter create --empty --platform android packagelist',

          output: [
            'Creating project packagelist...',
            'Resolving dependencies in `packagelist`...',
            'All done!!',
            'Your empty application code is in packagelist/lib/main.dart.',
          ],
        ),
        TerminalCommand(
          command: 'cd packagelist',
          output: [''],
        ),
        TerminalCommand(
          command: 'flutter pub add jni dev:jnigen',
          output: [
            'Resolving dependencies...',
            '+ jni 0.14.2',
            '+ jnigen 0.14.2',
            'Changed 15 dependencies!',
          ],
        ),
      ],
    );
  }
}

String get kotlinInteropPath => 'android/app/src/main/kotlin/com/example/packagelist/PackageRetriever.kt';
String get dataLineNumbers => '|9-14|16-27|7';
String get kotlinInteropCode => r'''
package com.example.packagelist

import android.content.Context
import androidx.annotation.Keep
import androidx.core.graphics.drawable.toBitmap

@Keep
class PackageRetriever {
    fun getInstalledPackages(context: Context): List<String> {
        val pm = context.packageManager
        val packages = pm.getInstalledPackages(0)

        return packages.map { "${it.packageName}" }
    }

    fun getPackageDrawable(context: Context, packageName: String): ByteArray {
        val pm = context.packageManager
        val drawable = pm.getApplicationIcon(packageName)
        val bitmap = drawable.toBitmap()
        // get byte array from bitmap
        val byteArray = android.graphics.Bitmap.CompressFormat.PNG.run {
            val stream = java.io.ByteArrayOutputStream()
            bitmap.compress(this, 100, stream)
            stream.toByteArray()
        }
        return byteArray
    }
}''';

String get proguardName => 'proguard-rules.pro';
String get proguardCode => r'''
-keep class com.example.packagelist.** { *; }''';

String get jniGenConfigName => 'jnigen.yaml';
String get jniGenConfigCode => r'''
android_sdk_config:
  add_gradle_deps: true

summarizer:
  backend: asm

output:
  dart:
    path: lib/package_retriever.dart
    structure: single_file

source_path:
  - "android/app/src/main/kotlin/com/example/packagelist/"
classes:
  - "com.example.packagelist.PackageRetriever"''';

String get dartFileName => 'lib/main.dart';
String get dartCode => r'''
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jni/jni.dart';
import 'package:packagelist/package_retriever.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<String> packages = [];
  bool isLoading = false;
  Map<String, Image> packageIcons = {};

  void fetchPackages() {
    if (packages.isNotEmpty) {
      for (var package in packages) {
        getPackageIcon(package);
      }
    }
    setState(() {
      isLoading = true;
    });
    final context = JObject.fromReference(Jni.getCachedApplicationContext());
    final jPackages = PackageRetriever().getInstalledPackages(context);
    setState(() {
      packages = jPackages.toList().map((e) => e.toDartString()).toList();
      isLoading = false;
    });
  }

  void getPackageIcon(String package) {
    final context = JObject.fromReference(Jni.getCachedApplicationContext());
    final bytes = PackageRetriever().getPackageDrawable(
      context,
      package.toJString(),
    );
    final byteList = bytes.toList();
    final image = Image.memory(Uint8List.fromList(byteList));
    packageIcons[package] = image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : packages.isEmpty
              ? Text('Refresh to load packages')
              : ListView.builder(
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(packages[index]),
                      leading: packageIcons[packages[index]],
                      onTap: () => getPackageIcon(packages[index]),
                    );
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fetchPackages,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}''';

String get jniFileName => 'lib/package_retriever.dart';
String get jniGeneratedCode => r'''
// AUTO GENERATED BY JNIGEN 0.14.2. DO NOT EDIT!

// ignore_for_file: annotate_overrides
// ignore_for_file: argument_type_not_assignable
// ignore_for_file: camel_case_extensions
// ignore_for_file: camel_case_types
// ignore_for_file: constant_identifier_names
// ignore_for_file: comment_references
// ignore_for_file: doc_directive_unknown
// ignore_for_file: file_names
// ignore_for_file: inference_failure_on_untyped_parameter
// ignore_for_file: invalid_internal_annotation
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: library_prefixes
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: no_leading_underscores_for_library_prefixes
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: only_throw_errors
// ignore_for_file: overridden_fields
// ignore_for_file: prefer_double_quotes
// ignore_for_file: unintended_html_in_doc_comment
// ignore_for_file: unnecessary_cast
// ignore_for_file: unnecessary_non_null_assertion
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: unused_element
// ignore_for_file: unused_field
// ignore_for_file: unused_import
// ignore_for_file: unused_local_variable
// ignore_for_file: unused_shown_name
// ignore_for_file: use_super_parameters

import 'dart:core' show Object, String, bool, double, int;
import 'dart:core' as core$_;

import 'package:jni/_internal.dart' as jni$_;
import 'package:jni/jni.dart' as jni$_;

/// from: `com.example.packagelist.PackageRetriever`
class PackageRetriever extends jni$_.JObject {
  @jni$_.internal
  @core$_.override
  final jni$_.JObjType<PackageRetriever> $type;

  @jni$_.internal
  PackageRetriever.fromReference(jni$_.JReference reference)
    : $type = type,
      super.fromReference(reference);

  static final _class = jni$_.JClass.forName(
    r'com/example/packagelist/PackageRetriever',
  );

  /// The type which includes information such as the signature of this class.
  static const nullableType = $PackageRetriever$NullableType();
  static const type = $PackageRetriever$Type();
  static final _id_new$ = _class.constructorId(r'()V');

  static final _new$ =
      jni$_.ProtectedJniExtensions.lookup<
            jni$_.NativeFunction<
              jni$_.JniResult Function(
                jni$_.Pointer<jni$_.Void>,
                jni$_.JMethodIDPtr,
              )
            >
          >('globalEnv_NewObject')
          .asFunction<
            jni$_.JniResult Function(
              jni$_.Pointer<jni$_.Void>,
              jni$_.JMethodIDPtr,
            )
          >();

  /// from: `public void <init>()`
  /// The returned object must be released after use, by calling the [release] method.
  factory PackageRetriever() {
    return PackageRetriever.fromReference(
      _new$(_class.reference.pointer, _id_new$ as jni$_.JMethodIDPtr).reference,
    );
  }

  static final _id_getInstalledPackages = _class.instanceMethodId(
    r'getInstalledPackages',
    r'(Landroid/content/Context;)Ljava/util/List;',
  );

  static final _getInstalledPackages =
      jni$_.ProtectedJniExtensions.lookup<
            jni$_.NativeFunction<
              jni$_.JniResult Function(
                jni$_.Pointer<jni$_.Void>,
                jni$_.JMethodIDPtr,
                jni$_.VarArgs<(jni$_.Pointer<jni$_.Void>,)>,
              )
            >
          >('globalEnv_CallObjectMethod')
          .asFunction<
            jni$_.JniResult Function(
              jni$_.Pointer<jni$_.Void>,
              jni$_.JMethodIDPtr,
              jni$_.Pointer<jni$_.Void>,
            )
          >();

  /// from: `public final java.util.List<java.lang.String> getInstalledPackages(android.content.Context context)`
  /// The returned object must be released after use, by calling the [release] method.
  jni$_.JList<jni$_.JString> getInstalledPackages(jni$_.JObject context) {
    final _$context = context.reference;
    return _getInstalledPackages(
      reference.pointer,
      _id_getInstalledPackages as jni$_.JMethodIDPtr,
      _$context.pointer,
    ).object<jni$_.JList<jni$_.JString>>(
      const jni$_.JListType<jni$_.JString>(jni$_.JStringType()),
    );
  }

  static final _id_getPackageDrawable = _class.instanceMethodId(
    r'getPackageDrawable',
    r'(Landroid/content/Context;Ljava/lang/String;)[B',
  );

  static final _getPackageDrawable =
      jni$_.ProtectedJniExtensions.lookup<
            jni$_.NativeFunction<
              jni$_.JniResult Function(
                jni$_.Pointer<jni$_.Void>,
                jni$_.JMethodIDPtr,
                jni$_.VarArgs<
                  (jni$_.Pointer<jni$_.Void>, jni$_.Pointer<jni$_.Void>)
                >,
              )
            >
          >('globalEnv_CallObjectMethod')
          .asFunction<
            jni$_.JniResult Function(
              jni$_.Pointer<jni$_.Void>,
              jni$_.JMethodIDPtr,
              jni$_.Pointer<jni$_.Void>,
              jni$_.Pointer<jni$_.Void>,
            )
          >();

  /// from: `public final byte[] getPackageDrawable(android.content.Context context, java.lang.String string)`
  /// The returned object must be released after use, by calling the [release] method.
  jni$_.JByteArray getPackageDrawable(
    jni$_.JObject context,
    jni$_.JString string,
  ) {
    final _$context = context.reference;
    final _$string = string.reference;
    return _getPackageDrawable(
      reference.pointer,
      _id_getPackageDrawable as jni$_.JMethodIDPtr,
      _$context.pointer,
      _$string.pointer,
    ).object<jni$_.JByteArray>(const jni$_.JByteArrayType());
  }
}

final class $PackageRetriever$NullableType
    extends jni$_.JObjType<PackageRetriever?> {
  @jni$_.internal
  const $PackageRetriever$NullableType();

  @jni$_.internal
  @core$_.override
  String get signature => r'Lcom/example/packagelist/PackageRetriever;';

  @jni$_.internal
  @core$_.override
  PackageRetriever? fromReference(jni$_.JReference reference) =>
      reference.isNull ? null : PackageRetriever.fromReference(reference);
  @jni$_.internal
  @core$_.override
  jni$_.JObjType get superType => const jni$_.JObjectType();

  @jni$_.internal
  @core$_.override
  jni$_.JObjType<PackageRetriever?> get nullableType => this;

  @jni$_.internal
  @core$_.override
  final superCount = 1;

  @core$_.override
  int get hashCode => ($PackageRetriever$NullableType).hashCode;

  @core$_.override
  bool operator ==(Object other) {
    return other.runtimeType == ($PackageRetriever$NullableType) &&
        other is $PackageRetriever$NullableType;
  }
}

final class $PackageRetriever$Type extends jni$_.JObjType<PackageRetriever> {
  @jni$_.internal
  const $PackageRetriever$Type();

  @jni$_.internal
  @core$_.override
  String get signature => r'Lcom/example/packagelist/PackageRetriever;';

  @jni$_.internal
  @core$_.override
  PackageRetriever fromReference(jni$_.JReference reference) =>
      PackageRetriever.fromReference(reference);
  @jni$_.internal
  @core$_.override
  jni$_.JObjType get superType => const jni$_.JObjectType();

  @jni$_.internal
  @core$_.override
  jni$_.JObjType<PackageRetriever?> get nullableType =>
      const $PackageRetriever$NullableType();

  @jni$_.internal
  @core$_.override
  final superCount = 1;

  @core$_.override
  int get hashCode => ($PackageRetriever$Type).hashCode;

  @core$_.override
  bool operator ==(Object other) {
    return other.runtimeType == ($PackageRetriever$Type) &&
        other is $PackageRetriever$Type;
  }
}''';
