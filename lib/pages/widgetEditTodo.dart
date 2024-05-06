import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:projet_todo_list/models/todoList.dart';

import '../models/colors.dart';
import '../models/todo.dart';

class WidgetEditTodo extends StatefulWidget {
  final Todo todo;
  final Function() refresh;

  const WidgetEditTodo({Key? key, required this.todo, required this.refresh}) : super(key: key);

  @override
  _WidgetEditTodoState createState() => _WidgetEditTodoState();
}

class _WidgetEditTodoState extends State<WidgetEditTodo> {
  final _formKey = GlobalKey<FormState>(); // Clé unique pour le formulaire

  late TextEditingController _title;
  late TextEditingController _description;
  late TextEditingController _city;
  late DateTime? _date;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.todo.title);
    _description = TextEditingController(text: widget.todo.description);
    _city = TextEditingController(text: widget.todo.city);
    _date = widget.todo.date;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Editez votre todo'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                key: _formKey, // Clé unique du formulaire
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _title,
                      decoration: const InputDecoration(
                        labelText: 'Titre (50 caractères max)',
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir un titre';
                        }
                        return null;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _description,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Description (500 caractères max)',
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(500),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _city,
                      decoration: const InputDecoration(
                        labelText: 'Ville',
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: _date ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                setState(() {
                                  _date = selectedDate;
                                });
                              }
                            });
                          },
                          child: Text(
                            _date != null ? DateFormat('dd/MM/yyyy').format(_date!) : 'Sélectionner une date',
                            style: const TextStyle(color: textColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: buttonColor, backgroundColor: insideButtonColor,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            TodoList().update(
                                widget.todo,
                                _title.text,
                                _description.text,
                                _city.text,
                                _date,
                                widget.refresh);
                            Navigator.pop(context);
                            widget.refresh;
                          }
                        },
                        child: const Text('Valider'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
