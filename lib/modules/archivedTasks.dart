import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_remake1/components/shared/sharedComponents.dart';
import 'package:todo_remake1/shared/cubit/cubit.dart';
import 'package:todo_remake1/shared/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskatyCubit, TaskatyStates>(
      listener: (BuildContext context, TaskatyStates state) {},
      builder: (BuildContext context, TaskatyStates state) {
        List<Map> archivedTasks = TaskatyCubit.get(context).archivedTasks;
        return ConditionalBuilder(
          condition: archivedTasks.isNotEmpty,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) =>
                  archivedTaskItem(archivedTasks[index], context),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 3,
                  ),
              itemCount: archivedTasks.length),
          fallback: (context) => const Center(
              child: Text(
            "No archived tasks",
            style: TextStyle(
                color: Color.fromARGB(255, 85, 208, 149),
                fontSize: 20,
                fontWeight: FontWeight.w600),
          )),
        );
      },
    );
  }
}
