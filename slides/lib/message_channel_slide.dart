import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:slides/code_highlight_slide.dart';

class MessageChannelSlide extends FlutterDeckSlideWidget {
  MessageChannelSlide({
    super.key,
  }) : super(
         configuration: FlutterDeckSlideConfiguration(
           route: '/message-channel',
           steps: 16,
           title: 'Message Channel Flow',
           header: FlutterDeckHeaderConfiguration(title: 'Message Channel Flow'),
         ),
       );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: FlutterDeckSlideStepsBuilder(
          builder: (context, stepNumber) {
            return FlutterDeckCodeHighlightTheme(
              data:
                  FlutterDeckCodeHighlightTheme.of(
                    context,
                  ).copyWith(
                    textStyle: FlutterDeckTheme.of(context).textTheme.bodySmall.copyWith(
                      fontFamily: GoogleFonts.sourceCodePro().fontFamily,
                    ),
                  ),
              child: MyChannelWidget(step: stepNumber),
            );
          },
        ),
      ),
    );
  }
}

class MyChannelWidget extends StatefulWidget {
  const MyChannelWidget({required this.step, super.key});

  final int step;

  @override
  State<MyChannelWidget> createState() => _MyChannelWidgetState();
}

class _MyChannelWidgetState extends State<MyChannelWidget> {
  final channel = const BasicMessageChannel<String>(
    'com.example/my_channel',
    StringCodec(),
  );

  List<String> log = [];

  Future<void> sendMessage(String message) async {
    try {
      final encoded = StringCodec().encodeMessage(message);
      log.add('Message: ${encoded?.buffer.asUint8List()}');
      final reply = await channel.send(message);
      final bytesReply = StringCodec().encodeMessage(reply);
      log.add('Reply: ${bytesReply?.buffer.asUint8List()}');
      log.add('Received: $reply');
      setState(() {});
    } on PlatformException catch (e) {
      print('Failed to send message: ${e.message}');
    }
  }

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
    final (code, stepNumber, highlights, filePath, language) = switch (widget.step) {
      1 => (dartCode, 1, '8-10', 'main.dart', 'dart'),
      2 => (engineCodeDart, 1, '', 'flutter/lib/src/services/platform_channel.dart', 'dart'),
      3 => (stringCodec, 1, stringCodecHighlights, 'flutter/lib/src/services/message_codecs.dart', 'dart'),
      4 => (stringCodec, 2, stringCodecHighlights, 'flutter/lib/src/services/message_codecs.dart', 'dart'),
      5 => (cppEngineCode, 1, '', 'engine/src/flutter/shell/platform/embedder/embedder_engine.cc', 'dart'),
      6 => (swiftCode, 1, '1-5|10-12', 'Runner/MainFlutterWindow.swift', 'swift'),
      7 => (swiftCode, 2, '1-5|10-12', 'Runner/MainFlutterWindow.swift', 'swift'),
      8 => (objcCode, 1, objcHighlights, 'engine/src/flutter/shell/platform/darwin/common/framework/Source/FlutterCodecs.mm', 'dart'),
      9 => (objcCode, 2, objcHighlights, 'engine/src/flutter/shell/platform/darwin/common/framework/Source/FlutterCodecs.mm', 'dart'),
      10 => (objcCode, 3, objcHighlights, 'engine/src/flutter/shell/platform/darwin/common/framework/Source/FlutterCodecs.mm', 'dart'),
      11 => (engineObjcCode, 1, engineObjcHigh, objcPath, 'dart'),
      12 => (engineObjcCode, 2, engineObjcHigh, objcPath, 'dart'),
      13 => (engineObjcCode, 3, engineObjcHigh, objcPath, 'dart'),
      14 => (engineObjcCode, 4, engineObjcHigh, objcPath, 'dart'),
      15 => (engineObjcCode, 5, engineObjcHigh, objcPath, 'dart'),
      // 5 => (objcCode, 5),
      // 6 => (dartCode, 1),
      _ => ('// End of code', 1, '', '', 'dart'),
    };

    var parseHighlights = _parseHighlights(highlights);
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: CodeViewer(
              key: ValueKey(code),
              code: code,
              language: language,
              highlightSteps: parseHighlights,
              stepNumber: stepNumber,
              fileName: filePath.isEmpty ? null : filePath,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 40,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(8),
            ),
            width: 320,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          log.add('Sent: Hello from Flutter!');
                        });
                        await sendMessage('Hello from Flutter!');
                      },
                      child: const Text('Send Message'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          log.clear();
                        });
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
                for (var entry in log)
                  Text(
                    entry,
                    style: GoogleFonts.sourceCodePro(fontSize: 24, height: 1.0),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String get objcHighlights => '|20-25|10-17';
final objcCode = '''
@implementation FlutterStringCodec
+ (instancetype)sharedInstance {
  static id _sharedInstance = nil;
  if (!_sharedInstance) {
    _sharedInstance = [[FlutterStringCodec alloc] init];
  }
  return _sharedInstance;
}

- (NSData*)encode:(id)message {
  if (message == nil) {
    return nil;
  }
  NSAssert([message isKindOfClass:[NSString class]], @"");
  NSString* stringMessage = message;
  const char* utf8 = stringMessage.UTF8String;
  return [NSData dataWithBytes:utf8 length:strlen(utf8)];
}

- (NSString*)decode:(NSData*)message {
  if (message == nil) {
    return nil;
  }
  return [[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding];
}
@end''';

final dartCode = '''
import 'package:flutter/services.dart';

final channel = const BasicMessageChannel<String>(
  'com.example/my_channel',
  StringCodec(),
);

Future<void> sendMessage(String message) async {
  final reply = await channel.send(message);
}''';

final engineCodeDart = '''
Future<T?> send(T message) async {
  final data = codec.encodeMessage(message);
  final response = await _binaryMessenger.send(name, data);
  return codec.decodeMessage(response);
}''';

String get stringCodecHighlights => '11-16|3-8';
String get stringCodec => '''
class StringCodec implements MessageCodec<String> {
  @override
  String? decodeMessage(ByteData? message) {
    if (message == null) {
      return null;
    }
    return utf8.decode(Uint8List.sublistView(message));
  }

  @override
  ByteData? encodeMessage(String? message) {
    if (message == null) {
      return null;
    }
    return ByteData.sublistView(utf8.encode(message));
  }
}''';

String get cppEngineCode => '''
// Crossing the platform barrier

EmbedderEngine::EmbedderEngine
// ...
bool EmbedderEngine::SendPlatformMessage(
    std::unique_ptr<PlatformMessage> message) {
  if (!IsValid() || !message) {
    return false;
  }

// ...

  platform_view->DispatchPlatformMessage(std::move(message));
  return true;
}''';

String get swiftCode => '''
let myChannel = FlutterBasicMessageChannel(
    name: "com.example/my_channel", 
    binaryMessenger: flutterViewController.engine.binaryMessenger, 
    codec: FlutterStringCodec()
  )

myChannel.setMessageHandler { 
  (message: Any?, reply: @escaping FlutterReply) in
  if let messageString = message as? String {
      print("Received message from Flutter: \\(messageString)")
      let responseString = "Hello from macOS!"
      reply(responseString)
  } else {
      reply(
        FlutterError(
          code: "INVALID_ARGUMENT", 
          message: "Expected a string", 
          details: nil
        )
      )
  }
}''';

String get objcPath => 'engine/src/flutter/shell/platform/darwin/macos/framework/Source/FlutterEngine.mm';
String get engineObjcHigh => '|6-8|39-45|47-48|50';
String get engineObjcCode => '''
@interface FlutterEngine () <FlutterBinaryMessenger,
                             FlutterMouseCursorPluginDelegate,
                             FlutterKeyboardManagerDelegate,
                             FlutterTextInputPluginDelegate>
//...
- (void)sendOnChannel:(NSString*)channel
              message:(NSData* _Nullable)message
          binaryReply:(FlutterBinaryReply _Nullable)callback {
  FlutterPlatformMessageResponseHandle* response_handle = nullptr;
  if (callback) {
    struct Captures {
      FlutterBinaryReply reply;
    };
    auto captures = std::make_unique<Captures>();
    captures->reply = callback;
    auto message_reply = [](const uint8_t* data, size_t data_size, void* user_data) {
      auto captures = reinterpret_cast<Captures*>(user_data);
      NSData* reply_data = nil;
      if (data != nullptr && data_size > 0) {
        reply_data = [NSData dataWithBytes:static_cast<const void*>(data) length:data_size];
      }
      captures->reply(reply_data);
      delete captures;
    };

    FlutterEngineResult create_result = _embedderAPI.PlatformMessageCreateResponseHandle(
        _engine, message_reply, captures.get(), &response_handle);
    if (create_result != kSuccess) {
      NSLog(@"Failed to create a FlutterPlatformMessageResponseHandle (%d)", create_result);
      return;
    }
    captures.release();
  }

  FlutterPlatformMessage platformMessage = {
      .struct_size = sizeof(FlutterPlatformMessage),
      .channel = [channel UTF8String],
      .message = static_cast<const uint8_t*>(message.bytes),
      .message_size = message.length,
      .response_handle = response_handle,
  };

  FlutterEngineResult message_result = _embedderAPI.SendPlatformMessage(_engine, &platformMessage);
  if (message_result != kSuccess) {
    NSLog(@"Failed to send message to Flutter engine on channel '%@' (%d).", channel,
          message_result);
  }

  if (response_handle != nullptr) {
    FlutterEngineResult release_result =
        _embedderAPI.PlatformMessageReleaseResponseHandle(_engine, response_handle);
    if (release_result != kSuccess) {
      NSLog(@"Failed to release the response handle (%d).", release_result);
    };
  }
}''';
