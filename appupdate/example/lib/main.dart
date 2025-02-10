import 'package:appupdate/appupdate_bindings.g.dart';
import 'package:flutter/material.dart';
import 'package:jni/_internal.dart';
import 'dart:async';

import 'package:jni/jni.dart';

void main() {
  runApp(const AppUpdatePage());
}

class AppUpdatePage extends StatefulWidget {
  const AppUpdatePage({super.key});

  @override
  State<AppUpdatePage> createState() => _AppUpdatePageState();
}

class _AppUpdatePageState extends State<AppUpdatePage> {
  AppUpdateManager? manager;
  Task<AppUpdateInfo?>? appInfoTask;
  Task? _updateTask;
  AppUpdateInfo? appUpdateInfo;
  bool isCanceled = false;
  List<String> logs = [];
  Stopwatch? stopwatch;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch()..start();
  }

  void updateTest() {
    localPrint('Checking for update');
    final context = JObject.fromReference(Jni.getCachedApplicationContext());
    manager = AppUpdateManagerFactory.create(context);

    localPrint('Got manager instance: ${manager}');
    appInfoTask = manager?.getAppUpdateInfo();

    localPrint('Got app info task: ${appInfoTask}');

    appInfoTask?.addOnSuccessListener(
      OnSuccessListener.implement(
        $OnSuccessListener<AppUpdateInfo>(
          onSuccess$async: true,
          TResult: AppUpdateInfo.type,
          onSuccess: (result) {
            setState(() {
              appUpdateInfo = result;
            });
          },
        ),
      ),
    );

    appInfoTask?.addOnFailureListener(
      OnFailureListener.implement(
        $OnFailureListener(
          onFailure$async: true,
          onFailure: (e) {
            localPrint(e.toString());
          },
        ),
      ),
    );

    appInfoTask?.addOnCanceledListener(
      OnCanceledListener.implement(
        $OnCanceledListener(
          onCanceled: () {
            localPrint('Canceled');
            setState(() {
              isCanceled = true;
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    manager?.release();
    appUpdateInfo?.release();
    super.dispose();
  }

  void localPrint(String msg) {
    final msgWithTime = '${stopwatch!.elapsed.inSeconds}: $msg';
    logs.add(msgWithTime);
    print(msgWithTime);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('In-app Update test'),
        ),
        body: ListView(
          children: [
            ElevatedButton(
              onPressed: updateTest,
              child: const Text('Check for update'),
            ),
            if (appUpdateInfo != null) ...[
              Text(
                'Update availability: ${convertToUpdateAvailability()}',
              ),
              Text(
                'Install status: ${convertToInstallStatus()}',
              ),
              Text(
                'Client version: ${appUpdateInfo!.clientVersionStalenessDays()}',
              ),
              Text(
                'Update priority: ${appUpdateInfo!.updatePriority()}',
              ),
              Text(
                'Available version code: ${appUpdateInfo!.availableVersionCode()}',
              ),
            ],
            if (manager != null && appUpdateInfo != null)
              ElevatedButton(
                onPressed: onImmediateUpdate,
                child: Text(
                  'Start IMMEDIATE update flow',
                ),
              ),
            if (manager != null && appUpdateInfo != null)
              ElevatedButton(
                onPressed: onFlexibleUpdate,
                child: Text(
                  'Start FLEXIBLE update flow',
                ),
              ),
            if (appUpdateInfo?.installStatus() == InstallStatus.DOWNLOADED)
              ElevatedButton(
                onPressed: () {
                  localPrint('Complete update');
                  manager?.completeUpdate();
                },
                child: Text(
                  'Complete update',
                ),
              ),
            if (isCanceled) Text('Canceled'),
            ...logs
                .map(
                  (e) => Text(e),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  void onFlexibleUpdate() {
    final activity = JObject.fromReference(Jni.getCurrentActivity());

    final allowed = appUpdateInfo!.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE);

    if (!allowed) {
      localPrint('Update type not allowed');
      return;
    }

    _updateTask = manager?.startUpdateFlow(
      appUpdateInfo!,
      activity,
      AppUpdateOptions.newBuilder(AppUpdateType.FLEXIBLE)
          .setAllowAssetPackDeletion(true)
          .build(),
    );

    // Not possible to inherit non-overriden methods of the interface
    // hence we need to provide super class implementation and cast it to the subclass
    manager?.registerListener(
      StateUpdatedListener.implement(
        $StateUpdatedListener(
          StateT: InstallState.type,
          onStateUpdate$async: true,
          onStateUpdate: (state) {
            localPrint('State update: ${state}');
          },
        ),
      ).as(InstallStateUpdatedListener.type),
    );

    _updateTask?.addOnSuccessListener(
      OnSuccessListener.implement(
        $OnSuccessListener(
          onSuccess$async: true,
          TResult: InstallStatus.type,
          onSuccess: (result) {
            localPrint('Update success ${result}');
          },
        ),
      ),
    );

    _updateTask?.addOnFailureListener(
      OnFailureListener.implement(
        $OnFailureListener(
          onFailure$async: true,
          onFailure: (e) {
            localPrint('Update failed');
            localPrint(e.toString());
          },
        ),
      ),
    );

    _updateTask?.addOnCanceledListener(
      OnCanceledListener.implement(
        $OnCanceledListener(
          onCanceled: () {
            localPrint('Update canceled');
          },
        ),
      ),
    );
  }

  void onImmediateUpdate() {
    final activity = JObject.fromReference(Jni.getCurrentActivity());

    final allowed = appUpdateInfo!.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE);

    if (!allowed) {
      localPrint('Update type not allowed');
      return;
    }

    _updateTask = manager?.startUpdateFlow(
      appUpdateInfo!,
      activity,
      AppUpdateOptions.newBuilder(AppUpdateType.IMMEDIATE)
          .setAllowAssetPackDeletion(true)
          .build(),
    );

    _updateTask?.addOnSuccessListener(
      OnSuccessListener.implement(
        $OnSuccessListener(
          onSuccess$async: true,
          TResult: InstallStatus.type,
          onSuccess: (result) {
            localPrint('Update success ${result}');
          },
        ),
      ),
    );

    _updateTask?.addOnFailureListener(
      OnFailureListener.implement(
        $OnFailureListener(
          onFailure$async: true,
          onFailure: (e) {
            localPrint('Update failed');
            localPrint(e.toString());
          },
        ),
      ),
    );

    _updateTask?.addOnCanceledListener(
      OnCanceledListener.implement(
        $OnCanceledListener(
          onCanceled: () {
            localPrint('Update canceled');
          },
        ),
      ),
    );
  }

  String convertToUpdateAvailability() {
    final value = appUpdateInfo!.updateAvailability();

    return switch (value) {
      UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS =>
        'DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS',
      UpdateAvailability.UPDATE_AVAILABLE => 'UPDATE_AVAILABLE',
      UpdateAvailability.UPDATE_NOT_AVAILABLE => 'UPDATE_NOT_AVAILABLE',
      UpdateAvailability.UNKNOWN => 'UNKNOWN',
      _ => 'UNKNOWN $value',
    };
  }

  String convertToInstallStatus() {
    final value = appUpdateInfo!.installStatus();

    return switch (value) {
      InstallStatus.DOWNLOADED => 'DOWNLOADED',
      InstallStatus.DOWNLOADING => 'DOWNLOADING',
      InstallStatus.FAILED => 'FAILED',
      InstallStatus.INSTALLED => 'INSTALLED',
      InstallStatus.INSTALLING => 'INSTALLING',
      InstallStatus.PENDING => 'PENDING',
      InstallStatus.UNKNOWN => 'UNKNOWN',
      InstallStatus.REQUIRES_UI_INTENT => 'REQUIRES_UI_INTENT',
      _ => 'UNKNOWN $value',
    };
  }
}
