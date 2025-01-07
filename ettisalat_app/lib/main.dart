import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_routes.dart';

void main() {
  runApp(const EttisalatApp());
}

class EttisalatApp extends StatelessWidget {
  const EttisalatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ettisalat App',
      theme: ThemeData(
          // primarySwatch: Colors.deepOrange,
          textTheme: GoogleFonts.tajawalTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            primary: Colors.blue,
          )),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.HOME,
      getPages: AppRoutes.routes,
    );
  }
}
