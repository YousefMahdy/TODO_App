import 'package:flutter/material.dart';
import 'package:jooo/shared/cubit/cubit.dart';

Widget defaultFormField({
  String? labelText,
  required TextEditingController controler,
  bool isObSecureText = false,
  required TextInputType keyboardType,
  IconData? prefexIcon,
  IconData? safexIcon,
  required Function validat,
  Function? prefex_pressed,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
}) {
  return TextFormField(
    controller: controler,
    obscureText: isObSecureText,
    keyboardType: keyboardType,
    onTap: () {
      onTap!();
    },
    onFieldSubmitted: (value) {
      //print(value);
      onSubmit!(value);
    },
    onChanged: (s) {
      onChange!(s);
    },
    validator: (s) {
      return validat(s);
    },
    decoration: InputDecoration(
// border: InputBorder.none,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        labelText: labelText,
// label: Text("gggggg")

        prefixIcon: IconButton(
          icon: Icon(prefexIcon),
          onPressed: () {}
          //print("prefex presssed");
          ,
        ),
        suffixIcon: Icon(safexIcon)),
  );
}

Widget buildTaskItem(Map row, context) => Dismissible(
      key: Key(row['id'].toString()),
      onDismissed: (directions) {

        AppCubit.get(context).deleteDatabase(id: row['id']);
      },
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text("${row["time"]}"),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' ${row["title"]}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${row["date"]}",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: "done", id: row['id']);
              },
              icon: Icon(
                Icons.check_box_outlined,
                color: row["status"] == "done" ? Colors.green : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: "archive", id: row['id']);
              },
              icon: Icon(
                row["status"] == "archive"
                    ? Icons.archive_sharp
                    : Icons.archive_outlined,
                color:
                    row["status"] == "archive" ? Colors.blueGrey : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
