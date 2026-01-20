import 'package:denty_cloud_test/modules/appointments/presentation/fragments/appointments.fragment.dart';
import 'package:denty_cloud_test/modules/common/presentation/pages/home/home.page.controller.dart';
import 'package:denty_cloud_test/modules/employees/presentation/fragments/employees.fragment.dart';
import 'package:denty_cloud_test/modules/patients/presentation/fragments/patients.fragment.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomePageController {
  final List<Widget> fragments = const <Widget>[
    AppointmentsFragment(),
    EmployeesFragment(),
    PatientsFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: logout,
          ),
        ],
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedIndexNotifier,
        builder: (context, index, _) =>
            IndexedStack(index: index, children: fragments),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: selectedIndexNotifier,
        builder: (context, index, _) => NavigationBar(
          destinations: const <NavigationDestination>[
            NavigationDestination(icon: Icon(Icons.event), label: 'Citas'),
            NavigationDestination(icon: Icon(Icons.people), label: 'Empleados'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Pacientes'),
          ],
          selectedIndex: index,
          onDestinationSelected: onDestinationSelected,
        ),
      ),
    );
  }
}
