import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewer/views/splash_view.dart';

import 'controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const Passenger(),
  );
}

class Passenger extends StatelessWidget {
  const Passenger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const SplashView(),
        onInit: () async {
          Get.put(AuthController());
        }
    );
  }
}
