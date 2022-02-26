import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jooo/shared/components/components.dart';
import 'package:jooo/shared/cubit/cubit.dart';
import 'package:jooo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var timeController = TextEditingController();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var form_Key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStetes>(
        listener: (context, state) {
          if(state is AppInsertDataBaseState){
            Navigator.pop(context);

          }

        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(cubit.title[cubit.current_Index]),
            ),
            body: state is AppDataBaseLoadingState
                ? Center(child: CircularProgressIndicator())
                : cubit.body[cubit.current_Index],

            // ConditionalBuilder(
            //   condition: tasks.length > 0,
            //   builder: body![current_index],
            //   fallback:Center(child: CircularProgressIndicator()) ,
            // )

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (!cubit.isBottomSheetShown) {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          color: Colors.grey[200],
                          child: Form(
                            key: form_Key,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  labelText: "Task Title",
                                  prefexIcon: Icons.title,
                                  //safexIcon:  Icons.visibility_off,

                                  validat: (s) {
                                    if (s.isEmpty)
                                      return "pleas Enter your Title";
                                  },
                                  controler: titleController,
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                defaultFormField(
                                  labelText: "Task Time",
                                  prefexIcon: Icons.watch_later_outlined,
                                  onTap: () {
                                    print("yousef ");
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  validat: (s) {
                                    if (s.isEmpty)
                                      return "pleas Enter your time";
                                  },
                                  controler: timeController,
                                  keyboardType: TextInputType.datetime,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                defaultFormField(
                                  labelText: "Task Date",
                                  prefexIcon: Icons.calendar_today,
                                  onTap: () {
                                    print("ontp  22222222222");
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse("2022-12-29"))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                      print(DateFormat.yMMMd().format(value));
                                    });
                                  },
                                  validat: (s) {
                                    if (s.isEmpty) return "pleas Enter Date";
                                  },
                                  controler: dateController,
                                  keyboardType: TextInputType.datetime,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                    cubit.changBottomSheetState(isBotomSheetShown: false);
                  });
                  cubit.changBottomSheetState(isBotomSheetShown: true);
                } else {
                  if (form_Key.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);
                    timeController.clear();
                    titleController.clear();
                    dateController.clear();

                 //   Navigator.pop(context);
                    cubit.isBottomSheetShown = false;
                    // setState(() {});
                  }
                }
                // insertToDatabase();
              },
              child: Icon(
                cubit.isBottomSheetShown ? Icons.add : Icons.edit,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(

              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.current_Index,
              onTap: (index) {
                cubit.changIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: "Archive",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
