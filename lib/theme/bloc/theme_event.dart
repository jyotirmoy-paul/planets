part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeChangedEvent extends ThemeEvent {
  final Planet planet;

  const ThemeChangedEvent({required this.planet});

  @override
  List<Object?> get props => [planet];
}
