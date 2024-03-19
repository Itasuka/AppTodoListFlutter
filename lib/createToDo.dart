import 'package:flutter/material.dart';
import 'package:projet_todo_list/colors.dart';
import 'package:projet_todo_list/todoList.dart';

class CreateToDo extends StatefulWidget {
  final Function() refresh;
  CreateToDo({Key? key, required this.refresh}) : super(key: key);

  @override
  State<CreateToDo> createState() => _CreateToDoState();
}

class _CreateToDoState extends State<CreateToDo> {
  final textController = TextEditingController();
  String titre = "";
  @override
  Widget build(BuildContext context) {
    return (Row(children: [
      Expanded(
        child: Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(
              left: 20,
              bottom: 20,
            ),
                child: TextField(
                    controller: textController,
                    decoration:
                        const InputDecoration(hintText: "Titre de la tâche"
                            //border: InputBorder.none
                            ))),
      ),
      Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.only(
          bottom: 20,
          right: 20,
        ),
        child: ElevatedButton(
          onPressed: () {
            creerTache();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            minimumSize: const Size(60, 60),
            elevation: 10,
          ),
          child: const Text(
            '+',
            style: TextStyle(color: insideButtonColor, fontSize: 40),
          ),
        ),
      ),
    ]));
  }

  void creerTache() {
    String titre = textController.text;
    if (titre.isNotEmpty) {
      TodoList().add(titre);
      widget.refresh();
    } else {
      print("Vous devez d'abord entrer un titre !"); //TODO FAIRE POPUP
    }
  }
}
