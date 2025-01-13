import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart' as pdf;

import 'package:jni/jni.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pdfs = <PdfEntry>[
    PdfEntry(
      name: 'A Course of Pure Mathematics',
      path: 'assets/mathematics.pdf',
    ),
    PdfEntry(
      name: 'Rembrandt, With a Complete List of His Etchings',
      path: 'assets/rembrandt.pdf',
    ),
    PdfEntry(
      name: 'Romeo and Juliet',
      path: 'assets/romeo-and-juliet.pdf',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: ListView(
          children: pdfs.map((pdf) {
            return ListTile(
              title: Text(pdf.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerPage(
                      path: pdf.path,
                      title: pdf.name,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({
    super.key,
    required this.path,
    required this.title,
  });

  final String path;
  final String title;

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  int sizeInBytes = 0;
  int currentPage = 0;
  int totalPages = 0;
  Uint8List? pdfData;

  @override
  void initState() {
    super.initState();

    loadPdf();
  }

  Future<void> loadPdf() async {
    final assetBytes = await rootBundle.load(widget.path);
    final bytes = assetBytes.buffer.asUint8List();

    final size = bytes.length;
    setState(() {
      sizeInBytes = size;
      pdfData = bytes;
    });
    final example = pdf.PDFViewController();

    final listener = pdf.PDFStatusListener.implement(
      pdf.$PDFStatusListener(
        onLoaded$async: true,
        onPageChanged$async: true,
        onLinkRequested$async: true,
        onError$async: true,
        onDisposed$async: true,
        onPageChanged: (int? page, int? total) {
          print('PDF page: $page, total: $total');
          setState(() {
            currentPage = page ?? 0;
            totalPages = total ?? 0;
          });
        },
        onLoaded: () {
          print('PDF Loaded');
        },
        onError: (JString? string) {
          print('PDF error: ${string?.toDartString()}');
        },
        onDisposed: () {
          print('PDF disposed');
          example.release();
        },
        onLinkRequested: (JString? string) {
          print("Link Requested: ${string?.toDartString()}");
        },
      ),
    );
    example.setPdfStatusListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          if (pdfData != null)
            pdf.PDFView(
              pdfData: pdfData,
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Colors.black26, width: 1),
              ),
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.all(10),
              child: Text(
                '$currentPage/$totalPages',
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PdfEntry {
  PdfEntry({required this.name, required this.path});

  final String name;
  final String path;
}
