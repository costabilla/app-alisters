import 'package:flutter/material.dart';

import 'features/auth/presentation/login_page.dart';

class AlistersApp extends StatelessWidget {
  const AlistersApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Alisters Campo',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff155b4b)),
      scaffoldBackgroundColor: const Color(0xfff3f6f1),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: const Login(),
  );
}
