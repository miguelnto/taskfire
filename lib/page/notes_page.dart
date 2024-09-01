import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../db/notes_database.dart';
import '../model/note.dart';
import '../page/edit_note_page.dart';
import '../widget/note_card_widget.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black,
          elevation: 2,
          title:
              Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.whatshot,
              color: Colors.blue[400],
              size: 25,
            ),
            Container(
		alignment: Alignment.center,
                //padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Taskfire',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            /* In the future, there'll be a search functionality
	      Icon(
              Icons.search,
              color: Colors.grey[600],
              size: 25,
            ),*/
          ]),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 3),
          child: isLoading
              ? Container(
		alignment: Alignment.center,
		child: const CircularProgressIndicator()
	      )
              : notes.isEmpty
                  ? 
		  Container(
		 alignment: Alignment.center,
		 child: Text(
                      'No Notes',
                      style:
                          TextStyle(color: Colors.grey.shade800, fontSize: 20, fontWeight:FontWeight.w500),
                    )
		 )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.blue[400],
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );
  Widget buildNotes() => StaggeredGrid.count(
      // itemCount: notes.length,
      // staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      //crossAxisCount: 2,
      crossAxisCount: 1,
      //mainAxisSpacing: 2,
      mainAxisSpacing: 1,
      //crossAxisSpacing: 2,
      crossAxisSpacing: 1,
      children: List.generate(
        notes.length,
        (index) {
          final note = notes[index];

          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddEditNotePage(note: note),
                ));

                refreshNotes();
              },
              child: NoteCardWidget(note: note),
            ),
          );
        },
      ));
}
