import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/constants/app_router.dart';
import 'package:field_ops/core/di/di_container.dart';
import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:field_ops/layers/presentation/widgets/app_bar_title.dart';
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
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            AppBarTitle(text: config.isMain ? 'FieldOPS' : config.title),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: config.isMain
                  ? PopupMenuButton<String>(
                      icon: const Icon(Icons.settings, size: 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) async {
                        if (value == 'logout') {
                          await context.read<AuthCubit>().logout();
                          if (context.mounted) context.go(loginPagePath);
                        } else if (value == 'feedback') {
                          // افتح feedback dialog أو sheet
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'feedback',
                          child: Row(
                            children: [
                              Icon(Icons.feedback_outlined),
                              SizedBox(width: 12),
                              Text('Report feedback'),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 12),
                              Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        titleSpacing: 0,
        forceMaterialTransparency: true,
        leadingWidth: 100,
        shape: Border.symmetric(horizontal: .new(color: inputBorder)),
        leading: config.isMain
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.account_circle_sharp,
                    color: secondaryText,
                    size: 40,
                  ),
                ),
              )
            : IconButton(
                icon: Icon((Icons.arrow_back_ios_new)),
                onPressed: () {
                  context.go(taskPagePath);
                },
              ),
      ),

      body: navigationShell, //calling page to navigate

      bottomNavigationBar: config.showBottomNavigationBar
          ? BottomNavigationBar(
              type: .fixed,
              showUnselectedLabels: true,
              selectedItemColor: primaryBlue,
              unselectedItemColor: secondaryText,
              currentIndex: navigationShell.currentIndex,
              unselectedLabelStyle: TextStyle(color: secondaryText),
              selectedLabelStyle: TextStyle(fontWeight: .bold),
              backgroundColor: bgColor,
              onTap: (value) {
                navigationShell.goBranch(
                  value,
                  initialLocation: value == navigationShell.currentIndex,
                );
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )
          : SizedBox.shrink(),
    );
  }
}
