import 'package:effective_mobile/block/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;

  const CustomAppBar({super.key, required this.title, this.centerTitle = true});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Стандартная высота AppBar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.brightness_4),
          onPressed: () {
            BlocProvider.of<ThemeBloc>(context).add(ThemeChanged());
          },
        ),
      ],
    );
  }
}
