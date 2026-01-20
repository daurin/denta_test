import 'package:auto_route/auto_route.dart';
import 'package:denty_cloud_test/injector.dart';
import 'package:denty_cloud_test/modules/auth/domain/use_cases/auth_use_cases.dart';
import 'package:denty_cloud_test/modules/auth/presentation/pages/login/login.page.dart';
import 'package:denty_cloud_test/modules/common/presentation/pages/home/home.page.dart';
import 'package:flutter/material.dart';

mixin LoginPageController on State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    obscurePasswordNotifier.dispose();
    super.dispose();
  }

  void toggleObscurePassword() {
    obscurePasswordNotifier.value = !obscurePasswordNotifier.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese su correo';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
      return 'Correo no válido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese su contraseña';
    }
    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }
    return null;
  }

  Future<void> login(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      final loginUseCase = getIt<LoginUseCase>();
      try {
        await loginUseCase.call(
          LoginParams(
            email: emailController.text,
            password: passwordController.text,
          ),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login exitoso')));
          context.router.replaceAll([NamedRoute(HomePage.routeName)]);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    }
  }
}
