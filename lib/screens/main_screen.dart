import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // Отображаем переданный child (текущий экран)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Персонажи'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Избранные'),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int index) {
          _onItemTapped(index, context);
        },
      ),
    );
  }

  // Определяем индекс выбранной вкладки на основе текущего маршрута
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/characters')) {
      return 0;
    }
    if (location.startsWith('/favorites')) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/characters');
        break;
      case 1:
        GoRouter.of(context).go('/favorites');
        break;
    }
  }
}
