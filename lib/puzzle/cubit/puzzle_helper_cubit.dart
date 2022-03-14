import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../app/cubit/audio_player_cubit.dart';
import '../puzzle.dart';
import '../../puzzle_solver/puzzle_solver.dart';

part 'puzzle_helper_state.dart';

class PuzzleHelperCubit extends Cubit<PuzzleHelperState> {
  int _autoSolverSteps = 0;
  int get autoSolverSteps => _autoSolverSteps;

  late PuzzleSolver _puzzleSolver;

  final AudioPlayerCubit audioPlayerCubit;

  PuzzleHelperCubit(
    PuzzleBloc puzzleBloc,
    this.audioPlayerCubit, {
    final bool optimized = false,
  }) : super(PuzzleHelperState(optimized: optimized)) {
    _puzzleSolver = PuzzleSolver(
      puzzleBloc: puzzleBloc,
      puzzleHelperCubit: this,
    );
  }

  @override
  Future<void> close() {
    _puzzleSolver.stop();
    return super.close();
  }

  void onNewGame() {
    _autoSolverSteps = 0;
  }

  void _start() async {
    // start the solver
    _autoSolverSteps += await _puzzleSolver.start();
  }

  void startAutoSolver() {
    // start auto solver
    _start();

    _puzzleSolver.puzzleBloc.onAutoSolvingStarted();

    // emit state
    emit(state.copyWith(isAutoSolving: true));
  }

  void stopAutoSolver() {
    // we are not immediately emitting state
    // state will be emitted, once auto solver is finished
    // and onAutoSolvingEnded is invoked
    _puzzleSolver.stop();
  }

  void onAutoSolvingEnded() {
    _puzzleSolver.puzzleBloc.onAutoSolvingStopped();

    // emit state
    if (!isClosed) emit(state.copyWith(isAutoSolving: false));
  }

  void onHelpToggle() {
    if (state.showHelp == false) {
      // old state false means, we are going to show help, play audio
      audioPlayerCubit.onVisibilityShown();
    }
    emit(state.copyWith(
      showHelp: !state.showHelp,
    ));
  }
}
