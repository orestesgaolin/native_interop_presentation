// How to design a Dart package with hooks
// 11:20 AM – 11:40 AM → 20 min
// By Moritz Sümmermann
// Lightning talk, Introductory and overview, Dart FFI, Open Source Contributions, Fluttercon
// Dash's Domain

// Who is a Native Bindings Author and why you should be one
// 01:45 PM – 02:25 PM → 40 min
// By Hossein Yousefi
// Session, Intermediate, Native Platform Integration, Fluttercon
// Pub.dev Plaza

// Unlocking Native Power: Deep Dive into Dart Build Hooks
// 02:40 PM – 03:20 PM → 40 min
// By Daco Harkes
// Session, Intermediate, Native Platform Integration, Dart FFI, Fluttercon
// Widget Way

// Using Dart FFI for Compute-Heavy Tasks in Flutter Apps
// 04:20 PM – 05:00 PM → 40 min
// By Robert Odrowaz-Sypniewski
// Session, Intermediate, Performance Optimization, Dart FFI, Fluttercon
// Widget Way

// Surviving the Long Game: Maintaining Flutter Apps Over Time
// 01:15 PM – 01:55 PM → 40 min Friday
// By Dominik Roszkowski, Simon Lightfoot
// Roundtable, Advanced, Flutter Multiplatform, Architecture, Enterprise/Tech Leadership, Fluttercon
// Flutter Forum

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class Talk {
  final String title;
  final String time;
  final String speaker;
  final String tags;
  final String location;

  Talk({
    required this.title,
    required this.time,
    required this.speaker,
    required this.tags,
    required this.location,
  });
}

final listOfTalks = [
  Talk(
    title: 'How to design a Dart package with hooks',
    time: 'Today 11:20 AM',
    speaker: 'Moritz Sümmermann',
    tags: 'Lightning talk, Introductory and overview, Dart FFI, Open Source Contributions, Fluttercon',
    location: 'Dash\'s Domain',
  ),
  Talk(
    title: 'Who is a Native Bindings Author and why you should be one',
    time: 'Today 01:45 PM',
    speaker: 'Hossein Yousefi',
    tags: 'Session, Intermediate, Native Platform Integration, Fluttercon',
    location: 'Pub.dev Plaza',
  ),
  Talk(
    title: 'Unlocking Native Power: Deep Dive into Dart Build Hooks',
    time: 'Today 02:40 PM',
    speaker: 'Daco Harkes',
    tags: 'Session, Intermediate, Native Platform Integration, Dart FFI, Fluttercon',
    location: 'Widget Way',
  ),
  Talk(
    title: 'Using Dart FFI for Compute-Heavy Tasks in Flutter Apps',
    time: 'Today 04:20 PM',
    speaker: 'Robert Odrowąż-Sypniewski',
    tags: 'Session, Intermediate, Performance Optimization, Dart FFI, Fluttercon',
    location: 'Widget Way',
  ),
  Talk(
    title: 'Surviving the Long Game: Maintaining Flutter Apps Over Time',
    time: 'Friday 01:15 PM',
    speaker: 'Dominik Roszkowski, Simon Lightfoot',
    tags: 'Roundtable, Advanced, Flutter Multiplatform, Architecture, Enterprise/Tech Leadership, Fluttercon',
    location: 'Flutter Forum',
  ),
];

class TalkTile extends StatelessWidget {
  const TalkTile({
    super.key,
    required this.talk,
    required this.isHighlighted,
    required this.titleGroup,
    required this.detailsGroup,
  });

  final Talk talk;
  final bool isHighlighted;
  final AutoSizeGroup titleGroup;
  final AutoSizeGroup detailsGroup;

  @override
  Widget build(BuildContext context) {
    final header = FlutterDeckTheme.of(context).textTheme.bodyLarge;
    final subHeader = FlutterDeckTheme.of(context).textTheme.bodyMedium;
    final smallerSubHeader = FlutterDeckTheme.of(context).textTheme.bodySmall;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: ShapeDecoration(
        shape: RoundedSuperellipseBorder(
          side: const BorderSide(
            color: Colors.black12,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        color: isHighlighted ? Colors.blue.withOpacity(0.1) : Colors.blue.withOpacity(0.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  AutoSizeText.rich(
                    TextSpan(
                      text: talk.title,
                    ),
                    style: header,
                    minFontSize: 20,
                    group: titleGroup,
                    maxLines: 2,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                talk.speaker,
                                style: smallerSubHeader.copyWith(color: Colors.deepOrange),
                                group: detailsGroup,
                              ),
                            ),
                            Flexible(
                              child: AutoSizeText(
                                talk.location,
                                style: smallerSubHeader,
                                group: detailsGroup,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          talk.time,
                          style: subHeader,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
