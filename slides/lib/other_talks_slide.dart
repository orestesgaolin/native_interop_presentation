import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/main.dart';
import 'package:slides/other_talks.dart';

class OtherTalksSlide extends StatefulWidget {
  const OtherTalksSlide({
    super.key,
  });

  @override
  State<OtherTalksSlide> createState() => _OtherTalksSlideState();
}

class _OtherTalksSlideState extends State<OtherTalksSlide> {
  final titleGroup = AutoSizeGroup();
  final detailsGroup = AutoSizeGroup();
  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlideStepsBuilder(
      builder: (context, stepNumber) => GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        mainAxisSpacing: 32,
        crossAxisSpacing: 32,
        children: listOfTalks.mapIndexed((i, e) {
          return TalkTile(
            talk: e,
            isHighlighted: stepNumber - 1 == i,
            titleGroup: titleGroup,
            detailsGroup: detailsGroup,
          );
        }).toList(),
      ),
    );
  }
}
