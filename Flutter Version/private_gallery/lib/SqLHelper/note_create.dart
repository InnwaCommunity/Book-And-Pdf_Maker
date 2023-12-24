import 'package:private_gallery/config/constant.dart';
import 'package:private_gallery/models/note_data_model.dart';
import 'package:private_gallery/models/subject_data_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  


  

  // Singleton pattern for the database helper
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();



  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'notes_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async{
        await db.execute('''
          CREATE TABLE ${Constants.noteTable} (
            ${Constants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Constants.subjectId} INTEGER,
            ${Constants.columnTitle} TEXT,
            ${Constants.columnNotes} TEXT,
            ${Constants.columnCreateDate} TEXT,
            ${Constants.columnAlarmTime} TEXT
          )
        ''');


        await db.execute('''
          CREATE TABLE ${Constants.subjectTable} (
            ${Constants.subjectId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Constants.subjectName} TEXT,
            ${Constants.subjectCreatedate} TEXT,
            ${Constants.pdfFile} TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE ${Constants.photoTable} (
            ${Constants.photoid} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Constants.photoName} TEXT,
            ${Constants.photoPath} TEXT,
            ${Constants.photoCreateDate} TEXT,
            ${Constants.photoSize} INTEGER
          )
        ''');
      },
    );
  }

  // Insert a note into the database
  Future<int> insertNotes(Note note) async {
    final db = await instance.database;
    return await db.insert(Constants.noteTable, note.toMap());
  }

  // Retrieve all notes from the database
  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(Constants.noteTable);
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Get a note by ID
  Future<Note?> getNoteById(int id) async {
    final db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      Constants.noteTable,
      where: '${Constants.columnId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Note>> getAllNotesBySubjectId(int subid) async{
    final db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      Constants.noteTable,
      where: '${Constants.subjectId} = ?',
      whereArgs: [subid],
      orderBy: '${Constants.columnCreateDate} ASC',///DESC
    );
     return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Update a note
  Future<int> updateNotes(Note note , int id) async {
    final db = await instance.database;
    return await db.update(
      Constants.noteTable,
      note.toMap(),
      where: '${Constants.columnId} = ?',
      whereArgs: [id],
    );
  }

  // Delete a notes by subject ID
  Future<int> deleteNotesWithSubjectId(int id) async {
    final db = await instance.database;
    return await db.delete(
      Constants.noteTable,
      where: '${Constants.subjectId} = ?',
      whereArgs: [id],
    );
  }

  Future<String> deleteNotes(int subId,String createDate) async{
    try {
      final db = await instance.database;
    await db.delete(
        Constants.noteTable,
        where: '${Constants.subjectId} = ? AND ${Constants.columnCreateDate} = ?',
        whereArgs: [subId, createDate],
      );
      return '200';
    }on Exception catch (e) {
      return e.toString();
    }
  }

   // Search notes by title and create date
  Future<List<Note>> searchNotes(int subjectId, String createDate) async {
    final db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      Constants.noteTable,
      // where: '${Constants.subjectId} LIKE ? AND ${Constants.columnCreateDate} = ?',
      where: '${Constants.subjectId} = ? AND ${Constants.columnCreateDate} = ?',
      whereArgs: [subjectId, createDate],
    );
    // if (maps.isNotEmpty) {
    //   return Note.fromMap(maps[0]);
    // } else {
    //   return null;
    // }
    
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }



  
  // Insert a note into the database
  Future<int> insertSubjects(Subject sub) async {
    final db = await instance.database;
    return await db.insert(Constants.subjectTable, sub.toMap());
  }

  // Future<String> updateSubjects(Subject sub) async{
  //   try {
  //     final db = await instance.database;
  //     await db.update(
  //     Constants.subjectTable,
  //     {
  //       Constants.subjectName: sub.subjectName,
  //       Constants.subjectCreatedate: sub.createDate,
  //       Constants.pdfFile: sub.pdfFile,
  //     },
  //     where: '${Constants.subjectId} = ?',
  //     whereArgs: [sub.id],
  //   );
  //   return 'success';
  //   }on Exception catch (e) {
  //     return e.toString();
  //   }
  // }

  // Retrieve all notes from the database
  Future<List<Subject>> getAllSubjects() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(Constants.subjectTable);
    return List.generate(maps.length, (i) {
      return Subject.fromMap(maps[i]);
    });
  }


  // Update a note
  Future<int> updateSubjects(Subject sub , int id) async {
    final db = await instance.database;
    return await db.update(
      Constants.subjectTable,
      sub.toMap(),
      where: '${Constants.subjectId} = ?',
      whereArgs: [id],
    );
  }

  // Delete a note by ID
  Future<int> deleteSubjects(int id) async {
    final db = await instance.database;
    return await db.delete(
      Constants.subjectTable,
      where: '${Constants.subjectId} = ?',
      whereArgs: [id],
    );
  }
}

