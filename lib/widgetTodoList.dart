import 'package:flutter/material.dart';
import 'package:projet_todo_list/widgetCreateToDo.dart';
import 'package:projet_todo_list/todoList.dart';
import 'package:projet_todo_list/widgetTodo.dart';

class WidgetTodoList extends StatefulWidget {
  WidgetTodoList({Key? key}) : super(key: key);
  List<WidgetTodo> _widgetTodoList = List.empty(growable: true);
  final TodoList todoList = TodoList();

  @override
  State<WidgetTodoList> createState() => _WidgetTodoListState();
}

class _WidgetTodoListState extends State<WidgetTodoList> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView.builder(
          itemCount: widget._widgetTodoList.length,
          itemBuilder: (_, i) => widget._widgetTodoList[i],
        ),
      ),
      WidgetCreateToDo(refresh: affichage)
    ]);
  }

  void affichage() {
    setState(() {
      widget._widgetTodoList = TodoList().afficherList();
    });
  }
}
