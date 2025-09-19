// ignore_for_file: depend_on_referenced_packages

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slides/my_big_fact_slide.dart';

class CleverSlide extends StatelessWidget {
  const CleverSlide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.custom(
      configuration: const FlutterDeckSlideConfiguration(
        route: '/clever',
        title: 'Clever',
      ),
      builder: (context) => MyFlutterDeckBigFactSlide(
        title: 'It\'s incredibly clever',
        subtitleBuilder: (context) => Column(
          children: [
            AutoSizeText(
              'This pattern is repeated across Android, iOS, macOS, Windows, Linux\n'
              'and expands to MethodChannel, EventChannel, and other codecs',
              textAlign: TextAlign.center,
              style: FlutterDeckTheme.of(context).textTheme.subtitle,
            ),
            Center(
              child: Text(
                '(method + arguments)    (stream-based method channel)',
                textAlign: TextAlign.center,
                style: FlutterDeckTheme.of(context).textTheme.bodyMedium.copyWith(
                  fontStyle: FontStyle.italic,
                  fontFamily: GoogleFonts.schoolbell().fontFamily,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
