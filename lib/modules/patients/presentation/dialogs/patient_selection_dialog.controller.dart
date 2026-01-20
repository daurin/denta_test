import 'package:denty_cloud_test/modules/patients/presentation/dialogs/patient_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:denty_cloud_test/modules/patients/domain/entities/patient.entity.dart';
import 'package:denty_cloud_test/modules/patients/domain/use_cases/patients_use_cases.dart';
import 'package:denty_cloud_test/injector.dart';

mixin PatientSelectionDialogController on State<PatientSelectionDialog> {
  final _patients = ValueNotifier<List<PatientEntity>?>(null);
  final _filteredPatients = ValueNotifier<List<PatientEntity>?>([]);
  final _isLoading = ValueNotifier<bool>(false);
  final _searchController = TextEditingController();

  ValueNotifier<List<PatientEntity>?> get patients => _patients;
  ValueNotifier<List<PatientEntity>?> get filteredPatients => _filteredPatients;
  ValueNotifier<bool> get isLoading => _isLoading;
  TextEditingController get searchController => _searchController;

  @override
  void initState() {
    super.initState();
    _loadPatientData();
    _searchController.addListener(_filterPatients);
  }

  @override
  void dispose() {
    _patients.dispose();
    _filteredPatients.dispose();
    _isLoading.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPatientData() async {
    _isLoading.value = true;
    try {
      final useCase = getIt<GetAllPatientsUseCase>();
      final patientsList = await useCase(null);
      _patients.value = patientsList;
      _filteredPatients.value = patientsList;
    } catch (e) {
      _patients.value = [];
      _filteredPatients.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _filteredPatients.value = _patients.value;
    } else {
      _filteredPatients.value = _patients.value
          ?.where(
            (patient) =>
                patient.firstName.toLowerCase().contains(query) ||
                (patient.lastName?.toLowerCase().contains(query) ?? false),
          )
          .toList();
    }
  }
}
