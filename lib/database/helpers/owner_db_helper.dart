// import 'package:sqflite/sqflite.dart';
// import '../../models/owner.dart';
// import 'db_helper.dart';

// class OwnerDbHelper {
//   static final OwnerDbHelper _instance = OwnerDbHelper._internal();
//   factory OwnerDbHelper() => _instance;

//   OwnerDbHelper._internal();

//   Future<int> insertOwner(Owner owner) async {
//     Database db = await DatabaseHelper().database;
//     return await db.insert(
//       'owners',
//       owner.toJson(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<List<Owner>> getOwners() async {
//     Database db = await DatabaseHelper().database;
//     List<Map<String, dynamic>> results = await db.query('owners');
//     return results.map((map) => Owner.fromJson(map)).toList();
//   }

//   Future<Owner?> getOwnerById(int id) async {
//     Database db = await DatabaseHelper().database;
//     List<Map<String, dynamic>> results =
//         await db.query('owners', where: 'id = ?', whereArgs: [id]);
//     if (results.isNotEmpty) {
//       return Owner.fromJson(results.first);
//     }
//     return null;
//   }

//   Future<int> updateOwner(int id, Owner owner) async {
//     Database db = await DatabaseHelper().database;
//     return await db
//         .update('owners', owner.toJson(), where: 'id = ?', whereArgs: [id]);
//   }

//   Future<int> deleteOwner(int id) async {
//     Database db = await DatabaseHelper().database;
//     return await db.delete('owners', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> deleteAllOwners() async {
//     await DatabaseHelper().deleteAllData('owners');
//   }
// }
