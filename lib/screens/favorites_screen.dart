import 'package:effective_mobile/models/character.dart';
import 'package:effective_mobile/services/favorites_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:effective_mobile/block/characters/characters_bloc.dart';

enum SortType { nameAsc, nameDesc, speciesAsc, speciesDesc }

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  SortType _sortType = SortType.nameAsc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Избранные персонажи')),
      body: SafeArea(
        minimum: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButton<SortType>(
              value: _sortType,
              onChanged: (SortType? newValue) {
                setState(() {
                  _sortType = newValue!;
                });
              },
              items: const [
                DropdownMenuItem(value: SortType.nameAsc, child: Text('Сортировка по имени (A-Z)')),
                DropdownMenuItem(value: SortType.nameDesc, child: Text('Сортировка по имени (Z-A)')),
                DropdownMenuItem(value: SortType.speciesAsc, child: Text('Сортировкапо виду (A-Z)')),
                DropdownMenuItem(value: SortType.speciesDesc, child: Text('Сортировкапо виду (Z-A)')),
              ],
            ),
            Expanded(
              child: BlocBuilder<CharactersBloc, CharactersState>(
                builder: (context, state) {
                  // Get the favorite characters directly from the state
                  List<Character> favoriteCharacters =
                      state.characters.where((character) => character.isFavorite).toList();

                  // Sort the favorite characters based on the selected sort type
                  switch (_sortType) {
                    case SortType.nameAsc:
                      favoriteCharacters.sort((a, b) => a.name.compareTo(b.name));
                      break;
                    case SortType.nameDesc:
                      favoriteCharacters.sort((a, b) => b.name.compareTo(a.name));
                      break;
                    case SortType.speciesAsc:
                      favoriteCharacters.sort((a, b) => a.species.compareTo(b.species));
                      break;
                    case SortType.speciesDesc:
                      favoriteCharacters.sort((a, b) => b.species.compareTo(a.species));
                      break;
                  }

                  if (favoriteCharacters.isEmpty) {
                    return const Center(child: Text('У вас пока нет избранных персонажей.'));
                  }

                  return ListView.builder(
                    itemCount: favoriteCharacters.length,
                    itemBuilder: (context, index) {
                      final character = favoriteCharacters[index];
                      return Card(
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                          child: ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: character.image,
                              placeholder: (context, url) => Container(color: Colors.blueGrey),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(character.name),
                            subtitle: Text(character.species),
                            trailing: IconButton(
                              icon: Icon(size: 30, Icons.star, color: Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                context.read<CharactersBloc>().add(ToggleFavorite(character));
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
