import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/constants/app_router.dart';
import 'package:field_ops/core/di/di_container.dart';
import 'package:field_ops/core/navigation/nav_items_config.dart';
import 'package:field_ops/core/widgets/pulse_dot_widget.dart';
import 'package:field_ops/features/auth/domain/entities/tenant_entity.dart';
import 'package:field_ops/features/auth/domain/entities/user_entity.dart';
import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:field_ops/core/routes/shell_/shell_config.dart';

class MainShellRouter extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellRouter({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final config = DiContainer.getIt<ShellConfig>()
        .routeConfiguration(context);

    final authState = context.watch<AuthCubit>().state;

    final tenantName = authState is AuthAuthenticated
        ? authState.user.tenantInfo.name
        : 'FIELDOPS';

    final username = authState is AuthAuthenticated
        ? authState.user.username
        : 'User';

    final role = authState is AuthAuthenticated
        ? UserRoleX.toStringValue(authState.user.role)
        : '';

    final navItems = role == 'technician'
        ? TechnicianNavItems.items
        : CustomerNavItems.items;

    return Scaffold(
      backgroundColor: bgColor,

      // ───────────────── APPBAR ─────────────────
      appBar: AppBar(
        toolbarHeight: 72,
        forceMaterialTransparency: true,
        titleSpacing: 0,
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        shape: Border(
          bottom: BorderSide(color: inputBorder),
        ),

        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Row(
            children: [
              config.isMain
                  ? CircleAvatar(
                      radius: 24,
                      backgroundColor: primaryBlue,
                      child: Text(
                        username.substring(0, 3).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),

              // ───────── TENANT INFO ─────────
              if (config.isMain)
                GestureDetector(
                  onTap: () {
                    if (authState is AuthAuthenticated) {
                      _showTenantInfoBottomSheet(
                        context,
                        authState.user.tenantInfo,
                      );
                    }
                  },

                  child: Container(
                    margin: const EdgeInsets.only(left: 8),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),

                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: chipBorder),
                    ),

                    child: Column(
                      children: [
                        Row(
                          children: [
                            PulseDot(),

                            const SizedBox(width: 6),

                            Text(
                              username.toUpperCase(),
                              style: const TextStyle(
                                color: primaryBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          tenantName.toUpperCase(),
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: () => context.go(taskPagePath),

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: chipBorder),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          size: 12,
                          color: primaryBlue,
                        ),

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

              // ───────── NOTIFICATION ─────────
              if (config.isMain)
                Builder(
                  builder: (btnContext) => IconButton(
                    onPressed: () async {
                      final RenderBox button =
                          btnContext.findRenderObject() as RenderBox;

                      final RenderBox overlay =
                          Navigator.of(
                            btnContext,
                          ).overlay!.context.findRenderObject()
                              as RenderBox;

                      final RelativeRect position =
                          RelativeRect.fromRect(
                        Rect.fromPoints(
                          button.localToGlobal(
                            Offset.zero,
                            ancestor: overlay,
                          ),

                          button.localToGlobal(
                            button.size.bottomRight(
                              Offset.zero,
                            ),
                            ancestor: overlay,
                          ),
                        ),

                        Offset.zero & overlay.size,
                      );

                      await showMenu(
                        context: btnContext,
                        position: position,
                        color: cardBg,
                        elevation: 8,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: inputBorder),
                        ),

                        constraints: const BoxConstraints(
                          minWidth: 340,
                          maxWidth: 340,
                        ),

                        items: [
                          PopupMenuItem<void>(
                            enabled: false,
                            padding: EdgeInsets.zero,

                            child: const ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: primaryBlue,

                                child: Icon(
                                  Icons.build,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),

                              title: Text(
                                'New Task Assigned',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),

                              subtitle: Text(
                                'You have been assigned a new task. Please check your schedule.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),

                          PopupMenuItem(
                            onTap: () async {
                              await context
                                  .read<AuthCubit>()
                                  .logout();

                              if (context.mounted) {
                                context.go(loginPagePath);
                              }
                            },

                            child: const Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  size: 16,
                                  color: Color(0xFFFF6B6B),
                                ),

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
                      );
                    },

                    icon: Container(
                      padding: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: inputBorder),
                      ),

                      child: const Badge(
                        label: Text('3'),
                        isLabelVisible: true,

                        child: Icon(
                          Icons.notifications_outlined,
                          size: 18,
                          color: primaryText,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      // ───────────────── BODY ─────────────────
      body: navigationShell,

      // ───────────────── BOTTOM NAV ─────────────────
      bottomNavigationBar: config.showBottomNavigationBar
          ? Container(
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(
                  top: BorderSide(color: inputBorder),
                ),
              ),

              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                selectedItemColor: primaryBlue,
                unselectedItemColor: secondaryText,
                currentIndex: navigationShell.currentIndex,

                unselectedLabelStyle: TextStyle(
                  color: secondaryText,
                  fontSize: 10,
                ),

                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),

                backgroundColor: Colors.transparent,
                elevation: 0,

                onTap: (value) {
                  navigationShell.goBranch(
                    value,
                    initialLocation:
                        value == navigationShell.currentIndex,
                  );
                },

                items: navItems,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

// ─────────────────────────────────────────────
// TENANT INFO BOTTOM SHEET
// ─────────────────────────────────────────────

void _showTenantInfoBottomSheet(
  BuildContext context,
  TenantEntity tenant,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: cardBg,

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),

    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,

                decoration: BoxDecoration(
                  color: inputBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: primaryBlue,

                  child: Text(
                    tenant.name.substring(0, 2).toUpperCase(),

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        tenant.name,

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        tenant.legalName,

                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            _tenantInfoTile(
              icon: Icons.email_outlined,
              title: "Email",
              value: tenant.email,
            ),

            _tenantInfoTile(
              icon: Icons.phone_outlined,
              title: "Phone",
              value: tenant.phoneNumber,
            ),

            _tenantInfoTile(
              icon: Icons.language_outlined,
              title: "Website",
              value: tenant.website,
            ),

            _tenantInfoTile(
              icon: Icons.badge_outlined,
              title: "Tax Number",
              value: tenant.taxNumber,
            ),

            _tenantInfoTile(
              icon: Icons.confirmation_number_outlined,
              title: "Identifier",
              value: tenant.identifier,
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: inputBorder),
              ),

              child: Row(
                children: [
                  Icon(
                    tenant.isActive
                        ? Icons.check_circle
                        : Icons.cancel,

                    color: tenant.isActive
                        ? Colors.green
                        : Colors.red,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      tenant.isTrial
                          ? "Trial Subscription"
                          : "Active Subscription",

                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Subscription End: "
              "${tenant.subscriptionEndDate.toLocal()}",
              style: TextStyle(
                color: secondaryText,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

// ─────────────────────────────────────────────
// INFO TILE
// ─────────────────────────────────────────────

Widget _tenantInfoTile({
  required IconData icon,
  required String title,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Icon(
          icon,
          size: 18,
          color: primaryBlue,
        ),

        const SizedBox(width: 10),

        Text(
          "$title: ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        Expanded(
          child: Text(
            value.isEmpty ? "-" : value,
          ),
        ),
      ],
    ),
  );
}