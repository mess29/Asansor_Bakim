import '../local/database_helper.dart';
import '../models/elevator_model.dart';

class ElevatorRepository {
  final dbHelper = DatabaseHelper();

  Future<List<ElevatorModel>> getAllElevators() async {
    final db = await dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query('elevators');
    return maps.map((e) => ElevatorModel.fromMap(e)).toList();
  }

  Future<void> insertElevator(ElevatorModel elevator) async {
    final db = await dbHelper.db;
    await db.insert('elevators', elevator.toMap());
  }

  Future<void> deleteElevator(String id) async {
    final db = await dbHelper.db;
    await db.delete('elevators', where: 'id = ?', whereArgs: [id]);
  }
  Future<void> updateElevator(ElevatorModel elevator) async {
    final db = await dbHelper.db;
    await db.update(
      'elevators',
      elevator.toMap(),
      where: 'id = ?',
      whereArgs: [elevator.id],
    );
  }
}
