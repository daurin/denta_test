import 'package:denty_cloud_test/modules/appointments/domain/entities/appointment.entity.dart';
import 'package:denty_cloud_test/modules/appointments/presentation/pages/add_appointment/add_appointment.page.controller.dart';
import 'package:flutter/material.dart';

class AddAppointmentPage extends StatefulWidget {
  final AppointmentEntity? appointment;

  const AddAppointmentPage({super.key, this.appointment});

  @override
  State<AddAppointmentPage> createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage>
    with AddAppointmentPageController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Cita' : 'Agregar Cita'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: selectedPatientNotifier,
                builder: (context, patientName, _) {
                  return OutlinedButton.icon(
                    onPressed: () => selectPatient(context),
                    icon: const Icon(Icons.person),
                    label: Text(
                      patientName.isEmpty
                          ? 'Seleccionar Paciente'
                          : patientName,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  );
                },
              ),
              if (!isPatientValid)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Seleccione un paciente',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),

              ValueListenableBuilder<String>(
                valueListenable: selectedEmployeeNotifier,
                builder: (context, employeeName, _) {
                  return OutlinedButton.icon(
                    onPressed: () => selectEmployee(context),
                    icon: const Icon(Icons.badge),
                    label: Text(
                      employeeName.isEmpty
                          ? 'Seleccionar Empleado'
                          : employeeName,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  );
                },
              ),
              if (!isEmployeeValid)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Seleccione un empleado',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),

              ValueListenableBuilder<DateTime?>(
                valueListenable: startDateNotifier,
                builder: (context, value, _) {
                  return TextFormField(
                    controller: startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Inicio',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.date_range),
                    ),
                    readOnly: true,
                    onTap: () => pickStartDate(context),
                    validator: validateStartDate,
                  );
                },
              ),
              const SizedBox(height: 16),

              ValueListenableBuilder<DateTime?>(
                valueListenable: endDateNotifier,
                builder: (context, value, _) {
                  return TextFormField(
                    controller: endDateController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Fin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.date_range),
                    ),
                    readOnly: true,
                    onTap: () => pickEndDate(context),
                    validator: validateEndDate,
                  );
                },
              ),
              const SizedBox(height: 16),

              ValueListenableBuilder<int>(
                valueListenable: statusValueNotifier,
                builder: (context, statusValue, _) {
                  return DropdownButtonFormField<int>(
                    initialValue: statusValue,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.info),
                    ),
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('Pendiente')),
                      DropdownMenuItem(value: 1, child: Text('Confirmada')),
                      DropdownMenuItem(value: 2, child: Text('Cancelada')),
                      DropdownMenuItem(value: 3, child: Text('Completada')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        statusValueNotifier.value = value;
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 32),

              ValueListenableBuilder<bool>(
                valueListenable: isLoadingNotifier,
                builder: (context, isLoading, child) {
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => saveAppointment(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEditing ? 'Actualizar Cita' : 'Guardar Cita'),
                  );
                },
              ),
              if (isEditing) ...[
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: isLoadingNotifier,
                  builder: (context, isLoading, child) {
                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => deleteAppointment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Eliminar Cita',
                              style: TextStyle(color: Colors.white),
                            ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
