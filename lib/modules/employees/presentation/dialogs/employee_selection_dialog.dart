import 'package:flutter/material.dart';
import 'package:denty_cloud_test/modules/employees/domain/entities/employee.entity.dart';
import 'employee_selection_dialog.controller.dart';

class EmployeeSelectionDialog extends StatefulWidget {
  const EmployeeSelectionDialog({Key? key}) : super(key: key);

  static Future<EmployeeEntity?> show(BuildContext context) {
    return showDialog<EmployeeEntity?>(
      context: context,
      builder: (context) => const EmployeeSelectionDialog(),
    );
  }

  @override
  State<EmployeeSelectionDialog> createState() =>
      _EmployeeSelectionDialogState();
}

class _EmployeeSelectionDialogState extends State<EmployeeSelectionDialog> with EmployeeSelectionDialogController {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar Empleado'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar empleado...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, isLoading, _) {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ValueListenableBuilder<List<EmployeeEntity>?>(
                    valueListenable: filteredEmployees,
                    builder: (context, employees, _) {
                      if (employees == null || employees.isEmpty) {
                        return const Center(child: Text('No hay empleados'));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];
                          return ListTile(
                            title: Text(employee.fullName),
                            onTap: () => Navigator.pop(context, employee),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
