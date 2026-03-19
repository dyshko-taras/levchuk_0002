import 'package:FlutterApp/app.dart';
import 'package:FlutterApp/services/notification_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await NotificationService.instance.init();

  if (kReleaseMode) {
    runApp(const ActiveOfficeApp());
    return;
  }

  runApp(
    DevicePreview(
      storage: DevicePreviewStorage.none(),
      data: const DevicePreviewData(
        isFrameVisible: false,
        isToolbarVisible: false,
      ),
      builder: (_) => const ActiveOfficeApp(),
    ),
  );
}
