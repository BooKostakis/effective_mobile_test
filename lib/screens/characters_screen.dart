import 'package:effective_mobile/block/characters/characters_bloc.dart';
import 'package:effective_mobile/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:effective_mobile/models/character.dart'; // Импортируем модель Character

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersBloc>(context).add(LoadCharacters());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CharactersBloc>().add(LoadMoreCharacters(context)); // Передаем context
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll == maxScroll;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Список персонажей'),
      body: SafeArea(
        minimum: const EdgeInsets.all(24.0),
        child: BlocBuilder<CharactersBloc, CharactersState>(
          builder: (context, state) {
            if (state.isLoading && state.characters.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.characters.length + (state.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.characters.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final character = state.characters[index];
                  return Card(
                    elevation: 2.0, // Небольшая тень
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
                          icon: Icon(
                            size: 30,
                            character.isFavorite ? Icons.star : Icons.star_border,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            context.read<CharactersBloc>().add(
                              ToggleFavorite(character),
                            ); // Отправляем событие ToggleFavorite
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
