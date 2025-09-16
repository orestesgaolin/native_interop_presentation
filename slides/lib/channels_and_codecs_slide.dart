import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class ChannelsAndCodecsSlide extends StatelessWidget {
  const ChannelsAndCodecsSlide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.custom(
      configuration: const FlutterDeckSlideConfiguration(
        route: '/codecs',
        title: 'Codecs',
        speakerNotes: '',
      ),
      builder: (context) {
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
                    Text(
                      'BasicMessageChannel',
                      style: hd,
                    ),
                    Text(
                      'MessageCodec',
                      style: colorHd,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 32,
                  children: [
                    Text('BinaryCodec', style: textStyle),
                    Text('StringCodec', style: textStyle),
                    Text('JSONMessageCodec', style: textStyle),
                    Text('StandardMessageCodec', style: textStyle),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 32,
                  children: [
                    Text(
                      'MethodChannel',
                      style: hd,
                    ),
                    Text(
                      'EventChannel',
                      style: hd,
                    ),
                    Text(
                      'MethodCodec',
                      style: colorHd,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 32,
                  children: [
                    Text('JSONMethodCodec', style: textStyle),
                    Text('StandardMethodCodec', style: textStyle),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
