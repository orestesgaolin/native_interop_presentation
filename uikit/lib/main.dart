// ignore_for_file: avoid_print

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:objective_c/objective_c.dart' as objc;

import 'uikit_bindings.g.dart';

// Data classes for settings
enum SettingType { toggle, disclosure }

class SettingItem {
  final String title;
  final SettingType type;
  final dynamic value;
  final Function(dynamic)? onChanged;

  SettingItem({
    required this.title,
    required this.type,
    required this.value,
    this.onChanged,
  });
}

class SettingSection {
  final String title;
  final List<SettingItem> items;

  SettingSection({
    required this.title,
    required this.items,
  });
}

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
      settingsViewController.title = 'Settings'.toNSString();

      // Create main container view
      final mainView = UIView();
      mainView.backgroundColor = UIColorSystemColors.getSystemGroupedBackgroundColor();
      settingsViewController.view = mainView;

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

      // Create Done button
      final doneButton = UIBarButtonItem.alloc().initWithTitle$1('Done'.toNSString());
      settingsViewController.navigationItem.rightBarButtonItem = doneButton;

      // Create navigation controller
      final navController = UINavigationController().initWithRootViewController(settingsViewController);

      // Create settings data structure
      final settingsData = <SettingSection>[
        SettingSection(
          title: 'General',
          items: [
            SettingItem(
              title: 'Notifications',
              type: SettingType.toggle,
              value: true,
              onChanged: (value) => print('Notifications changed: $value'),
            ),
            SettingItem(
              title: 'Dark Mode',
              type: SettingType.toggle,
              value: false,
              onChanged: (value) => print('Dark Mode changed: $value'),
            ),
            SettingItem(
              title: 'Language',
              type: SettingType.disclosure,
              value: 'English',
              onChanged: (value) => print('Language tapped'),
            ),
          ],
        ),
        SettingSection(
          title: 'Privacy',
          items: [
            SettingItem(
              title: 'Location Services',
              type: SettingType.toggle,
              value: true,
              onChanged: (value) => print('Location Services changed: $value'),
            ),
            SettingItem(
              title: 'Analytics',
              type: SettingType.toggle,
              value: false,
              onChanged: (value) => print('Analytics changed: $value'),
            ),
            SettingItem(
              title: 'Camera Access',
              type: SettingType.toggle,
              value: true,
              onChanged: (value) => print('Camera Access changed: $value'),
            ),
          ],
        ),
      ];

      // Create settings UI manually with table-like appearance
      _createSettingsUI(contentView, settingsData, screenWidth);

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

  void _createSettingsUI(UIView contentView, List<SettingSection> settingsData, double screenWidth) {
    double currentY = 20;

    for (final section in settingsData) {
      // Create section header
      final headerLabel = UILabel();
      headerLabel.text = section.title.toNSString();
      headerLabel.font = UIFont.systemFontOfSize(13);
      headerLabel.textColor = UIColorSystemColors.getSecondaryLabelColor();
      contentView.addSubview(headerLabel);
      UIViewGeometry(headerLabel).frame = createCGRect(16, currentY, screenWidth - 32, 20);

      currentY += 30;

      // Create a background view for the section
      final sectionBackgroundView = UIView();
      sectionBackgroundView.backgroundColor = UIColorSystemColors.getSecondarySystemBackgroundColor();
      contentView.addSubview(sectionBackgroundView);

      final sectionHeight = section.items.length * 44.0;
      UIViewGeometry(sectionBackgroundView).frame = createCGRect(0, currentY, screenWidth, sectionHeight);

      // Create cells for each item in the section
      double itemY = 0;
      for (final item in section.items) {
        final cellView = _createSettingsCell(item, screenWidth);
        sectionBackgroundView.addSubview(cellView);
        UIViewGeometry(cellView).frame = createCGRect(0, itemY, screenWidth, 44);
        itemY += 44;
      }

      currentY += sectionHeight + 30; // Add spacing between sections
    }

    // Update content view size
    UIViewGeometry(contentView).frame = createCGRect(0, 0, screenWidth, currentY);
  }

  UIView _createSettingsCell(SettingItem item, double width) {
    final cellView = UIView();

    // Add separator line at bottom
    final separatorView = UIView();
    separatorView.backgroundColor = UIColorSystemColors.getSeparatorColor();
    cellView.addSubview(separatorView);
    UIViewGeometry(separatorView).frame = createCGRect(16, 43, width - 16, 1);

    // Title label
    final titleLabel = UILabel();
    titleLabel.text = item.title.toNSString();
    titleLabel.font = UIFont.systemFontOfSize(17);
    cellView.addSubview(titleLabel);
    UIViewGeometry(titleLabel).frame = createCGRect(16, 0, width - 100, 44);

    if (item.type == SettingType.toggle) {
      // Create switch
      final switchControl = UISwitch();
      switchControl.on$ = item.value as bool;
      
      cellView.addSubview(switchControl);

      final switchWidth = 51.0;
      UIViewGeometry(switchControl).frame = createCGRect(
        width - switchWidth - 16,
        (44 - 31) / 2, // Center vertically (31 is UISwitch height)
        switchWidth,
        31,
      );

      // Note: In a complete implementation, you'd set up target-action pattern:
      // switchControl.addTarget(target, action: selector, for: .valueChanged)
      // The callback would call: item.onChanged?.call(switchControl.on)
    } else {
      // Create detail label for disclosure indicator rows
      final detailLabel = UILabel();
      detailLabel.text = (item.value as String).toNSString();
      detailLabel.textColor = UIColorSystemColors.getSecondaryLabelColor();
      detailLabel.font = UIFont.systemFontOfSize(17);
      detailLabel.textAlignment = NSTextAlignment.NSTextAlignmentRight;
      cellView.addSubview(detailLabel);
      UIViewGeometry(detailLabel).frame = createCGRect(width - 200, 0, 165, 44);

      // Add disclosure indicator (>)
      final disclosureLabel = UILabel();
      disclosureLabel.text = '>'.toNSString();
      disclosureLabel.textColor = UIColorSystemColors.getSecondaryLabelColor();
      disclosureLabel.font = UIFont.systemFontOfSize(17);
      disclosureLabel.textAlignment = NSTextAlignment.NSTextAlignmentCenter;
      cellView.addSubview(disclosureLabel);
      UIViewGeometry(disclosureLabel).frame = createCGRect(width - 30, 0, 20, 44);
    }

    return cellView;
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
