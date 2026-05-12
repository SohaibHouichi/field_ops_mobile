import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/layers/business_logic/cubit/Home/home_cubit.dart';
import 'package:field_ops/layers/presentation/widgets/custom_card.dart';
import 'package:field_ops/layers/presentation/widgets/description_text.dart';
import 'package:field_ops/layers/presentation/widgets/generale_title.dart';
import 'package:field_ops/layers/presentation/widgets/lable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: .all(8),
      children: [
        Row(
          children: [
            // card task
            Expanded(
              child: CustomCard(
                firstText: "Today's \nTask",
                secondText: context
                    .read<HomeCubit>()
                    .taskCountPerDay
                    .toString(),
                icon: Icons.calendar_month,
              ),
            ),
            // card project
            Expanded(
              child: CustomCard(
                firstText: 'Active \nProject',
                secondText: context
                    .read<HomeCubit>()
                    .currentProjects
                    .toString(),
                icon: Icons.account_tree,
              ),
            ),
          ],
        ),

        SizedBox(height: 8),

        Card(
          elevation: 1,
          color: Colors.white,
          child: ListTile(
            contentPadding: .only(right: 10, top: 10, left: 20, bottom: 10),
            title: Lable(
              text: 'Current Availability',
              color: Colors.black,
              size: 18,
            ),
            subtitle: DescriptionText(
              text: "Switch to 'Available' for new tasks",
              align: .start,
            ),
            trailing: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Switch(
                  value: context.watch<HomeCubit>().isAvailable,
                  onChanged: (value) {
                    //do post to switch thea vaibility
                    context.read<HomeCubit>().toggle(value);
                  },
                  activeThumbColor: primaryBlue,
                );
              },
            ),
          ),
        ),
        SizedBox(height: 8),
        GeneraleTitle(
          text: 'Recent Activity',
          size: 24,
          align: .start,
          padding: 8,
        ),
        Divider(thickness: 2 ,radius: .circular(20),indent: 8,endIndent: 8,),
        SizedBox(height: 8),
        Card.filled(
          color: Colors.white,
          elevation: 1,
          child:  Padding(
            padding: const EdgeInsets.only(bottom: 100, top: 10),
            child: DescriptionText(text: 'No recent activity'),
          ),
        )
       
      ],
    );
  }
}
