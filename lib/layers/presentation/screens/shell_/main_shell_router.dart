import 'package:field_ops/constants/about_coloring.dart';
import 'package:field_ops/constants/about_routing.dart';
import 'package:field_ops/layers/presentation/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:field_ops/layers/presentation/screens/shell_/shell_config.dart';
import '../../../../di/shell_injection.dart';
class MainShellRouter extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShellRouter({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final config = getIt<ShellConfig>().routeConfiguration(context);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            AppBarTitle(
              text:
              config.isMain ? 'FieldOPS' : config.title),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  // settings profile or profile fast feature like sign out dark mood some thing like that
                  print(GoRouterState.of(context).uri.toString());
                },
                icon: config.isMain ? Icon(Icons.settings) : SizedBox.shrink(),
                iconSize: 28,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
        forceMaterialTransparency: true,
        leadingWidth: 100,
        shape: Border.symmetric(horizontal: .new(color: inputBorder)),
        leading: config.isMain ? Padding(
          padding: const EdgeInsets.all(20),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.account_circle_sharp,
              color: secondaryText,
              size: 40,
            ),
          ),
        ) : 
        IconButton(icon :Icon((Icons.arrow_back_ios_new)) , onPressed: (){context.go(taskPagePath);}),
      ),

      body: navigationShell, //calling page to navigate

      bottomNavigationBar: config.showBottomNavigationBar ? BottomNavigationBar(
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
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ) : SizedBox.shrink() ,
    );
  }
}
