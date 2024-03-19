import 'package:flutter/material.dart';
import 'package:projet_todo_list/colors.dart';
import 'package:projet_todo_list/todo.dart';

class WidgetTodo extends StatefulWidget {
  const WidgetTodo({Key? key, required this.todo, required this.supprimer})
      : super(key: key);
  final Todo todo;
  final Function(Todo) supprimer;

  @override
  State<WidgetTodo> createState() => _WidgetToDoState();
}

class _WidgetToDoState extends State<WidgetTodo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        tileColor: backgroundColor,
        leading: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
              onPressed: () {
                setState(() {
                  widget.todo
                      .changeIsDone(); // Assurez-vous d'appeler la méthode sur l'objet todo de votre widget
                });
              },
              icon: Icon(
                widget.todo.getIsDone()
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: textColor,
              )),
          IconButton(
            onPressed: () {
              setState(() {
                widget.todo.changeIsImportant();
              });
            },
            icon: Icon(
              widget.todo.getIsImportant() ? Icons.star : Icons.star_outline,
              color: starButton,
            ),
          )
        ]),
        title: Text(
          overflow: TextOverflow.ellipsis,
          widget.todo.getMessage() ?? "",
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            decoration:
                widget.todo.getIsDone() ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
            onPressed: () {
              widget.supprimer(widget.todo);
            },
            icon: const Icon(
              Icons.delete,
              color: deleteButton,
            )),
      ),
    );
  }
}
