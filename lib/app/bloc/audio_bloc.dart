import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:planets/resource/app_assets.dart';

import '../../helpers/audio_player.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  AudioBloc()
      : _audioPlayer = getAudioPlayer(),
        super(const AudioState()) {
    on<AudioMusicToggle>(_onMusicToggle);
    on<AudioSoundEffectToggle>(_onSoundEffectToggle);
    _initAudioAsset();
  }

  final AudioPlayer _audioPlayer;

  static const _maxThemeVolume = 0.10;

  /// this only takes care of the theme music
  void _initAudioAsset() async {
    // performance reason
    await Future.delayed(const Duration(milliseconds: 500));
    await _audioPlayer.setAsset(AppAssets.planetThemeMusic);
    await _audioPlayer.setLoopMode(LoopMode.one);
    await _audioPlayer.setVolume(_maxThemeVolume);
    unawaited(_audioPlayer.play());
  }

  void _onMusicToggle(AudioMusicToggle _, Emitter<AudioState> emit) {
    final newIsMusicEnabled = !state.isMusicEnabled;
    _audioPlayer.setVolume(newIsMusicEnabled ? _maxThemeVolume : 0.0);
    emit(state.copyWith(
      isMusicEnabled: newIsMusicEnabled,
    ));
  }

  void _onSoundEffectToggle(AudioSoundEffectToggle _, Emitter<AudioState> emit) {
    emit(state.copyWith(
      isSoundEffectEnabled: !state.isSoundEffectEnabled,
    ));
  }
}
