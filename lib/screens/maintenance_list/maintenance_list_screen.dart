import 'package:asansor_bakim/screens/edit_screens/maintenance_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/maintenance_provider.dart';
import 'package:go_router/go_router.dart';

class MaintenanceListScreen extends ConsumerWidget {
  final String elevatorId;
  const MaintenanceListScreen({super.key, required this.elevatorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenances = ref.watch(maintenanceListProvider(elevatorId));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, popResult) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bakım Kayıtları'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
        ),
        body: maintenances.isEmpty
            ? const Center(child: Text('Henüz bakım kaydı yok.'))
            : ListView.builder(
                itemCount: maintenances.length,
                itemBuilder: (context, index) {
                  final maintenance = maintenances[index];
                  return Dismissible(
                    key: Key(maintenance.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Silinsin mi?'),
                          content: Text(
                              'Bakım kaydını silmek istediğine emin misin?'),
                          actions: [
                            TextButton(
                                child: const Text('İptal'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false)),
                            TextButton(
                                child: const Text('Sil'),
                                onPressed: () =>
                                    Navigator.of(context).pop(true)),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      ref
                          .read(maintenanceListProvider(elevatorId).notifier)
                          .deleteMaintenance(maintenance.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bakım kaydı silindi')),
                      );
                    },
                    child: ListTile(
                      title: Text(maintenance.description),
                      subtitle: Text('Tarih: ${maintenance.date}'),
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MaintenanceEditScreen(
                              maintenance: maintenance,
                              elevatorId: elevatorId,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/add_maintenance/$elevatorId'),
          child: const Icon(Icons.add),
          tooltip: 'Bakım Ekle',
        ),
      ),
    );
  }
}
