part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final PuzzleTheme theme;

  const ThemeState({required this.theme});

  ThemeState copyWith({
    PuzzleTheme? theme,
  }) {
    return ThemeState(
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object> get props => [theme];
}
