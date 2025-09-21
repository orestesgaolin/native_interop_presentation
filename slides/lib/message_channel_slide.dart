import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:slides/code_highlight_slide.dart';
import 'package:slides/webview_mermaid.dart';

get slides => [
  (dartCode, 1, '', 'main.dart', 'dart'),
  (dartCode, 1, '8-10', 'main.dart', 'dart'),
  (engineCodeDart, 1, '7-11', 'flutter/lib/src/services/platform_channel.dart', 'dart'),
  (stringCodec, 1, stringCodecHighlights, 'flutter/lib/src/services/message_codecs.dart', 'dart'),
  (stringCodec, 2, stringCodecHighlights, 'flutter/lib/src/services/message_codecs.dart', 'dart'),
  (binaryMessengerCode, 1, '', 'flutter/lib/src/services/binding.dart', 'dart'),
  (binaryMessengerCode, 2, binaryMessengerHighlights, 'flutter/lib/src/services/binding.dart', 'dart'),
  (binaryMessengerCode, 3, binaryMessengerHighlights, 'flutter/lib/src/services/binding.dart', 'dart'),
  (platformDispatcherCode, 1, platformDispatcherHighlights, 'sky_engine/lib/ui/platform_dispatcher.dart', 'dart'),
  (platformDispatcherCode, 2, platformDispatcherHighlights, 'sky_engine/lib/ui/platform_dispatcher.dart', 'dart'),
  (
    engineCodeOnPlatform,
    1,
    engineCodeOnPlatformHighlights,
    'flutter/engine/src/flutter/shell/platform/darwin/macos/framework/Source/FlutterEngine.mm',
    'dart',
  ),
  (cppEngineCode1, 1, '', 'flutter/engine/src/flutter/lib/ui/window/platform_configuration.cc', 'dart'),
  // (cppEngineCode, 1, '', 'engine/src/flutter/shell/platform/embedder/embedder_engine.cc', 'dart'),
  (swiftCode, 1, '1-5|10-12', 'Runner/MainFlutterWindow.swift', 'swift'),
  (swiftCode, 2, '1-5|10-12', 'Runner/MainFlutterWindow.swift', 'swift'),
  (objcCode, 1, objcHighlights, 'engine/src/flutter/shell/platform/darwin/common/framework/Source/FlutterCodecs.mm', 'dart'),
  (objcCode, 2, objcHighlights, 'engine/src/flutter/shell/platform/darwin/common/framework/Source/FlutterCodecs.mm', 'dart'),
  (objcCode, 3, objcHighlights, 'engine/src/flutter/shell/platform/darwin/common/framework/Source/FlutterCodecs.mm', 'dart'),
  (engineObjcCode, 1, engineObjcHigh, objcPath, 'dart'),
  (engineObjcCode, 2, engineObjcHigh, objcPath, 'dart'),
  (engineObjcCode, 3, engineObjcHigh, objcPath, 'dart'),
  (dartEntryPointCode, 1, dartEntryPointHighlights, dartEntryPointPath, 'dart'),
  // (dartEntryPointCode, 1, '', dartEntryPointPath, 'dart'),
  (dartCode, 1, '9', 'main.dart', 'dart'),

  // 5 => (objcCode, 5),
  // 6 => (dartCode, 1),
];

class MessageChannelSlide extends FlutterDeckSlideWidget {
  MessageChannelSlide({
    super.key,
  }) : super(
         configuration: FlutterDeckSlideConfiguration(
           route: '/message-channel',
           steps: slides.length - 1,
           title: 'Message Channel Flow',
           header: FlutterDeckHeaderConfiguration(title: 'How does a simple Message Channel work?'),
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
    var slide = slides[widget.step];
    final code = slide.$1;
    final stepNumber = slide.$2;
    final highlights = slide.$3;
    final filePath = slide.$4;
    final language = slide.$5;
    var parseHighlights = _parseHighlights(highlights);
    var mermaid = '''
sequenceDiagram
    participant D as Dart
    participant C as C++ Engine
    participant I as ObjC Engine
    participant S as Swift Host


    D->>C:
    C->>I:
    I->>S:
    S->>I:
    I->>C:
    C->>D:
''';
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
          bottom: 0,
          width: 600,
          height: 220,
          child: Opacity(
            opacity: 0.6,
            child: WebViewMermaid(
              mermaid: mermaid,
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
final BinaryMessenger? _binaryMessenger;

/// Sends the specified [message] to the platform plugins on this channel.
///
/// Returns a [Future] which completes to the received response, which may
/// be null.
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

String get binaryMessengerHighlights => '|19|30';
String get binaryMessengerCode => '''
/// The default implementation of [BinaryMessenger].
///
/// This messenger sends messages from the app-side to the platform-side and
/// dispatches incoming messages from the platform-side to the appropriate
/// handler.
class _DefaultBinaryMessenger extends BinaryMessenger {
  const _DefaultBinaryMessenger._();

  @override
  Future<void> handlePlatformMessage(
    String channel,
    ByteData? message,
    ui.PlatformMessageResponseCallback? callback,
  ) async {
    ui.channelBuffers.push(channel, message, (ByteData? data) => callback?.call(data));
  }

  @override
  Future<ByteData?> send(String channel, ByteData? message) {
    final Completer<ByteData?> completer = Completer<ByteData?>();
    // ui.PlatformDispatcher.instance is accessed directly instead of using
    // ServicesBinding.instance.platformDispatcher because this method might be
    // invoked before any binding is initialized. This issue was reported in
    // #27541. It is not ideal to statically access
    // ui.PlatformDispatcher.instance because the PlatformDispatcher may be
    // dependency injected elsewhere with a different instance. However, static
    // access at this location seems to be the least bad option.
    // TODO(ianh): Use ServicesBinding.instance once we have better diagnostics
    // on that getter.
    ui.PlatformDispatcher.instance.sendPlatformMessage(channel, message, (ByteData? reply) {
      try {
        completer.complete(reply);
      } catch (exception, stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: exception,
            stack: stack,
            library: 'services library',
            context: ErrorDescription('during a platform message response callback'),
          ),
        );
      }
    });
    return completer.future;
  }''';

String get platformDispatcherHighlights => '|30-34';
String get platformDispatcherCode => '''
/// Sends a message to a platform-specific plugin.
///
/// The `name` parameter determines which plugin receives the message. The
/// `data` parameter contains the message payload and is typically UTF-8
/// encoded JSON but can be arbitrary data. If the plugin replies to the
/// message, `callback` will be called with the response.
///
/// The framework invokes [callback] in the same zone in which this method was
/// called.
void sendPlatformMessage(String name, ByteData? data, PlatformMessageResponseCallback? callback) {
  final String? error = _sendPlatformMessage(
    name,
    _zonedPlatformMessageResponseCallback(callback),
    data,
  );
  if (error != null) {
    throw Exception(error);
  }
}

String? _sendPlatformMessage(
  String name,
  PlatformMessageResponseCallback? callback,
  ByteData? data,
) => __sendPlatformMessage(name, callback, data);

@Native<Handle Function(Handle, Handle, Handle)>(
  symbol: 'PlatformConfigurationNativeApi::SendPlatformMessage',
)
external static String? __sendPlatformMessage(
  String name,
  PlatformMessageResponseCallback? callback,
  ByteData? data,
);

/// Sends a message to a platform-specific plugin via a [SendPort].
///
/// This operates similarly to [sendPlatformMessage] but is used when sending
/// messages from background isolates. The [port] parameter allows Flutter to
/// know which isolate to send the result to. The [name] parameter is the name
/// of the channel communication will happen on. The [data] parameter is the
/// payload of the message. The [identifier] parameter is a unique integer
/// assigned to the message.
void sendPortPlatformMessage(String name, ByteData? data, int identifier, SendPort port) {
  final String? error = _sendPortPlatformMessage(name, identifier, port.nativePort, data);
  if (error != null) {
    throw Exception(error);
  }
}''';

///flutter/engine/src/flutter/lib/ui/window/platform_configuration.cc
String get cppEngineCode1 => '''
// called via ffi from /platform_dispatcher.dart
Dart_Handle PlatformConfigurationNativeApi::SendPlatformMessage(
    const std::string& name,
    Dart_Handle callback,
    Dart_Handle data_handle) {
  UIDartState* dart_state = UIDartState::Current();

  if (!dart_state->platform_configuration()) {
    return tonic::ToDart(
        "SendPlatformMessage only works on the root isolate, see "
        "SendPortPlatformMessage.");
  }

  fml::RefPtr<PlatformMessageResponse> response;
  if (!Dart_IsNull(callback)) {
    response = fml::MakeRefCounted<PlatformMessageResponseDart>(
        tonic::DartPersistentValue(dart_state, callback),
        dart_state->GetTaskRunners().GetUITaskRunner(), name);
  }

  return HandlePlatformMessage(dart_state, name, data_handle, response);
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
String get engineObjcHigh => '|6-8|45-46';
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

String get dartEntryPointPath => 'flutter/engine/src/flutter/lib/ui/hooks.dart';
String get dartEntryPointHighlights => '1-5';
String get dartEntryPointCode => '''
@pragma('vm:entry-point')
void _dispatchPlatformMessage(String name, ByteData? data, int responseId) {
  PlatformDispatcher.instance._dispatchPlatformMessage(name, data, responseId);
}''';

String get engineCodeOnPlatformHighlights => '';

String get engineCodeOnPlatform => '''
- (void)engineCallbackOnPlatformMessage:(const FlutterPlatformMessage*)message {
  NSData* messageData = nil;
  if (message->message_size > 0) {
    messageData = [NSData dataWithBytesNoCopy:(void*)message->message
                                       length:message->message_size
                                 freeWhenDone:NO];
  }
  NSString* channel = @(message->channel);
  __block const FlutterPlatformMessageResponseHandle* responseHandle = message->response_handle;
  __block FlutterEngine* weakSelf = self;
  NSMutableArray* isResponseValid = self.isResponseValid;
  FlutterEngineSendPlatformMessageResponseFnPtr sendPlatformMessageResponse =
      _embedderAPI.SendPlatformMessageResponse;
  FlutterBinaryReply binaryResponseHandler = ^(NSData* response) {
    @synchronized(isResponseValid) {
      if (![isResponseValid[0] boolValue]) {
        // Ignore, engine was killed.
        return;
      }
      if (responseHandle) {
        sendPlatformMessageResponse(weakSelf->_engine, responseHandle,
                                    static_cast<const uint8_t*>(response.bytes), response.length);
        responseHandle = NULL;
      } else {
        NSLog(@"Error: Message responses can be sent only once. Ignoring duplicate response "
               "on channel '%@'.",
              channel);
      }
    }
  };

  FlutterEngineHandlerInfo* handlerInfo = _messengerHandlers[channel];
  if (handlerInfo) {
    handlerInfo.handler(messageData, binaryResponseHandler);
  } else {
    binaryResponseHandler(nil);
  }
}''';
