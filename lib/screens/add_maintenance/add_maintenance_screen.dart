import 'package:asansor_bakim/utils/notification_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/maintenance_model.dart';
import '../../providers/maintenance_provider.dart';
import 'package:asansor_bakim/services/notification_service.dart';

DateTime addMonths(DateTime date, int monthsToAdd) {
  int year = date.year + ((date.month - 1 + monthsToAdd) ~/ 12);
  int month = ((date.month - 1 + monthsToAdd) % 12) + 1;
  int day = date.day;
  int lastDayOfMonth = DateTime(year, month + 1, 0).day;
  if (day > lastDayOfMonth) day = lastDayOfMonth;
  return DateTime(year, month, day);
}

/// Her zaman geçerli bir initialDate döndürür.
DateTime safeInitialDate(String text, DateFormat formatter,
    {DateTime? fallback}) {
  try {
    final dt = formatter.parseStrict(text);
    if (dt.isBefore(DateTime(1900)) || dt.isAfter(DateTime(2100)))
      throw Exception();
    return dt;
  } catch (_) {
    return fallback ?? DateTime.now();
  }
}

class AddMaintenanceScreen extends ConsumerWidget {
  final String elevatorId;
  const AddMaintenanceScreen({super.key, required this.elevatorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    String description = '';
    // ignore: unused_local_variable
    String date = '';
    // ignore: unused_local_variable
    String nextMaintenanceDate = '';

    final now = DateTime.now();
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final dateController =
        TextEditingController(text: dateFormatter.format(now));
    final nextDateController = TextEditingController(
      text: dateFormatter.format(addMonths(now, 1)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bakım Ekle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Açıklama'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Zorunlu' : null,
                onSaved: (value) => description = value ?? '',
              ),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Bakım Tarihi'),
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: safeInitialDate(
                        dateController.text, dateFormatter,
                        fallback: now),
                    firstDate: DateTime(now.year - 2),
                    lastDate: DateTime(now.year + 5),
                    locale: const Locale('tr', 'TR'),
                     useRootNavigator: true,
                  );
                  if (picked != null) {
                    dateController.text = dateFormatter.format(picked);
                  }
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Zorunlu' : null,
                onSaved: (value) => date = value ?? '',
              ),
              TextFormField(
                controller: nextDateController,
                decoration:
                    const InputDecoration(labelText: 'Sonraki Bakım Tarihi'),
                readOnly: true,
                onTap: () async {
                  final baseDate = safeInitialDate(
                      dateController.text, dateFormatter,
                      fallback: now);
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: addMonths(baseDate, 1),
                    firstDate: DateTime(now.year - 2),
                    lastDate: DateTime(now.year + 5),
                    locale: const Locale('tr', 'TR'),
                     useRootNavigator: true,
                  );
                  if (picked != null) {
                    nextDateController.text = dateFormatter.format(picked);
                  }
                },
                onSaved: (value) => nextMaintenanceDate = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Kaydet'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final maintenance = MaintenanceModel(
                      id: const Uuid().v4(),
                      elevatorId: elevatorId,
                      description: description,
                      date: dateController.text,
                      nextMaintenanceDate: nextDateController.text,
                    );

                  await  ref.read(maintenanceListProvider(elevatorId).notifier).addMaintenance(maintenance);
                  final maintenanceDate = DateFormat('dd/MM/yyyy').parse(dateController.text);
      final notificationId = getNotificationId(maintenance.id);
      await NotificationService.scheduleMaintenanceNotification(
        notificationId: notificationId,
        title: 'Bakım Zamanı Yaklaşıyor!',
        body: '${maintenance.description} bakımının zamanı geldi.',
        maintenanceDate: maintenanceDate,
      );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
