import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:planets/app/bloc/audio_control_bloc.dart';
import 'package:planets/helpers/audio_player.dart';
import 'package:planets/resource/app_assets.dart';

part 'audio_player_state.dart';

const _maxThemeVolume = 0.15;
const _clickVolume = 0.50;

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioControlBloc _audioBloc;

  // audioplayers
  // theme music player
  final AudioPlayer _themeMusicPlayer = getAudioPlayer();

  // button click player
  final AudioPlayer _buttonClickPlayer = getAudioPlayer();

  // tile tap player
  final AudioPlayer _tileTapPlayer = getAudioPlayer();

  Timer? _timer;

  AudioPlayerCubit(this._audioBloc) : super(const AudioPlayerLoading()) {
    _init();
  }

  void _init() {
    // do audio initializations after showing loading screen
    // to avoid freeze screen
    _timer = Timer(const Duration(milliseconds: 500), () async {
      // theme music setup
      await _themeMusicPlayer.setAsset(AppAssets.planetThemeMusic);
      await _themeMusicPlayer.setLoopMode(LoopMode.one);
      await _themeMusicPlayer.setVolume(_maxThemeVolume);

      // button & tile clicks
      await _buttonClickPlayer.setAsset(AppAssets.buttonClick);
      await _buttonClickPlayer.setVolume(_clickVolume);
      
      // todo: setAsset for tile tapped

      emit(const AudioPlayerReady());
    });

    _audioBloc.stream.listen(_onAudioControlStateChanged);
  }

  bool _themeMusicInitialized = false;

  void _onAudioControlStateChanged(AudioControlState audioControlState) {
    if (audioControlState.isMusicEnabled) {
      if (_themeMusicInitialized == false) {
        unawaited(_themeMusicPlayer.play());
        _themeMusicInitialized = true;
      } else {
        _themeMusicPlayer.setVolume(_maxThemeVolume);
      }
    } else {
      _themeMusicPlayer.setVolume(0.0);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _themeMusicPlayer.dispose();
    _buttonClickPlayer.dispose();
    _tileTapPlayer.dispose();
    return super.close();
  }

  bool get _isSoundEffectEnabled => _audioBloc.state.isSoundEffectEnabled;

  // public methods

  void tileTappedAudio() {
    // todo do this
  }

  void buttonClickAudio() {
    if (_isSoundEffectEnabled) unawaited(_buttonClickPlayer.replay());
  }
}
