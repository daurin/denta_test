import 'package:get_it/get_it.dart';
import 'package:denty_cloud_test/modules/auth/domain/repositories/auth.repository.dart';
import 'package:denty_cloud_test/modules/auth/infrastructure/repositories/auth.repository_impl.dart';
import 'package:denty_cloud_test/modules/auth/infrastructure/datasources/auth.datasource.dart';
import 'package:denty_cloud_test/modules/auth/infrastructure/datasources/auth.datasource.impl.dart';
import 'package:denty_cloud_test/modules/auth/domain/use_cases/auth_use_cases.dart';
import 'package:denty_cloud_test/services/local_storage/local_storage.service.dart';
import 'package:denty_cloud_test/services/local_storage/local_storage.service.impl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:denty_cloud_test/modules/appointments/domain/repositories/appointments.repository.dart';
import 'package:denty_cloud_test/modules/appointments/infrastructure/repositories/appointments.repository.impl.dart';
import 'package:denty_cloud_test/modules/appointments/infrastructure/datasources/appointments.datasource.dart';
import 'package:denty_cloud_test/modules/appointments/infrastructure/datasources/appointments.datasource.impl.dart';
import 'package:denty_cloud_test/modules/appointments/domain/use_cases/appointments_use_cases.dart';
import 'package:denty_cloud_test/modules/employees/domain/repositories/employees.repository.dart';
import 'package:denty_cloud_test/modules/employees/infrastructure/repositories/employees.repository.impl.dart';
import 'package:denty_cloud_test/modules/employees/infrastructure/datasources/employees.datasource.dart';
import 'package:denty_cloud_test/modules/employees/infrastructure/datasources/employees.datasource.impl.dart';
import 'package:denty_cloud_test/modules/employees/domain/use_cases/employees_use_cases.dart';
import 'package:denty_cloud_test/modules/patients/domain/repositories/patients.repository.dart';
import 'package:denty_cloud_test/modules/patients/infrastructure/repositories/patients.repository.impl.dart';
import 'package:denty_cloud_test/modules/patients/infrastructure/datasources/patients.datasource.dart';
import 'package:denty_cloud_test/modules/patients/infrastructure/datasources/patients.datasource.impl.dart';
import 'package:denty_cloud_test/modules/patients/domain/use_cases/patients_use_cases.dart';

final getIt = GetIt.instance;

Future<void> initInjector() async {
  // Servicios
  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageServiceImpl('localStorageContainer'),
  );

  // Repositorios
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: getIt(), localStorageService: getIt()),
  );
  getIt.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerLazySingleton<EmployeesRepository>(
    () => EmployeesRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerLazySingleton<PatientsRepository>(
    () => PatientsRepositoryImpl(dataSource: getIt()),
  );

  // Datasources
  getIt.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl());
  getIt.registerLazySingleton<AppointmentsDataSource>(
    () => AppointmentsDataSourceImpl(localStorageService: getIt()),
  );
  getIt.registerLazySingleton<EmployeesDataSource>(
    () => EmployeesDataSourceImpl(localStorageService: getIt()),
  );
  getIt.registerLazySingleton<PatientsDataSource>(
    () => PatientsDataSourceImpl(localStorageService: getIt()),
  );

  // Casos de uso
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<ValidateTokenUseCase>(
    () => ValidateTokenUseCase(getIt()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton<GetPaginatedAppointmentsUseCase>(
    () => GetPaginatedAppointmentsUseCase(getIt()),
  );
  getIt.registerLazySingleton<GetAllAppointmentsUseCase>(
    () => GetAllAppointmentsUseCase(getIt()),
  );
  getIt.registerLazySingleton<GetAppointmentByIdUseCase>(
    () => GetAppointmentByIdUseCase(getIt()),
  );
  getIt.registerLazySingleton<AddAppointmentUseCase>(
    () => AddAppointmentUseCase(getIt()),
  );
  getIt.registerLazySingleton<UpdateAppointmentUseCase>(
    () => UpdateAppointmentUseCase(getIt()),
  );
  getIt.registerLazySingleton<DeleteAppointmentUseCase>(
    () => DeleteAppointmentUseCase(getIt()),
  );
  getIt.registerLazySingleton<GetPaginatedEmployeesUseCase>(
    () => GetPaginatedEmployeesUseCase(getIt()),
  );
  getIt.registerLazySingleton<GetAllEmployeesUseCase>(
    () => GetAllEmployeesUseCase(getIt()),
  );
  getIt.registerLazySingleton<AddEmployeeUseCase>(
    () => AddEmployeeUseCase(getIt()),
  );
  getIt.registerLazySingleton<UpdateEmployeeUseCase>(
    () => UpdateEmployeeUseCase(getIt()),
  );
  getIt.registerLazySingleton<DeleteEmployeeUseCase>(
    () => DeleteEmployeeUseCase(getIt()),
  );
  getIt.registerLazySingleton<GetPaginatedPatientsUseCase>(
    () => GetPaginatedPatientsUseCase(getIt()),
  );
  getIt.registerLazySingleton<GetAllPatientsUseCase>(
    () => GetAllPatientsUseCase(getIt()),
  );
  getIt.registerLazySingleton<AddPatientUseCase>(
    () => AddPatientUseCase(getIt()),
  );
  getIt.registerLazySingleton<UpdatePatientUseCase>(
    () => UpdatePatientUseCase(getIt()),
  );
  getIt.registerLazySingleton<DeletePatientUseCase>(
    () => DeletePatientUseCase(getIt()),
  );

  // Inicializar librerías o servicios adicionales si es necesario
  await GetStorage.init('localStorageContainer');
}
