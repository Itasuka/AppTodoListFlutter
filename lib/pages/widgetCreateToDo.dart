import 'package:flutter/material.dart';
import 'package:projet_todo_list/models/colors.dart';
import 'package:projet_todo_list/models/todoList.dart';

///Gestion du champ de création de nouvelle tâche
class WidgetCreateToDo extends StatefulWidget {
  final Function() refresh;
  const WidgetCreateToDo({super.key, required this.refresh});

  @override
  State<WidgetCreateToDo> createState() => _WidgetCreateToDoState();
}

class _WidgetCreateToDoState extends State<WidgetCreateToDo> {
  final textController = TextEditingController();
  String titre = "";
  @override
  Widget build(BuildContext context) {
    return (Row(children: [
      //Champ de saisi pour le titre de la tâche
      Expanded(
        child: Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(
              left: 20,
              bottom: 20,
            ),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "Titre de la tâche",
                hintStyle: TextStyle(color: AppColor().textColor()),
              ),
              style: TextStyle(color: AppColor().textColor()),
            )
        ),
      ),
      //Bouton de validation de la tâche
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
            backgroundColor: AppColor().buttonColor(),
            minimumSize: const Size(60, 60),
            elevation: 10,
          ),
          child: Text(
            '+',
            style: TextStyle(color: AppColor().insideButtonColor(), fontSize: 40),
          ),
        ),
      ),
    ]));
  }

  ///Gere la création d'une nouvelle tâche
  void creerTache() {
    String titre = textController.text;
    //Réinitialisation du champ de saisi après ajout de la tache dans la liste
    if (titre.isNotEmpty) {
      TodoList().add(titre, widget.refresh);
      titre = "";
      setState(() {
        textController.clear();
      });
    }
    //Si le champ est vide et que l'utilisateur veut ajouter un tache alors on ouvre une popup d'erreur
    else {
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: AppColor().background(),
              child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attention',
                    style: TextStyle(
                      color: AppColor().textColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Vous devez d\'abord entrer un titre !',
                    style: TextStyle(fontSize: 16,
                      color: AppColor().textColor()),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor().buttonColor(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Ferme le dialog
                    },
                    child: Text('OK', style: TextStyle(color: AppColor().insideButtonColor())),
                  ),
                ],
              ),
            ));
          });
    }
  }
}
