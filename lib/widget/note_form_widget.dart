import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final int? number;
  final String? title;
  final String? description;
  final String date;
  //final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    super.key,
    this.number = 0,
    this.title = '',
    this.description = '',
    //required this.onChangedNumber,
    required this.date,
    required this.onChangedTitle,
    required this.onChangedDescription,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          //padding: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              const SizedBox(height: 1),
              Text(
                date.toLowerCase(),
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 10),
              Divider(
                color: Colors.grey[300],
              ),
              buildDescription(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 21,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Título',
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'O título não pode estar vazio'
            : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 10,
        initialValue: description,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Nota',
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'A descrição não pode estar vazia'
            : null,
        onChanged: onChangedDescription,
      );
}
