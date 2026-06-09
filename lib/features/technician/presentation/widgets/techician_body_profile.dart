import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/constants/app_router.dart';
import 'package:field_ops/core/enums/gender_enum.dart';
import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:field_ops/features/customer/presentation/widgets/profile_widgets/info_card_widget.dart';
import 'package:field_ops/features/customer/presentation/widgets/profile_widgets/info_row_widget.dart';
import 'package:field_ops/features/technician/domain/entities/technician_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TechnicianProfileBody extends StatelessWidget {
  final TechnicianEntity technician;
  const TechnicianProfileBody({super.key, required this.technician});

  String get _initials {
    final parts = technician.fullName.trim().split(' ');
    return parts.length >= 2
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : parts.first.substring(0, 2).toUpperCase();
  }

  String get _genderLabel =>
      Gender.fromInt(technician.gender) == Gender.male ? 'Male' : 'Female';

  @override
  Widget build(BuildContext context) {
    final logout = context.read<AuthCubit>().logout;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        technician.fullName,
                        style: const TextStyle(
                          color: primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        technician.email,
                        style: const TextStyle(
                          color: secondaryText,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // ── Availability badge ─────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: technician.isAvailable
                              ? Colors.green.withOpacity(0.12)
                              : Colors.red.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: technician.isAvailable
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              technician.isAvailable
                                  ? 'Available'
                                  : 'Unavailable',
                              style: TextStyle(
                                color: technician.isAvailable
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
                value: technician.email,
                valueColor: primaryBlue,
              ),
              InfoRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: technician.phoneNumber ?? '—',
              ),
              InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: technician.addressLabel ?? '—',
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
                value: '#${technician.id}',
                mono: true,
              ),
              InfoRow(
                icon: Icons.work_outline_rounded,
                label: 'Job Title',
                value: technician.jobTitle ?? '—',
              ),
              InfoRow(
                icon: Icons.wc_outlined,
                label: 'Gender',
                value: _genderLabel,
              ),
              InfoRow(
                icon: Icons.cake_outlined,
                label: 'Birth Date',
                value: technician.birthDate ?? '—',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Team ───────────────────────────────────────────────────
          InfoCard(
            title: 'Team',
            rows: [
              InfoRow(
                icon: Icons.group_outlined,
                label: 'Team',
                value: technician.teamName ?? '—',
              ),
              InfoRow(
                icon: Icons.tag_outlined,
                label: 'Team ID',
                value: technician.teamId != null
                    ? '#${technician.teamId}'
                    : '—',
                mono: true,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ── Logout ─────────────────────────────────────────────────
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

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}