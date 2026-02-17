import 'package:go_router/go_router.dart';
import 'package:portfolio_steve/presentation/pages/error.page.dart';
import 'package:portfolio_steve/presentation/pages/home.page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => ErrorPage(error: state.error),
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
