import 'package:flutter/material.dart';
import 'package:tracker_app/auth/login.dart';
import 'package:tracker_app/home_screen.dart';
import 'package:get/get.dart';

import 'auth/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
