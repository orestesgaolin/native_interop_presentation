import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class FinalWordsSlide extends FlutterDeckSlideWidget {
  const FinalWordsSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/final-words',
          title: 'Final Remarks',
          speakerNotes: '',
          header: FlutterDeckHeaderConfiguration(
            title: 'Final Remarks',
            showHeader: true,
          ),
          steps: 1,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) {
        return FlutterDeckSlideStepsBuilder(
          builder: (context, stepNumber) {
            return FlutterDeckBulletList(
              // useSteps: true,
              // stepOffset: 6,
              items: const [
                'Native Interop is getting better - jnigen practically production ready',
                'ObjC Interop is doing really well - package:objective_c 8.1.0 brought nice updates',
                'Swift and swiftgen are in very early stages',
                'Dart Hooks are coming!',
              ],
            );
          },
        );
      },
      configuration: configuration,
    );
  }
}
