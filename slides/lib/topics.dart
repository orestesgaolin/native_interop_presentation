import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/animated_mesh_gradient_background.dart';
import 'package:slides/main.dart';

FlutterDeckSlideWidget topicsSlide() {
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
      steps: 10,
      title: 'Agenda',

      header: FlutterDeckHeaderConfiguration(showHeader: false),
    ),
    theme: darkTheme,
  );
}

class ThisSlideCard extends StatelessWidget {
  const ThisSlideCard({
    super.key,
    required this.title,
    required this.toptems,
    required this.bottomItems,
    required this.currentStep,
    required this.showOnStep,
    required this.showItemsOnFollowingSteps,
    this.headerGroup,
    this.itemGroup,
  });

  final String title;
  final List<String> toptems;
  final List<String> bottomItems;
  final int currentStep;
  final int showOnStep;
  final bool showItemsOnFollowingSteps;
  final AutoSizeGroup? headerGroup;
  final AutoSizeGroup? itemGroup;

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
    final itemsGroup = itemGroup ?? AutoSizeGroup();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: currentStep > showOnStep ? 1 : 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              AutoSizeText(
                title,
                style: header,
                maxLines: 1,
                group: headerGroup,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 32,
                children: [
                  for (var i = 0; i < toptems.length; i++)
                    Flexible(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: currentStep > (showItemsOnFollowingSteps ? (showOnStep + i) : showOnStep) ? 1 : 0,
                        child: AutoSizeText(
                          toptems[i],
                          style: item,
                          maxLines: 1,
                          group: itemsGroup,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              if (bottomItems.isNotEmpty) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 32,
                  children: [
                    for (var i = 0; i < bottomItems.length; i++)
                      Flexible(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: currentStep > (showItemsOnFollowingSteps ? (showOnStep + toptems.length + i) : showOnStep) ? 1 : 0,
                          child: AutoSizeText(
                            bottomItems[i],
                            style: item,
                            maxLines: 1,
                            group: itemsGroup,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class Content extends StatefulWidget {
  const Content({
    super.key,
    required this.stepNumber,
  });
  final int stepNumber;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final AutoSizeGroup headerGroup = AutoSizeGroup();
  final AutoSizeGroup itemsGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 32,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: ThisSlideCard(
                title: 'Platform Channels',
                toptems: [
                  'Method Channel',
                  'Event Channel',
                ],
                bottomItems: const [
                  'BasicMessageChannel',
                ],
                currentStep: widget.stepNumber,
                showOnStep: 1,
                showItemsOnFollowingSteps: true,
                headerGroup: headerGroup,
                itemGroup: itemsGroup,
              ),
            ),
            const SizedBox(width: 64),
            Flexible(
              child: ThisSlideCard(
                title: 'Codecs',
                toptems: [
                  'BinaryCodec',
                  'MessageCodec',
                ],
                bottomItems: const [
                  'MethodCodec',
                  'JSONMessageCodec...',
                ],
                currentStep: widget.stepNumber,
                showOnStep: 4,
                showItemsOnFollowingSteps: true,
                headerGroup: headerGroup,
                itemGroup: itemsGroup,
              ),
            ),
          ],
        ),

        ThisSlideCard(
          title: 'Embedder',
          toptems: [
            'Android',
            'iOS/macOS',
          ],
          bottomItems: const [
            'Windows, Linux, Web...',
          ],
          currentStep: widget.stepNumber,
          showOnStep: 8,
          showItemsOnFollowingSteps: false,
          headerGroup: headerGroup,
          itemGroup: itemsGroup,
        ),

        ThisSlideCard(
          title: 'Direct Native Interop',
          toptems: [
            'jnigen',
            'ffigen',
          ],
          bottomItems: const [
            'swiftgen',
          ],
          currentStep: widget.stepNumber,
          showOnStep: 9,
          showItemsOnFollowingSteps: false,
          headerGroup: headerGroup,
          itemGroup: itemsGroup,
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
