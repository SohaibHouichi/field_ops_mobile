import 'package:field_ops/constants/about_coloring.dart';
import 'package:field_ops/constants/about_routing.dart';
import 'package:field_ops/features/auth/business_logic/cubit/auth_cubit.dart';
import 'package:field_ops/features/auth/data/models/DTO/login_request_dto.dart';
//import 'package:field_ops/layers/business_logic/cubit/login_/password_cubit.dart';
import 'package:field_ops/layers/presentation/widgets/app_bar_title.dart';
import 'package:field_ops/layers/presentation/widgets/description_text.dart';
import 'package:field_ops/layers/presentation/widgets/generale_title.dart';
import 'package:field_ops/layers/presentation/widgets/lable.dart';
import 'package:field_ops/layers/presentation/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
      LoginRequestDto loginData =  LoginRequestDto(
    username: usernameController.text.trim(),
    password: passwordController.text, );

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,

        leading: IconButton(
          onPressed: () => SystemNavigator.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),

        title: AppBarTitle(text: 'FieldOPS'),
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: ListView(
        children: [
          Image.asset(
            'assets/img/login.png',
            height: 200,
            colorBlendMode: .difference,
            filterQuality: .high,
          ),
          GeneraleTitle(text: 'Welcome Back'),
          DescriptionText(text: 'Log in to manage your field service '),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                return Center(
                  child: Lable(text: 'Success', color: Colors.green),
                );
              } else if (state is AuthFailed) {
                return Center(
                  child: Lable(
                    text: context.read<AuthCubit>().message,
                    color: Colors.red,
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          Form(
            key: loginKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  CustomTextFormField(
                    textLable: 'Username',
                    controller: usernameController,
                    hint: 'Enter your username',

                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Required' : null,

                    prefixIcon: Icon(
                      Icons.person_rounded,
                      color: secondaryText,
                    ),
                  ),

                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Lable(text: 'Password', color: Colors.black),
                      MaterialButton(
                        visualDensity: .compact,
                        onPressed: () {
                          context.push(passwordRestorePath);
                        }, //change
                        child: Lable(
                          text: 'Forget password?',
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomTextFormField(
                        controller: passwordController,
                        hint: '*********************',
                        obscureText: context.watch<AuthCubit>().isNotVisible,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Required'
                            : null,

                        prefixIcon: Icon(Icons.lock, color: secondaryText),
                        suffixIcon: IconButton(
                          onPressed: () {
                            context.read<AuthCubit>().toggle();
                          },
                          icon: Icon(
                            context.watch<AuthCubit>().isNotVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 16),

                  MaterialButton(
                    onPressed: () {
                      if (loginKey.currentState!.validate()) {
                        context.read<AuthCubit>().login(
                       loginData
                        );
                      }
                    },
                    color: primaryBlue,
                    padding: .all(20),
                    shape: OutlineInputBorder(
                      borderRadius: .all(Radius.circular(8)),
                      borderSide: .none,
                    ),
                    child: BlocConsumer<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return CircularProgressIndicator(color: Colors.white);
                        }
                        return Row(
                          mainAxisAlignment: .center,
                          children: [
                            Lable(text: 'SIGN IN  ', color: Colors.white),
                            Icon(Icons.login, color: Colors.white),
                          ],
                        );
                      },
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          context.push(homePagePath);
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 24),

                  Row(
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Lable(
                          text: 'OR CONTINUE WITH',
                          color: Colors.grey,
                        ),
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),

                  SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            /// call the biomitric registering
                          },
                          elevation: 0,
                          color: inputFill,
                          padding: .all(20),
                          shape: OutlineInputBorder(
                            borderRadius: .all(Radius.circular(8)),
                            borderSide: BorderSide(
                              width: 1,
                              color: secondaryText,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: .spaceEvenly,
                            children: [
                              Icon(Icons.fingerprint, color: Colors.grey),
                              Lable(text: 'Biomitric  ', color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            context.go(homePagePath);
                          },
                          elevation: 0,
                          color: inputFill,
                          padding: .all(20),
                          shape: OutlineInputBorder(
                            borderRadius: .all(Radius.circular(8)),
                            borderSide: BorderSide(
                              width: 1,
                              color: secondaryText,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: .spaceEvenly,
                            children: [
                              Icon(Icons.key_sharp, color: Colors.grey),
                              Lable(text: 'SSO  ', color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Lable(text: "Don't have an account?", color: Colors.grey),
                      MaterialButton(
                        visualDensity: .compact,
                        onPressed: () {
                          context.go(signUpPagePath);
                        }, //change
                        child: Lable(
                          text: 'Request Access',
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
