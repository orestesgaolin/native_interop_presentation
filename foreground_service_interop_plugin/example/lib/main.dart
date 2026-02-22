import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:jni/jni.dart' as jni;

import 'package:foreground_service_interop_plugin/foreground_service_interop_plugin.dart'
    as native;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  native.ServiceConnection? serviceConnection;
  StreamSubscription<String>? repliesSubscription;
  native.ExampleForegroundService$LocalBinder? localBinder;
  native.ExampleForegroundService? service;

  bool get isServiceRunning => service != null;
  bool hasPermission = false;
  List<(DateTime, String, String)> messages = [];

  @override
  void initState() {
    super.initState();

    serviceConnection = native.ServiceConnection.implement(
      native.$ServiceConnection(
        onServiceConnected: (componentName, iBinder) {
          localBinder = iBinder?.as(
            native.ExampleForegroundService$LocalBinder.type,
          );
          service = localBinder?.getService();

          // Converting proxy callback to stream subscription
          repliesSubscription = service?.replyStream.replies.listen((reply) {
            setState(() {
              messages.add((DateTime.now(), 'Service', reply));
            });
          });

          setState(() {});
        },
        onServiceDisconnected: (componentName) {
          service = null;
          localBinder = null;
          repliesSubscription?.cancel();
          setState(() {});
        },
        onBindingDied: (componentName) {
          service = null;
          localBinder = null;
          repliesSubscription?.cancel();
          setState(() {});
        },
        onNullBinding: (componentName) {
          service = null;
          localBinder = null;
          repliesSubscription?.cancel();
          setState(() {});
        },
      ),
    );

    // You can check synchronously if the permission is already granted or not
    hasPermission = checkPermission();
  }

  @override
  void dispose() {
    repliesSubscription?.cancel();
    super.dispose();
  }

  void startAndBind() {
    final context = jni.Jni.androidApplicationContext.as(native.Context.type);
    final intent = native.Intent.new$1(
      context,
      native.ExampleForegroundService.type.jClass,
    );
    context.bindService$1(
      intent,
      serviceConnection,
      native.Context$BindServiceFlags.of(native.Context.BIND_AUTO_CREATE),
    );

    setState(() {});
  }

  void requestPermission() {
    final engineId = PlatformDispatcher.instance.engineId;
    if (engineId == null) {
      print('Engine ID is null, cannot request permission');
      return;
    }
    // This is how you cast the Android Activity from JNI
    final activity = jni.Jni.androidActivity(
      engineId,
    )?.as(native.Activity.type);
    if (activity == null) {
      print('Activity is null, cannot request permission');
      return;
    }

    native.ActivityCompat.requestPermissions(
      activity,
      jni.JArray.of(jni.JString.type, [
        'android.permission.POST_NOTIFICATIONS'.toJString(),
      ]),
      0,
    );

    // set timer to poll for permissions (up to 30 seconds)
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final granted = checkPermission();
      if (granted) {
        setState(() {
          hasPermission = true;
        });
        timer.cancel();
      } else {
        print('Permission not granted yet, checking again...');
      }
    });
  }

  bool checkPermission() {
    final context = jni.Jni.androidApplicationContext.as(native.Context.type);

    final result = native.ContextCompat.checkSelfPermission(
      context,
      'android.permission.POST_NOTIFICATIONS'.toJString(),
    );
    return result == 0;
  }

void sendMessage() {
  if (service != null) {
    final msg = 'Hello from Flutter at ${DateTime.now()}';
    messages.add((DateTime.now(), 'Flutter', msg));
    service?.receiveMessage(msg.toJString());
  }
  setState(() {});
}

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Native Packages')),
        body: Container(
          padding: const .all(10),
          child: Column(
            children: [
              const Text('Foreground Service Interop Plugin', style: textStyle),
              spacerSmall,
              const Text(
                'You can start a foreground service from Flutter and then send messages to it using JNI. '
                'You can swipe awawy the app, and on coming back you can bind to '
                'the running foreground service and send messages to it.',
              ),
              spacerSmall,
              if (!hasPermission)
                ElevatedButton(
                  onPressed: requestPermission,
                  child: Text('Request permissions'),
                ),
              if (service == null)
                ElevatedButton(
                  onPressed: hasPermission ? startAndBind : null,
                  child: const Text('Start and Bind to Foreground Service'),
                ),
              if (service != null)
                ElevatedButton(
                  onPressed: sendMessage,
                  child: const Text('Send Message to Service'),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final (timestamp, sender, message) = messages[index];
                    return MessageTile(
                      sender: sender,
                      message: message,
                      timestamp: timestamp,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatefulWidget {
  const MessageTile({
    super.key,
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  final String sender;
  final String message;
  final DateTime timestamp;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.message),
      leading: CircleAvatar(child: Text(widget.sender[0])),
      subtitle: Text(widget.timestamp.timeAgo()),
    );
  }
}

extension on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 10) {
      return 'Just now';
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h ago';
    } else {
      return '${difference.inDays} d ago';
    }
  }
}
