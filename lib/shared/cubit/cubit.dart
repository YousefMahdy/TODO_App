import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jooo/modules/archivedScrean/archived.dart';
import 'package:jooo/modules/doneScrean/done.dart';
import 'package:jooo/modules/tasks/Tasks.dart';
import 'package:jooo/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStetes> {
  AppCubit() : super(AppInitialState());
  var current_Index = 0;
  List<String> title = ["New Tasks", "Done Tasks", "Archived Tasks"];
  List<Widget> body = [Tasks(), Done(), Arcvived()];
  late List<Map> tasks = [];
  late List<Map> newTasks = [];
  late List<Map> doneTasks = [];
  late List<Map> archiveTasks = [];
  late Database database;
  bool isButtomSheetShown = false;

  static AppCubit get(context) => BlocProvider.of(context);

  changIndex(index) {
    current_Index = index;
    emit(AppChangButtomNavBarStste());
  }

  changButtomSheetState({
    required bool isButomSheetShown,
  }) {
    isButtomSheetShown = isButomSheetShown;
    emit(ChangButtomSheetState());
  }

  void creatDatabase() async {
    openDatabase("todo.db", version: 1, onCreate: (database, version) {
      print("data created");
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
          .then((value) {
        print("table created");
      }).catchError((error) {
        print("error is ${error.toString()}");
      });
    }, onOpen: (database) {
      getData(database);  //database for onOpen
    }).then((value) {
      database = value;
      print("$value  ");
      // emit(AppCreatDataBaseState());
    });
    print("data opend");
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time,status) VALUES("$title", "$date", "$time","new")')
          .then((value) {
        print('inserted1 rooooow : ${value}');
        emit(AppInsertDataBaseState());
        getData(database);

      }).catchError((error) {
        print("error issss $error");
      });
    });

  }

  void getData(database) async {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppDataBaseLoadingState());
    return await database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element["status"] == "new")
          newTasks.add(element);
        else if (element["status"] == "done")
          doneTasks.add(element);
        else
          archiveTasks.add(element);

        print(element["status"]);
      });
      emit(AppGetDataBaseState());
    });
  }

  void updateDatabase({required String status, required int id}) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getData(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void deleteDatabase({required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getData(database);
      emit(AppDeleteDataBaseState());
    });
  }


}
