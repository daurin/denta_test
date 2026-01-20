import 'package:flutter/material.dart';
import 'package:denty_cloud_test/modules/patients/domain/entities/patient.entity.dart';
import 'patient_selection_dialog.controller.dart';

class PatientSelectionDialog extends StatefulWidget {
  const PatientSelectionDialog({super.key});

  static Future<PatientEntity?> show(BuildContext context) {
    return showDialog<PatientEntity?>(context: context, builder: (context) => const PatientSelectionDialog());
  }

  @override
  State<PatientSelectionDialog> createState() => _PatientSelectionDialogState();
}

class _PatientSelectionDialogState extends State<PatientSelectionDialog> with PatientSelectionDialogController {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar Paciente'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar paciente...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, isLoading, child) {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ValueListenableBuilder<List<PatientEntity>?>(
                    valueListenable: filteredPatients,
                    builder: (context, patients, _) {
                      if (patients == null || patients.isEmpty) {
                        return const Center(child: Text('No hay pacientes'));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return ListTile(
                            title: Text(patient.firstName),
                            subtitle: Text(patient.lastName ?? ''),
                            onTap: () => Navigator.pop(context, patient),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar'))],
    );
  }
}
