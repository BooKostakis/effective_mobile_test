import 'package:effective_mobile/block/characters/characters_bloc.dart';
import 'package:effective_mobile/block/theme/theme_bloc.dart';
import 'package:effective_mobile/router/app_router.dart';
import 'package:effective_mobile/services/api_service.dart';
import 'package:effective_mobile/services/cache_service.dart';
import 'package:effective_mobile/services/favorites_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(
          create:
              (context) => CharactersBloc(
                apiService: ApiService(),
                cacheService: CacheService(),
                favoritesService: FavoritesService(),
              ),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Effective Mobile test',
          theme: state.themeData,
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        );
      },
    );
  }
}
