import 'package:field_ops/core/constants/about_routing.dart';
import 'package:field_ops/layers/presentation/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Status { all ,inProgress, urgent, completed, suspunded }

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          CustomTextFormField(
            hint: 'Serach',
            controller: TextEditingController(), //get the value of feild
            validator: (v) => (v),
            prefixIcon: Icon(Icons.search),
          ),

          SizedBox(height: 8),

          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Status.values.length,
              itemBuilder: (context, index) {
                final status = Status.values[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    disabledColor: Colors.white,
                    label: Text(status.name),
                    selected: false,
                    onSelected: (_) {},
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: .all(8),
              itemCount: 4,
              itemBuilder: (context, _) {
                return Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.red, width: 1.5),
                        ),
                        borderRadius: .all(.circular(15)),
                      ),
                      child: ListTile(
                        onTap: () {
                          context.go(taskDetailPath);
                        },
                        leading: Icon(Icons.abc),
                        title: Text('Project name'),
                        subtitle: Column(
                          crossAxisAlignment: .start,
                          mainAxisSize: .min,
                          children: [
                            Text('TaskRef + Task Name'),
                            Text('startAt + DiedLine'),
                          ],
                        ),
                        trailing: Text('status'),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
