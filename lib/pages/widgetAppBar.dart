import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projet_todo_list/models/todoList.dart';

import '../colors.dart';

class WidgetAppBar extends StatelessWidget implements PreferredSizeWidget{
  WidgetAppBar({Key? key, required this.refresh}) : super(key: key);
  final TodoList todoList = TodoList();
  final Function() refresh;

  @override
  Size get preferredSize => const Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: buttonColor,
      title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        IconButton(
          onPressed: () {
            parameterPopUp(context);
          },
          tooltip: "Paramètres",
          icon: const Icon(Icons.settings, color: insideButtonColor),
        ),
      ]),
    );
  }

  Future parameterPopUp(BuildContext context) async{
    bool sortByCreationDate = todoList.getCreationDate();
    bool sortByFavorites = todoList.getFavorites();
    bool sortByInProgress = todoList.getInProgress();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Trier par:"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CheckboxListTile(
                    title: const Text("En cours"),
                    value: sortByInProgress,
                    onChanged: (value) {
                      setState(() {
                        sortByInProgress = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Favoris"),
                    value: sortByFavorites,
                    onChanged: (value) {
                      setState(() {
                        sortByFavorites = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Date de création"),
                    value: sortByCreationDate,
                    onChanged: (value) {
                      setState(() {
                        sortByCreationDate = value!;
                      });
                    },
                  ),
                  const Text("En cours a la prioritée sur les favoris."),
                  const Text("Les favoris ont la priorité sur la date."),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    TodoList().setOrder(sortByFavorites, sortByInProgress, sortByCreationDate);
                    refresh();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Valider'),
                ),
              ],
            );
          }
        );
      },
    );
  }
}


