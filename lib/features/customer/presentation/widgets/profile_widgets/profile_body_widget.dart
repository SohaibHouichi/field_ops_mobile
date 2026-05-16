import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/constants/app_router.dart';
import 'package:field_ops/core/enums/gender_enum.dart';
import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:field_ops/features/customer/presentation/widgets/profile_widgets/info_card_widget.dart';
import 'package:field_ops/features/customer/presentation/widgets/profile_widgets/info_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProfileBody extends StatelessWidget {
  final CustomersEntity customer;
  const ProfileBody({super.key, required this.customer});

  String get _initials {
    final parts = customer.fullName.trim().split(' ');
    return parts.length >= 2
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : parts.first.substring(0, 2).toUpperCase();
  }

  String get _genderLabel =>
      Gender.fromInt(customer.gender) == Gender.male ? 'Male' : 'Female';

  String get _birthDate => customer.birthDate != null
      ? DateFormat('MMM dd, yyyy').format(customer.birthDate!)
      : '—';

  @override
  Widget build(BuildContext context) {
    final logout = context.read<AuthCubit>().logout;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo chip ──────────────────────────────────────────────
          const SizedBox(height: 28),

          // ── Headline ───────────────────────────────────────────────
          const Text(
            'My Profile',
            style: TextStyle(
              color: primaryText,
              fontSize: 38,
              fontWeight: FontWeight.w700,
              height: 1.05,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your personal information and account details.',
            style: TextStyle(color: secondaryText, fontSize: 13),
          ),

          const SizedBox(height: 32),

          // ── Avatar + name ──────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: inputBorder),
            ),
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: accentDim,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryBlue.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: primaryBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.fullName,
                        style: const TextStyle(
                          color: primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        customer.email,
                        style: const TextStyle(
                          color: secondaryText,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Contact ────────────────────────────────────────────────
          InfoCard(
            title: 'Contact',
            rows: [
              InfoRow(
                icon: Icons.mail_outline_rounded,
                label: 'Email',
                value: customer.email,
                valueColor: primaryBlue,
              ),
              InfoRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: customer.phoneNumber,
              ),
              InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: customer.fullAddressLine ?? customer.addressLabel ?? '—',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Details ────────────────────────────────────────────────
          InfoCard(
            title: 'Details',
            rows: [
              InfoRow(
                icon: Icons.badge_outlined,
                label: 'ID',
                value: '#${customer.id}',
                mono: true,
              ),
              InfoRow(
                icon: Icons.wc_outlined,
                label: 'Gender',
                value: _genderLabel,
              ),
              InfoRow(
                icon: Icons.cake_outlined,
                label: 'Birth date',
                value: _birthDate,
              ),
            ],
          ),

          // ── Note ───────────────────────────────────────────────────
          if (customer.note != null && customer.note!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: inputBorder),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NOTE',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    customer.note!,
                    style: const TextStyle(
                      color: primaryText,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),
          // ── Action buttons ─────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: inputBorder),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: inputBorder, height: 1),
                const SizedBox(height: 16),
                // Logout button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      logout();
                      if (context.mounted) {
                        context.go(loginPagePath);
                      }
                    },
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red.withOpacity(0.4)),
                      backgroundColor: Colors.red.withOpacity(0.07),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
