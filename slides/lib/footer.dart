import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
    required this.author,
    required this.website,
    required this.title,
  });
  final String author;
  final String website;
  final String title;

  @override
  Widget build(BuildContext context) {
    final footerTheme = FlutterDeckTheme.of(context).footerTheme;
    final bodySmall = FlutterDeckTheme.of(context).textTheme.bodySmall;
    return Row(
      spacing: 16,
      children: [
        Text(
          title,
          style: footerTheme.socialHandleTextStyle?.copyWith(
            fontSize: bodySmall.fontSize,
          ),
        ),
        Text(
          '$author | $website',
          style: footerTheme.socialHandleTextStyle?.copyWith(
            fontSize: bodySmall.fontSize,
          ),
        ),
      ],
    );
  }
}
