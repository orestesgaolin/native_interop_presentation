import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/animated_mesh_gradient_background.dart';
import 'package:slides/main.dart';

FlutterDeckSlideWidget agendaSlide() {
  return FlutterDeckSlide.blank(
    backgroundBuilder: (context) {
      return const AnimatedMeshGradientBackground();
    },

    builder: (context) => FlutterDeckSlideStepsBuilder(
      builder: (context, stepNumber) {
        return Content(
          stepNumber: stepNumber,
        );
      },
    ),
    configuration: const FlutterDeckSlideConfiguration(
      route: '/agenda',
      steps: 12,
      title: 'Agenda',

      header: FlutterDeckHeaderConfiguration(showHeader: false),
    ),
    theme: darkTheme,
  );
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.stepNumber,
  });
  final int stepNumber;

  @override
  Widget build(BuildContext context) {
    final textStyle = FlutterDeckTheme.of(context).textTheme.bodyMedium;
    var header = textStyle.copyWith(
      color: Colors.black,
      fontSize: 48,
      fontWeight: FontWeight.bold,
    );
    var item = textStyle.copyWith(
      color: Colors.black,
      fontSize: 32,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 32,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: stepNumber > 1 ? 1 : 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        Text(
                          'Platform Channels',
                          style: header,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 32,
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: stepNumber > 2 ? 1 : 0,
                              child: Text(
                                'Method Channel',
                                style: item,
                              ),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: stepNumber > 3 ? 1 : 0,
                              child: Text(
                                'Event Channel',
                                style: item,
                              ),
                            ),
                          ],
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: stepNumber > 4 ? 1 : 0,
                          child: Text(
                            'BasicMessageChannel',
                            style: item,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 64),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: stepNumber > 5 ? 1 : 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        Text(
                          'Codecs',
                          style: header,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 32,
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: stepNumber > 6 ? 1 : 0,
                              child: Text(
                                'BinaryCodec',
                                style: item,
                              ),
                            ),

                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: stepNumber > 7 ? 1 : 0,
                              child: Text(
                                'MessageCodec',
                                style: item,
                              ),
                            ),

                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: stepNumber > 8 ? 1 : 0,
                              child: Text(
                                'MethodCodec',
                                style: item,
                              ),
                            ),
                          ],
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: stepNumber > 9 ? 1 : 0,
                          child: Text(
                            'JSONMessageCodec...',
                            style: item,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: stepNumber > 10 ? 1 : 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 500),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Embedder',
                      style: header,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Android',
                          style: item,
                        ),

                        const SizedBox(width: 32),
                        Text(
                          'iOS/macOS',
                          style: item,
                        ),
                      ],
                    ),

                    const SizedBox(width: 32),
                    Text(
                      'Windows, Linux, Web...',
                      style: item,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: stepNumber > 11 ? 1 : 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 500),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Direct Native Interop',
                      style: header,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'jnigen',
                          style: item,
                        ),

                        const SizedBox(width: 32),
                        Text(
                          'ffigen',
                          style: item,
                        ),
                      ],
                    ),

                    const SizedBox(width: 32),
                    Text(
                      'swiftgen',
                      style: item,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: FlutterDeckTheme.of(context).bulletListTheme.textStyle,
    );
  }
}
