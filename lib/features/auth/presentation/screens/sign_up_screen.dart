import 'package:field_ops/core/constants/about_coloring.dart';
import 'package:field_ops/core/constants/about_routing.dart';
import 'package:field_ops/layers/presentation/widgets/app_bar_title.dart';
import 'package:field_ops/layers/presentation/widgets/description_text.dart';
import 'package:field_ops/layers/presentation/widgets/generale_title.dart';
import 'package:field_ops/layers/presentation/widgets/lable.dart';
import 'package:field_ops/layers/presentation/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,

        leading: IconButton(
          onPressed: () => context.go(loginPagePath),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),

        title: AppBarTitle(text: 'Create Account'),
        centerTitle: true,
      ),
      backgroundColor: bgColor,

      body: ListView(
        padding: .all(15),
        children: [
          GeneraleTitle(text: 'Join FieldOps', align: .start),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DescriptionText(
              text:
                  'Demand your contracting business to start intelligent field management.',
              align: .start,
            ),
          ),
          SizedBox(height: 16),
          Form(
            ///........ key change
            key: GlobalKey(),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                //name
                CustomTextFormField(
                  textLable: 'Fullname',
                  controller: TextEditingController(),
                  hint: 'Houichi Sohaib',

                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Required' : null,

                  prefixIcon: Icon(Icons.label_important_outline, color: secondaryText),
                ),

                SizedBox(height: 16),
                //company
                CustomTextFormField(
                  textLable: 'Company Name',
                  controller: TextEditingController(),
                  hint: 'Mformatic',
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Required' : null,

                  prefixIcon: Icon(Icons.lock, color: secondaryText),
                ),

                SizedBox(height: 16),
                //username
                CustomTextFormField(
                  textLable: 'Username',
                  controller: TextEditingController(),
                  hint: 'Sohaib___',
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Required' : null,

                  prefixIcon: Icon(Icons.person, color: secondaryText),
                ),

                SizedBox(height: 16),

                Lable(text: 'Trade Type', color: Colors.black),

                SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Required' : null,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryBlue),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  dropdownColor: bgColor,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Select your trade'),
                    ),
                    DropdownMenuItem(
                      value: 'Category 1',
                      child: Lable(text: 'C1', color: primaryText),
                    ),
                    DropdownMenuItem(
                      value: 'Category 2',
                      child: Lable(text: 'C2', color: primaryText),
                    ),
                    DropdownMenuItem(
                      value: 'Category 3',
                      child: Lable(text: 'C3', color: primaryText),
                    ),
                    DropdownMenuItem(
                      value: 'Category 4',
                      child: Lable(text: 'C4', color: primaryText),
                    ),
                  ],
                  onChanged: (value) {
                    // handle change
                  },
                ),

                SizedBox(height: 24),

                MaterialButton(
                  onPressed: () {},
                  color: primaryBlue,
                  padding: .all(20),
                  shape: OutlineInputBorder(
                    borderRadius: .all(Radius.circular(8)),
                    borderSide: .none,
                  ),
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Lable(text: 'Create Account ', color: Colors.white),
                      Icon(Icons.add, color: Colors.white),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Lable(text: "Already have an account?", color: Colors.grey),
                    TextButton(
                      onPressed: () {
                        context.go(loginPagePath);
                      }, //change
                      child: Lable(text: 'Log in', color: primaryBlue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
