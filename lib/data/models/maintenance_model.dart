class MaintenanceModel {
  final String id;
  final String elevatorId;
  final String description;
  final String date;
  final String? nextMaintenanceDate;
  final int notified;

  MaintenanceModel({
    required this.id,
    required this.elevatorId,
    required this.description,
    required this.date,
    this.nextMaintenanceDate,
    this.notified = 0,
  });

  factory MaintenanceModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceModel(
      id: map['id'],
      elevatorId: map['elevatorId'],
      description: map['description'],
      date: map['date'],
      nextMaintenanceDate: map['nextMaintenanceDate'],
      notified: map['notified'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'elevatorId': elevatorId,
      'description': description,
      'date': date,
      'nextMaintenanceDate': nextMaintenanceDate,
      'notified': notified,
    };
  }
}
