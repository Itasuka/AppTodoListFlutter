import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projet_todo_list/models/colors.dart';
import 'package:projet_todo_list/pages/widgetTodoList.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';


Future main() async{
  //initialisation de la BDD pour le web
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  //initialisation de la BBD pour ce qui n'est pas android ou ios
  else if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WidgetTodoList(),
    );
  }
}
