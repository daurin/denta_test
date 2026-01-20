import 'package:denty_cloud_test/modules/employees/presentation/pages/add_employee/add_employee.page.controller.dart';
import 'package:denty_cloud_test/modules/employees/domain/entities/employee.entity.dart';
import 'package:flutter/material.dart';

class AddEmployeePage extends StatefulWidget {
  final EmployeeEntity? employee;

  const AddEmployeePage({super.key, this.employee});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage>
    with AddEmployeePageController {
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.employee != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Empleado' : 'Agregar Empleado'),
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
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: validateFullName,
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
                            : () => saveEmployee(context),
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
                                    ? 'Actualizar Empleado'
                                    : 'Guardar Empleado',
                              ),
                      ),
                      if (isEdit) const SizedBox(height: 16),
                      if (isEdit)
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => deleteEmployee(context),
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
                              : const Text('Eliminar Empleado'),
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
