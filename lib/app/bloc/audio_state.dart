part of 'audio_bloc.dart';

class AudioState extends Equatable {
  final bool isMusicEnabled;
  final bool isSoundEffectEnabled;

  const AudioState({
    this.isMusicEnabled = true,
    this.isSoundEffectEnabled = true,
  });

  AudioState copyWith({
    bool? isMusicEnabled,
    bool? isSoundEffectEnabled,
  }) {
    return AudioState(
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
      isSoundEffectEnabled: isSoundEffectEnabled ?? this.isSoundEffectEnabled,
    );
  }

  @override
  List<Object> get props => [isMusicEnabled, isSoundEffectEnabled];
}
