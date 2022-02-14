import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planets/utils/app_logger.dart';
import 'package:rive/rive.dart';

part 'puzzle_init_state.dart';

class PuzzleInitCubit extends Cubit<PuzzleInitState> {
  final int _puzzleSize;

  // -1 because we do not show the last tile
  int get _noTiles => _puzzleSize * _puzzleSize - 1;

  PuzzleInitCubit(this._puzzleSize) : super(const PuzzleInitLoading());

  final Map<int, RiveAnimationController> _riveController = {};
  int _instanceInited = 0;

  RiveAnimationController getRiveControllerFor(int tileKey) {
    if (tileKey == 0) {
      // we call this function when we need to load the rive widgets
      emit(const PuzzleInitLoading());
    }
    final controller = SimpleAnimation('Animation 1', autoplay: false);
    _riveController[tileKey] = controller;
    return controller;
  }

  void _startAnimating() async {
    // for performance reasons
    await Future.delayed(const Duration(milliseconds: 100));

    _riveController.forEach((_, controller) {
      controller.isActive = true;
    });

    emit(const PuzzleInitReady());
  }

  void onInit(_) {
    _instanceInited += 1;
    AppLogger.log('_instanceInited: $_instanceInited / out of $_noTiles');
    if (_instanceInited == _noTiles) {
      _startAnimating();
    } else if (_instanceInited == _noTiles + 1) {
      AppLogger.log('PuzzleInitCubit : puzzle re-initializing');
      _instanceInited = 1;
    }
  }
}
