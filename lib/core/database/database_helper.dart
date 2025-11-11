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

    // 1. Create jobs table
    await db.execute('''
    CREATE TABLE jobs (
      id $idType,
      title $textType,
      day $textType,
      date $textType,
      startTime $textType,
      endTime $textType,
      description $textType,
      location $textType,
      salary $textType,
      requirements $textType,
      status $textType,
      appliedBy $intType,
      isPending $intType,
      createdAt $intType
    )
  ''');

    // 2. Create users table
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

    // 3. Insert initial users and jobs
    await _insertInitialUsers(db);
    await _insertInitialJobs(db);
  }

  Future<void> _insertInitialUsers(Database db) async {
    // Insert initial users if needed
    final users = [
      {
        "id": 1,
        "phone": "0599123456",
        "firstName": "Israa",
        "fatherName": "Ahmed",
        "grandFatherName": "Mohammed",
        "familyName": "El-halaby",
        "birthDate": "1995-05-10",
        "accountName": "Israa Account",
        "departmentName": "IT",
        "accountNumber": "1234567890",

        "acceptAlcohol": 0,
        "governorate": "Gaza",
        "district": "Rafah",
        "location": "Street 12",

        "nationalId": "987654321",
        "gender": "Female",
        "nationality": "Palestinian",
        "maritalStatus": "Single",
        "countryCode": "+970",
        "personalImage": "https://example.com/personal.jpg",
        "frontIdImage": "https://example.com/front_id.jpg",
        "backIdImage": "https://example.com/back_id.jpg",
        "password": "123456",
        "token": "some_token_string",
        "createdAt": 1699372800,
      },
    ];
    for (var user in users) {
      await db.insert('users', user);
    }
  }

  Future<void> _insertInitialJobs(Database db) async {
    final jobs = [
      {
        'title': 'مقدم طعام',
        'day': 'الأحد',
        'date': '2025-11-09',
        'startTime': '14:00',
        'endTime': '20:00',
        'description':
            'تقديم الطعام في مطعم XYZ، يشمل ترتيب الطاولات، خدمة الزبائن، وتجهيز المشروبات.',
        'location': 'شارع الملك فيصل، عمان',
        'salary': '50 دينار/اليوم',
        'requirements': '["خبرة سنتين في المطاعم", "معرفة بالسلامة الغذائية"]',
        'status': 'new',
        'isPending': 0,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'title': 'مساعد نظافة',
        'day': 'الإثنين',
        'date': '2025-11-10',
        'startTime': '08:00',
        'endTime': '16:00',
        'description':
            'تنظيف وترتيب الصالة والمرافق، مساعدة الفريق في المهام اليومية.',
        'location': 'مبنى الشركة الرئيسي، عمان',
        'salary': '40 دينار/اليوم',
        'requirements': '["لياقة بدنية جيدة", "القدرة على العمل ضمن فريق"]',
        'status': 'new',
        'isPending': 0,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'title': 'مشرف مبيعات',
        'day': 'الثلاثاء',
        'date': '2025-11-11',
        'startTime': '09:00',
        'endTime': '17:00',
        'description':
            'الإشراف على فريق المبيعات، متابعة الأهداف اليومية وتحليل الأداء.',
        'location': 'فرع المدينة، عمان',
        'salary': '70 دينار/اليوم',
        'requirements': '["خبرة سنة في المبيعات", "مهارات قيادية ممتازة"]',
        'status': 'new',
        'isPending': 0,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'title': 'مضيف/ة استقبال',
        'day': 'الأربعاء',
        'date': '2025-11-12',
        'startTime': '10:00',
        'endTime': '18:00',
        'description':
            'استقبال الزوار والعملاء، الرد على الاستفسارات وتقديم الدعم اللوجستي.',
        'location': 'مبنى الفنادق، عمان',
        'salary': '55 دينار/اليوم',
        'requirements':
            '["مهارات تواصل ممتازة", "القدرة على التعامل مع الضغط"]',
        'status': 'new',
        'isPending': 0,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'title': 'عامل توصيل',
        'day': 'الخميس',
        'date': '2025-11-13',
        'startTime': '07:00',
        'endTime': '15:00',
        'description':
            'توصيل الطلبات للعملاء ضمن المدينة، مع الحفاظ على الوقت والجودة.',
        'location': 'مركز المدينة، عمان',
        'salary': '45 دينار/اليوم',
        'requirements': '["رخصة قيادة سارية", "معرفة بالطرق المحلية"]',
        'status': 'new',
        'isPending': 0,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
    ];

    for (var job in jobs) {
      await db.insert('jobs', job);
    }
  }

  Future<Map<String, dynamic>?> getJob(int id) async {
    final db = await database;
    final results = await db.query('jobs', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllJobs2({
    String? status,
    int? appliedBy,
  }) async {
    final db = await database;

    String where = '';
    List<dynamic> whereArgs = [];

    if (status != null) {
      where += 'status = ?';
      whereArgs.add(status);
    }

    if (appliedBy != null) {
      if (where.isNotEmpty) where += ' AND ';
      where += 'appliedBy = ?';
      whereArgs.add(appliedBy);
    }

    if (where.isNotEmpty) {
      return await db.query('jobs', where: where, whereArgs: whereArgs);
    }

    return await db.query('jobs');
  }

  Future<List<Map<String, dynamic>>> getAllJobs({String? status}) async {
    final db = await database;
    if (status != null) {
      return await db.query('jobs', where: 'status = ?', whereArgs: [status]);
    }
    return await db.query('jobs');
  }

  Future<int> updateJob(int id, Map<String, dynamic> job) async {
    final db = await database;
    return await db.update('jobs', job, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteJob(int id) async {
    final db = await database;
    return await db.delete('jobs', where: 'id = ?', whereArgs: [id]);
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

  Future<List<Map<String, dynamic>>> getAllUsersById(int id) async {
    final db = await database;
    return await db.query('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getUserCount() async {
    final db = await database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM users'),
    );
    return result ?? 0;
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;

    // If updating images, verify they exist and convert to proper format if needed
    if (user.containsKey('frontIdImage')) {
      if (user['frontIdImage'] != null && user['frontIdImage'].isNotEmpty) {
        print('📸 Updating front ID image for user $id');
      }
    }
    if (user.containsKey('backIdImage')) {
      if (user['backIdImage'] != null && user['backIdImage'].isNotEmpty) {
        print('📸 Updating back ID image for user $id');
      }
    }
    if (user.containsKey('personalImage')) {
      if (user['personalImage'] != null && user['personalImage'].isNotEmpty) {
        print('📸 Updating personal image for user $id');
      }
    }

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
