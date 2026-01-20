import 'package:denty_cloud_test/modules/employees/domain/entities/employee.entity.dart';
import 'package:denty_cloud_test/modules/employees/presentation/fragments/employees.fragment.controller.dart';
import 'package:flutter/material.dart';

class EmployeesFragment extends StatefulWidget {
  const EmployeesFragment({super.key});

  @override
  State<EmployeesFragment> createState() => _EmployeesFragmentState();
}

class _EmployeesFragmentState extends State<EmployeesFragment>
    with EmployeesFragmentController {
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
                return ValueListenableBuilder<List<EmployeeEntity>>(
                  valueListenable: employees,
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
                              onPressed: () => fetchEmployees(),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (list.isEmpty) {
                      return const Center(child: Text('No hay empleados.'));
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
                        final employee = list[index];
                        return _buildEmployeeListTile(
                          context: context,
                          fullName: employee.fullName,
                          id: employee.id,
                          onTap: () => onEditEmployeeTap(employee),
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
        onPressed: () => onAddEmployeeTap(),
        heroTag: 'add_employee_fab',
        tooltip: 'Agregar empleado',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget _buildEmployeeListTile({
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
