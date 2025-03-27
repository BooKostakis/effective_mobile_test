part of 'characters_bloc.dart';

abstract class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object> get props => [];
}

class LoadCharacters extends CharactersEvent {}

class LoadMoreCharacters extends CharactersEvent {
  final BuildContext context;

  const LoadMoreCharacters(this.context);

  @override
  List<Object> get props => [context];
}

class ClearError extends CharactersEvent {
  const ClearError();
}

class ToggleFavorite extends CharactersEvent {
  // Добавляем событие для переключения избранного
  final Character character;

  const ToggleFavorite(this.character);

  @override
  List<Object> get props => [character];
}
