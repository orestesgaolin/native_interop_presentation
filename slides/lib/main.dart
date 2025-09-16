import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_deck_web_client/flutter_deck_web_client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slides/01_agenda.dart';
import 'package:slides/animated_mesh_gradient_background.dart';
import 'package:slides/channels_and_codecs_slide.dart';
import 'package:slides/code_highlight_slide.dart';
import 'package:slides/lava_gradient_background.dart';
import 'package:slides/message_channel_slide.dart';
import 'package:slides/other_talks.dart';
import 'package:slides/simple_table.dart';
import 'package:slides/stats_slide.dart';

void main() async {
  runApp(const MainApp());
}

final flutterDeckDarkTextTheme = FlutterDeckTextTheme(
  title: GoogleFonts.workbench(
    fontSize: 72,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  subtitle: GoogleFonts.bricolageGrotesque(
    fontSize: 36,
    color: Colors.white,
  ),
  header: GoogleFonts.bricolageGrotesque(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  display: GoogleFonts.bricolageGrotesque(
    fontSize: 103,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  bodyLarge: GoogleFonts.bricolageGrotesque(
    fontSize: 36,
    color: Colors.white,
  ),
  bodyMedium: GoogleFonts.bricolageGrotesque(
    fontSize: 24,
    color: Colors.white,
  ),
  bodySmall: GoogleFonts.bricolageGrotesque(
    fontSize: 16,
    color: Colors.white,
  ),
);
final flutterDeckLightTextTheme = FlutterDeckTextTheme(
  title: GoogleFonts.workbench(
    fontSize: 72,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 44, 44, 44),
  ),
  subtitle: GoogleFonts.bricolageGrotesque(
    fontSize: 36,
    color: const Color.fromARGB(255, 44, 44, 44),
  ),
  header: GoogleFonts.bricolageGrotesque(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 44, 44, 44),
  ),
  display: GoogleFonts.bricolageGrotesque(
    fontSize: 103,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 44, 44, 44),
  ),
  bodyLarge: GoogleFonts.bricolageGrotesque(
    fontSize: 36,
    color: const Color.fromARGB(255, 44, 44, 44),
  ),
  bodyMedium: GoogleFonts.bricolageGrotesque(
    fontSize: 24,
    color: const Color.fromARGB(255, 44, 44, 44),
  ),
  bodySmall: GoogleFonts.bricolageGrotesque(
    fontSize: 16,
    color: const Color.fromARGB(255, 44, 44, 44),
  ),
);
final darkTheme = FlutterDeckThemeData.fromThemeAndText(
  ThemeData(
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(
      onSurface: Colors.white,
    ),
  ),

  flutterDeckDarkTextTheme,
  speakerInfoWidgetTheme: FlutterDeckSpeakerInfoWidgetThemeData(
    descriptionTextStyle: flutterDeckDarkTextTheme.bodyMedium,
    socialHandleTextStyle: flutterDeckDarkTextTheme.bodyMedium,
    nameTextStyle: flutterDeckDarkTextTheme.bodyLarge.copyWith(
      color: Colors.deepOrange,
      fontWeight: FontWeight.bold,
    ),
  ),
);
final lightTheme = FlutterDeckThemeData.fromThemeAndText(
  ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      onSurface: const Color.fromARGB(255, 44, 44, 44),
    ),
  ),
  flutterDeckLightTextTheme,
  speakerInfoWidgetTheme: FlutterDeckSpeakerInfoWidgetThemeData(
    descriptionTextStyle: flutterDeckLightTextTheme.bodyMedium,
    nameTextStyle: flutterDeckLightTextTheme.bodyLarge.copyWith(
      color: Colors.deepOrange,
      fontWeight: FontWeight.bold,
    ),
    socialHandleTextStyle: flutterDeckLightTextTheme.bodyMedium,
  ),
);

class MainApp extends StatefulWidget {
  const MainApp({this.isPresenterView = false, super.key});

  final bool isPresenterView;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  Future<void> init() async {
    await precacheImage(
      const AssetImage('assets/visible-person.png'),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final author = 'Dominik Roszkowski';
    final website = 'roszkowski.dev';
    final title = 'From Method Channels to Native Interop';

    final slides = [
      FlutterDeckSlide.title(
        title: title,
        subtitle: 'Accessing native code has never been easier',
        theme: darkTheme,
        configuration: const FlutterDeckSlideConfiguration(
          route: '/start',
          title: 'Start',
          speakerNotes: '',
        ),
        backgroundBuilder: (context) {
          return const AnimatedMeshGradientBackground();
        },
        footerBuilder: (context) {
          return SizedBox();
        },
      ),
      FlutterDeckSlide.bigFact(
        title: 'Flutter gives you freedom to choose',
        theme: darkTheme,
        backgroundBuilder: (context) {
          return const AnimatedMeshGradientBackground();
        },
        configuration: const FlutterDeckSlideConfiguration(
          route: '/freedom',
          title: 'Freedom',
          speakerNotes: '',
        ),
      ),
      SizedBox.expand(
        child: Image.asset(
          'assets/visible-person.png',
          fit: BoxFit.cover,
        ),
      ),

      agendaSlide(),
      // StatsSlide(),
      MessageChannelSlide(),
      FlutterDeckSlide.bigFact(
        title: 'It\'s incredibly clever',
        subtitle:
            'This pattern is repeated across Android, iOS, macOS, Windows, Linux\n'
            'and expands to MethodChannel, EventChannel, and other codecs',
        configuration: const FlutterDeckSlideConfiguration(
          route: '/clever',
          title: 'Clever',
        ),
      ),
      FlutterDeckSlide.custom(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/embedders',
          title: 'Embedders',
          speakerNotes: '',
        ),
        builder: (context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(64.0),
              child: SimpleTable(
                data: [
                  [
                    'Dart',
                    'BinaryMessenger (Dart)',
                  ],
                  [
                    'Android',
                    'DartExecutor (JNI)',
                  ],
                  [
                    'iOS/macOS',
                    'FlutterEngine via proxy (Obj-C)',
                  ],
                  [
                    'Windows',
                    'FlutterDesktopEngine (C++)',
                  ],
                ],
              ),
            ),
          );
        },
      ),
      ChannelsAndCodecsSlide(),
      FlutterDeckSlide.blank(
        configuration: FlutterDeckSlideConfiguration(
          route: '/other-talks',
          speakerNotes: '',
          steps: listOfTalks.length,
          header: FlutterDeckHeaderConfiguration(
            title: 'Related talks at Fluttercon',
            showHeader: true,
          ),
          title: 'Related talks at Fluttercon',
        ),
        theme: lightTheme,
        builder: (context) {
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
                );
              }).toList(),
            ),
          );
        },
      ),
      FlutterDeckSlide.bigFact(
        title: 'Thank you',
        subtitle:
            'roszkowski.dev/plugins\n\n'
            'roszkowski.dev/shaders-gallery',
        backgroundBuilder: (context) => const LavaGradientBackground(),
        theme: darkTheme,
        configuration: FlutterDeckSlideConfiguration(
          route: '/end',
          footer: FlutterDeckFooterConfiguration(
            showFooter: false,
          ),
        ),
      ),
    ];
    return DefaultTextStyle(
      style: GoogleFonts.bricolageGrotesque(),
      child: FlutterDeckBulletListTheme(
        data: FlutterDeckBulletListThemeData(
          textStyle: lightTheme.textTheme.bodyLarge,
        ),
        child: FlutterDeckApp(
          client: FlutterDeckWebClient(),

          speakerInfo: FlutterDeckSpeakerInfo(
            name: author,
            description: 'Lead at Visible, GDE in Flutter',
            socialHandle: '@OrestesGaolin',
            imagePath: null,
          ),
          themeMode: ThemeMode.light,
          darkTheme: darkTheme,
          lightTheme: lightTheme,

          configuration: FlutterDeckConfiguration(
            footer: FlutterDeckFooterConfiguration(
              showFooter: true,
              showSlideNumbers: true,
              showSocialHandle: true,

              widget: Footer(
                author: author,
                website: website,
                title: title,
              ),
            ),

            progressIndicator: FlutterDeckProgressIndicator.gradient(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.pink, Colors.purple],
              ),
              backgroundColor: Colors.black,
            ),
            controls: FlutterDeckControlsConfiguration(
              presenterToolbarVisible: false,
            ),
          ),
          isPresenterView: widget.isPresenterView,
          slides: slides,
        ),
      ),
    );
  }
}

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
