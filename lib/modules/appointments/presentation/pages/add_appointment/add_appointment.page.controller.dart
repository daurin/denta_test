import 'package:denty_cloud_test/injector.dart';
import 'package:denty_cloud_test/modules/appointments/domain/entities/appointment.entity.dart';
import 'package:denty_cloud_test/modules/appointments/domain/use_cases/appointments_use_cases.dart';
import 'package:denty_cloud_test/modules/appointments/presentation/pages/add_appointment/add_appointment.page.dart';
import 'package:denty_cloud_test/modules/employees/domain/entities/employee.entity.dart';
import 'package:denty_cloud_test/modules/employees/presentation/dialogs/employee_selection_dialog.dart';
import 'package:denty_cloud_test/modules/patients/domain/entities/patient.entity.dart';
import 'package:denty_cloud_test/modules/patients/presentation/dialogs/patient_selection_dialog.dart';
import 'package:flutter/material.dart';

mixin AddAppointmentPageController on State<AddAppointmentPage> {
  final formKey = GlobalKey<FormState>();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final isLoadingNotifier = ValueNotifier<bool>(false);
  final selectedPatientNotifier = ValueNotifier<String>('');
  final selectedEmployeeNotifier = ValueNotifier<String>('');

  final startDateNotifier = ValueNotifier<DateTime?>(null);
  final endDateNotifier = ValueNotifier<DateTime?>(null);

  late AppointmentEntity? editingAppointment;
  PatientEntity? selectedPatient;
  EmployeeEntity? selectedEmployee;
  final statusValueNotifier = ValueNotifier<int>(0);

  bool get isPatientValid => selectedPatient != null;
  bool get isEmployeeValid => selectedEmployee != null;
  bool get isEditing => editingAppointment != null;

  @override
  void initState() {
    super.initState();
    editingAppointment = widget.appointment;
    if (isEditing) {
      _loadAppointmentData();
    }
  }

  void _loadAppointmentData() {
    
    selectedPatientNotifier.value = 'ID: ${editingAppointment!.patientId}';
    selectedEmployeeNotifier.value = 'ID: ${editingAppointment!.employeeId}';
    startDateNotifier.value = editingAppointment!.startDate;
    endDateNotifier.value = editingAppointment!.endDate;
    statusValueNotifier.value = editingAppointment!.status.index;
    startDateController.text =
        '${editingAppointment!.startDate.day}/${editingAppointment!.startDate.month}/${editingAppointment!.startDate.year} ${editingAppointment!.startDate.hour}:${editingAppointment!.startDate.minute.toString().padLeft(2, '0')}';
    endDateController.text =
        '${editingAppointment!.endDate.day}/${editingAppointment!.endDate.month}/${editingAppointment!.endDate.year} ${editingAppointment!.endDate.hour}:${editingAppointment!.endDate.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    isLoadingNotifier.dispose();
    selectedPatientNotifier.dispose();
    selectedEmployeeNotifier.dispose();
    statusValueNotifier.dispose();
    super.dispose();
  }

  Future<void> selectPatient(BuildContext context) async {
    final patient = await PatientSelectionDialog.show(context);
    if (patient != null) {
      selectedPatient = patient;
      selectedPatientNotifier.value = '${patient.firstName} ${patient.lastName ?? ''}';
    }
  }

  Future<void> selectEmployee(BuildContext context) async {
    final employee = await EmployeeSelectionDialog.show(context);
    if (employee != null) {
      selectedEmployee = employee;
      selectedEmployeeNotifier.value = employee.fullName;
    }
  }

  String? validateStartDate(String? value) {
    if (startDateNotifier.value == null) {
      return 'Seleccione la fecha de inicio';
    }
    return null;
  }

  String? validateEndDate(String? value) {
    if (endDateNotifier.value == null) {
      return 'Seleccione la fecha de fin';
    }
    if (startDateNotifier.value != null && endDateNotifier.value!.isBefore(startDateNotifier.value!)) {
      return 'La fecha de fin debe ser posterior a la de inicio';
    }
    return null;
  }

  Future<void> pickStartDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      if (context.mounted) {
        final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

        if (pickedTime != null) {
          final dt = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
          startDateNotifier.value = dt;
          startDateController.text =
              '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
        }
      }
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: startDateNotifier.value ?? DateTime.now(),
      firstDate: startDateNotifier.value ?? DateTime.now(),
      lastDate: (startDateNotifier.value ?? DateTime.now()).add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      if (context.mounted) {
        final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

        if (pickedTime != null) {
          final dt = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
          endDateNotifier.value = dt;
          endDateController.text =
              '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
        }
      }
    }
  }

  Future<void> saveAppointment(BuildContext context) async {
    if (!isPatientValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Seleccione un paciente'), backgroundColor: Colors.red));
      return;
    }

    if (!isEmployeeValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Seleccione un empleado'), backgroundColor: Colors.red));
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      isLoadingNotifier.value = true;

      try {
        if (isEditing) {
          // Actualizar cita existente
          final appointment = AppointmentEntity(
            id: editingAppointment!.id,
            patientId: selectedPatient!.id!,
            employeeId: selectedEmployee!.id!,
            startDate: startDateNotifier.value!,
            endDate: endDateNotifier.value!,
            status: AppointmentStatus.values[statusValueNotifier.value],
          );

          final updateAppointmentUseCase = getIt<UpdateAppointmentUseCase>();
          await updateAppointmentUseCase(UpdateAppointmentParams(appointment));

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cita actualizada exitosamente'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop(true);
          }
        } else {
          // Crear nueva cita
          final appointment = AppointmentEntity(
            patientId: selectedPatient!.id!,
            employeeId: selectedEmployee!.id!,
            startDate: startDateNotifier.value!,
            endDate: endDateNotifier.value!,
            status: AppointmentStatus.values[statusValueNotifier.value],
          );

          final addAppointmentUseCase = getIt<AddAppointmentUseCase>();
          await addAppointmentUseCase(AddAppointmentParams(appointment));

          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Cita creada exitosamente'), backgroundColor: Colors.green));
            Navigator.of(context).pop(true);
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red));
        }
      } finally {
        isLoadingNotifier.value = false;
      }
    }
  }

  Future<void> deleteAppointment(BuildContext context) async {
    isLoadingNotifier.value = true;

    try {
      final deleteAppointmentUseCase = getIt<DeleteAppointmentUseCase>();
      await deleteAppointmentUseCase(DeleteAppointmentParams(editingAppointment!.id!));

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cita eliminada exitosamente'), backgroundColor: Colors.green));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red));
      }
    } finally {
      isLoadingNotifier.value = false;
    }
  }
}
