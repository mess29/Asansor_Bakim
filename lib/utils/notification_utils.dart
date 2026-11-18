int getNotificationId(String maintenanceId) {
  return maintenanceId.codeUnits.fold(0, (prev, el) => prev + el);
}