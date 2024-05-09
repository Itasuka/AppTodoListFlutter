import 'package:flutter/material.dart';
import 'package:projet_todo_list/pages/widgetAppBar.dart';
import 'package:projet_todo_list/pages/widgetCreateToDo.dart';
import 'package:projet_todo_list/models/todoList.dart';

import '../models/colors.dart';

///Gestion de l'ensemble de l'affichage de l'application
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().background(),
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

  ///Fonction de rafraichissement de l'affichage de la liste de tâche utilisés par les fonctions fils
  void affichage() {
    setState(() {
      _widgetTodoList = todoList.afficherList(affichage);
    });
  }
}

