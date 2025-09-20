import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class MoreJnigenSlide extends FlutterDeckSlideWidget {
  const MoreJnigenSlide({
    super.key,
  }) : super(
         configuration: const FlutterDeckSlideConfiguration(
           route: '/jnigen-more',
           title: 'More jnigen',
           speakerNotes: '',
           header: FlutterDeckHeaderConfiguration(
             title: 'More about jnigen',
             showHeader: true,
           ),
           steps: 5,
         ),
       );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      configuration: configuration,
      builder: (context) {
        return FlutterDeckSlideStepsBuilder(
          builder: (context, stepNumber) {
            return Column(
              children: [
                FlutterDeckBulletList(
                  useSteps: true,
                  stepOffset: 1,
                  items: [
                    'works with app source code, plugins, compiled jars',
                    'at Visible we used it to generate bindings for Java obfuscated SDK',
                    'works for Android, Windows and Linux',
                  ],
                ),
                Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: stepNumber > 4 ? 1 : 0,
                    child: SizedBox(
                      width: double.infinity,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              Positioned(
                                top: 40,
                                bottom: 0,
                                right: constraints.maxWidth / 2 - 450,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 50,
                                        spreadRadius: 10,
                                        offset: const Offset(0, 40),
                                      ),
                                    ],
                                  ),

                                  child: Image.asset(
                                    'assets/screenshot_20250920_165417.png',
                                    width: 500,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: constraints.maxWidth / 2 - 450,
                                top: 0,
                                bottom: 40,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 50,
                                        spreadRadius: 10,
                                        offset: const Offset(0, 40),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/screenshot_20250920_165405.png',
                                    width: 500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
