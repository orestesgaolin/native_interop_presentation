import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/lava_gradient_background.dart';

class NativeDartSlide extends FlutterDeckSlideWidget {
  const NativeDartSlide({
    super.key,
  }) : super(
         configuration: const FlutterDeckSlideConfiguration(
           route: '/native',
           title: 'Dart native',
           speakerNotes: '',
         ),
       );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) {
        return Center(
          child: Image.asset(
            'assets/dart-native-gh.png',
            fit: BoxFit.cover,
          ),
        );
      },
      backgroundBuilder: (context) {
        return LavaGradientBackground();
      },
      configuration: this.configuration,
    );
  }
}
