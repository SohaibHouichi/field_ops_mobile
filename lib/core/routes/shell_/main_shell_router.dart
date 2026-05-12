import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/constants/app_router.dart';
import 'package:field_ops/core/di/di_container.dart';
import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:field_ops/core/widgets/pulse_dot_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:field_ops/core/routes/shell_/shell_config.dart';

class MainShellRouter extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShellRouter({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final config = DiContainer.getIt<ShellConfig>().routeConfiguration(context);

    return Scaffold(
      backgroundColor: bgColor,

      // ── AppBar ──────────────────────────────────────────────────────
      appBar: AppBar(
        toolbarHeight: 72,
        forceMaterialTransparency: true,
        titleSpacing: 0,
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        shape: Border(bottom: BorderSide(color: inputBorder)),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Left — avatar OR back button
              if (config.isMain)
                // Same chip style as login logo chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: chipBorder),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PulseDot(),
                      SizedBox(width: 8),
                      Text(
                        'FieldOPS',
                        style: TextStyle(
                          color: primaryBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: () => context.go(taskPagePath),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: chipBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios_new,
                            size: 12, color: primaryBlue),
                        const SizedBox(width: 6),
                        Text(
                          config.title,
                          style: const TextStyle(
                            color: primaryBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const Spacer(),

              // Right — settings popup (main) or nothing
              if (config.isMain)
                PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: inputBorder),
                    ),
                    child: const Icon(Icons.settings_outlined,
                        size: 18, color: primaryText),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: inputBorder),
                  ),
                  color: cardBg,
                  elevation: 4,
                  onSelected: (value) async {
                    if (value == 'logout') {
                      await context.read<AuthCubit>().logout();
                      if (context.mounted) context.go(loginPagePath);
                    } else if (value == 'feedback') {
                      // open feedback sheet
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'feedback',
                      child: Row(
                        children: [
                          Icon(Icons.feedback_outlined,
                              size: 16, color: secondaryText),
                          const SizedBox(width: 10),
                          Text(
                            'Report feedback',
                            style: TextStyle(
                                color: primaryText, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              size: 16, color: Color(0xFFFF6B6B)),
                          SizedBox(width: 10),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),

      // ── Body ────────────────────────────────────────────────────────
      body: navigationShell,

      // ── Bottom Nav — card style matching login card ─────────────────
      bottomNavigationBar: config.showBottomNavigationBar
          ? Container(
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(top: BorderSide(color: inputBorder)),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                selectedItemColor: primaryBlue,
                unselectedItemColor: secondaryText,
                currentIndex: navigationShell.currentIndex,
                unselectedLabelStyle:
                    TextStyle(color: secondaryText, fontSize: 10),
                selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 10),
                backgroundColor: Colors.transparent,
                elevation: 0,
                onTap: (value) {
                  navigationShell.goBranch(
                    value,
                    initialLocation: value == navigationShell.currentIndex,
                  );
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list_alt_outlined),
                      activeIcon: Icon(Icons.list_alt),
                      label: 'Requests'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month_outlined),
                      activeIcon: Icon(Icons.calendar_month),
                      label: 'Schedule'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person),
                      label: 'Profile'),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}