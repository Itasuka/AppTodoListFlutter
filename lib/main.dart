import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projet_todo_list/pages/widgetTodoList.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';


Future main() async{
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  else if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WidgetTodoList(),
    );
  }

}
