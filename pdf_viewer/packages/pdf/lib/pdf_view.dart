import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef PDFViewCreatedCallback = void Function();
typedef RenderCallback = void Function(int? pages);
typedef PageChangedCallback = void Function(int? page, int? total);
typedef ErrorCallback = void Function(dynamic error);
typedef PageErrorCallback = void Function(int? page, dynamic error);
typedef LinkHandlerCallback = void Function(String? uri);

// ignore: constant_identifier_names
enum FitPolicy { WIDTH, HEIGHT, BOTH }

class PDFView extends StatefulWidget {
  const PDFView({
    super.key,
    this.filePath,
    this.pdfData,
    this.onViewCreated,
    this.onRender,
    this.onPageChanged,
    this.onError,
    this.onPageError,
    this.onLinkHandler,
    this.gestureRecognizers,
    this.enableSwipe = true,
    this.swipeHorizontal = false,
    this.password,
    this.nightMode = false,
    this.autoSpacing = true,
    this.pageFling = true,
    this.pageSnap = true,
    this.defaultPage = 0,
    this.fitPolicy = FitPolicy.WIDTH,
    this.preventLinkNavigation = false,
  }) : assert(filePath != null || pdfData != null);

  @override
  // ignore: library_private_types_in_public_api
  _PDFViewState createState() => _PDFViewState();

  /// If not null invoked once the PDFView is created.
  final PDFViewCreatedCallback? onViewCreated;

  /// Return PDF page count as a parameter
  final RenderCallback? onRender;

  /// Return current page and page count as a parameter
  final PageChangedCallback? onPageChanged;

  /// Invokes on error that handled on native code
  final ErrorCallback? onError;

  /// Invokes on page cannot be rendered or something happens
  final PageErrorCallback? onPageError;

  /// Used with preventLinkNavigation=true. It's helpful to customize link navigation
  final LinkHandlerCallback? onLinkHandler;

  /// Which gestures should be consumed by the pdf view.
  ///
  /// It is possible for other gesture recognizers to be competing with the pdf view on pointer
  /// events, e.g if the pdf view is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The pdf view will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the pdf view will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  /// The initial URL to load.
  final String? filePath;

  /// The binary data of a PDF document
  final Uint8List? pdfData;

  /// Indicates whether or not the user can swipe to change pages in the PDF document. If set to true, swiping is enabled.
  final bool enableSwipe;

  /// Indicates whether or not the user can swipe horizontally to change pages in the PDF document. If set to true, horizontal swiping is enabled.
  final bool swipeHorizontal;

  /// Represents the password for a password-protected PDF document. It can be nullable
  final String? password;

  /// Indicates whether or not the PDF viewer is in night mode. If set to true, the viewer is in night mode
  final bool nightMode;

  /// Indicates whether or not the PDF viewer automatically adds spacing between pages. If set to true, spacing is added.
  final bool autoSpacing;

  /// Indicates whether or not the user can "fling" pages in the PDF document. If set to true, page flinging is enabled.
  final bool pageFling;

  /// Indicates whether or not the viewer snaps to a page after the user has scrolled to it. If set to true, snapping is enabled.
  final bool pageSnap;

  /// Represents the default page to display when the PDF document is loaded.
  final int defaultPage;

  /// FitPolicy that determines how the PDF pages are fit to the screen. The FitPolicy enum can take on the following values:
  /// - FitPolicy.WIDTH: The PDF pages are scaled to fit the width of the screen.
  /// - FitPolicy.HEIGHT: The PDF pages are scaled to fit the height of the screen.
  /// - FitPolicy.BOTH: The PDF pages are scaled to fit both the width and height of the screen.
  final FitPolicy fitPolicy;

  /// Indicates whether or not clicking on links in the PDF document will open the link in a new page. If set to true, link navigation is prevented.
  final bool preventLinkNavigation;
}

class _PDFViewState extends State<PDFView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformViewLink(
        viewType: 'com.example.pdf/pdfview',
        surfaceFactory: (
          BuildContext context,
          PlatformViewController controller,
        ) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: widget.gestureRecognizers ??
                const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: 'com.example.pdf/pdfview',
            layoutDirection: TextDirection.rtl,
            creationParams: _CreationParams.fromWidget(widget).toMap(),
            creationParamsCodec: const StandardMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener((int id) {
              _onPlatformViewCreated(id);
            })
            ..create();
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'com.example.pdf/pdfview',
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: _CreationParams.fromWidget(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
      '$defaultTargetPlatform is not yet supported by the pdfview_flutter plugin',
    );
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onViewCreated != null) {
      widget.onViewCreated!();
    }
  }

  @override
  void didUpdateWidget(PDFView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}

class _CreationParams {
  _CreationParams({
    this.filePath,
    this.pdfData,
    this.settings,
  });

  static _CreationParams fromWidget(PDFView widget) {
    return _CreationParams(
      filePath: widget.filePath,
      pdfData: widget.pdfData,
      settings: _PDFViewSettings.fromWidget(widget),
    );
  }

  final String? filePath;
  final Uint8List? pdfData;

  final _PDFViewSettings? settings;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> params = {
      'filePath': filePath,
      'pdfData': pdfData,
    };

    params.addAll(settings!.toMap());

    return params;
  }
}

class _PDFViewSettings {
  _PDFViewSettings(
      {this.enableSwipe,
      this.swipeHorizontal,
      this.password,
      this.nightMode,
      this.autoSpacing,
      this.pageFling,
      this.pageSnap,
      this.defaultPage,
      this.fitPolicy,
      // this.fitEachPage,
      this.preventLinkNavigation});

  static _PDFViewSettings fromWidget(PDFView widget) {
    return _PDFViewSettings(
        enableSwipe: widget.enableSwipe,
        swipeHorizontal: widget.swipeHorizontal,
        password: widget.password,
        nightMode: widget.nightMode,
        autoSpacing: widget.autoSpacing,
        pageFling: widget.pageFling,
        pageSnap: widget.pageSnap,
        defaultPage: widget.defaultPage,
        fitPolicy: widget.fitPolicy,
        preventLinkNavigation: widget.preventLinkNavigation);
  }

  final bool? enableSwipe;
  final bool? swipeHorizontal;
  final String? password;
  final bool? nightMode;
  final bool? autoSpacing;
  final bool? pageFling;
  final bool? pageSnap;
  final int? defaultPage;
  final FitPolicy? fitPolicy;
  // final bool? fitEachPage;
  final bool? preventLinkNavigation;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'enableSwipe': enableSwipe,
      'swipeHorizontal': swipeHorizontal,
      'password': password,
      'nightMode': nightMode,
      'autoSpacing': autoSpacing,
      'pageFling': pageFling,
      'pageSnap': pageSnap,
      'defaultPage': defaultPage,
      'fitPolicy': fitPolicy.toString(),
      'preventLinkNavigation': preventLinkNavigation
    };
  }

  Map<String, dynamic> updatesMap(_PDFViewSettings newSettings) {
    final Map<String, dynamic> updates = <String, dynamic>{};
    if (enableSwipe != newSettings.enableSwipe) {
      updates['enableSwipe'] = newSettings.enableSwipe;
    }
    if (pageFling != newSettings.pageFling) {
      updates['pageFling'] = newSettings.pageFling;
    }
    if (pageSnap != newSettings.pageSnap) {
      updates['pageSnap'] = newSettings.pageSnap;
    }
    if (preventLinkNavigation != newSettings.preventLinkNavigation) {
      updates['preventLinkNavigation'] = newSettings.preventLinkNavigation;
    }
    return updates;
  }
}
