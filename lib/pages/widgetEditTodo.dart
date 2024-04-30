import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../colors.dart';
import '../models/todo.dart';

class WidgetEditTodo extends StatefulWidget {
  final Todo todo;
  final Function refresh;

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
    _title = TextEditingController(text: widget.todo.getTitle());
    _description = TextEditingController(text: widget.todo.getDescription());
    _city = TextEditingController(text: widget.todo.getCity());
    _date = widget.todo.getDateTime();
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
                        labelText: 'Titre',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir un titre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _description,
                      maxLines: null,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _city,
                      decoration: const InputDecoration(labelText: 'Ville'),
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
                          if (_formKey.currentState!.validate()) { // Vérifier la validation du formulaire
                            widget.todo.setTitle(_title.text);
                            widget.todo.setDescription(_description.text);
                            widget.todo.setCity(_city.text);
                            widget.todo.setDate(_date);
                            widget.refresh();
                            Navigator.pop(context);
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
