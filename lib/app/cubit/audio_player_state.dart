part of 'audio_player_cubit.dart';

abstract class AudioPlayerState extends Equatable {
  const AudioPlayerState();

  @override
  List<Object> get props => [];
}

class AudioPlayerLoading extends AudioPlayerState {
  const AudioPlayerLoading();
}

class AudioPlayerReady extends AudioPlayerState {
  const AudioPlayerReady();
}
