import 'package:field_ops/constants/about_coloring.dart';
import 'package:field_ops/layers/presentation/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeployFeedback extends StatelessWidget {
  const DeployFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: AppBarTitle(text: 'Deploy Feedback'),
        centerTitle: true,
      ),
      body: Text('data'),
    );
  }
}