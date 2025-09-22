import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/code_highlight_slide.dart';
import 'package:slides/terminal_slide.dart';
import 'package:slides/webview_mermaid.dart';

// TODO: explain some limitations:
// - only open source code
// - threading may get complicated - isolates aren't bound to OS thread https://github.com/dart-lang/sdk/issues/46943
// https://quickbirdstudios.com/blog/dart-swift-objective-c-interop/
//Annotate your API with @objc (if you don't own the library, write a wrapper library and mark that with the annotation).
//Use the swift compiler to generate an ObjC wrapper header (a 1 liner swiftc command)
// ObjC obeys the C calling convention, so we can do interop. In Dart's case, that means using ffigen to parse the ObjC header then using FFI to load the library.
class SwiftGenSlide extends FlutterDeckSlideWidget {
  const SwiftGenSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/swiftgen',
          title: 'SwiftGen',
          speakerNotes: '',
          header: FlutterDeckHeaderConfiguration(
            title: 'swiftgen',
            showHeader: true,
          ),
          steps: 10,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) {
        return FlutterDeckSlideStepsBuilder(
          builder: (context, stepNumber) {
            if (stepNumber < 4) {
              return Stack(
                children: [
                  CodeViewer(
                    fileName: 'example/generate_code.dart',
                    code: swiftGeneratCode,
                    language: 'swift',
                    highlightSteps: [
                      [0],
                      [25],
                      [27],
                    ],
                    stepNumber: stepNumber,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SizedBox(
                      width: 300,
                      height: 250,
                      child: Opacity(
                        opacity: 0.8,
                        child: WebViewMermaid(
                          mermaid: '''flowchart TD
                      A[Dart] <-->|ffi| O(ObjC like C)
                      S[Swift @objc] <--> O''',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (stepNumber == 4) {
              return TerminalContent(
                commands: [
                  TerminalCommand(
                    command: 'dart run generate_code.dart',
                    output: [
                      'INFO: Finished, Bindings generated in /example/avf_audio_bindings.dart',
                      'INFO: Finished, Objective C bindings generated in /example/avf_audio_wrapper.m',
                    ],
                  ),
                  TerminalCommand(
                    command: 'dart play_audio.dart file1.wav',
                    output: [
                      'Loading file1.wav',
                      '3 sec',
                      'Playing...',
                    ],
                  ),
                ],
              );
            } else if (stepNumber == 5) {
              return Center(child: Image.asset('assets/swiftgen.png'));
            } else if (stepNumber < 10) {
              return CodeViewer(
                fileName: 'lib/audio_player.dart',
                code: dartAudioPlayerCode,
                language: 'dart',
                highlightSteps: [
                  [28],
                  [30, 31, 32, 33],
                  [51, 52],
                  [92],
                ],
                stepNumber: stepNumber - 5,
              );
            } else {
              return FlutterDeckBulletList(
                // useSteps: true,
                // stepOffset: 6,
                items: const [
                  'slightly limited to only open source code or manual wrappers',
                  'uses ffigen under the hood',
                  'Swift code needs to be ObjC compatible (@objc annotation)',
                ],
              );
            }
          },
        );
      },
      configuration: configuration,
    );
  }
}

String get dartAudioPlayerCode => r'''
import 'dart:async';
import 'dart:ffi';
import 'dart:math' as math;
import 'package:ffi/ffi.dart';

import 'package:flutter/widgets.dart';
import 'package:objective_c/objective_c.dart';
import 'package:sandbox/avf_audio_bindings.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({super.key});

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  late final AVAudioPlayerWrapper? player;
  double _currentTime = 0.0;
  double _totalDuration = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Allocate error pointer using Pointer<Void> and cast
    final error = calloc<Pointer<Void>>().cast<Pointer<ObjCObject>>();

    player = AVAudioPlayerWrapper.alloc().initWithContentsOf(
      NSURL.fileURLWithPath('assets/audio.wav'.toNSString()),
      error: error,
    );

    // Check for error
    // error	NSError	domain: "NSOSStatusErrorDomain" - code: -54	0x00000001527bc120
    if (error.value != nullptr) {
      final nsError = NSError.castFromPointer(error.value, retain: true, release: true);
      calloc.free(error);
      print('Error initializing audio player: ${nsError.code}');
      throw Exception('Failed to initialize audio player: ${nsError.code}');
    }
    calloc.free(error);
    if (player == null) {
      throw Exception('Audio player initialization returned null');
    }
    _totalDuration = player?.duration ?? 0.0;
  }

  void play() {
    player?.play();
    startUpdatingTime();
  }

  void pause() {
    player?.pause();
    _timer?.cancel();
  }

  void stop() {
    player?.stop();
    player?.currentTime = 0.0;
    _currentTime = 0.0;
    _timer?.cancel();
  }

  void setVolume(double volume) {
    player?.volume = volume;
  }

  void seek(double time) {
    player?.currentTime = time;
  }

  void updateTime() {
    setState(() {
      _currentTime = player?.currentTime ?? 0.0;
    });
  }

  void startUpdatingTime() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      updateTime();
    });
  }

  void openFile() {}

  @override
  void dispose() {
    player?.release();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Time display
          Text('${roundDouble(_currentTime, 2)} / ${roundDouble(_totalDuration, 2)}'),
          const SizedBox(height: 10),
          // Progress bar
          LayoutBuilder(
            builder: (context, constraints) {
              double progress = _totalDuration > 0 ? _currentTime / _totalDuration : 0.0;
              return GestureDetector(
                onTapDown: (details) {
                  double newTime = details.localPosition.dx / constraints.maxWidth * _totalDuration;
                  seek(newTime);
                  setState(() {
                    _currentTime = newTime;
                  });
                },
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: progress * constraints.maxWidth,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0000FF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: play,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color(0xFFEEEEEE),
                  child: const Text('Play'),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: pause,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color(0xFFEEEEEE),
                  child: const Text('Pause'),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: stop,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color(0xFFEEEEEE),
                  child: const Text('Stop'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String roundDouble(double value, int places) {
  double mod = math.pow(10.0, places).toDouble();
  return ((value * mod).round().toDouble() / mod).toString();
}''';

String get swiftGeneratCode => r'''
// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:ffigen/ffigen.dart' as fg;
import 'package:logging/logging.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:swiftgen/swiftgen.dart';

Future<void> main() async {
  final logger = Logger('swiftgen');
  logger.onRecord.listen((record) {
    stderr.writeln('${record.level.name}: ${record.message}');
  });

  await SwiftGenerator(
    target: Target(
      triple: 'arm64-apple-macosx14.0',
      sdk: Uri.directory(
        '/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk',
      ),
    ),
    inputs: const [SwiftModuleInput(module: 'AVFAudio')],
    // or
    inputs: [SwiftFileInput(files: [Uri.file('compression.swift')]),],
    include: (d) => d.name == 'AVAudioPlayer',
    output: Output(
      swiftWrapperFile: SwiftWrapperFile(
        path: Uri.file('avf_audio_wrapper.swift'),
      ),
      module: 'AVFAudioWrapper',
      dartFile: Uri.file('avf_audio_bindings.dart'),
      objectiveCFile: Uri.file('avf_audio_wrapper.m'),
    ),
    ffigen: FfiGeneratorOptions(
      objectiveC: fg.ObjectiveC(
        externalVersions: fg.ExternalVersions(
          ios: fg.Versions(min: Version(12, 0, 0)),
          macos: fg.Versions(min: Version(10, 14, 0)),
        ),
        interfaces: fg.Interfaces(
          include: (decl) => decl.originalName == 'AVAudioPlayerWrapper',
        ),
      ),
    ),
  ).generate(logger: logger, tempDirectory: Uri.directory('temp'));

  final result = Process.runSync('swiftc', [
    '-emit-library',
    '-o',
    'avf_audio_wrapper.dylib',
    '-module-name',
    'AVFAudioWrapper',
    'avf_audio_wrapper.swift',
    '-framework',
    'AVFAudio',
    '-framework',
    'Foundation',
  ]);
  if (result.exitCode != 0) {
    print('Failed to build the swift wrapper library');
    print(result.stdout);
    print(result.stderr);
  }
}''';
