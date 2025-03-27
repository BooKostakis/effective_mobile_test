import 'package:effective_mobile/models/character.dart';
import 'package:effective_mobile/services/api_service.dart';
import 'package:effective_mobile/services/cache_service.dart';
import 'package:effective_mobile/widgets/custom_snack_bar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:effective_mobile/services/favorites_service.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final ApiService apiService;
  final CacheService cacheService;
  final FavoritesService favoritesService;

  CharactersBloc({required this.apiService, required this.cacheService, required this.favoritesService})
    : super(const CharactersState(characters: [], isLoading: false, error: null, page: 1)) {
    on<LoadCharacters>(_onLoadCharacters);
    on<LoadMoreCharacters>(_onLoadMoreCharacters);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadCharacters(LoadCharacters event, Emitter<CharactersState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // 1. Пытаемся загрузить данные из кеша
      final cachedData = await cacheService.getCharacters();
      final cachedCharacters = cachedData.characters;
      final cachedPage = cachedData.page;

      // 2. Если данные есть в кеше, отображаем их и прекращаем дальнейшую загрузку
      if (cachedCharacters.isNotEmpty) {
        // Get favorites and update characters
        final favorites = await favoritesService.getFavorites();
        final updatedCharacters =
            cachedCharacters.map((character) {
              final isFavorite = favorites.any((fav) => fav.id == character.id);
              return character.copyWith(isFavorite: isFavorite);
            }).toList();

        emit(
          state.copyWith(characters: updatedCharacters, isLoading: false, error: null, page: 2),
        ); // Always start from page 2
        return; // Прекращаем выполнение функции
      }

      // 3. Если в кеше нет данных, проверяем наличие интернет-соединения
      final connectivityResult = await (Connectivity().checkConnectivity());
      bool isOnline = connectivityResult != ConnectivityResult.none;

      if (isOnline) {
        try {
          // 4. Загружаем данные из API
          final characters = await apiService.getCharacters(page: 1); // Always start from page 1
          // Get favorites and update characters
          final favorites = await favoritesService.getFavorites();
          final updatedCharacters =
              characters.map((character) {
                final isFavorite = favorites.any((fav) => fav.id == character.id);
                return character.copyWith(isFavorite: isFavorite);
              }).toList();

          emit(
            state.copyWith(characters: updatedCharacters, isLoading: false, error: null, page: 2),
          ); // Always start from page 2

          // 5. Сохраняем данные в кеш
          await cacheService.saveCharacters(characters, 2);
        } catch (apiError) {
          // 6. Обрабатываем ошибку загрузки из API
          print('API Error: $apiError');
          emit(
            state.copyWith(
              isLoading: false,
              error:
                  'Нет подключения к серверу, проверьте подключение к интернету или попробуйте подключиться позднее.',
            ),
          );
        }
      } else {
        // 7. Если нет соединения и в кеше нет данных, отображаем ошибку
        emit(
          state.copyWith(
            isLoading: false,
            error:
                'Похоже вы зашли в приложение первый раз. Для первого использования необходимо подключение к интенету, пожалуйста, проверьте подключение к интернету или попробуйте подключиться позднее.',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMoreCharacters(LoadMoreCharacters event, Emitter<CharactersState> emit) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    try {
      // Проверяем подключение к интернету
      final connectivityResult = await (Connectivity().checkConnectivity());
      bool isOnline = connectivityResult != ConnectivityResult.none;

      if (isOnline) {
        try {
          final characters = await apiService.getCharacters(page: state.page);

          // Get favorites and update characters
          final favorites = await favoritesService.getFavorites();
          final updatedCharacters =
              characters.map((character) {
                final isFavorite = favorites.any((fav) => fav.id == character.id);
                return character.copyWith(isFavorite: isFavorite);
              }).toList();

          final newCharacters = List<Character>.from(state.characters)..addAll(updatedCharacters);
          emit(state.copyWith(characters: newCharacters, isLoading: false, error: null, page: state.page + 1));

          // Сохраняем данные в кеш
          await cacheService.saveCharacters(characters, 2);
        } catch (apiError) {
          // Обрабатываем ошибку загрузки из API
          print('API Error: $apiError');
          CustomSnackBar.show(
            event.context,
            'Нет подключения к серверу, проверьте подключение к интернету или попробуйте подключиться позднее.',
          ); // Используем CustomSnackBar
          emit(state.copyWith(isLoading: false)); // Сбрасываем isLoading
        }
      } else {
        // Если нет соединения, отображаем сообщение
        CustomSnackBar.show(event.context, 'Проверьте подключение к интернету'); // Используем CustomSnackBar
        emit(state.copyWith(isLoading: false)); // Сбрасываем isLoading
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<CharactersState> emit) async {
    await favoritesService.toggleFavorite(event.character); // Toggle favorite in FavoritesService

    // Update the specific character in the list
    final updatedCharacters =
        state.characters.map((character) {
          if (character.id == event.character.id) {
            return character.copyWith(isFavorite: !character.isFavorite); // Toggle the isFavorite property
          }
          return character;
        }).toList();

    emit(state.copyWith(characters: updatedCharacters));
  }
}
