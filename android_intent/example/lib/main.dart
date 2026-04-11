import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:android_intent/android_intent.dart' as a;
import 'package:jni/jni.dart';
import 'package:jni_flutter/jni_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  a.ActivityResultListenerProxy? listener;

  @override
  void initState() {
    super.initState();
  }

  void openEmailRaw() {
    try {
      final intent = a.Intent.new$3(a.Intent.ACTION_SENDTO);
      intent.setData(a.Uri.parse("mailto:".toJString()));

      intent.putExtra$19(
        a.Intent.EXTRA_EMAIL,
        JArray.of<JString>(JString.type, ["example@example.com".toJString()]),
      );
      intent.putExtra$18(
        a.Intent.EXTRA_SUBJECT,
        "This is a sample e-mail subject".toJString(),
      );
      intent.putExtra$18(
        a.Intent.EXTRA_TEXT,
        "This is a sample e-mail body".toJString(),
      );
      intent.putExtra$19(
        a.Intent.EXTRA_CC,
        JArray.of<JString>(JString.type, ["cc@example.com".toJString()]),
      );

      intent.setFlags(a.Intent.FLAG_ACTIVITY_NEW_TASK);
      // ignore: invalid_use_of_internal_member
      a.Context contextInstance = androidApplicationContext.as(a.Context.type);

      contextInstance.startActivity(intent);
    } catch (e) {
      print('Error opening email: $e');
    }
  }

  void selectContact() {
    try {
      final intent = a.Intent.new$3(a.Intent.ACTION_PICK);
      intent.setType(a.ContactsContract$Contacts.CONTENT_TYPE);

      listener = a.ActivityResultListenerProxy.Companion.instance;
      listener!.onResultListener =
          a.ActivityResultListenerProxy$OnResultListener.implement(
            a.$ActivityResultListenerProxy$OnResultListener(
              onResult: (result, request, data) {
                print(
                  'ARLP Selected contact: $result, request: $request, data: $data',
                );
              },
            ),
          );

      // ignore: invalid_use_of_internal_member
      final engineId = PlatformDispatcher.instance.engineId;
      if (engineId == null) {
        print('Error: Engine ID is null');
        return;
      }

      final activity = androidActivity(engineId);
      if (activity == null) {
        print('Error: Activity is null');
        return;
      }
      activity.as(a.Activity.type).startActivityForResult(intent, 1);
    } catch (e) {
      print('Error selecting contact: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: openEmailRaw,
                child: const Text('Open Email Raw'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: selectContact,
                child: const Text('Select Contact'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
