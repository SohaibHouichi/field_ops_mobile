import 'package:field_ops/core/constants/about_coloring.dart';
import 'package:field_ops/layers/presentation/widgets/app_bar_title.dart';
import 'package:field_ops/layers/presentation/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PasswordRestoringScreen extends StatelessWidget {
  const PasswordRestoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,

        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),

        title: AppBarTitle(text: 'Forget Password'),
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: ListView(
        children: [
          Center(
            child: CustomCard(
             firstText: 'Contact your respansible SS :',
             secondText : '     +213 555 17 76 13',
             icon: Icons.call,
              
            ),
          ),
        ],
      ),
    );
  }
}