part of 'music_bloc.dart';

class MusicState extends Equatable {
  final bool isMusicEnabled;
  final bool isSoundEffectEnabled;

  const MusicState({
    this.isMusicEnabled = true,
    this.isSoundEffectEnabled = true,
  });

  MusicState copyWith({
    bool? isMusicEnabled,
    bool? isSoundEffectEnabled,
  }) {
    return MusicState(
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
      isSoundEffectEnabled: isSoundEffectEnabled ?? this.isSoundEffectEnabled,
    );
  }

  @override
  List<Object> get props => [isMusicEnabled, isSoundEffectEnabled];
}
