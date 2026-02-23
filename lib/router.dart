import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_steve/presentation/pages/error.page.dart';
import 'package:portfolio_steve/presentation/pages/home.page.dart';
import 'package:portfolio_steve/presentation/widgets/background.widget.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => ErrorPage(error: state.error),
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // On force l'application du thème global ici pour corriger la couleur/police
        return Theme(
          data: Theme.of(context),
          child: Scaffold(
            backgroundColor: const Color(0xFF0D0D0D),
            body: Stack(
              children: [
                const RepaintBoundary(child: ParticleBackground()),
                // KeyedSubtree avec ValueKey règle l'erreur "Multiple widgets used the same GlobalKey"
                KeyedSubtree(key: ValueKey(state.uri.toString()), child: child),
              ],
            ),
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
      ],
    ),
  ],
);
