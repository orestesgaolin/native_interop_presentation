import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Widget that uses a WebView to render a Mermaid diagram.
class WebViewMermaid extends StatefulWidget {
  const WebViewMermaid({super.key, required this.mermaid});

  final String mermaid;

  @override
  State<WebViewMermaid> createState() => _WebViewMermaidState();
}

class _WebViewMermaidState extends State<WebViewMermaid> {
  late final WebViewController _controller;

  @override
  void didUpdateWidget(covariant WebViewMermaid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mermaid != widget.mermaid) {
      _controller.loadHtmlString(_generateHtml(widget.mermaid));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_generateHtml(widget.mermaid));
  }

  String _generateHtml(String mermaidCode) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
  <style>
    body {
      margin: 0px;
      padding: 0px;
      font-family: Arial, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }
    #mermaid-diagram {
      width: 100%;
      height: 100%;
    }
  </style>
</head>
<body>
  <div id="mermaid-diagram">
    <div class="mermaid">
$mermaidCode
    </div>
  </div>
  <script>
    mermaid.initialize({ startOnLoad: true, theme: 'dark' });
  </script>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }
}
