import 'package:denty_cloud_test/injector.dart';
import 'package:denty_cloud_test/modules/patients/domain/use_cases/patients_use_cases.dart';
import 'package:denty_cloud_test/modules/patients/presentation/pages/add_patient/add_patient.page.dart';
import 'package:flutter/material.dart';

mixin AddPatientPageController on State<AddPatientPage> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDateController = TextEditingController();
  final isLoadingNotifier = ValueNotifier<bool>(false);

  final birthDateNotifier = ValueNotifier<DateTime?>(null);
  final genderNotifier = ValueNotifier<String?>(null);

  DateTime? get birthDate => birthDateNotifier.value;
  set birthDate(DateTime? value) => birthDateNotifier.value = value;
  String? get genderValue => genderNotifier.value;
  set genderValue(String? value) => genderNotifier.value = value;

  @override
  void initState() {
    super.initState();
    if (widget.patient != null) {
      firstNameController.text = widget.patient!.firstName;
      lastNameController.text = widget.patient!.lastName ?? '';
      birthDateNotifier.value = widget.patient!.birthDate;
      genderNotifier.value = widget.patient!.gender;
      birthDateController.text =
          '${widget.patient!.birthDate.day}/${widget.patient!.birthDate.month}/${widget.patient!.birthDate.year}';
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    isLoadingNotifier.dispose();
    super.dispose();
  }

  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese el nombre';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value != null && value.isNotEmpty && value.length < 2) {
      return 'El apellido debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? validateBirthDate(String? value) {
    if (birthDate == null) {
      return 'Seleccione la fecha de nacimiento';
    }
    return null;
  }

  Future<void> pickBirthDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:
          birthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      birthDateNotifier.value = pickedDate;
      birthDateController.text =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
    }
  }

  Future<void> savePatient(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      isLoadingNotifier.value = true;

      try {
        final firstName = firstNameController.text;
        final lastName = lastNameController.text.isEmpty
            ? null
            : lastNameController.text;
        final gender = genderValue!;

        if (widget.patient != null) {
          // Editar paciente existente
          final updatePatientUseCase = getIt<UpdatePatientUseCase>();
          await updatePatientUseCase(
            UpdatePatientParams(
              id: widget.patient!.id!,
              firstName: firstName,
              lastName: lastName,
              birthDate: birthDate!,
              gender: gender,
            ),
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Paciente actualizado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          }
        } else {
          // Crear nuevo paciente
          final addPatientUseCase = getIt<AddPatientUseCase>();
          await addPatientUseCase(
            AddPatientParams(
              firstName: firstName,
              lastName: lastName,
              birthDate: birthDate!,
              gender: gender,
            ),
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Paciente creado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        isLoadingNotifier.value = false;
      }
    }
  }

  Future<void> deletePatient(BuildContext context) async {
    if (widget.patient == null || widget.patient!.id == null) return;
    isLoadingNotifier.value = true;
    try {
      final deletePatientUseCase = getIt<DeletePatientUseCase>();
      await deletePatientUseCase(DeletePatientParams(widget.patient!));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paciente eliminado exitosamente'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      isLoadingNotifier.value = false;
    }
  }
}
