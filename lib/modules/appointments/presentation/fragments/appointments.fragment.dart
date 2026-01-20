import 'package:denty_cloud_test/modules/appointments/domain/entities/appointment.entity.dart';
import 'package:denty_cloud_test/modules/appointments/presentation/fragments/appointments.fragment.controller.dart';
import 'package:flutter/material.dart';

class AppointmentsFragment extends StatefulWidget {
  const AppointmentsFragment({super.key});

  @override
  State<AppointmentsFragment> createState() => _AppointmentsFragmentState();
}

class _AppointmentsFragmentState extends State<AppointmentsFragment>
    with AppointmentsFragmentController {
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
                return ValueListenableBuilder<List<AppointmentEntity>>(
                  valueListenable: appointments,
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
                              onPressed: () => fetchAppointments(),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (list.isEmpty) {
                      return const Center(child: Text('No hay citas.'));
                    }
                    return ListView.builder(
                      itemCount: hasMore ? list.length + 1 : list.length,
                      itemBuilder: (context, index) {
                        if (index == list.length && hasMore) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: isLoading
                                  ? const CircularProgressIndicator()
                                  : null,
                            ),
                          );
                        }
                        final appointment = list[index];
                        return _buildAppointmentListTile(appointment);
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
        heroTag: 'add_appointment_fab',
        onPressed: () => onAddAppointmentTap(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentListTile(AppointmentEntity appointment) {
    return ListTile(
      title: Text('ID Paciente: ${appointment.patientId}'),
      subtitle: Text('ID Empleado: ${appointment.employeeId}'),
      trailing: Text(appointment.status.toString().split('.').last),
      onTap: () => onEditAppointmentTap(appointment, context),
    );
  }
}
