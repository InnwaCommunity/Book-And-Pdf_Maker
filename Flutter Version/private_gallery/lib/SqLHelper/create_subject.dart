// import 'package:private_gallery/config/constant.dart';
// import 'package:private_gallery/models/subject_data_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class SubjectDatabase{
//   static Database? _database;
//   // Singleton pattern for the database helper
//   SubjectDatabase._privateConstructor();
//   static final SubjectDatabase instance = SubjectDatabase._privateConstructor();



//   // Getter for the database
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   // Initialize the database
//   Future<Database> _initDatabase() async {
//     final path = join(await getDatabasesPath(), 'notes_database.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute('''
//           CREATE TABLE ${Constants.subjectTable} (
//             ${Constants.subjectId} INTEGER PRIMARY KEY AUTOINCREMENT,
//             ${Constants.subjectName} TEXT,
//             ${Constants.subjectCreatedate} TEXT
//           )
//         ''');
//       },
//     );
//   }

//   // Insert a note into the database
//   Future<int> insertSubjects(Subject sub) async {
//     final db = await instance.database;
//     return await db.insert(Constants.subjectTable, sub.toMap());
//   }

//   // Retrieve all notes from the database
//   Future<List<Subject>> getAllSubjects() async {
//     final db = await instance.database;
//     final List<Map<String, dynamic>> maps = await db.query(Constants.subjectTable);
//     return List.generate(maps.length, (i) {
//       return Subject.fromMap(maps[i]);
//     });
//   }


//   // Update a note
//   Future<int> updateSubjects(Subject sub , int id) async {
//     final db = await instance.database;
//     return await db.update(
//       Constants.subjectTable,
//       sub.toMap(),
//       where: '${Constants.columnId} = ?',
//       whereArgs: [id],
//     );
//   }

//   // Delete a note by ID
//   Future<int> deleteSubjects(int id) async {
//     final db = await instance.database;
//     return await db.delete(
//       Constants.subjectTable,
//       where: '${Constants.subjectId} = ?',
//       whereArgs: [id],
//     );
//   }
// }