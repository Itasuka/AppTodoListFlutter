import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:projet_todo_list/colors.dart';
import 'package:projet_todo_list/models/todo.dart';
import 'package:projet_todo_list/models/todoList.dart';

import '../models/weather.dart';

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
      GestureDetector(
        onTap: () {todoDetail();},
        child:Container(
          decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: separator,
                  width: 1.0,
                )
              )
          ),
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
                  widget.refresh();
                });
              }
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                return askForDelete();
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
                          widget.todo.changeIsDone();
                          widget.refresh();
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
                        widget.refresh();
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
                  widget.todo.getTitle() ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    decoration:
                        widget.todo.getIsDone() ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    onPressed: () async {
                      if(await askForDelete()) {
                        TodoList().remove(widget.todo);
                        widget.refresh();
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: deleteButton,
                    )
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      //todo
                    },
                  ),
                ]),
              ),
            )
          )
        )
      );
  }

  Future<bool> askForDelete() async {
    bool dismiss = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Voulez-vous vraiment supprimer cette tâche?"),
          actions: [
            TextButton(
              onPressed: () {
                dismiss = true;
                Navigator.pop(context);
              },
              child: const Text("Oui"),
            ),
            TextButton(
              onPressed: () {
                dismiss = false;
                Navigator.pop(context);
              },
              child: const Text("Non"),
            ),
          ],
        );
      },
    );
    return dismiss;
  }

  String weatherAnimation(String? condition){
    if(condition == null) return 'assets/sunny.json';
    switch(condition.toLowerCase()){
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'clouds':
        return 'assets/clouds.json';
      case 'drizzle':
      case 'shower rain':
      case 'rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  Widget setWidgetDetail(Weather? _weather) {
    List<Widget> widgetsList = [];

    if (widget.todo.getDescription() != "") {
      widgetsList.add(
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Description: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              TextSpan(
                text: widget.todo.getDescription(),
                style: const TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      );
    }
    if (widget.todo.getDate() != ""){
      widgetsList.add(
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Date: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              TextSpan(
                text: widget.todo.getDate(),
                style: const TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      );
    }
    if(widget.todo.getCity() != ""){
      widgetsList.add(
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Ville: ',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              TextSpan(
                text: widget.todo.getCity(),
                style: const TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      );
    }
    if(_weather != null){
      widgetsList.add(
      Center(
        child:Column(
          children: <Widget>[
            Container(
              height: 80,
              width: 80,
              child: Lottie.asset(
                weatherAnimation(_weather?.condition),
              ),
            ),
            Text("Actuel: ${_weather?.temp ?? 0}°C",
              softWrap: true,
              style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            Text("Min: ${_weather?.minTemp ?? 0}°C | Max: ${_weather?.maxTemp ?? 0}°C",
              softWrap: true,
              style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
            )
          ]
          )
        ),
      );
    }

    if(widgetsList.isEmpty){
      return Container(
        child: const Text("Vous n'avez pas encore édité cette activité. \n"
            "Une fois cela fait, vous aurez toutes les informations renseignées qui apparaîtront ici."),
      );
    }
    else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgetsList,
      );
    }
  }

  Future todoDetail() async{
    Weather? _weather;
    try {
      final weather = await widget.todo.getWeather();
      setState(() {
        _weather = weather;
      });
    }
    catch(e){
      print(e);
    }
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Expanded(
                    child: Text(widget.todo.getTitle()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                    },
                  ),
                ],
              ),
              content: setWidgetDetail(_weather),
            );
          }
        );
      },
    );
  }
}
