import 'package:flutter/material.dart';
import 'package:projet_todo_list/models/todoList.dart';

import '../models/colors.dart';

//Affichage de la barre supérieur de l'application
class WidgetAppBar extends StatelessWidget implements PreferredSizeWidget{
  WidgetAppBar({super.key, required this.refresh});
  final TodoList todoList = TodoList();
  final Function() refresh;

  //taille en hauteur de l'appbar
  @override
  Size get preferredSize => const Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor().buttonColor(),
      title: Text(
        'My todo',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: AppColor().insideButtonColor()),
      ),
      actions: [
        IconButton(
          onPressed: () {
            parameterPopUp(context);
          },
          tooltip: "Paramètres",
          icon: Icon(Icons.settings, color: AppColor().insideButtonColor()),
        ),
      ],
    );
  }

  ///Définition de la popup de parametrage de l'application
  Future parameterPopUp(BuildContext context) async{
    bool sortByFavorites = todoList.getFavorites();
    bool theme = AppColor().getTheme();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColor().background(),
              title: Text("Options", style: TextStyle(color: AppColor().textColor()),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                //Ajout du corp de la popup
                children: <Widget>[
                  Text("Trier par: ", style: TextStyle(color: AppColor().textColor())),
                  RadioListTile(
                    activeColor: AppColor().buttonColor(),
                    title: Text("Favoris", style: TextStyle(color: AppColor().textColor()),),
                    value: true,
                    groupValue: sortByFavorites,
                    onChanged: (value) {
                      setState(() {
                        sortByFavorites = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    activeColor: AppColor().buttonColor(),
                    title: Text("Date", style: TextStyle(color: AppColor().textColor()),),
                    value: true,
                    groupValue: !sortByFavorites,
                    onChanged: (value) {
                      setState(() {
                        sortByFavorites = !value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text("Theme: ", style: TextStyle(color: AppColor().textColor())),
                  Switch(
                    activeColor: AppColor().buttonColor(),
                    value: theme,
                    onChanged: (value) {
                      setState((){
                        theme = value;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor().buttonColor(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Annuler', style: TextStyle(color: AppColor().insideButtonColor())),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor().buttonColor(),
                  ),
                  onPressed: () {
                    //Change le booléen de TodoList pour le trie s'il est changé dans les options
                    TodoList().setOrder();
                    //Change le booléen de AppColor si l'utilisateur veut changer le théme
                    AppColor().setTheme(theme);
                    //Rafraichi l'affichage du widgetTodoList
                    refresh();
                    //Ferme la popup
                    Navigator.of(context).pop();
                  },
                  child: Text('Valider', style: TextStyle(color: AppColor().insideButtonColor())),
                ),
              ],
            );
          }
        );
      },
    );
  }
}


