import 'package:flutter/material.dart';
import 'package:objective_c/objective_c.dart';
import 'uikit_bindings.g.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  void showDialog() {
    final controller = UIAlertController();
    controller.title = 'Dialog Title 123'.toNSString();
    controller.message = 'This is a dialog message.'.toNSString();
    controller.addAction(
      UIAlertAction.actionWithTitle(
        'OK'.toNSString(),
        style: UIAlertActionStyle.UIAlertActionStyleDefault,
        handler: null,
      ),
    );
    UIApplication.getSharedApplication().keyWindow?.rootViewController
        ?.presentViewController(controller, animated: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: showDialog,
            child: Text('Show Dialog'),
          ),
        ),
      ),  
    );
  }
}
