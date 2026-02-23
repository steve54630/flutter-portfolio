import 'package:flutter/material.dart';
import 'package:portfolio_steve/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Steve Retournay - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent,
          surface: Color(0xFF0D0D0D),
          brightness: Brightness
              .dark, // Un portfolio de dev est souvent mieux en dark mode
        ),
        scaffoldBackgroundColor: Color(0xFF0D0D0D),
        // On pourra extraire ça dans un dossier presentation/theme plus tard
      ),
      routerConfig: appRouter,
    );
  }
}
