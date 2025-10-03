// import 'package:sqflite/sqflite.dart';
// import '../../models/region.dart';
// import 'db_helper.dart';

// class RegionDbHelper {
//   static final RegionDbHelper _instance = RegionDbHelper._internal();
//   factory RegionDbHelper() => _instance;

//   RegionDbHelper._internal();

//   Future<int> insertRegion(Region region) async {
//     Database db = await DatabaseHelper().database;
//     return await db.insert(
//       'regions',
//       region.toJson(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<List<Region>> getRegions() async {
//     Database db = await DatabaseHelper().database;
//     List<Map<String, dynamic>> results = await db.query('regions');
//     return results.map((map) => Region.fromJson(map)).toList();
//   }

//   Future<Region?> getRegionById(int id) async {
//     Database db = await DatabaseHelper().database;
//     List<Map<String, dynamic>> results =
//         await db.query('regions', where: 'id = ?', whereArgs: [id]);
//     if (results.isNotEmpty) {
//       return Region.fromJson(results.first);
//     }
//     return null;
//   }

//   Future<int> updateRegion(int id, Region region) async {
//     Database db = await DatabaseHelper().database;
//     return await db
//         .update('regions', region.toJson(), where: 'id = ?', whereArgs: [id]);
//   }

//   Future<int> deleteRegion(int id) async {
//     Database db = await DatabaseHelper().database;
//     return await db.delete('regions', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> deleteAllRegions() async {
//     await DatabaseHelper().deleteAllData('regions');
//   }
// }
