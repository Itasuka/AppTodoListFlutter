import 'package:flutter/material.dart';
import 'package:projet_todo_list/createToDo.dart';
import 'package:projet_todo_list/todo.dart';
import 'package:projet_todo_list/todoItem.dart';
import 'package:projet_todo_list/todoList.dart';
import './colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final List<ToDo> _todoList = ToDoList.getInstance().getList();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {print("coucoucoufeur");},        //TODO ON CLICK
                tooltip: "Paramètres",
                icon: const Icon(
                  Icons.settings,
                  color: textColor
                ),
              ),                
              
          ]),
        ),
        body: Stack(
          children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: ListView(
                children: [
                  for(ToDo todoo in _todoList)
                    ToDoItem(key: Key(todoo.getId().toString()), todo: todoo),
                ],
              ),
            ),
            createToDo().build(context)
          ]
      ),
      ),
    );
  }
}
