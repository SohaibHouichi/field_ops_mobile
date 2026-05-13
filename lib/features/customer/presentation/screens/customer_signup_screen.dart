import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/constants/app_router.dart';
import 'package:field_ops/core/constants/app_strings.dart';
import 'package:field_ops/core/enums/gender_enum.dart';
import 'package:field_ops/core/widgets/pulse_dot_widget.dart';
import 'package:field_ops/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:field_ops/core/widgets/field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _signUpKey = GlobalKey<FormState>();
final _firstNameController = TextEditingController();
final _lastNameController = TextEditingController();
final _emailController = TextEditingController();
final _phoneController = TextEditingController();
final _addressIdController = TextEditingController();
final _noteController = TextEditingController();

class CustomerSignUpScreen extends StatelessWidget {
  const CustomerSignUpScreen({super.key});

  Future<void> _pickDate(
    BuildContext context,
    DateTime? current,
    void Function(DateTime?) onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime(1995),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: primaryBlue,
            onSurface: primaryText,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    // Local mutable state lives here — no StatefulWidget needed
    Gender? selectedGender;
    DateTime? selectedBirthDate;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: BlocListener<CustomerCubit, CustomerState>(
          listener: (context, state) {
            if (state is CustomerSuccess) {
              context.go(homePagePath);
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // ── Back + Logo chip row ──────────────────────────────
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.go(loginPagePath),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: primaryText,
                            ),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
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
                                  appName,
                                  style: TextStyle(
                                    color: primaryBlue,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ── Headline ──────────────────────────────────────────
                      const Text(
                        'New Customer',
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
                        'Fill in the details below to register a new customer.',
                        style: TextStyle(color: secondaryText, fontSize: 13),
                      ),

                      const SizedBox(height: 32),

                      // ── Card ─────────────────────────────────────────────
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
                            // ── Error banner ──────────────────────────────
                            BlocBuilder<CustomerCubit, CustomerState>(
                              buildWhen: (p, c) =>
                                  c is CustomerError || p is CustomerError,
                              builder: (_, state) {
                                if (state is! CustomerError) {
                                  return const SizedBox.shrink();
                                }
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0x22FF4D4D),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0x55FF4D4D),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Color(0xFFFF6B6B),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          state.message,
                                          style: const TextStyle(
                                            color: Color(0xFFFF6B6B),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            Form(
                              key: _signUpKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── First name ──────────────────────────
                                  Field(
                                    label: 'First Name',
                                    hint: 'Sohaib',
                                    controller: _firstNameController,
                                    icon: Icons.person_outline_rounded,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? validationRequired
                                        : null,
                                  ),

                                  const SizedBox(height: 16),

                                  // ── Last name ───────────────────────────
                                  Field(
                                    label: 'Last Name',
                                    hint: 'Houichi',
                                    controller: _lastNameController,
                                    icon: Icons.person_outline_rounded,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? validationRequired
                                        : null,
                                  ),

                                  const SizedBox(height: 16),

                                  // ── Email ───────────────────────────────
                                  Field(
                                    label: 'Email',
                                    hint: 'sohaib@example.com',
                                    controller: _emailController,
                                    icon: Icons.email_outlined,
                                    inputType: TextInputType.emailAddress,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return validationRequired;
                                      }
                                      if (!v.contains('@')) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  // ── Phone ───────────────────────────────
                                  Field(
                                    label: 'Phone Number',
                                    hint: '+213 555 000 000',
                                    controller: _phoneController,
                                    icon: Icons.phone_outlined,
                                    inputType: TextInputType.phone,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? validationRequired
                                        : null,
                                  ),

                                  const SizedBox(height: 16),

                                  // ── Gender ──────────────────────────────
                                  const Text(
                                    'Gender',
                                    style: TextStyle(
                                      color: secondaryText,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<Gender>(
                                    value: selectedGender,
                                    validator: (v) =>
                                        v == null ? validationRequired : null,
                                    decoration: InputDecoration(
                                      hintText: 'Select gender',
                                      hintStyle: const TextStyle(
                                        color: secondaryText,
                                        fontSize: 14,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.wc_outlined,
                                        color: secondaryText,
                                        size: 18,
                                      ),
                                      filled: true,
                                      fillColor: bgColor,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 14,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: inputBorder,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: inputBorder,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: primaryBlue,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFFF6B6B),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFFF6B6B),
                                        ),
                                      ),
                                    ),
                                    dropdownColor: cardBg,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: secondaryText,
                                    ),
                                    items: Gender.values
                                        .map(
                                          (g) => DropdownMenuItem(
                                            value: g,
                                            child: Text(
                                              g.name[0].toUpperCase() +
                                                  g.name.substring(1),
                                              style: const TextStyle(
                                                color: primaryText,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) =>
                                        setState(() => selectedGender = v),
                                  ),

                                  const SizedBox(height: 16),

                                  // ── Birth date (optional) ───────────────
                                  const Text(
                                    'Birth Date (optional)',
                                    style: TextStyle(
                                      color: secondaryText,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () => _pickDate(
                                      context,
                                      selectedBirthDate,
                                      (date) => setState(
                                        () => selectedBirthDate = date,
                                      ),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: inputBorder),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            color: secondaryText,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            selectedBirthDate == null
                                                ? 'Select date'
                                                : '${selectedBirthDate!.day.toString().padLeft(2, '0')}/'
                                                      '${selectedBirthDate!.month.toString().padLeft(2, '0')}/'
                                                      '${selectedBirthDate!.year}',
                                            style: TextStyle(
                                              color: selectedBirthDate == null
                                                  ? secondaryText
                                                  : primaryText,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const Spacer(),
                                          if (selectedBirthDate != null)
                                            GestureDetector(
                                              onTap: () => setState(
                                                () => selectedBirthDate = null,
                                              ),
                                              child: const Icon(
                                                Icons.close_rounded,
                                                color: secondaryText,
                                                size: 16,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // ── Address ID ──────────────────────────
                                  Field(
                                    label: 'Address',
                                    hint: 'e.g. Msila, Algeria',
                                    controller: _addressIdController,
                                    icon: Icons.location_on_outlined,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? validationRequired
                                        : null,
                                  ),

                                  const SizedBox(height: 16),

                                  // ── Note ────────────────────────────────
                                  Field(
                                    label: 'Note',
                                    hint: 'Any additional info...',
                                    controller: _noteController,
                                    icon: Icons.notes_rounded,
                                    maxLines: 3,
                                    validator: null,
                                  ),

                                  const SizedBox(height: 24),

                                  // ── Submit button ───────────────────────
                                  BlocBuilder<CustomerCubit, CustomerState>(
                                    buildWhen: (p, c) =>
                                        c is CustomerLoading ||
                                        p is CustomerLoading,
                                    builder: (context, state) {
                                      final loading = state is CustomerLoading;
                                      return SizedBox(
                                        width: double.infinity,
                                        height: 52,
                                        child: ElevatedButton(
                                          onPressed: loading
                                              ? null
                                              : () {
                                                  if (_signUpKey.currentState!
                                                      .validate()) {
                                                    context
                                                        .read<CustomerCubit>()
                                                        .createCustomer(
                                                          firstName:
                                                              _firstNameController
                                                                  .text
                                                                  .trim(),
                                                          lastName:
                                                              _lastNameController
                                                                  .text
                                                                  .trim(),
                                                          email:
                                                              _emailController
                                                                  .text
                                                                  .trim(),

                                                          gender:
                                                              selectedGender!
                                                                  .value,
                                                          phoneNumber:
                                                              _phoneController
                                                                  .text
                                                                  .trim(),
                                                          addressId:
                                                              _addressIdController
                                                                  .text
                                                                  .trim(),
                                                          note: _noteController
                                                              .text
                                                              .trim(),
                                                          birthDate:
                                                              selectedBirthDate,
                                                        );
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryBlue,
                                            foregroundColor: Colors.white,
                                            disabledBackgroundColor: accentDim,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: loading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2.5,
                                                        color: Colors.white,
                                                      ),
                                                )
                                              : const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Create Customer',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.3,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      size: 18,
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
