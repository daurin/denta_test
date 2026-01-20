import 'package:denty_cloud_test/modules/patients/domain/entities/patient.entity.dart';
import 'package:denty_cloud_test/modules/patients/presentation/pages/add_patient/add_patient.page.controller.dart';
import 'package:flutter/material.dart';

class AddPatientPage extends StatefulWidget {
  final PatientEntity? patient;

  const AddPatientPage({super.key, this.patient});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage>
    with AddPatientPageController {
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.patient != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Paciente' : 'Agregar Paciente'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: validateFirstName,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: validateLastName,
              ),
              const SizedBox(height: 16),

              ValueListenableBuilder<DateTime?>(
                valueListenable: birthDateNotifier,
                builder: (context, value, _) {
                  return TextFormField(
                    controller: birthDateController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Nacimiento',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.date_range),
                    ),
                    readOnly: true,
                    onTap: () => pickBirthDate(context),
                    validator: validateBirthDate,
                  );
                },
              ),
              const SizedBox(height: 16),

              ValueListenableBuilder<String?>(
                valueListenable: genderNotifier,
                builder: (context, value, _) {
                  return DropdownButtonFormField<String>(
                    initialValue: value,
                    decoration: const InputDecoration(
                      labelText: 'Género',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.wc),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'M', child: Text('Masculino')),
                      DropdownMenuItem(value: 'F', child: Text('Femenino')),
                    ],
                    onChanged: (v) => genderNotifier.value = v,
                    validator: (v) => v == null ? 'Seleccione un género' : null,
                  );
                },
              ),
              const SizedBox(height: 32),
              ValueListenableBuilder<bool>(
                valueListenable: isLoadingNotifier,
                builder: (context, isLoading, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => savePatient(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isEdit
                                    ? 'Actualizar Paciente'
                                    : 'Guardar Paciente',
                              ),
                      ),
                      if (isEdit) const SizedBox(height: 16),
                      if (isEdit)
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => deletePatient(context),
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
                                  ),
                                )
                              : const Text('Eliminar Paciente'),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
