import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertest/src/core/services/dependency_injection.dart';
import 'package:fluttertest/src/features/app.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
      // GetMaterialApp(home:
      App()
      // )
      );
  DependencyInjection.init();
}
