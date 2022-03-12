import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

import '../../helpers/audio_player.dart';
import '../../resource/app_assets.dart';
import '../../utils/app_logger.dart';
import '../../utils/constants.dart';
import '../bloc/audio_control_bloc.dart';

part 'audio_player_state.dart';

const _maxThemeVolume = 0.30;
const _clickVolume = 0.80;
const _visibilityVolume = 0.30;
const _countDownVolume = 0.30;
const _tapVolume = 0.40;
const _completionVolume = 0.70;

// max size allowed is 5x5
const _maxTiles = 25;

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioControlBloc _audioBloc;

  // audio players
  // theme music player
  final AudioPlayer _themeMusicPlayer = getAudioPlayer();

  // button click player
  final AudioPlayer _buttonClickPlayer = getAudioPlayer();

  // visibility player
  final AudioPlayer _visibility = getAudioPlayer();

  // count down begin player
  final AudioPlayer _countDownBeginPlayer = getAudioPlayer();

  // completion player
  final AudioPlayer _completionPlayer = getAudioPlayer();

  // tile tap player
  final Map<int, AudioPlayer> _tileTapSuccess = {};
  final Map<int, AudioPlayer> _tileTapError = {};
  // final AudioPlayer _tileTapPlayerSuccess = getAudioPlayer();
  // final AudioPlayer _tileTapPlayerError = getAudioPlayer();

  Timer? _timer;

  AudioPlayerCubit(this._audioBloc) : super(const AudioPlayerLoading()) {
    _init();
  }

  void _init() {
    // do audio initializations after showing loading screen
    // to avoid freeze screen
    _timer = Timer(kMS200, () async {
      // theme music setup
      await _themeMusicPlayer.setAsset(AppAssets.planetThemeMusic);
      await _themeMusicPlayer.setLoopMode(LoopMode.one);
      await _themeMusicPlayer.setVolume(_maxThemeVolume);

      // after the large part of audio is loaded, we can emit audio player ready,
      // the web app won't freeze the UI anymore - for these small audio files
      emit(const AudioPlayerReady());

      // button click
      await _buttonClickPlayer.setAsset(AppAssets.buttonClick);
      await _buttonClickPlayer.setVolume(_clickVolume);

      // button click
      await _visibility.setAsset(AppAssets.visibility);
      await _visibility.setVolume(_visibilityVolume);

      // count down begin
      await _countDownBeginPlayer.setAsset(AppAssets.countDownBegin);
      await _countDownBeginPlayer.setVolume(_countDownVolume);

      // completion
      await _completionPlayer.setAsset(AppAssets.completion);
      await _completionPlayer.setVolume(_completionVolume);

      // tile tap
      for (int i = 0; i < _maxTiles; i++) {
        // tile tap success
        final tileTapSuccess = getAudioPlayer();
        await tileTapSuccess.setAsset(AppAssets.tileTapSuccess);
        await tileTapSuccess.setVolume(_tapVolume);
        _tileTapSuccess[i] = tileTapSuccess;

        // tile tap error
        final tileTapError = getAudioPlayer();
        await tileTapError.setAsset(AppAssets.tileTapError);
        await tileTapError.setVolume(_tapVolume);
        _tileTapError[i] = tileTapError;
      }
    });

    _audioBloc.stream.listen(_onAudioControlStateChanged);
  }

  void onBackToSolarSystem() {
    // stop count down sound effect
    _countDownBeginPlayer.stop();

    // visibility sound effect
    _visibility.stop();
  }

  void playThemeMusic() {
    unawaited(_themeMusicPlayer.play());
  }

  void _onAudioControlStateChanged(AudioControlState audioControlState) {
    // sound effect related settings
    // count down sound effect
    if (audioControlState.isSoundEffectEnabled) {
      _countDownBeginPlayer.setVolume(_countDownVolume);
    } else {
      _countDownBeginPlayer.setVolume(0.0);
    }

    // music related settings
    // app theme music
    if (audioControlState.isMusicEnabled) {
      _themeMusicPlayer.setVolume(_maxThemeVolume);
    } else {
      _themeMusicPlayer.setVolume(0.0);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _themeMusicPlayer.dispose();
    _buttonClickPlayer.dispose();
    _tileTapSuccess.forEach((_, audioPlayer) => audioPlayer.dispose());
    _tileTapError.forEach((_, audioPlayer) => audioPlayer.dispose());
    return super.close();
  }

  bool get _isSoundEffectEnabled => _audioBloc.state.isSoundEffectEnabled;

  // public methods

  void tileTappedAudio(int tileValue, {isError = false}) {
    AppLogger.log('AudioPlayerCubit :: tileTappedAudio');
    if (!_isSoundEffectEnabled) return;
    if (isError) {
      unawaited(_tileTapError[tileValue]!.replay());
    } else {
      unawaited(_tileTapSuccess[tileValue]!.replay());
    }
  }

  void buttonClickAudio() {
    if (_isSoundEffectEnabled) unawaited(_buttonClickPlayer.replay());
  }

  void beginCountDown() {
    unawaited(_countDownBeginPlayer.replay());
  }

  void onVisibilityShown() {
    if (_isSoundEffectEnabled) unawaited(_visibility.replay());
  }

  void completion() {
    if (_isSoundEffectEnabled) unawaited(_completionPlayer.replay());
  }
}
