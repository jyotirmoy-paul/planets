part of 'audio_bloc.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class AudioMusicToggle extends AudioEvent {
  const AudioMusicToggle();
}

class AudioSoundEffectToggle extends AudioEvent {
  const AudioSoundEffectToggle();
}
