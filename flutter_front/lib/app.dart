import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_router.dart';
import 'providers/app_bootstrap_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/shell_navigation_provider.dart';
import 'ui/theme/app_theme.dart';

class ActiveOfficeApp extends StatelessWidget {
  const ActiveOfficeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..load()),
        ChangeNotifierProvider(create: (_) => AppBootstrapProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ShellNavigationProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'ActiveOffice',
        theme: AppTheme.dark,
        routerConfig: AppRouter.router,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
      ),
    );
  }
}
