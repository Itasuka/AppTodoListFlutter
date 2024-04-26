import 'package:flutter/material.dart';
import 'package:projet_todo_list/colors.dart';
import 'package:projet_todo_list/todo.dart';
import 'package:projet_todo_list/todoList.dart';

class WidgetTodo extends StatefulWidget {
  const WidgetTodo({Key? key, required this.todo, required this.refresh})
      : super(key: key);
  final Todo todo;
  final Function() refresh;

  @override
  State<WidgetTodo> createState() => _WidgetToDoState();
}

class _WidgetToDoState extends State<WidgetTodo> {
  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        child:ClipRRect(
        child: Dismissible(
            direction: DismissDirection.horizontal,
            key: UniqueKey(),
            resizeDuration: null,
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                TodoList().remove(widget.todo);
                widget.refresh();
              }
              if (direction == DismissDirection.startToEnd) {
                setState(() {
                  widget.todo.changeIsImportant();
                });
              }
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                bool dismiss = false;
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Voulez-vous vraiment supprimer cette tache?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                dismiss = true;
                                Navigator.pop(context);
                              },
                              child: const Text("Oui")),
                          TextButton(
                              onPressed: () {
                                dismiss = false;
                                Navigator.pop(context);
                              },
                              child: const Text("Non")),
                        ],
                      );
                    });
                return dismiss;
              } else{
                return true;
              }
            },
            background: const ColoredBox(
              color: starButton,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.star, color: iconOnColor),
                ),
              ),
            ),
            secondaryBackground: const ColoredBox(
              color: deleteButton,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.delete, color: iconOnColor),
                ),
              ),
            ),
          child:Container(
            color: backgroundColor,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              leading: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.todo
                            .changeIsDone();
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
                  TodoList().remove(widget.todo);
                  widget.refresh();
                },
                icon: const Icon(
                  Icons.delete,
                  color: deleteButton,
                )
              ),
            ),
          )
        )
      )
    );
  }
}
