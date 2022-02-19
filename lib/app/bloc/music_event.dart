part of 'music_bloc.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object> get props => [];
}

class MusicToggle extends MusicEvent {
  const MusicToggle();
}

class SoundEffectToggle extends MusicEvent {
  const SoundEffectToggle();
}
