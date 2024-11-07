import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/config/routes.dart';
import 'core/config/theme.dart';
import 'core/utils/methodes.dart';
import 'view/screen/details.dart';
import 'view/screen/home.dart';

void main() async {
  await initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      themeMode: AppTheme().instance.themeMode,
      theme: AppTheme().instance.theme,
      darkTheme: AppTheme().instance.darkTheme,
      initialRoute: Routes.home,
      getPages: [
        GetPage(name: Routes.home, page: () => Home()),
        GetPage(name: Routes.details, page: () => Details()),
      ],
    );
  }
}
