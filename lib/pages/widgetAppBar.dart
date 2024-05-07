import 'package:flutter/material.dart';
import 'package:projet_todo_list/models/todoList.dart';

import '../models/colors.dart';

class WidgetAppBar extends StatelessWidget implements PreferredSizeWidget{
  WidgetAppBar({Key? key, required this.refresh}) : super(key: key);
  final TodoList todoList = TodoList();
  final Function() refresh;

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
                children: <Widget>[
                  Text("Trier par: ", style: TextStyle(color: AppColor().textColor())),
                  RadioListTile(
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    TodoList().setOrder();
                    AppColor().setTheme(theme);
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


