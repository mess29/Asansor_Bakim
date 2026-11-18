/*
import 'package:asansor_bakim/services/notification_service.dart';
import 'package:asansor_bakim/utils/notification_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/maintenance_model.dart';
import '../../providers/maintenance_provider.dart';

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

class MaintenanceEditSheet extends StatefulWidget {
  final MaintenanceModel maintenance;
  final WidgetRef ref;
  final String elevatorId;
  const MaintenanceEditSheet({
    required this.maintenance,
    required this.ref,
    required this.elevatorId,
  });

  @override
  State<MaintenanceEditSheet> createState() => _MaintenanceEditSheetState();
}

class _MaintenanceEditSheetState extends State<MaintenanceEditSheet> {
  late TextEditingController descriptionController;
  late TextEditingController dateController;
  late TextEditingController nextDateController;
  final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    descriptionController =
        TextEditingController(text: widget.maintenance.description);
    dateController = TextEditingController(text: widget.maintenance.date);
    nextDateController = TextEditingController(
        text: widget.maintenance.nextMaintenanceDate ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Bakım Kaydını Düzenle',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Açıklama'),
          ),
          TextField(
            controller: dateController,
            decoration: const InputDecoration(labelText: 'Bakım Tarihi'),
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: safeInitialDate(dateController.text, dateFormatter,
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
          ),
          TextField(
  controller: nextDateController,
  decoration: const InputDecoration(labelText: 'Sonraki Bakım Tarihi'),
  readOnly: true,
  onTap: () async {
    final base = safeInitialDate(dateController.text, dateFormatter, fallback: now);
    final picked = await showDatePicker(
      context: context,
      initialDate: addMonths(base, 1),
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
      locale: const Locale('tr', 'TR'),
       useRootNavigator: true,
    );
    if (picked != null) {
      nextDateController.text = dateFormatter.format(picked);
    }
  },
),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final updatedMaintenance = MaintenanceModel(
                    id: widget.maintenance.id,
                    elevatorId: widget.elevatorId,
                    description: descriptionController.text,
                    date: dateController.text,
                    nextMaintenanceDate: nextDateController.text,
                    notified: widget.maintenance.notified,
                  );
                  widget.ref
                      .read(maintenanceListProvider(widget.elevatorId).notifier)
                      .updateMaintenance(updatedMaintenance);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: const Text('Kaydet'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Bakım Kaydı Silinsin mi?'),
                      content: const Text(
                          'Bu bakım kaydını silmek istediğinize emin misiniz?'),
                      actions: [
                        TextButton(
                            child: const Text('İptal'),
                            onPressed: () => Navigator.pop(ctx, false)),
                        TextButton(
                            child: const Text('Sil'),
                            onPressed: () => Navigator.pop(ctx, true)),
                      ],
                    ),
                  );
                  if (result == true) {
                    widget.ref
                        .read(
                            maintenanceListProvider(widget.elevatorId).notifier)
                        .deleteMaintenance(widget.maintenance.id);
                    await NotificationService.cancelNotification(
                        getNotificationId(widget.maintenance.id));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.delete),
                label: const Text('Sil'),
              ),
            ],
          )
        ],
      ),
    );
  }
}*/