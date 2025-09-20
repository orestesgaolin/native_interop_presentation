import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jni/jni.dart';
import 'package:packagelist/package_retriever.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<String> packages = [];
  bool isLoading = false;
  Map<String, Image> packageIcons = {};

  void fetchPackages() {
    if (packages.isNotEmpty) {
      for (var package in packages) {
        getPackageIcon(package);
      }
    }
    setState(() {
      isLoading = true;
    });
    final context = JObject.fromReference(Jni.getCachedApplicationContext());
    final jPackages = PackageRetriever().getInstalledPackages(context);
    setState(() {
      packages = jPackages.toList().map((e) => e.toDartString()).toList();
      isLoading = false;
    });
  }

  void getPackageIcon(String package) {
    final context = JObject.fromReference(Jni.getCachedApplicationContext());
    final bytes = PackageRetriever().getPackageDrawable(
      context,
      package.toJString(),
    );
    final byteList = bytes.toList();
    // create image
    final image = Image.memory(Uint8List.fromList(byteList));
    packageIcons[package] = image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : packages.isEmpty
              ? Text('Refresh to load packages')
              : ListView.builder(
                  itemCount: packages.length,

                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(packages[index]),
                      leading: packageIcons[packages[index]],
                      onTap: () => getPackageIcon(packages[index]),
                    );
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fetchPackages,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
