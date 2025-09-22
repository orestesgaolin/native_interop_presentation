import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:ui';
import 'package:objective_c/objective_c.dart' as objc;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/code_highlight_slide.dart';

// TODO: add example of using the Swift via ObjC via ffigen?

class SwiftInteropSlide extends FlutterDeckSlideWidget {
  SwiftInteropSlide({super.key})
    : super(
        configuration: FlutterDeckSlideConfiguration(
          route: '/swift-interop',

          title: 'Swift Interop via ffi via C (not Obj-C)',
          header: FlutterDeckHeaderConfiguration(
            title: 'Swift Interop via ffi via C (not Obj-C)',
            showHeader: true,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: CodeViewer(
                      fileName: 'main.dart',
                      code: dartCode,
                      language: 'dart',
                      highlightSteps: [[]],
                      stepNumber: 1,
                    ),
                  ),
                  Expanded(
                    child: CodeViewer(
                      fileName: 'calculator.swift',
                      code: swiftCode,
                      language: 'swift',
                      highlightSteps: [[]],
                      stepNumber: 1,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              top: 80,
              child: ClipRect(
                child: CheckedModeBanner(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const SlideInteropCalc(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SlideInteropCalc extends StatefulWidget {
  const SlideInteropCalc({super.key});

  @override
  State<SlideInteropCalc> createState() => _SlideInteropCalcState();
}

class _SlideInteropCalcState extends State<SlideInteropCalc> {
  int? _result;
  int a = 0;
  int b = 0;

  int invokeAdd(int a, int b) {
    final nativeLib = ffi.DynamicLibrary.process();
    final addFunction = nativeLib.lookupFunction<ffi.Int32 Function(ffi.Int32, ffi.Int32), int Function(int, int)>('add');
    final result = addFunction(a, b);
    print('$a + $b = $result');
    return result;
  }

  void showNotification() {
    final nativeLib = ffi.DynamicLibrary.process();
    final showNotificationFunction = nativeLib.lookupFunction<ffi.Void Function(), void Function()>('showNotification');
    showNotificationFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Row(
              children: [
                Text('A: $a'),
                Slider(
                  value: a.toDouble(),
                  min: -10,
                  max: 10,

                  onChanged: (value) {
                    setState(() {
                      a = value.round();
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text('B: $b'),
                Slider(
                  value: b.toDouble(),
                  min: -10,
                  max: 10,
                  label: 'B: $b',
                  onChanged: (value) {
                    setState(() {
                      b = value.round();
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                final result = invokeAdd(a, b);
                setState(() {
                  _result = result;
                });
              },

              child: Text('Invoke add function'),
            ),
            if (_result != null) Text('Result: $_result'),
            SwiftBenchmarkContent(),
          ],
        ),
      ),
    );
  }
}

String get swiftCode => '''
@_cdecl("add") //_cdecl is the default calling convention for C and C++ programs
func add(_ a: Int, _ b: Int) -> Int {
  return a + b
}''';

String get dartCode => '''
import 'dart:ffi' as ffi;

int add(int a, int b) {
  final nativeLib = ffi.DynamicLibrary.process();
  final addFunction = nativeLib.lookupFunction
      <ffi.Int32 Function(ffi.Int32, ffi.Int32), 
                        int Function(int, int)>('add');
  return addFunction(a, b);
}''';

class SwiftBenchmarkContent extends StatefulWidget {
  const SwiftBenchmarkContent({super.key});

  @override
  State<SwiftBenchmarkContent> createState() => _SwiftBenchmarkContentState();
}

class _SwiftBenchmarkContentState extends State<SwiftBenchmarkContent> {
  late MethodChannel _methodChannel;
  Timer? _progressBarTimer;
  Duration _ffiDuration = Duration.zero;
  Duration _methodChannelDuration = Duration.zero;
  int _count = 100000;

  int invokeAdd(int a, int b) {
    final nativeLib = ffi.DynamicLibrary.process();
    final addFunction = nativeLib.lookupFunction<ffi.Int32 Function(ffi.Int32, ffi.Int32), int Function(int, int)>('add');
    final result = addFunction(a, b);
    return result;
  }

  Future<int> invokeMethodchannelAdd(int a, int b) async {
    final result = await _methodChannel.invokeMethod<int>('add', {'a': a, 'b': b});
    return result ?? 0;
  }

  @override
  void initState() {
    super.initState();
    _methodChannel = const MethodChannel('com.example/benchmark');
  }

  void runBenchmark() async {
    final stopwatch = Stopwatch()..start();

    for (var i = 0; i < _count; i++) {
      invokeAdd(i, i);
    }

    stopwatch.stop();
    final ffiTime = stopwatch.elapsedMilliseconds;
    print('FFI Time: $ffiTime ms');
    setState(() {
      _ffiDuration = Duration(milliseconds: ffiTime);
    });

    stopwatch.reset();
    stopwatch.start();

    for (var i = 0; i < _count; i++) {
      await invokeMethodchannelAdd(i, i);
    }

    stopwatch.stop();
    final methodChannelTime = stopwatch.elapsedMilliseconds;
    setState(() {
      _methodChannelDuration = Duration(milliseconds: methodChannelTime);
    });
    print('Method Channel Time: $methodChannelTime ms');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        ElevatedButton(
          onPressed: runBenchmark,
          child: Text('Benchmark ($_count times, debug)'),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: _ffiDuration,
                  height: 64,
                  width: _ffiDuration.inMilliseconds / 10,
                  color: Colors.blue,
                ),
                if (_ffiDuration > Duration.zero)
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        'FFI ${_ffiDuration.inMilliseconds} ms',
                        style: FlutterDeckTheme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
              ],
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: _methodChannelDuration,
                  height: 64,
                  width: _methodChannelDuration.inMilliseconds / 10,
                  color: Colors.red,
                ),
                if (_methodChannelDuration > Duration.zero)
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        'Method Channel ${_methodChannelDuration.inMilliseconds} ms',
                        style: FlutterDeckTheme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
