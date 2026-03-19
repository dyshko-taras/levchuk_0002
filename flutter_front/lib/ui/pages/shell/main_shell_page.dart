import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/shell_navigation_provider.dart';
import '../../widgets/navigation/app_bottom_nav_bar.dart';

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

    return Scaffold(
      body: navigationShell,
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
    );
  }
}
