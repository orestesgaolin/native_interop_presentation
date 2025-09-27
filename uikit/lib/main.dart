// ignore_for_file: avoid_print

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:objective_c/objective_c.dart' as objc;

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
    try {
      final handler = ObjCBlock_ffiVoid_UIAlertAction.listener((action) {
        print('done: ${action.title?.toDartString()}');
      });
      final completion = ObjCBlock_ffiVoid.listener(() {
        print('completed');
      });
      final controller = UIAlertController();
      controller.title = 'Dialog Title 123'.toNSString();
      controller.message = 'This is a dialog message.'.toNSString();
      controller.addAction(
        UIAlertAction.actionWithTitle(
          'OK'.toNSString(),
          style: UIAlertActionStyle.UIAlertActionStyleDefault,
          handler: handler,
        ),
      );
      controller.addAction(
        UIAlertAction.actionWithTitle(
          'Cancel'.toNSString(),
          style: UIAlertActionStyle.UIAlertActionStyleCancel,
          handler: handler,
        ),
      );

      UIApplication.getSharedApplication().keyWindow?.rootViewController?.presentViewController(
        controller,
        animated: true,
        completion: completion,
      );
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  void showViewController() {
    try {
      final completion = ObjCBlock_ffiVoid.listener(() {
        print('completed');
      });
      final newViewController = UIViewController();
      final view = UIView();
      final size = MediaQuery.of(context).size;
      final screenWidth = size.width;
      final label = UILabel();
      label.text = 'This is a custom view controller'.toNSString();
      view.addSubview(label);
      label.textAlignment = NSTextAlignment.NSTextAlignmentCenter;
      final labelWidth = label.intrinsicContentSize.width;

      UIViewGeometry(label).frame = createCGRect(
        screenWidth / 2 - labelWidth / 2,
        100,
        labelWidth,
        label.intrinsicContentSize.height,
      );
      label.sizeToFit();
      newViewController.view = view;
      newViewController.view.backgroundColor = Colors.amber.toUIColor();
      UIApplication.getSharedApplication().keyWindow?.rootViewController?.presentViewController(
        newViewController,
        animated: true,
        completion: completion,
      );
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: showDialog,
                child: Text('Show Dialog'),
              ),
              ElevatedButton(
                onPressed: showViewController,
                child: Text('Show View Controller'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on Color {
  UIColor toUIColor() {
    return UIColor.colorWithRed(
      r,
      green: g,
      blue: b,
      alpha: a,
    );
  }
}

objc.CGRect createCGRect(double x, double y, double width, double height) {
  final ptr = calloc<objc.CGRect>();
  ptr.ref.origin.x = x;
  ptr.ref.origin.y = y;
  ptr.ref.size.width = width;
  ptr.ref.size.height = height;
  return ptr.ref;
}
