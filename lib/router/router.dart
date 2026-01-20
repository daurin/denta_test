import 'package:auto_route/auto_route.dart';
import 'package:denty_cloud_test/modules/auth/presentation/pages/login/login.page.dart';
import 'package:denty_cloud_test/router/middleware/auth.guard.dart';
import 'package:flutter/material.dart';
import 'package:denty_cloud_test/modules/common/presentation/pages/home/home.page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext get navigatorContext => navigatorKey.currentContext!;

String get currentUrl {
  final currentRoute = navigatorContext.router.urlState.url;
  return currentRoute;
}

final autoRoute = RootStackRouter.build(
  navigatorKey: navigatorKey,
  defaultRouteType: const RouteType.material(),
  routes: [
    NamedRouteDef(
      name: LoginPage.routeName,
      initial: false,
      path: '/login',
      guards: [],
      builder: (context, data) {
        return const LoginPage();
      },
    ),
    NamedRouteDef(
      name: HomePage.routeName,
      path: '/home',
      initial: true,
      guards: [authGuard()],
      builder: (context, data) {
        return const HomePage();
      },
    ),
  ],
);
