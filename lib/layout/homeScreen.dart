import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_remake1/components/shared/sharedComponents.dart';
import 'package:todo_remake1/shared/cubit/cubit.dart';
import 'package:todo_remake1/shared/cubit/states.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          TaskatyCubit(InitialState())..createDB(),
      child: BlocConsumer<TaskatyCubit, TaskatyStates>(
        listener: (BuildContext context, TaskatyStates state) {},
        builder: (BuildContext context, TaskatyStates state) {
          var cubit = TaskatyCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: const Color.fromARGB(255, 45, 45, 45),
            appBar: AppBar(
              automaticallyImplyLeading: !cubit.isBottomSheetup,
              title: const Center(
                child: Text(
                  "Taskaty",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 208, 149)),
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 45, 45, 45),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 85, 208, 149),
              tooltip: "add Note",
              child: Icon(
                cubit.isBottomSheetup ? Icons.add : Icons.edit,
                color: const Color.fromARGB(255, 45, 45, 45),
              ),
              onPressed: () {
                if (!cubit.isBottomSheetup) {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          width: double.infinity,
                          height: 300,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 44, 44, 44),
                          ),
                          child: SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      dateController.text = "";
                                      timeController.text = "";
                                      titleController.text = "";
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 30,
                                      color: Color.fromARGB(255, 85, 208, 149),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  defaultInputForm(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    onSubmitted: (value) {
                                      print(value);
                                    },
                                    validator: (String? value) {
                                      return (value!.isEmpty)
                                          ? 'write something.'
                                          : null;
                                    },
                                    label: "title",
                                    prefixIcon: Icons.lightbulb_outline,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  defaultInputForm(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    onSubmitted: (value) {
                                      print(value);
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context);
                                      });
                                    },
                                    validator: (String? value) {
                                      return (value!.isEmpty)
                                          ? 'enter time'
                                          : null;
                                    },
                                    label: "time",
                                    prefixIcon: Icons.watch_later_outlined,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  defaultInputForm(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    onSubmitted: (value) {
                                      print(value);
                                    },
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse("2030-12-31"))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validator: (String? value) {
                                      return (value!.isEmpty)
                                          ? 'enter date'
                                          : null;
                                    },
                                    label: "date",
                                    prefixIcon: Icons.date_range,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(false);
                  });
                  cubit.changeBottomSheetState(true);
                } else {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertIntoDB(titleController.text, timeController.text,
                            dateController.text)
                        .then((value) {
                      cubit.changeBottomSheetState(false);
                      Navigator.pop(context);
                    });
                  }
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              currentIndex: cubit.screenIndex,
              backgroundColor: const Color.fromARGB(255, 85, 208, 149),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu_outlined,
                    color: Color.fromARGB(255, 45, 45, 45),
                  ),
                  label: "current task",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check,
                        color: Color.fromARGB(255, 45, 45, 45)),
                    label: "done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive,
                        color: Color.fromARGB(255, 45, 45, 45)),
                    label: "archived")
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! GetFromDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.screenIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 85, 208, 149),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
