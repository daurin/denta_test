import 'package:auto_route/auto_route.dart';
import 'package:denty_cloud_test/injector.dart';
import 'package:denty_cloud_test/modules/auth/domain/use_cases/auth_use_cases.dart';
import 'package:denty_cloud_test/modules/auth/presentation/pages/login/login.page.dart';
import 'package:denty_cloud_test/modules/common/presentation/pages/home/home.page.dart';
import 'package:flutter/material.dart';

mixin HomePageController on State<HomePage> {
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    selectedIndexNotifier.dispose();
    super.dispose();
  }

  void onDestinationSelected(int index) {
    selectedIndexNotifier.value = index;
  }

  Future<void> logout() async {
    await getIt<LogoutUseCase>().call();
    if (!mounted) return;
    context.router.replaceAll([NamedRoute(LoginPage.routeName)]);
  }
}
