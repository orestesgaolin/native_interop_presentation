import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slides/main.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

const _speakerNotes = '''
- Use FlutterDeckCodeHighlight widget to highlight code.
- It supports multiple programming languages.
- You can customize the text style and background color.
''';

class CodeHighlightSlide extends FlutterDeckSlideWidget {
  CodeHighlightSlide({
    required this.code,
    required this.dataLineNumbers, //eg data-line-numbers="3-5|8-10|13-15"
    this.language = 'dart',
    super.key,
  }) : highlightSteps = _parseHighlights(dataLineNumbers),
       super(
         configuration: FlutterDeckSlideConfiguration(
           route: '/code-highlight-1',
           speakerNotes: _speakerNotes,
           steps: _parseHighlights(dataLineNumbers).length,
           header: FlutterDeckHeaderConfiguration(title: 'Code Highlighting'),
         ),
       );

  final String code;
  final String dataLineNumbers;
  final String language;
  final List<List<int>> highlightSteps;

  static List<List<int>> _parseHighlights(String data) {
    if (data.isEmpty) return [[]];
    return data.split('|').map((step) {
      List<int> lines = [];
      for (String range in step.split(',')) {
        if (range.contains('-')) {
          var parts = range.split('-').map(int.parse).toList();
          for (int i = parts[0]; i <= parts[1]; i++) {
            lines.add(i);
          }
        } else {
          lines.add(int.parse(range));
        }
      }
      return lines;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: FlutterDeckSlideStepsBuilder(
          builder: (context, stepNumber) {
            return FlutterDeckCodeHighlightTheme(
              data:
                  FlutterDeckCodeHighlightTheme.of(
                    context,
                  ).copyWith(
                    textStyle: FlutterDeckTheme.of(context).textTheme.bodySmall.copyWith(
                      fontFamily: GoogleFonts.sourceCodePro().fontFamily,
                    ),
                  ),
              child: CodeViewer(
                code: code,
                language: language,
                highlightSteps: highlightSteps,
                stepNumber: stepNumber,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CodeViewer extends StatefulWidget {
  const CodeViewer({
    super.key,
    required this.code,
    required this.language,
    required this.highlightSteps,
    required this.stepNumber,
    this.fileName,
    this.linesOffset,
  });

  final String code;
  final String language;
  final List<List<int>> highlightSteps;
  final int stepNumber;
  final String? fileName;
  final int? linesOffset;

  @override
  State<CodeViewer> createState() => _CodeViewerState();
}

class _CodeViewerState extends State<CodeViewer> {
  late final ScrollController scrollController;

  late HighlighterTheme _theme;
  bool initialized = false;
  TextSpan? _code;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    initialize();
  }

  Future<void> initialize() async {
    await Highlighter.initialize([
      widget.language,
    ]);
    _theme = await HighlighterTheme.loadLightTheme();
    final highlighter = Highlighter(
      theme: _theme,
      language: widget.language,
    );
    _code = highlighter.highlight(widget.code);
    // split code into newlines and group it into lines
    initialized = true;

    setState(() {});
    // add post frame to scroll if needed
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onStepChanged();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final double padding = 16.0;

  @override
  void didUpdateWidget(covariant CodeViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stepNumber != widget.stepNumber) {
      onStepChanged();
    }
  }

  void onStepChanged() {
    final firstHighlightedLine = widget.highlightSteps[widget.stepNumber - 1].isNotEmpty
        ? widget.highlightSteps[widget.stepNumber - 1].first
        : 1;
    final lineHeight = codeSize * 1.4; // fontSize * height
    final topPadding = 3 * lineHeight;
    final targetOffset = (firstHighlightedLine - 1) * lineHeight - topPadding + padding;

    final maxScroll = scrollController.position.maxScrollExtent;
    final maxY = targetOffset.clamp(0.0, maxScroll);
    scrollController.animateTo(
      maxY,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final highlightedLines = widget.highlightSteps[widget.stepNumber - 1];
    final lineHeight = 1.5;

    final lines = widget.code.split('\n');
    var textStyle = TextStyle(
      color: Colors.grey,
      fontFamily: GoogleFonts.firaCode().fontFamily,
      fontSize: codeSize,
      height: lineHeight,
      // ligatures
      fontFeatures: [],
    );

    final over100 = lines.length > 99 || (widget.linesOffset ?? 0) > 99;
    final over1000 = lines.length > 999 || (widget.linesOffset ?? 0) > 999;

    final leftMargin = over100
        ? over1000
              ? codeSize * 1.3 + 32
              : codeSize * 1.3 + 16
        : codeSize * 1.3;

    if (!initialized) {
      return SizedBox();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (widget.fileName != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.fileName!,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: GoogleFonts.firaCode().fontFamily,
                        fontSize: 16,
                        height: lineHeight,

                        // ligatures
                        fontFeatures: [const FontFeature.alternativeFractions()],
                      ),
                    ),
                  ),
                  Text(
                    '${widget.stepNumber}/${widget.highlightSteps.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.firaCode().fontFamily,
                      fontSize: 16,
                      height: lineHeight,

                      // ligatures
                      fontFeatures: [const FontFeature.alternativeFractions()],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              controller: scrollController,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: leftMargin + 8),
                    child: SelectionArea(
                      child: Text.rich(
                        _code!,
                        style: textStyle,
                        textAlign: TextAlign.left,
                        softWrap: false,
                      ),
                    ),
                  ),
                  IgnorePointer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: List.generate(lines.length, (index) {
                        final lineNumber = index + 1;
                        final isHighlighted = highlightedLines.contains(
                          lineNumber,
                        );

                        return Row(
                          children: [
                            SizedBox(
                              width: leftMargin,
                              height: codeSize * lineHeight,
                              child: Text.rich(
                                TextSpan(
                                  text: '${lineNumber + (widget.linesOffset ?? 0)}',
                                  style: textStyle,
                                ),
                                textAlign: TextAlign.right,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(8.0),
                                color: isHighlighted
                                    ? Colors.yellow.withOpacity(0.2)
                                    : Colors.grey.withOpacity(index % 2 == 0 ? 0.05 : 0.0),
                                height: codeSize * lineHeight,
                              ),
                            ),
                          ],
                        );
                      }),
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

get vs2015Theme => {
  'root': TextStyle(
    backgroundColor: Color(0xff1E1E1E),
    color: Color(0xffDCDCDC),
  ),
  'keyword': TextStyle(color: Color(0xff569CD6)),
  'literal': TextStyle(color: Color(0xff569CD6)),
  'symbol': TextStyle(color: Color(0xff569CD6)),
  'name': TextStyle(color: Color(0xff569CD6)),
  'link': TextStyle(color: Color(0xff569CD6)),
  'built_in': TextStyle(color: Color(0xff4EC9B0)),
  'type': TextStyle(color: Color(0xff4EC9B0)),
  'number': TextStyle(color: Color(0xffB8D7A3)),
  'class': TextStyle(color: Color(0xffB8D7A3)),
  'string': TextStyle(color: Color(0xffD69D85)),
  'meta-string': TextStyle(color: Color(0xffD69D85)),
  'regexp': TextStyle(color: Color(0xff9A5334)),
  'template-tag': TextStyle(color: Color(0xff9A5334)),
  'subst': TextStyle(color: Color(0xffDCDCDC)),
  'function': TextStyle(color: Color(0xffDCDCDC)),
  'title': TextStyle(color: Color(0xffDCDCDC)),
  'params': TextStyle(color: Color(0xffDCDCDC)),
  'formula': TextStyle(color: Color(0xffDCDCDC)),
  'comment': TextStyle(color: Color(0xff57A64A), fontStyle: FontStyle.italic),
  'quote': TextStyle(color: Color(0xff57A64A), fontStyle: FontStyle.italic),
  'doctag': TextStyle(color: Color(0xff608B4E)),
  'meta': TextStyle(color: Color.fromARGB(255, 170, 130, 130)),
  'meta-keyword': TextStyle(color: Color(0xff9B9B9B)),
  'tag': TextStyle(color: Color(0xff9B9B9B)),
  'variable': TextStyle(color: Color(0xffBD63C5)),
  'template-variable': TextStyle(color: Color(0xffBD63C5)),
  'attr': TextStyle(color: Color(0xff9CDCFE)),
  'attribute': TextStyle(color: Color(0xff9CDCFE)),
  'builtin-name': TextStyle(color: Color(0xff9CDCFE)),
  'section': TextStyle(color: Color(0xffffd700)),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'strong': TextStyle(fontWeight: FontWeight.bold),
  'bullet': TextStyle(color: Color(0xffD7BA7D)),
  'selector-tag': TextStyle(color: Color(0xffD7BA7D)),
  'selector-id': TextStyle(color: Color(0xffD7BA7D)),
  'selector-class': TextStyle(color: Color(0xffD7BA7D)),
  'selector-attr': TextStyle(color: Color(0xffD7BA7D)),
  'selector-pseudo': TextStyle(color: Color(0xffD7BA7D)),
  'addition': TextStyle(backgroundColor: Color(0xff144212)),
  'deletion': TextStyle(backgroundColor: Color(0xff660000)),
};
