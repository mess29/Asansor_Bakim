import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/elevator_model.dart';
import '../data/repositories/elevator_repository.dart';

final elevatorRepositoryProvider = Provider((ref) => ElevatorRepository());

final elevatorListProvider = StateNotifierProvider<ElevatorListNotifier, List<ElevatorModel>>(
  (ref) => ElevatorListNotifier(ref.read(elevatorRepositoryProvider)),
);

class ElevatorListNotifier extends StateNotifier<List<ElevatorModel>> {
  final ElevatorRepository _repo;

  ElevatorListNotifier(this._repo) : super([]) {
    loadElevators();
  }

  Future<void> loadElevators() async {
    final elevators = await _repo.getAllElevators();
    state = elevators;
  }

  Future<void> addElevator(ElevatorModel elevator) async {
    await _repo.insertElevator(elevator);
    await loadElevators();
  }

  Future<void> deleteElevator(String id) async {
    await _repo.deleteElevator(id);
    await loadElevators();
  }

  Future<void> updateElevator(ElevatorModel elevator) async {
    await _repo.updateElevator(elevator);
    await loadElevators();
  }
}
