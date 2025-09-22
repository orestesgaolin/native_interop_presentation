import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_deck_web_client/flutter_deck_web_client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slides/animated_shake_shader.dart';
import 'package:slides/final_words_slide.dart';
import 'package:slides/other_talks_slide.dart';
import 'package:slides/swiftgen_slide.dart';
import 'package:slides/topics.dart';
import 'package:slides/animated_bokeh_background.dart';
import 'package:slides/animated_mesh_gradient_background.dart';
import 'package:slides/channels_and_codecs_slide.dart';
import 'package:slides/clever_slide.dart';
import 'package:slides/footer.dart';
import 'package:slides/kotlin_interop_slides.dart';
import 'package:slides/lava_gradient_background.dart';
import 'package:slides/message_channel_slide.dart';
import 'package:slides/more_jnigen_slide.dart';
import 'package:slides/native_dart_slide.dart';
import 'package:slides/other_talks.dart';
import 'package:slides/swift_interop_slide.dart';
import 'package:slides/webview_mermaid.dart';

double _codeSize = 28;
double get codeSize => _codeSize;

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
        title: 'Flutter native interop is great',
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
      FlutterDeckSlide.blank(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/visible',
          title: 'Visible',
          speakerNotes: '',
          steps: 4,
        ),
        backgroundBuilder: (context) {
          return SizedBox.expand(
            child: Image.asset(
              'assets/visible-person.png',
              fit: BoxFit.cover,
            ),
          );
        },
        theme: darkTheme,

        builder: (context) => FlutterDeckBulletListTheme(
          data: FlutterDeckBulletListThemeData(
            textStyle: darkTheme.textTheme.bodyLarge,
          ),
          child: Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/visible.png',
                      height: 50,
                    ),
                    const SizedBox(height: 32),
                    FlutterDeckBulletList(
                      useSteps: true,
                      stepOffset: 1,
                      items: [
                        'symptoms tracker for people with chronic conditions',
                        'a lot of native integrations',
                        'experimenting with native interop',
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),

      topicsSlide(),
      FlutterDeckSlide.bigFact(
        title: 'Platform Channels',
        subtitle: 'Message Channel, Method Channel, Event Channel',

        configuration: const FlutterDeckSlideConfiguration(
          route: '/platform-channels',
          title: 'platform-channels',
        ),
      ),
      FlutterDeckSlide.bigFact(
        title: 'Platform Channels',
        subtitle: 'Easy, flexible but verbose',
        configuration: const FlutterDeckSlideConfiguration(
          route: '/platform-channels-1',
          title: 'platform-channels-1',
        ),
      ),
      // StatsSlide(),
      MessageChannelSlide(),
      CleverSlide(),

      ChannelsAndCodecsSlide(),
      FlutterDeckSlide.blank(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/platform-channels-summary',
          title: 'Platform Channels summary',
          header: FlutterDeckHeaderConfiguration(
            showHeader: true,
            title: 'Platform Channels',
          ),
        ),
        builder: (context) {
          return FlutterDeckSlideStepsBuilder(
            builder: (context, stepNumber) => Stack(
              children:
                  [
                        ['easy to set up\nin minutes', 'verbose - a bit\nof boilerplate code', 'debuggable'],
                        [
                          'not type safe',
                          'can be extended\nwith Pigeon',
                          'basically unchanged\nAPI since 945cfc3 in 2017',
                        ],
                        ['commonly understood\nby Flutter developers', 'can be accessed from\nbackground isolate', 'not the quickest'],
                      ]
                      .mapIndexed(
                        (x, e) => e.mapIndexed((y, e) {
                          return Align(
                            alignment: Alignment((x - 1).toDouble(), (y - 1).toDouble()),
                            child: Text(
                              e,
                              style: FlutterDeckTheme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }),
                      )
                      .toList()
                      .expand((x) => x)
                      .toList(),
            ),
          );
        },
      ),
      // ThreadsSlide(),
      FlutterDeckSlide.bigFact(
        theme: darkTheme,
        title: 'Native Interop',
        backgroundBuilder: (context) {
          return const AnimatedBokehBackground();
        },
      ),
      NativeDartSlide(),
      NativeListSlide(),
      SwiftInteropSlide(),
      FlutterDeckSlide.bigFact(
        title: 'Code generation',
        subtitle: 'Less boilerplate, more type safety',
        configuration: const FlutterDeckSlideConfiguration(
          route: '/codegen',
          title: 'codegen',
        ),
      ),
      FlutterDeckSlide.bigFact(
        title: 'jnigen/swiftgen',
        subtitle: 'Usage example',
        configuration: const FlutterDeckSlideConfiguration(
          route: '/gen-packages',
          title: 'Gen packages',
        ),
      ),
      KotlinInteropSlide(),
      KotlinInteropCodeSlide(),
      KotlinRunSlide(),
      DartInteropCodeSlide(),
      AndroidEmulatorRunSlide(),
      MoreJnigenSlide(),
      SwiftGenSlide(),
      FinalWordsSlide(),
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
          return OtherTalksSlide();
        },
      ),
      FlutterDeckSlide.bigFact(
        title: 'Thank you',
        subtitle:
            'roszkowski.dev/plugins\n\n'
            'roszkowski.dev/shaders_gallery',
        backgroundBuilder: (context) => const LavaGradientBackground(),
        theme: darkTheme,
        configuration: FlutterDeckSlideConfiguration(
          route: '/end',
          footer: FlutterDeckFooterConfiguration(
            showFooter: false,
          ),
          showProgress: false,
        ),
      ),
      MoreWebInteropSlide(),
    ];
    return Shortcuts(
      shortcuts: {
        SingleActivator(LogicalKeyboardKey.equal): const ZoomInIntent(),
        SingleActivator(LogicalKeyboardKey.minus): const ZoomOutIntent(),
      },
      child: Actions(
        actions: {
          ZoomInIntent: CallbackAction<ZoomInIntent>(
            onInvoke: (intent) {
              print('Zoom in');
              _codeSize = _codeSize + 2;
              setState(() {});
              return true;
            },
          ),
          ZoomOutIntent: CallbackAction<ZoomOutIntent>(
            onInvoke: (intent) {
              print('Zoom out');
              _codeSize = _codeSize - 2;
              setState(() {});
              return true;
            },
          ),
        },
        child: DefaultTextStyle(
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
                transition: FlutterDeckTransition.fade(),

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
                    colors: [Colors.pink, Colors.purple],
                  ),
                  backgroundColor: Colors.black,
                ),
                controls: FlutterDeckControlsConfiguration(
                  presenterToolbarVisible: true,
                ),
              ),
              isPresenterView: widget.isPresenterView,
              slides: slides,
            ),
          ),
        ),
      ),
    );
  }
}

class NativeListSlide extends FlutterDeckSlideWidget {
  const NativeListSlide({
    super.key,
  }) : super(
         configuration: const FlutterDeckSlideConfiguration(
           route: '/native-list',
           title: 'Native packages',
           speakerNotes: '',
           steps: 8,
           header: FlutterDeckHeaderConfiguration(
             title: 'The native interop packages ecosystem',
             showHeader: true,
           ),
         ),
       );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      configuration: this.configuration,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
          ),
          child: FlutterDeckBulletList(
            useSteps: true,
            stepOffset: 1,
            items: [
              'ffi (Dart 2.5, 2019)',
              'ffigen (2020-2021)',
              'jni',
              'jnigen (2022)',
              'objective_c',
              'swift2objc (2025)',
              'swiftgen (202?)',
            ],
          ),
        );
      },
    );
  }
}

class ThreadsSlide extends FlutterDeckSlideWidget {
  const ThreadsSlide({
    super.key,
  }) : super(
         configuration: const FlutterDeckSlideConfiguration(
           route: '/threading',
           title: 'Threading',
           speakerNotes: '',
           steps: 5,
           header: FlutterDeckHeaderConfiguration(
             title: '"The Thread Merging"',
             showHeader: true,
           ),
         ),
       );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      configuration: this.configuration,

      builder: (context) {
        return FlutterDeckBulletList(
          useSteps: true,
          stepOffset: 1,
          items: [
            'https://github.com/flutter/flutter/issues/150525',
            // 'Platform thread',
            // 'Background threads (Dart VM)',
            // 'Thread merging',
          ],
        );
      },
    );
  }
}

class ZoomInIntent extends Intent {
  const ZoomInIntent();
}

class ZoomOutIntent extends Intent {
  const ZoomOutIntent();
}
