part of 'audio_control_bloc.dart';

abstract class AudioControlEvent extends Equatable {
  const AudioControlEvent();

  @override
  List<Object> get props => [];
}

class AudioControlMusicToggle extends AudioControlEvent {
  const AudioControlMusicToggle();
}

class AudioControlSoundEffectToggle extends AudioControlEvent {
  const AudioControlSoundEffectToggle();
}
