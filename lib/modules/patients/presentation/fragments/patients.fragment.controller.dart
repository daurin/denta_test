import 'package:denty_cloud_test/injector.dart';
import 'package:denty_cloud_test/modules/patients/domain/entities/patient.entity.dart';
import 'package:denty_cloud_test/modules/patients/domain/use_cases/patients_use_cases.dart';
import 'package:denty_cloud_test/modules/patients/presentation/fragments/patients.fragment.dart';
import 'package:denty_cloud_test/modules/patients/presentation/pages/add_patient/add_patient.page.dart';
import 'package:flutter/material.dart';

mixin PatientsFragmentController on State<PatientsFragment> {
  final loading = ValueNotifier<bool>(false);
  final error = ValueNotifier<String?>(null);
  final patients = ValueNotifier<List<PatientEntity>>([]);

  int currentPage = 1;
  bool hasMore = true;
  static const int itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  @override
  void dispose() {
    loading.dispose();
    error.dispose();
    patients.dispose();
    super.dispose();
  }

  Future<void> fetchPatients() async {
    if (currentPage == 1) {
      loading.value = true;
      error.value = null;
    }

    try {
      final useCase = getIt<GetPaginatedPatientsUseCase>();
      final result = await useCase(
        GetPaginatedPatientsParams(page: currentPage, items: itemsPerPage),
      );

      if (mounted) {
        if (currentPage == 1) {
          patients.value = result;
        } else {
          patients.value = [...patients.value, ...result];
        }

        if (result.length < itemsPerPage) {
          hasMore = false;
        } else {
          hasMore = true;
        }
      }
    } catch (e) {
      if (mounted) {
        error.value = e.toString();
      }
    } finally {
      if (mounted) {
        loading.value = false;
      }
    }
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent - 200) {
        if (hasMore && !loading.value) {
          currentPage++;
          fetchPatients();
        }
      }
    }
    return false;
  }

  Future<void> onEditPatientTap(PatientEntity patient) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddPatientPage(patient: patient)),
    );
    if (result == true) {
      currentPage = 1;
      fetchPatients();
    }
  }

  Future<void> onAddPatientTap() async {
    final result = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const AddPatientPage()));
    if (result == true) {
      currentPage = 1;
      fetchPatients();
    }
  }
}
