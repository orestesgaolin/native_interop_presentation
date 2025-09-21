import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class ChannelsAndCodecsSlide extends FlutterDeckSlideWidget {
  const ChannelsAndCodecsSlide({
    super.key,
  }) : super(
         configuration: const FlutterDeckSlideConfiguration(
           route: '/channels_and_codecs',
           title: 'Channels & Codecs',
           header: FlutterDeckHeaderConfiguration(showHeader: false),
         ),
       );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.custom(
      builder: (context) {
        return const _Content();
      },
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({super.key});

  @override
  State<_Content> createState() => __ContentState();
}

class __ContentState extends State<_Content> {
  final AutoSizeGroup headerGroup = AutoSizeGroup();
  final AutoSizeGroup itemGroup = AutoSizeGroup();
  @override
  Widget build(BuildContext context) {
    final textStyle = FlutterDeckTheme.of(context).textTheme.bodyLarge;
    var colorHd = textStyle.copyWith(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: Colors.deepOrange,
    );
    var hd = textStyle.copyWith(
      fontSize: 48,
      fontWeight: FontWeight.bold,
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 32,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 32,
              children: [
                AutoSizeText(
                  'BasicMessageChannel',
                  style: hd,
                  group: headerGroup,
                  maxLines: 1,
                ),
                AutoSizeText(
                  'MessageCodec',
                  style: colorHd,
                  group: headerGroup,
                  maxLines: 1,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 32,
              children: [
                Flexible(
                  child: AutoSizeText(
                    'BinaryCodec',
                    style: textStyle,
                    group: itemGroup,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: AutoSizeText(
                    'StringCodec',
                    style: textStyle,
                    group: itemGroup,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: AutoSizeText(
                    'JSONMessageCodec',
                    style: textStyle,
                    group: itemGroup,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: AutoSizeText(
                    'StandardMessageCodec',
                    style: textStyle,
                    group: itemGroup,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 32,
              children: [
                Flexible(
                  child: AutoSizeText(
                    'MethodChannel',
                    style: hd,
                    group: headerGroup,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: AutoSizeText(
                    'EventChannel',
                    style: hd,
                    group: headerGroup,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: AutoSizeText(
                    'MethodCodec',
                    style: colorHd,
                    group: headerGroup,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 32,
              children: [
                Flexible(
                  child: AutoSizeText(
                    'JSONMethodCodec',
                    style: textStyle,
                    group: itemGroup,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: AutoSizeText(
                    'StandardMethodCodec',
                    style: textStyle,
                    group: itemGroup,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
