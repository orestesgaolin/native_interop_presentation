import 'dart:io';

import 'package:jnigen/jnigen.dart';

void main(List<String> args) {
  final packageRoot = Platform.script.resolve('../');
  generateJniBindings(
    Config(
      outputConfig: OutputConfig(
        dartConfig: DartCodeOutputConfig(
          path: packageRoot.resolve(
            'lib/src/foreground_service_interop_plugin.g.dart',
          ),
          structure: OutputStructure.singleFile,
        ),
      ),
      androidSdkConfig: AndroidSdkConfig(
        addGradleDeps: true,
        androidExample: 'example',
      ),
      sourcePath: [packageRoot.resolve('android/src/main/java')],
      classes: [
        'com.example.foreground_service_interop_plugin.ExampleForegroundService',
        'com.example.foreground_service_interop_plugin.ReplyListenerProxy',
        'android.content.ServiceConnection',
        'android.content.Intent',
        'android.content.Context',
        'android.app.Activity',
        'androidx.core.content.ContextCompat',
        'androidx.core.app.ActivityCompat',
        'android.os.Build',
      ],
    ),
  );
}
