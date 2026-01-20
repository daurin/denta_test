import 'package:denty_cloud_test/injector.dart';
import 'package:denty_cloud_test/modules/employees/domain/use_cases/employees_use_cases.dart';
import 'package:denty_cloud_test/modules/employees/presentation/pages/add_employee/add_employee.page.dart';
import 'package:flutter/material.dart';

mixin AddEmployeePageController on State<AddEmployeePage> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final isLoadingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      fullNameController.text = widget.employee!.fullName;
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    isLoadingNotifier.dispose();
    super.dispose();
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese el nombre completo';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  Future<void> saveEmployee(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      isLoadingNotifier.value = true;

      try {
        final fullName = fullNameController.text;

        if (widget.employee != null) {
          // Editar empleado existente
          final updateEmployeeUseCase = getIt<UpdateEmployeeUseCase>();
          await updateEmployeeUseCase(
            UpdateEmployeeParams(id: widget.employee!.id!, fullName: fullName),
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Empleado actualizado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          }
        } else {
          // Crear nuevo empleado
          final addEmployeeUseCase = getIt<AddEmployeeUseCase>();
          await addEmployeeUseCase(AddEmployeeParams(fullName));

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Empleado creado exitosamente'),
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

  Future<void> deleteEmployee(BuildContext context) async {
    if (widget.employee == null || widget.employee!.id == null) return;
    isLoadingNotifier.value = true;
    try {
      final deleteEmployeeUseCase = getIt<DeleteEmployeeUseCase>();
      await deleteEmployeeUseCase(DeleteEmployeeParams(widget.employee!));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Empleado eliminado exitosamente'),
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
