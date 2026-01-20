import 'package:denty_cloud_test/injector.dart';
import 'package:denty_cloud_test/modules/appointments/domain/entities/appointment.entity.dart';
import 'package:denty_cloud_test/modules/appointments/domain/use_cases/appointments_use_cases.dart';
import 'package:denty_cloud_test/modules/appointments/presentation/fragments/appointments.fragment.dart';
import 'package:denty_cloud_test/modules/appointments/presentation/pages/add_appointment/add_appointment.page.dart';
import 'package:flutter/material.dart';

mixin AppointmentsFragmentController on State<AppointmentsFragment> {
  final loading = ValueNotifier<bool>(false);
  final error = ValueNotifier<String?>(null);
  final appointments = ValueNotifier<List<AppointmentEntity>>([]);

  int currentPage = 1;
  bool hasMore = true;
  static const int itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  @override
  void dispose() {
    loading.dispose();
    error.dispose();
    appointments.dispose();
    super.dispose();
  }

  Future<void> fetchAppointments() async {
    if (currentPage == 1) {
      loading.value = true;
      error.value = null;
    }

    try {
      final useCase = getIt<GetPaginatedAppointmentsUseCase>();
      final result = await useCase(
        GetPaginatedAppointmentsParams(page: currentPage, items: itemsPerPage),
      );

      if (mounted) {
        if (currentPage == 1) {
          appointments.value = result;
        } else {
          appointments.value = [...appointments.value, ...result];
        }

        if (result.length < itemsPerPage) {
          hasMore = false;
        } else {
          currentPage++;
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
      if (metrics.pixels >= metrics.maxScrollExtent * 0.9 &&
          hasMore &&
          !loading.value) {
        fetchAppointments();
      }
    }
    return false;
  }

  Future<void> onAddAppointmentTap(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddAppointmentPage()),
    );

    if (result == true) {
      currentPage = 1;
      hasMore = true;
      await fetchAppointments();
    }
  }

  Future<void> onEditAppointmentTap(
    AppointmentEntity appointment,
    BuildContext context,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddAppointmentPage(appointment: appointment),
      ),
    );

    if (result == true) {
      currentPage = 1;
      hasMore = true;
      await fetchAppointments();
    }
  }
}
