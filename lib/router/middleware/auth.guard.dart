import 'package:auto_route/auto_route.dart';
import 'package:denty_cloud_test/injector.dart';
import 'package:denty_cloud_test/modules/auth/domain/use_cases/auth_use_cases.dart';
import 'package:denty_cloud_test/modules/auth/presentation/pages/login/login.page.dart';
import 'package:denty_cloud_test/services/local_storage/local_storage.service.dart';

AutoRouteGuard authGuard() {
  return AutoRouteGuard.simple((resolver, stackrouter) async {
    final localStorageService = getIt<LocalStorageService>();
    final validateTokenUseCase = getIt<ValidateTokenUseCase>();

    try {
      final token = localStorageService.getValue('auth_token');

      if (token == null || token.isEmpty) {
        resolver.redirectUntil(NamedRoute(LoginPage.routeName));
        return;
      }

      final isValid = await validateTokenUseCase(token);

      if (!isValid) {
        resolver.redirectUntil(NamedRoute(LoginPage.routeName));
        return;
      }

      resolver.next();
    } catch (e) {
      resolver.redirectUntil(NamedRoute(LoginPage.routeName));
    }
  });
}
