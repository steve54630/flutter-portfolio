import 'package:flutter/material.dart';
import 'package:portfolio_steve/presentation/pages/home.page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steve Retournay - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent,
          brightness: Brightness
              .light, // Un portfolio de dev est souvent mieux en dark mode
        ),
        // On pourra extraire ça dans un dossier presentation/theme plus tard
      ),
      home: const HomePage(),
    );
  }
}
