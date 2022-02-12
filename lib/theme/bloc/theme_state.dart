part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class NoThemeState extends ThemeState {}

class ThemeSelectedState extends ThemeState {
  final PuzzleTheme theme;

  const ThemeSelectedState({required this.theme});

  ThemeSelectedState copyWith({
    PuzzleTheme? theme,
  }) {
    return ThemeSelectedState(
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object> get props => [theme];
}
