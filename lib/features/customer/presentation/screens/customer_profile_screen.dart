import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/enums/gender_enum.dart';
import 'package:field_ops/features/customer/domain/entities/customer_entity.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final id = authState is AuthAuthenticated
        ? authState.user.userId
        : 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<CustomerCubit>().state;
      if (state is! CustomerSuccess && state is! CustomerLoading) {
        context.read<CustomerCubit>().getCustomerById(id: 25);
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: BlocBuilder<CustomerCubit, CustomerState>(
            builder: (context, state) {
              if (state is CustomerInitial || state is CustomerLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryBlue),
                );
              }
              if (state is CustomerError) {
                return _ErrorView(message: state.message);
              }
              if (state is CustomerSuccess) {
                return _ProfileBody(customer: state.customer);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final CustomersEntity customer;
  const _ProfileBody({required this.customer});

  String get _initials {
    final parts = customer.fullName.trim().split(' ');
    return parts.length >= 2
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : parts.first.substring(0, 2).toUpperCase();
  }

  String get _genderLabel => Gender.fromInt(customer.gender) == Gender.male ? 'Male' : 'Female';

  String get _birthDate => customer.birthDate != null
      ? DateFormat('MMM dd, yyyy').format(customer.birthDate!)
      : '—';

  @override
  Widget build(BuildContext context) {
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
          _InfoCard(
            title: 'Contact',
            rows: [
              _InfoRow(
                icon: Icons.mail_outline_rounded,
                label: 'Email',
                value: customer.email,
                valueColor: primaryBlue,
              ),
              _InfoRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: customer.phoneNumber,
              ),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: customer.fullAddressLine ?? customer.addressLabel ?? '—',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Details ────────────────────────────────────────────────
          _InfoCard(
            title: 'Details',
            rows: [
              _InfoRow(
                icon: Icons.badge_outlined,
                label: 'ID',
                value: '#${customer.id}',
                mono: true,
              ),
              _InfoRow(
                icon: Icons.wc_outlined,
                label: 'Gender',
                value: _genderLabel,
              ),
              _InfoRow(
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
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;
  const _InfoCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: inputBorder),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          ...rows,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool mono;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: secondaryText, size: 18),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: secondaryText, fontSize: 13),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor ?? primaryText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: mono ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0x22FF4D4D),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0x55FF4D4D)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFFF6B6B), size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
