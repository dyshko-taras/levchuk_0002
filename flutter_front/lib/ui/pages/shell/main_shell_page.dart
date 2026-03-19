import 'dart:async';

import 'package:FlutterApp/providers/shell_navigation_provider.dart';
import 'package:FlutterApp/ui/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<ShellNavigationProvider>();
    if (nav.index != navigationShell.currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ShellNavigationProvider>().setIndex(
          navigationShell.currentIndex,
        );
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        unawaited(_handleShellBack(context, navigationShell));
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: navigationShell,
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            context.read<ShellNavigationProvider>().setIndex(index);
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleShellBack(
    BuildContext context,
    StatefulNavigationShell navigationShell,
  ) async {
    if (navigationShell.currentIndex != 0) {
      context.read<ShellNavigationProvider>().setIndex(0);
      navigationShell.goBranch(0);
      return;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Exit ActiveOffice?'),
        content: const Text(
          'Your progress is already saved. Do you want to close the app?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      await SystemNavigator.pop();
    }
  }
}
