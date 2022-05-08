import 'package:sqflite/sqflite.dart';
import 'package:untitled/models/note.dart';

import 'constants.dart';

class DBHelper {
  DBHelper._instance();
  static final DBHelper dbHelper = DBHelper._instance();

  Future<String> getDbPath() async {
    String Path = await getDatabasesPath();
    String dbPath = Path + '/' + DB_NAME;
    return dbPath;
  }

  Future<Database> getDBInstance() async {
    String path = await getDbPath();
    return openDatabase(path, version: DB_VERSION, onCreate: (db, version) {
      createTable(db);
    });
  }

  void createTable(Database db) {
    String sql =
        'create table $TABLE_NAME ($COL_ID integer primary key autoincrement,$COL_Text text,$COL_Date date )';
    db.execute(sql);
  }

  Future<int> saveNote(Note note) async {
    Database db = await getDBInstance();
    return db.insert(TABLE_NAME, note.toMap());
  }

  Future<List<Note>> geNotes() async {
    Database db = await getDBInstance();
    List<Map<String, dynamic>> notes = await db.query(TABLE_NAME);
    List<Note> noteObjs = notes.map((e) => Note.fromMap(e)).toList();
    return noteObjs;
  }

  Future<int> deleteNote(int? noteId) async {
    Database db = await getDBInstance();
    return db.delete(TABLE_NAME, where: '$COL_ID=?', whereArgs: [noteId]);
  }

  Future<int> updateNote(Note note) async {
    Database db = await getDBInstance();
    return db.update(TABLE_NAME, note.toMap(),
        where: '$COL_ID=?', whereArgs: [note.noteId]);
  }
}
