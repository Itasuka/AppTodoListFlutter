import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projet_todo_list/colors.dart';

class createToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return (Row(
            children: [
            Expanded(
              child: Container(
               alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(
                left: 20,
                bottom: 20,
              ),
              child: const Flexible (
                child: TextField(
                      decoration: InputDecoration(
                        hintText: "Titre de la tâche"
                        //border: InputBorder.none
                      )
                    )
              )
            ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.only(
                bottom: 20,
                right: 20,
              ),
              child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      minimumSize:  const Size(60, 60),
                      elevation: 10,
                  ),
                    child: const Text('+', style: TextStyle(color: insideButtonColor, fontSize: 40),),
                  ),
              ),
        
        ]
        ));
  }
}