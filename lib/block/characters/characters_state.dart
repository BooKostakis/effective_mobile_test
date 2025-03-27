part of 'characters_bloc.dart';

class CharactersState extends Equatable {
  final List<Character> characters;
  final bool isLoading;
  final String? error;
  final int page; // Добавляем номер текущей страницы

  const CharactersState({required this.characters, required this.isLoading, this.error, required this.page});

  @override
  List<Object?> get props => [characters, isLoading, error, page];

  CharactersState copyWith({List<Character>? characters, bool? isLoading, String? error, int? page}) {
    return CharactersState(
      characters: characters ?? this.characters,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      page: page ?? this.page,
    );
  }
}
