// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_remake1/modules/archivedTasks.dart';
import 'package:todo_remake1/modules/currentTasks.dart';
import 'package:todo_remake1/modules/doneTasks.dart';
import 'package:todo_remake1/shared/cubit/states.dart';

class TaskatyCubit extends Cubit<TaskatyStates> {
  TaskatyCubit(super.InitialState);

  static TaskatyCubit get(context) => BlocProvider.of(context);

  int screenIndex = 0;

  List<Widget> screens = [
    const CurrentTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];

  Database? taskatyDatabase;

  List<Map> allTasks = [];
  List<Map> currentTasks = [];
  List<Map> archivedTasks = [];
  List<Map> doneTasks = [];

  bool isBottomSheetup = false;

  void changeIndex(int index) {
    screenIndex = index;
    emit(ChangeScreenIndex());
  }

  void changeBottomSheetState(bool isBottomSheetup) {
    this.isBottomSheetup = isBottomSheetup;
    emit(ChangeBottomSheetState());
  }

  void createDB() {
    openDatabase(
      "taskaty.db",
      version: 1,
      onCreate: (taskatyDatabase, version) {
        taskatyDatabase
            .execute(
                "create table tasks (id integer primary key , title text , date text , time text ,status text )")
            .then((value) {})
            .catchError((error) {
          print("$error");
        });
      },
      onOpen: (taskatyDatabase) {
        print("database opened");
        getDataFromDB(taskatyDatabase);
      },
    ).then((value) {
      taskatyDatabase = value;
      emit(CreateDatabaseState());
    });
  }

  Future insertIntoDB(
    String title,
    String time,
    String date,
  ) async {
    await taskatyDatabase?.transaction((txn) async {
      txn
          .rawInsert(
              "insert into tasks (title,date,time,status) values ('$title' ,'$date' ,'$time', 'current') ")
          .then((value) {
        emit(InsertdataIntoDatabase());
        getDataFromDB(taskatyDatabase!);
      }).catchError((error) {
        print("error while inserting $error");
      });
      return null;
    });
  }

  // Future<List<Map<String, Object?>>>
  void getDataFromDB(Database taskatyDatabase) async {
    emit(GetFromDatabaseLoadingState());
    taskatyDatabase.rawQuery("select * from tasks ").then((value) {
      if (value == []) {
        emit(GetFromDatabaseState());
      }
      currentTasks = [];
      doneTasks = [];
      archivedTasks = [];

      for (var value in value) {
        if (value["status"] == "current") {
          currentTasks.add(value);
        } else if (value["status"] == "done") {
          doneTasks.add(value);
        } else {
          archivedTasks.add(value);
        }
        print(allTasks);
      }
      emit(GetFromDatabaseState());
    });
  }

  void updateDB(int id, String status) {
    taskatyDatabase!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ? ',
        [status, id]).then((value) {
      emit(UpdateDatabaseState());
      getDataFromDB(taskatyDatabase!);
    });
  }

  void deleteFromDB(int id) {
    taskatyDatabase!
        .rawDelete("delete from tasks where id = ?", [id]).then((value) {
      emit(DeleteFromDatabaseState());
      getDataFromDB(taskatyDatabase!);
    });
  }
}
