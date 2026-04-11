import 'dart:io';
import 'package:jnigen/jnigen.dart';

void main(List<String> args) {
  final packageRoot = Platform.script.resolve('../');
  generateJniBindings(
    Config(
      outputConfig: OutputConfig(
        dartConfig: DartCodeOutputConfig(
          path: packageRoot.resolve('lib/src/bindings.g.dart'),
          structure: OutputStructure.singleFile,
        ),
      ),
      androidSdkConfig: AndroidSdkConfig(
        addGradleDeps: true,
        androidExample: 'example',
      ),
      sourcePath: [packageRoot.resolve('android/src/main/java/')],
      classes: [
        'android.content.Intent',
        'android.content.Context',
        'android.app.Activity',
        'android.net.Uri',
        'android.provider.ContactsContract',
        'com.example.android_intent.ActivityResultListenerProxy',
      ],
    ),
  );
}
