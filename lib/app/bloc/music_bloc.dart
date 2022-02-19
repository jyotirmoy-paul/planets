import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:planets/resource/app_assets.dart';

import '../../helpers/audio_player.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc()
      : _audioPlayer = getAudioPlayer(),
        super(const MusicState()) {
    on<MusicToggle>(_onMusicToggle);
    on<SoundEffectToggle>(_onSoundEffectToggle);
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

  void _onMusicToggle(MusicToggle _, Emitter<MusicState> emit) {
    final newIsMusicEnabled = !state.isMusicEnabled;
    _audioPlayer.setVolume(newIsMusicEnabled ? _maxThemeVolume : 0.0);
    emit(state.copyWith(
      isMusicEnabled: newIsMusicEnabled,
    ));
  }

  void _onSoundEffectToggle(SoundEffectToggle _, Emitter<MusicState> emit) {
    emit(state.copyWith(
      isSoundEffectEnabled: !state.isSoundEffectEnabled,
    ));
  }
}
