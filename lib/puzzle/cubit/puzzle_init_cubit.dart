import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rive/rive.dart';

import '../../puzzles/planet/planet.dart';
import '../../utils/app_logger.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

part 'puzzle_init_state.dart';

class PuzzleInitCubit extends Cubit<PuzzleInitState> {
  final PlanetPuzzleBloc _planetPuzzleBloc;
  final int _puzzleSize;

  int get _lastTileKey => _puzzleSize * _puzzleSize - 1;

  PuzzleInitCubit(this._puzzleSize, this._planetPuzzleBloc)
      : super(const PuzzleInitLoading());

  final Map<int, SimpleAnimation> _riveController = {};

  RiveAnimationController getRiveControllerFor(int tileKey) {
    if (tileKey == 0) {
      // we call this function when we need to load the rive widgets
      emit(const PuzzleInitLoading());
    }

    if (_riveController.containsKey(tileKey)) return _riveController[tileKey]!;

    final controller = SimpleAnimation(
      Utils.planetRotationAnimationName,
      autoplay: false,
    );
    _riveController[tileKey] = controller;

    return controller;
  }

  void _startAnimating() async {
    // for performance reasons
    await Future.delayed(kMS250);

    _riveController.forEach((_, controller) {
      controller.reset();
      if (!controller.isActive) {
        controller.isActive = true;
      }
    });

    if (!isClosed) emit(const PuzzleInitReady());
  }

  void onInit(int tileKey) {
    final hasStarted =
        _planetPuzzleBloc.state.status == PlanetPuzzleStatus.started;

    AppLogger.log('puzzle_init_cubit: onInit: hasStarted: $hasStarted');

    if (tileKey == _lastTileKey) {
      _startAnimating();
    }

    if (hasStarted && tileKey == _lastTileKey - 1) {
      // during the game, if screen is resized
      _startAnimating();
    }
  }
}
