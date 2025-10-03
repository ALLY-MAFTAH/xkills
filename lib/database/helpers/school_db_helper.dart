// import 'package:sqflite/sqflite.dart';
// import '../../models/school.dart';
// import 'db_helper.dart';

// class SchoolDbHelper {
//   static final SchoolDbHelper _instance = SchoolDbHelper._internal();
//   factory SchoolDbHelper() => _instance;

//   SchoolDbHelper._internal();

//   Future<int> insertSchool(School school) async {
//     Database db = await DatabaseHelper().database;
//     return await db.insert(
//       'schools',
//       school.toJson(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<List<School>> getSchools() async {
//     Database db = await DatabaseHelper().database;
//     List<Map<String, dynamic>> results = await db.query('schools');
//     return results.map((map) => School.fromJson(map)).toList();
//   }

//   Future<School?> getSchoolById(int id) async {
//     Database db = await DatabaseHelper().database;
//     List<Map<String, dynamic>> results =
//         await db.query('schools', where: 'id = ?', whereArgs: [id]);
//     if (results.isNotEmpty) {
//       return School.fromJson(results.first);
//     }
//     return null;
//   }

//   Future<int> updateSchool(int id, School school) async {
//     Database db = await DatabaseHelper().database;
//     return await db
//         .update('schools', school.toJson(), where: 'id = ?', whereArgs: [id]);
//   }

//   Future<int> deleteSchool(int id) async {
//     Database db = await DatabaseHelper().database;
//     return await db.delete('schools', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> deleteAllSchools() async {
//     await DatabaseHelper().deleteAllData('schools');
//   }
// }
