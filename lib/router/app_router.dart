import 'package:effective_mobile/screens/characters_screen.dart';
import 'package:effective_mobile/screens/favorites_screen.dart';
import 'package:effective_mobile/screens/main_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/characters',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(path: '/characters', builder: (context, state) => const CharactersScreen()),
        GoRoute(path: '/favorites', builder: (context, state) => const FavoritesScreen()),
      ],
    ),
  ],
);
