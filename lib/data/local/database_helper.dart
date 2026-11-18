import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'asansor_bakim.db');
    return await openDatabase(
      path,
      version: 2, // <-- ARTIK 2
      onCreate: _onCreate,
      // Gelişmiş migrasyon gerekiyorsa onUpgrade eklenebilir.
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE elevators (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        siteName TEXT,
        block TEXT,
        location TEXT,
        district TEXT,
        municipalitySerialNo TEXT,
        firmSerialNo TEXT,
        type TEXT,
        driveType TEXT,
        stopCount INTEGER,
        capacityKg REAL,
        capacityPerson INTEGER,
        monthlyFee REAL,
        authorizedName TEXT,
        authorizedPhone TEXT,
        installationYear TEXT,
        lastInspectionDate TEXT,
        warrantyEndDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE maintenances (
        id TEXT PRIMARY KEY,
        elevatorId TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        nextMaintenanceDate TEXT,
        notified INTEGER DEFAULT 0,
        FOREIGN KEY (elevatorId) REFERENCES elevators (id) ON DELETE CASCADE
      )
    ''');
  }

  // (İsteğe bağlı) DB kapama fonksiyonu
  Future close() async {
    final dbClient = await db;
    dbClient.close();
  }
}
