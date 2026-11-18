import '../local/database_helper.dart';
import '../models/maintenance_model.dart';

class MaintenanceRepository {
  final dbHelper = DatabaseHelper();

  Future<List<MaintenanceModel>> getMaintenancesByElevator(String elevatorId) async {
    final db = await dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'maintenances',
      where: 'elevatorId = ?',
      whereArgs: [elevatorId],
      orderBy: 'date DESC',
    );
    return maps.map((e) => MaintenanceModel.fromMap(e)).toList();
  }

  Future<void> insertMaintenance(MaintenanceModel maintenance) async {
    final db = await dbHelper.db;
    await db.insert('maintenances', maintenance.toMap());
  }

  Future<void> deleteMaintenance(String id) async {
    final db = await dbHelper.db;
    await db.delete('maintenances', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<MaintenanceModel>> getUpcomingMaintenances() async {
    final db = await dbHelper.db;
    final now = DateTime.now().toIso8601String();
    final List<Map<String, dynamic>> maps = await db.query(
      'maintenances',
      where: 'nextMaintenanceDate > ? AND notified = 0',
      whereArgs: [now],
    );

    return maps.map((e) => MaintenanceModel.fromMap(e)).toList();
  }

  Future<void> updateMaintenance(MaintenanceModel maintenance) async {
    final db = await dbHelper.db;
    await db.update(
      'maintenances',
      maintenance.toMap(),
      where: 'id = ?',
      whereArgs: [maintenance.id],
    );
  }
  
}
