import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:google_fonts/google_fonts.dart';

class TerminalSlide extends FlutterDeckSlideWidget {
  TerminalSlide({
    required this.commands,
    this.title = 'Terminal',
    this.animationSpeed = const Duration(milliseconds: 25),
    this.lineDelay = const Duration(milliseconds: 500),
    this.animationCurve = Curves.linear,
    this.prompt = '\$ ',
    super.key,
  }) : super(
         configuration: FlutterDeckSlideConfiguration(
           route: '/terminal',
           title: title,
           steps: commands.length,
           header: FlutterDeckHeaderConfiguration(
             title: title,
             showHeader: true,
           ),
         ),
       );

  final List<TerminalCommand> commands;
  final String title;
  final Duration animationSpeed;
  final Curve animationCurve;
  final Duration lineDelay;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Terminal header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5F56),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFBD2E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFF27CA3F),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Terminal',
                      style: GoogleFonts.sourceCodePro(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Terminal content
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: FlutterDeckSlideStepsBuilder(
                    builder: (context, stepNumber) => TerminalAnimator(
                      commands: commands,
                      index: stepNumber - 1,
                      animationSpeed: animationSpeed,
                      animationCurve: animationCurve,
                      lineDelay: lineDelay,
                      prompt: prompt,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TerminalCommand {
  const TerminalCommand({
    required this.command,
    required this.output,
    this.isError = false,
    this.customDelay,
  });

  final String command;
  final List<String> output;
  final bool isError;
  final Duration? customDelay;
}

class TerminalAnimator extends StatefulWidget {
  const TerminalAnimator({
    super.key,
    required this.commands,
    required this.animationSpeed,
    required this.animationCurve,
    required this.lineDelay,
    required this.prompt,
    required this.index,
  });

  final List<TerminalCommand> commands;
  final Duration animationSpeed;
  final Curve animationCurve;
  final Duration lineDelay;
  final String prompt;
  final int index;

  @override
  State<TerminalAnimator> createState() => _TerminalAnimatorState();
}

class _TerminalAnimatorState extends State<TerminalAnimator> with TickerProviderStateMixin {
  final List<String> _displayedLines = [];
  final ScrollController _scrollController = ScrollController();
  int _currentCommandIndex = 0;
  int _currentLineIndex = 0;
  int _currentCharIndex = 0;
  bool _showCursor = true;
  bool _isTypingCommand = true;
  bool _animationInProgress = false;

  late AnimationController _cursorController;
  late Timer _typingTimer;

  @override
  void initState() {
    super.initState();
    _setupCursorAnimation();
    _startAnimation();
  }

  @override
  void didUpdateWidget(covariant TerminalAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      if (_animationInProgress) {
        return;
      }
      _startAnimation();
    }
  }

  void _setupCursorAnimation() {
    _cursorController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _cursorController.repeat(reverse: true);
    _cursorController.addListener(() {
      setState(() {
        _showCursor = _cursorController.value > 0.5;
      });
    });
  }

  void _startAnimation() {
    if (_currentCommandIndex >= widget.commands.length) {
      _cursorController.stop();
      _animationInProgress = false;
      setState(() {
        _showCursor = false;
      });
      return;
    }
    if (_currentCommandIndex > widget.index) {
      _animationInProgress = false;
      // If the current command index exceeds the step index, we should not type further.
      _cursorController.stop();
      setState(() {
        _showCursor = false;
      });
      return;
    }

    final command = widget.commands[_currentCommandIndex];
    _animationInProgress = true;

    if (_isTypingCommand) {
      _typeCommand(command.command);
    } else {
      _typeOutput(command.output);
    }
  }

  void _typeCommand(String command) {
    if (_currentCharIndex < command.length) {
      setState(() {
        if (_displayedLines.isEmpty || !_displayedLines.last.startsWith(widget.prompt)) {
          _displayedLines.add(widget.prompt);
        }
        _displayedLines[_displayedLines.length - 1] = widget.prompt + command.substring(0, _currentCharIndex + 1);
        _currentCharIndex++;
      });

      _typingTimer = Timer(widget.animationSpeed, () => _typeCommand(command));
      _scrollToBottom();
    } else {
      // Command finished, move to output
      _currentCharIndex = 0;
      _isTypingCommand = false;
      _typingTimer = Timer(widget.lineDelay, _startAnimation);
    }
  }

  void _typeOutput(List<String> output) {
    if (_currentLineIndex < output.length) {
      final currentLine = output[_currentLineIndex];

      setState(() {
        // Simply add the line to the end of the displayed lines
        _displayedLines.add(currentLine);
      });

      _scrollToBottom();

      // Move to next line after delay
      _currentLineIndex++;
      final delay = widget.commands[_currentCommandIndex].customDelay ?? widget.lineDelay;
      _typingTimer = Timer(delay, () => _typeOutput(output));
    } else {
      // Output finished, move to next command
      _currentCommandIndex++;
      _currentLineIndex = 0;
      _currentCharIndex = 0;
      _isTypingCommand = true;
      _typingTimer = Timer(widget.lineDelay, _startAnimation);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: widget.animationCurve,
        );
      }
    });
  }

  @override
  void dispose() {
    _cursorController.dispose();
    _typingTimer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._displayedLines.asMap().entries.map((entry) {
              final index = entry.key;
              final line = entry.value;
              final isCurrentLine = index == _displayedLines.length - 1;
              final isCommandLine = line.startsWith(widget.prompt);
              final isErrorLine = _isErrorLine(index);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: line,
                        style: GoogleFonts.sourceCodePro(
                          color: isErrorLine
                              ? const Color(0xFFFF6B6B)
                              : isCommandLine
                              ? const Color(0xFF50FA7B)
                              : Colors.white,
                          fontSize: 20,
                          height: 1.4,
                        ),
                      ),
                      if (isCurrentLine && _showCursor)
                        TextSpan(
                          text: '█',
                          style: GoogleFonts.sourceCodePro(
                            color: const Color(0xFF50FA7B),
                            fontSize: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 100), // Extra space for scrolling
          ],
        ),
      ),
    );
  }

  bool _isErrorLine(int lineIndex) {
    int lineCount = 0;

    for (int i = 0; i < widget.commands.length; i++) {
      lineCount++; // Command line
      if (lineIndex == lineCount - 1) return false; // Command lines are never errors

      for (int j = 0; j < widget.commands[i].output.length; j++) {
        lineCount++; // Output line
        if (lineIndex == lineCount - 1) {
          return widget.commands[i].isError;
        }
      }
    }

    return false;
  }
}
