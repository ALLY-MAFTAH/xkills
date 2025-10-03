// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// import '../../constants/auth_user.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;

//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     int? userId = await Auth().user!.id;

//     _database = await _initDatabase(userId!);
//     return _database!;
//   }

//   Future<Database> _initDatabase(int userId) async {
//     String path = join(await getDatabasesPath(), 'user_${userId}_NASI_DB.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//       onUpgrade: _onUpgrade,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
    
//     await _createShopsTable(db);
//   }

//   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  
//   Future<void> _createShopsTable(Database db) async {
//     await db.execute('''
//       CREATE TABLE shops (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT,
//         phoneNumber TEXT,
//         commonStreetId INTEGER,
//         commonStreetName TEXT,
//         wardId INTEGER,
//         wardName TEXT,
//         districtId INTEGER,
//         districtName TEXT,
//         regionId INTEGER,
//         regionName TEXT,
//         countryId INTEGER,
//         countryName TEXT,
//         superDealerId INTEGER,
//         superDealerName TEXT,
//         isActive INTEGER
//       )
//     ''');
//   }

 


//   Future<void> deleteAllData(String tableName) async {
//     Database db = await database;
//     await db.delete(tableName);
//   }

//   Future<void> deleteDatabaseFile() async {
//     int userId = Auth().user!.id!;
//     print("CAME HERE TO CLEAD DB");
//     print(userId);
//     String path = join(await getDatabasesPath(), 'user_${userId}_NASI_DB.db');

//     await deleteDatabase(path);
//   }

//   void startFreshDatabase() async {
//     print("1. :::::::::::::::::::: CAME HERE TO CLEAD DB");
//     await deleteDatabaseFile();
//     await database;
//   }

//   Future<void> closeDatabase() async {
//     if (_database != null) {
//       await _database!.close();
//       _database = null;
//     }
//   }
// }
