import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../model/note.dart';

class NotesDatabase {
  static Future<sql.Database> db() async {
    final path = join(await sql.getDatabasesPath(), "dbtodos.db");
    return await sql.openDatabase(
      path,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
      //singleInstance: true,
    );
  }

  static Future<void> createTables(sql.Database database) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await database.execute('''
CREATE TABLE $tableNotes ( 
  ${NoteFields.id} $idType, 
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.time} $textType
  )
''');
  }

  static Future<Note> create(Note note) async {
    final db = await NotesDatabase.db();

    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  static Future<Note> readNote(int id) async {
    final db = await NotesDatabase.db();

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future<List<Note>> readAllNotes() async {
    final db = await NotesDatabase.db();

    const orderBy = '${NoteFields.time} ASC';

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  static Future<int> update(Note note) async {
    final db = await NotesDatabase.db();

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await NotesDatabase.db();

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  static Future close() async {
    final db = await NotesDatabase.db();
    db.close();
  }
}
