import 'package:denty_cloud_test/modules/patients/domain/entities/patient.entity.dart';
import 'package:denty_cloud_test/modules/patients/presentation/fragments/patients.fragment.controller.dart';
import 'package:flutter/material.dart';

class PatientsFragment extends StatefulWidget {
  const PatientsFragment({super.key});

  @override
  State<PatientsFragment> createState() => _PatientsFragmentState();
}

class _PatientsFragmentState extends State<PatientsFragment>
    with PatientsFragmentController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: ValueListenableBuilder<bool>(
          valueListenable: loading,
          builder: (context, isLoading, _) {
            return ValueListenableBuilder<String?>(
              valueListenable: error,
              builder: (context, errorMsg, _) {
                return ValueListenableBuilder<List<PatientEntity>>(
                  valueListenable: patients,
                  builder: (context, list, _) {
                    if (list.isEmpty && isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (errorMsg != null) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(errorMsg),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => fetchPatients(),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (list.isEmpty) {
                      return const Center(child: Text('No hay pacientes.'));
                    }
                    return ListView.builder(
                      itemCount: hasMore ? list.length + 1 : list.length,
                      itemBuilder: (context, index) {
                        if (index >= list.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final patient = list[index];
                        return _buildPatientListTile(
                          context: context,
                          fullName: patient.fullName,
                          id: patient.id,
                          onTap: () => onEditPatientTap(patient),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAddPatientTap(),
        tooltip: 'Agregar paciente',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget _buildPatientListTile({
  required BuildContext context,
  required String fullName,
  required int? id,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: const Icon(Icons.person),
    title: Text(fullName),
    subtitle: Text('ID: $id'),
    onTap: onTap,
  );
}
