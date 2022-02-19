part of 'audio_control_bloc.dart';

class AudioControlState extends Equatable {
  final bool isMusicEnabled;
  final bool isSoundEffectEnabled;

  const AudioControlState({
    /// default set music to false, due to chrome policy: https://goo.gl/xX8pDD
    this.isMusicEnabled = false,
    this.isSoundEffectEnabled = true,
  });

  AudioControlState copyWith({
    bool? isMusicEnabled,
    bool? isSoundEffectEnabled,
  }) {
    return AudioControlState(
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
      isSoundEffectEnabled: isSoundEffectEnabled ?? this.isSoundEffectEnabled,
    );
  }

  @override
  List<Object> get props => [isMusicEnabled, isSoundEffectEnabled];
}
