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
      final controller = UIAlertController.alertControllerWithTitle(
        'Title'.toNSString(),
        message: 'Message'.toNSString(),
        preferredStyle: UIAlertControllerStyle.UIAlertControllerStyleAlert,
      );
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

  void showSettingsScreen() {
    try {
      final completion = ObjCBlock_ffiVoid.listener(() {
        print('Settings screen presented');
      });

      // Create main view controller
      final settingsViewController = UIViewController();
      final mainView = UIView();
      mainView.backgroundColor = UIColorSystemColors.getSystemBackgroundColor();
      settingsViewController.view = mainView;

      // Create navigation controller with the settings view controller
      final navController = UINavigationController().initWithRootViewController(settingsViewController);

      // Set up navigation bar
      settingsViewController.title = 'Settings'.toNSString();

      // Create Done button
      // final doneHandler = ObjCBlock_button.listener((button) {
      //   print('Settings dismissed');
      //   navController.dismissViewControllerAnimated(true, completion: null);
      // });

      final doneButton = UIBarButtonItem.alloc().initWithTitle$1(
        'Done'.toNSString(),
        // style: UIBarButtonItemStyle.UIBarButtonItemStyleDone,
        // target: null,
        // action: null, // Will need to set up proper target-action later
      );

      settingsViewController.navigationItem.rightBarButtonItem = doneButton;

      // Create scroll view for settings content
      final scrollView = UIScrollView();
      mainView.addSubview(scrollView);

      final size = MediaQuery.of(context).size;
      final screenWidth = size.width;
      final screenHeight = size.height;

      UIViewGeometry(scrollView).frame = createCGRect(0, 0, screenWidth, screenHeight);

      // Content view inside scroll view
      final contentView = UIView();
      scrollView.addSubview(contentView);
      UIViewGeometry(contentView).frame = createCGRect(0, 0, screenWidth, 600); // Adjust height as needed

      double currentY = 20;
      final padding = 20.0;
      final rowHeight = 44.0;

      // Helper function to create setting rows
      void createSettingRow(String title, String subtitle, bool isToggle, bool initialValue, Function(bool) onChanged) {
        // Background view for the row
        final rowView = UIView();
        contentView.addSubview(rowView);
        rowView.backgroundColor = UIColorSystemColors.getSecondarySystemBackgroundColor();
        UIViewGeometry(rowView).frame = createCGRect(padding, currentY, screenWidth - (padding * 2), rowHeight);

        // Title label
        final titleLabel = UILabel();
        titleLabel.text = title.toNSString();
        titleLabel.font = UIFont.systemFontOfSize(17);
        rowView.addSubview(titleLabel);
        UIViewGeometry(titleLabel).frame = createCGRect(15, 0, 200, rowHeight);

        if (isToggle) {
          // Create UISwitch (toggle)
          final toggle = UISwitch();
          toggle.on$ = initialValue;

          // Create callback for toggle changes
          // final toggleHandler = ObjCBlock_ffiVoid_UISwitch.listener((switchControl) {
          //   final newValue = switchControl.on;
          //   print('Toggle "$title" changed to: $newValue');
          //   onChanged(newValue);
          // });

          // Note: You'll need to set up proper target-action for the switch
          // toggle.addTarget(target, action: #selector(toggleChanged:), for: .valueChanged)

          rowView.addSubview(toggle);
          final toggleWidth = 51.0; // Standard UISwitch width
          UIViewGeometry(toggle).frame = createCGRect(
            screenWidth - padding - toggleWidth - 15,
            (rowHeight - 31) / 2, // Center vertically (31 is standard switch height)
            toggleWidth,
            31,
          );
        } else {
          // Create detail label for non-toggle rows
          final detailLabel = UILabel();
          detailLabel.text = subtitle.toNSString();
          detailLabel.textColor = UIColorSystemColors.getSecondaryLabelColor();
          detailLabel.font = UIFont.systemFontOfSize(15);
          detailLabel.textAlignment = NSTextAlignment.NSTextAlignmentRight;
          rowView.addSubview(detailLabel);
          UIViewGeometry(detailLabel).frame = createCGRect(screenWidth - 200, 0, 180, rowHeight);
        }

        currentY += rowHeight + 1; // Add 1px separator
      }

      // Create settings sections

      // Section 1: General Settings
      createSectionHeader(contentView, 'General', currentY, screenWidth, padding);
      currentY += 30;

      createSettingRow('Notifications', '', true, true, (value) {
        print('Notifications setting changed: $value');
        // Handle notifications setting change
      });

      createSettingRow('Dark Mode', '', true, false, (value) {
        print('Dark Mode setting changed: $value');
        // Handle dark mode setting change
      });

      createSettingRow('Language', 'English', false, false, (value) {
        print('Language tapped');
        // Handle language selection
      });

      // Add some spacing
      currentY += 20;

      // Section 2: Privacy Settings
      createSectionHeader(contentView, 'Privacy', currentY, screenWidth, padding);
      currentY += 30;

      createSettingRow('Location Services', '', true, true, (value) {
        print('Location Services setting changed: $value');
        // Handle location services setting change
      });

      createSettingRow('Analytics', '', true, false, (value) {
        print('Analytics setting changed: $value');
        // Handle analytics setting change
      });

      createSettingRow('Camera Access', '', true, true, (value) {
        print('Camera Access setting changed: $value');
        // Handle camera access setting change
      });

      // Update scroll view content size
      scrollView.contentSize$1 = createCGSize(screenWidth, currentY + 50);

      // Present the navigation controller
      UIApplication.getSharedApplication().keyWindow?.rootViewController?.presentViewController(
        navController,
        animated: true,
        completion: completion,
      );
    } catch (e, s) {
      print('Error showing settings: $e');
      print(s);
    }
  }

  void createSectionHeader(UIView parentView, String title, double y, double screenWidth, double padding) {
    final headerLabel = UILabel();
    headerLabel.text = title.toNSString();
    headerLabel.font = UIFont.systemFontOfSize(13);
    headerLabel.textColor = UIColorSystemColors.getSecondaryLabelColor();
    parentView.addSubview(headerLabel);
    UIViewGeometry(headerLabel).frame = createCGRect(padding, y, screenWidth - (padding * 2), 20);
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
              ElevatedButton(
                onPressed: showSettingsScreen,
                child: Text('Show Settings Screen'),
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

objc.CGSize createCGSize(double width, double height) {
  final ptr = calloc<objc.CGSize>();
  ptr.ref.width = width;
  ptr.ref.height = height;
  return ptr.ref;
}
