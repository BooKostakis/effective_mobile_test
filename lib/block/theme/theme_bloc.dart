import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: ThemeData.light())) {
    // Начальная тема - светлая
    on<ThemeChanged>(_onThemeChanged);
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    // Переключаем тему между светлой и темной
    if (state.themeData == ThemeData.light()) {
      emit(ThemeState(themeData: ThemeData.dark()));
    } else {
      emit(ThemeState(themeData: ThemeData.light()));
    }
  }
}
