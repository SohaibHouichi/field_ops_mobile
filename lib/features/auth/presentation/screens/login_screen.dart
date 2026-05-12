import 'package:field_ops/core/constants/about_coloring.dart';
import 'package:field_ops/core/constants/about_routing.dart';
import 'package:field_ops/core/constants/app_strings.dart';
import 'package:field_ops/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:field_ops/features/auth/presentation/widgets/field_widget.dart';
import 'package:field_ops/core/widgets/pulse_dot_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _loginKey = GlobalKey<FormState>();
final _usernameController = TextEditingController();
final _passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go(homePagePath);
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // ── Logo chip ─────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
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

                  const SizedBox(height: 28),

                  // ── Headline ──────────────────────────────────────────
                  const Text(
                    loginHeadline,
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
                    loginSubtitle,
                    style: TextStyle(color: secondaryText, fontSize: 13),
                  ),

                  const SizedBox(height: 32),

                  // ── Card ──────────────────────────────────────────────
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
                        // Error banner
                        BlocBuilder<AuthCubit, AuthState>(
                          buildWhen: (p, c) =>
                              c is AuthError || p is AuthError,
                          builder: (_, state) {
                            if (state is! AuthError) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0x22FF4D4D),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0x55FF4D4D)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: Color(0xFFFF6B6B), size: 16),
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
                          key: _loginKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Username
                              Field(
                                label: usernameLabel,
                                hint: usernameHint,
                                controller: _usernameController,
                                icon: Icons.person_outline_rounded,
                                validator: (v) =>
                                    (v == null || v.isEmpty)
                                        ? validationRequired
                                        : null,
                              ),

                              const SizedBox(height: 16),

                              // Password
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  final hidden =
                                      context.watch<AuthCubit>().isNotVisible;
                                  return Field(
                                    label: passwordLabel,
                                    hint: passwordHint,
                                    controller: _passwordController,
                                    icon: Icons.lock_outline_rounded,
                                    obscureText: hidden,
                                    validator: (v) =>
                                        (v == null || v.isEmpty)
                                            ? validationRequired
                                            : null,
                                    suffix: IconButton(
                                      onPressed: () =>
                                          context.read<AuthCubit>().toggle(),
                                      icon: Icon(
                                        hidden
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: secondaryText,
                                        size: 18,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // Forgot password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () =>
                                      context.push(passwordRestorePath),
                                  style: TextButton.styleFrom(
                                    foregroundColor: primaryBlue,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    forgotPassword,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 4),

                              // Sign in button
                              BlocBuilder<AuthCubit, AuthState>(
                                buildWhen: (p, c) =>
                                    c is AuthLoading || p is AuthLoading,
                                builder: (context, state) {
                                  final loading = state is AuthLoading;
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: loading
                                          ? null
                                          : () {
                                              if (_loginKey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<AuthCubit>()
                                                    .login(
                                                      email: _usernameController
                                                          .text
                                                          .trim(),
                                                      password:
                                                          _passwordController
                                                              .text,
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
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  signIn,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(Icons.arrow_forward,
                                                    size: 18),
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

                  const SizedBox(height: 28),

                  // ── Request access ────────────────────────────────────
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          noAccount,
                          style:
                              TextStyle(color: secondaryText, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () => context.go(signUpPagePath),
                          child: const Text(
                            requestAccess,
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}