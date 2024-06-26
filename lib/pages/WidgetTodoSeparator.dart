import 'package:flutter/material.dart';
import 'package:projet_todo_list/models/colors.dart';
import 'package:projet_todo_list/models/todoList.dart';

///Permet de mettre se widget dans la liste de tâche pour séparer les faites des non finis
class WidgetTodoSeparator extends StatelessWidget {
  const WidgetTodoSeparator({super.key, required this.refresh});
  final Function() refresh;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TodoList().setDisplayIsDone();
        refresh();
      },
      child: Container(
        height: 30,
        color: AppColor().separatorDone(),
        child: Center(
          child: Icon(
            TodoList().getDisplayIsDone() ? Icons.arrow_drop_down : Icons.arrow_drop_up,
            color: AppColor().textColor(),
          ),
        ),
      ),
    );
  }
}