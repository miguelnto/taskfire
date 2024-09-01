import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/notes_database.dart';
import '../model/note.dart';
import '../widget/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    super.key,
    this.note,
  });

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late String date;

  @override
  void initState() {
    super.initState();

    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    date =
        DateFormat.yMMMd().format(widget.note?.createdTime ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black,
          elevation: 2,
          actions: [deleteButton(), buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            title: title,
            description: description,
            date: date,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget deleteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0.1),
      child: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          if (widget.note != null) {
            await NotesDatabase.delete(widget.note?.id ?? 0);

	    if (mounted) {
                Navigator.of(context).pop();
	    }
          }
        },
      ),
    );
  }

  Widget buildButton() {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: IconButton(icon: const Icon(Icons.save), onPressed: addOrUpdateNote
          ),
      
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      if (mounted) {
          Navigator.of(context).pop();
      }
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      //number: number,
      title: title,
      description: description,
    );

    await NotesDatabase.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      //number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.create(note);
  }
}
