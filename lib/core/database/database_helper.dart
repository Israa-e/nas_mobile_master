import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('nas_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const intType = 'INTEGER';
    const boolType = 'INTEGER'; // SQLite doesn't have real BOOLEAN type

    await db.execute('''
      CREATE TABLE users (
        id $idType,
        phone $textType,
        firstName $textType,
        fatherName $textType,
        grandFatherName $textType,
        familyName $textType,
        birthDate $textType,
        accountName $textType,
        departmentName $textType,
        accountNumber $textType,
        workHours $textType,
        favouriteDays $textType,
        favouriteTimes $textType,
        selectedTasks $textType,
        acceptAlcohol $boolType,
        governorate $textType,
        district $textType,
        location $textType,
        nationalId $textType,
        nationality $textType,
        gender $textType,
        maritalStatus $textType,
        countryCode $textType,
        personalImage $textType,
        frontIdImage $textType,
        backIdImage $textType,
        password $textType,
        firstContact $textType,
        secondContact $textType,
        acceptedTerms $textType,
        token $textType,
        createdAt $intType
      )
    ''');
  }

  // User CRUD operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String phone) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update('users', user, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
