import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:planets/app/bloc/audio_control_bloc.dart';
import 'package:planets/helpers/audio_player.dart';
import 'package:planets/resource/app_assets.dart';
import 'package:planets/utils/app_logger.dart';

part 'audio_player_state.dart';

const _maxThemeVolume = 0.15;
const _clickVolume = 0.80;
const _tapVolume = 0.60;

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioControlBloc _audioBloc;

  // audioplayers
  // theme music player
  final AudioPlayer _themeMusicPlayer = getAudioPlayer();

  // button click player
  final AudioPlayer _buttonClickPlayer = getAudioPlayer();

  // tile tap player
  final AudioPlayer _tileTapPlayerSuccess = getAudioPlayer();
  final AudioPlayer _tileTapPlayerError = getAudioPlayer();

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

      // button click
      await _buttonClickPlayer.setAsset(AppAssets.buttonClick);
      await _buttonClickPlayer.setVolume(_clickVolume);

      // tile tap success
      await _tileTapPlayerSuccess.setAsset(AppAssets.tileTapSuccess);
      await _tileTapPlayerSuccess.setVolume(_tapVolume);

      // tile tap error
      await _tileTapPlayerError.setAsset(AppAssets.tileTapError);
      await _tileTapPlayerError.setVolume(_tapVolume);

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
    _tileTapPlayerSuccess.dispose();
    _tileTapPlayerError.dispose();
    return super.close();
  }

  bool get _isSoundEffectEnabled => _audioBloc.state.isSoundEffectEnabled;

  // public methods

  void tileTappedAudio({isError = false}) {
    AppLogger.log('AudioPlayerCubit :: tileTappedAudio');
    if (!_isSoundEffectEnabled) return;
    if (isError) {
      unawaited(_tileTapPlayerError.replay());
    } else {
      unawaited(_tileTapPlayerSuccess.replay());
    }
  }

  void buttonClickAudio() {
    if (_isSoundEffectEnabled) unawaited(_buttonClickPlayer.replay());
  }
}
