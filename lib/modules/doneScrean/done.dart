
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jooo/shared/components/components.dart';
import 'package:jooo/shared/cubit/cubit.dart';
import 'package:jooo/shared/cubit/states.dart';

class Done extends StatelessWidget {
  // const Tasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStetes>(
      listener: (context, stats) {},
      builder: (context, stats) {
        var tasks = AppCubit.get(context).doneTasks;

        return ConditionalBuilder(
            condition: tasks.length > 0,
            builder: (context)=> ListView.separated(
                itemBuilder: (context, index) =>
                    buildTaskItem(tasks[index], context),
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
                itemCount: tasks.length),
            fallback: (context)=>Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.menu,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  Text(
                    "No Done Tasks Yet",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                ],
              ),
            )
        );
      },
    );
  }
}
