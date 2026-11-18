import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/maintenance_model.dart';
import '../data/repositories/maintenance_repository.dart';

final maintenanceRepositoryProvider = Provider((ref) => MaintenanceRepository());

final maintenanceListProvider = StateNotifierProvider.family<
    MaintenanceListNotifier, List<MaintenanceModel>, String>(
  (ref, elevatorId) =>
      MaintenanceListNotifier(ref.read(maintenanceRepositoryProvider), elevatorId),
);

class MaintenanceListNotifier extends StateNotifier<List<MaintenanceModel>> {
  final MaintenanceRepository _repo;
  final String elevatorId;

  MaintenanceListNotifier(this._repo, this.elevatorId) : super([]) {
    loadMaintenances();
  }

  Future<void> loadMaintenances() async {
    final maintenances = await _repo.getMaintenancesByElevator(elevatorId);
    state = maintenances;
  }

  Future<void> addMaintenance(MaintenanceModel maintenance) async {
    await _repo.insertMaintenance(maintenance);
    await loadMaintenances();
  }

  Future<void> deleteMaintenance(String id) async {
    await _repo.deleteMaintenance(id);
    await loadMaintenances();
  }
   Future<void> updateMaintenance(MaintenanceModel maintenance) async {
    await _repo.updateMaintenance(maintenance);
    await loadMaintenances();
  }
}
