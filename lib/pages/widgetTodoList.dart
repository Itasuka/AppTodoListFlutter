import 'package:flutter/material.dart';
import 'package:projet_todo_list/pages/widgetAppBar.dart';
import 'package:projet_todo_list/pages/widgetCreateToDo.dart';
import 'package:projet_todo_list/models/todoList.dart';

class WidgetTodoList extends StatefulWidget {
  WidgetTodoList({Key? key}) : super(key: key);

  @override
  State<WidgetTodoList> createState() => _WidgetTodoListState();
}

class _WidgetTodoListState extends State<WidgetTodoList> {
  final TodoList todoList = TodoList();
  List<Widget> _widgetTodoList = [];

  @override
  void initState() {
    super.initState();
    todoList.initialisation(affichage);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    todoList.initialisation(affichage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppBar(refresh: affichage),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _widgetTodoList.length,
              itemBuilder: (_, i) => _widgetTodoList[i],
            ),
          ),
          WidgetCreateToDo(refresh: affichage)
        ],
      ),
    );
  }

  void affichage() {
    setState(() {
      _widgetTodoList = todoList.afficherList(affichage);
    });
  }
}

