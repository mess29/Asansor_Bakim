import 'package:asansor_bakim/providers/maintenance_provider.dart';
import 'package:asansor_bakim/services/notification_service.dart';
import 'package:asansor_bakim/utils/notification_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/elevator_model.dart';
import '../../providers/elevator_provider.dart';

class ElevatorEditScreen extends ConsumerStatefulWidget {
  final ElevatorModel elevator;
  const ElevatorEditScreen({super.key, required this.elevator});

  @override
  ConsumerState<ElevatorEditScreen> createState() => _ElevatorEditScreenState();
}

class _ElevatorEditScreenState extends ConsumerState<ElevatorEditScreen> {
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController yearController;
  

  @override
  void initState() {
    nameController = TextEditingController(text: widget.elevator.name);
    locationController = TextEditingController(text: widget.elevator.location ?? '');
    String initialYear = '';
    if (widget.elevator.installationYear != null && widget.elevator.installationYear!.isNotEmpty) {
      final parts = widget.elevator.installationYear!.split('/');
      // Eğer "yyyy" olarak tutuluyorsa direkt al, yoksa parçala
      if (parts.length == 1) {
        initialYear = widget.elevator.installationYear!;
      } else if (parts.length == 3) {
        initialYear = parts[2];
      }
    }

    super.initState();
    yearController = TextEditingController(text: initialYear);

  }

  Future<void> _pickInstallationYear(BuildContext context) async {
    DateTime now = DateTime.now();
    final selectedYear  = int.tryParse(yearController.text) ?? now.year;
    
    final pickedYear = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kurulum Yılı Seç'),
        content: SizedBox(
          width: 300,
          height: 300,
          child: YearPicker(
            selectedDate: DateTime(selectedYear),
            firstDate: DateTime(now.year - 40),
            lastDate: DateTime(now.year + 1),
            onChanged: (date) => Navigator.pop(context, date.year),
          ),
        ),
      ),
    );

    if (!mounted) return;
    if (pickedYear != null) {
      setState(() {
      yearController.text = pickedYear.toString();
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asansör Düzenle'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Adı'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Konum'),
            ),
            TextField(
              controller: yearController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Kurulum Tarihi'),
              onTap: () => _pickInstallationYear(context),
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
                      installationYear: yearController.text,
                    );
                    await ref.read(elevatorListProvider.notifier).updateElevator(updatedElevator);
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
                        content: const Text('Bu asansörü silmek istediğine emin misin?'),
                        actions: [
                          TextButton(child: const Text('İptal'), onPressed: () => Navigator.pop(ctx, false)),
                          TextButton(child: const Text('Sil'), onPressed: () => Navigator.pop(ctx, true)),
                        ],
                      ),
                    );
                    if (confirm == true) {
                     final maintenances = await ref
        .read(maintenanceRepositoryProvider)
        .getMaintenancesByElevator(widget.elevator.id);

    // 2. Bildirimler iptal ediliyor
    for (final m in maintenances) {
      await NotificationService.cancelNotification(getNotificationId(m.id));
    }
    // 3. Asansör siliniyor
    await ref.read(elevatorListProvider.notifier).deleteElevator(widget.elevator.id);

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
      ),
    );
  }
}
