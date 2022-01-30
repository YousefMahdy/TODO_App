import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:jooo/layout/homeLayout.dart';
import 'package:jooo/shared/bloc_Observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
