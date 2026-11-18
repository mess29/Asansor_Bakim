import 'package:asansor_bakim/providers/maintenance_provider.dart';
import 'package:asansor_bakim/screens/add_maintenance/add_maintenance_screen.dart';
import 'package:asansor_bakim/services/notification_service.dart';
import 'package:asansor_bakim/utils/notification_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:asansor_bakim/data/models/elevator_model.dart';
import '../../providers/elevator_provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elevators = ref.watch(elevatorListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Asansörler')),
      body: elevators.isEmpty
          ? const Center(child: Text('Kayıtlı asansör yok.'))
          : ListView.builder(
              itemCount: elevators.length,
              itemBuilder: (context, index) {
                final elevator = elevators[index];
                return Dismissible(
                  key: Key(elevator.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    // Silme onayı
                    return await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Silinsin mi?'),
                        content: Text(
                            '${elevator.name} asansörünü silmek istediğine emin misin?'),
                        actions: [
                          TextButton(
                              child: const Text('İptal'),
                              onPressed: () =>
                                  Navigator.of(context).pop(false)),
                          TextButton(
                            child: const Text('Sil'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    final maintenances = await ref
                        .read(maintenanceRepositoryProvider)
                        .getMaintenancesByElevator(elevator.id);

                    for (final m in maintenances) {
                      await NotificationService.cancelNotification(
                          getNotificationId(m.id));
                    }

                    // 3. Asansörü sil
                    await ref
                        .read(elevatorListProvider.notifier)
                        .deleteElevator(elevator.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${elevator.name} silindi')),
                    );
                  },
                  child: ListTile(
                    title: Text(elevator.name),
                    subtitle: Text(elevator.location ?? '-'),
                    onTap: () =>
                        context.push('/maintenance_list/${elevator.id}'),
                    onLongPress: () {
                      context.push('/edit_elevator/${elevator.id}',
                          extra: elevator);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add_elevator'),
        child: const Icon(Icons.add),
        tooltip: 'Asansör Ekle',
      ),
    );
  }
}
/*
class ElevatorEditSheet extends StatefulWidget {
  final ElevatorModel elevator;
  final WidgetRef ref;
  const ElevatorEditSheet({required this.elevator, required this.ref});

  @override
  State<ElevatorEditSheet> createState() => _ElevatorEditSheetState();
}

class _ElevatorEditSheetState extends State<ElevatorEditSheet> {
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController dateController;
  final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    nameController = TextEditingController(text: widget.elevator.name);
    locationController =
        TextEditingController(text: widget.elevator.location ?? '');
    dateController =
        TextEditingController(text: widget.elevator.installationDate ?? '');
    super.initState();
  }

  // Kurulum tarihi picker (her zaman güvenli initialDate)
  Future<void> _pickInstallationDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime initialDate = safeInitialDate(dateController.text, dateFormatter,
        fallback: DateTime.now());
    ;
    try {
      initialDate = dateFormatter.parseStrict(dateController.text);
    } catch (_) {
      initialDate = now;
    }
    /* DateTime now = DateTime.now();
DateTime initialDate;
try {
  if (dateController.text.isNotEmpty) {
    initialDate = dateFormatter.parseStrict(dateController.text);
  } else {
    initialDate = now;
  }
} catch (_) {
  initialDate = now;
}*/
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 40),
      lastDate: DateTime(now.year + 1),
      locale: const Locale('tr', 'TR'),
      useRootNavigator: true,
    );
    if (picked != null) {
      dateController.text = dateFormatter.format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Wrap(
        children: [
          Text('Asansör Düzenle',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Adı'),
          ),
          TextField(
            controller: locationController,
            decoration: const InputDecoration(labelText: 'Konum'),
          ),
          TextField(
            controller: dateController,
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Kurulum Tarihi'),
            onTap: () => _pickInstallationDate(context),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final updatedElevator = ElevatorModel(
                    id: widget.elevator.id,
                    name: nameController.text,
                    location: locationController.text,
                    installationDate: dateController.text,
                  );
                  await widget.ref
                      .read(elevatorListProvider.notifier)
                      .updateElevator(updatedElevator);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: const Text('Kaydet'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Silinsin mi?'),
                      content: const Text(
                          'Bu asansörü silmek istediğine emin misin?'),
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
                  if (confirm == true) {
                    widget.ref
                        .read(elevatorListProvider.notifier)
                        .deleteElevator(widget.elevator.id);
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
}
*/