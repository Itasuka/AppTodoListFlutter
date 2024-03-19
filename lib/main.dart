import 'package:flutter/material.dart';
import 'package:projet_todo_list/createTodo.dart';
import 'package:projet_todo_list/widgetTodoList.dart';
import './colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              onPressed: () {
                print("coucoucoufeur");
              }, //TODO ON CLICK
              tooltip: "Paramètres",
              icon: const Icon(Icons.settings, color: textColor),
            ),
          ]),
        ),
        body: WidgetTodoList(),
      ),
    );
  }
}
