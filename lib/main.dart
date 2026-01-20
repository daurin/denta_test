import 'package:denty_cloud_test/app.dart';
import 'package:denty_cloud_test/injector.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Iniciar dependencias
  await initInjector();

  runApp(const MainApp());
}
