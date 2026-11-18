import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../providers/elevator_provider.dart';
import '../../data/models/elevator_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AddElevatorScreen extends ConsumerWidget {
  const AddElevatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String location = '';
    String installationYear = '';
    final installationYearController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Asansör Ekle',
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Adı'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Zorunlu' : null,
                onSaved: (value) => name = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Konum'),
                onSaved: (value) => location = value ?? '',
              ),
              TextFormField(
                controller: installationYearController,
                decoration: const InputDecoration(labelText: 'Kurulum Yılı'),
                readOnly: true,
                onTap: () async {
                  final now = DateTime.now();
                  final year = await showDialog<int>(
                    context: context,
                    builder: (context) => YearPickerDialog(
                      initialYear: now.year,
                      firstYear: 1980,
                      lastYear: now.year,
                    ),
                  );
                  if (year != null) {
                    installationYearController.text = year.toString();
                  }
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Zorunlu' : null,
                onSaved: (value) => installationYear = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Kaydet'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final elevator = ElevatorModel(
                      id: const Uuid().v4(),
                      name: name,
                      location: location,
                      installationYear: installationYear,
                    );
                    ref
                        .read(elevatorListProvider.notifier)
                        .addElevator(elevator);
                    context.go('/home');
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

class YearPickerDialog extends StatelessWidget {
  final int initialYear;
  final int firstYear;
  final int lastYear;
  const YearPickerDialog({
    required this.initialYear,
    required this.firstYear,
    required this.lastYear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kurulum Yılı Seç'),
      content: SizedBox(
        width: 300,
        height: 300,
        child: YearPicker(
          selectedDate: DateTime(initialYear),
          firstDate: DateTime(firstYear),
          lastDate: DateTime(lastYear),
          onChanged: (date) => Navigator.pop(context, date.year),
        ),
      ),
    );
  }
}
