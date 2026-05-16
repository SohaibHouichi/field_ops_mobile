import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/widgets/tenant_info_tile_widget.dart';
import 'package:field_ops/features/auth/domain/entities/tenant_entity.dart';
import 'package:flutter/material.dart';

void showTenantInfoBottomSheet(
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
                        tenant.name.toUpperCase(),

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

            tenantInfoTile(
              icon: Icons.email_outlined,
              title: "Email",
              value: tenant.email,
            ),

            tenantInfoTile(
              icon: Icons.phone_outlined,
              title: "Phone",
              value: tenant.phoneNumber,
            ),

            tenantInfoTile(
              icon: Icons.language_outlined,
              title: "Website",
              value: tenant.website,
            ),

            tenantInfoTile(
              icon: Icons.badge_outlined,
              title: "Tax Number",
              value: tenant.taxNumber,
            ),

            tenantInfoTile(
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