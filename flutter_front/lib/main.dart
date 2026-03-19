import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await NotificationService.instance.initialize();

  runApp(
    DevicePreview(
      enabled: false,
      storage: DevicePreviewStorage.none(),
      data: const DevicePreviewData(
        isFrameVisible: false,
        isToolbarVisible: false,
      ),
      builder: (_) => const ActiveOfficeApp(),
    ),
  );
}
