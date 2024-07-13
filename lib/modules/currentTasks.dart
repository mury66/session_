import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_remake1/components/shared/sharedComponents.dart';
import 'package:todo_remake1/shared/cubit/cubit.dart';
import 'package:todo_remake1/shared/cubit/states.dart';

class CurrentTasks extends StatelessWidget {
  const CurrentTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskatyCubit, TaskatyStates>(
      listener: (BuildContext context, TaskatyStates state) {},
      builder: (BuildContext context, TaskatyStates state) {
        List<Map> currentTasks = TaskatyCubit.get(context).currentTasks;
        return ConditionalBuilder(
          condition: currentTasks.isNotEmpty,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) =>
                  currentTaskItem(currentTasks[index], context),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 3,
                  ),
              itemCount: currentTasks.length),
          fallback: (context) => const Center(
              child: Text(
            "No current Tasks yet, add some!",
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
