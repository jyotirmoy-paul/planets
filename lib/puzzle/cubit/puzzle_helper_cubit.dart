import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planets/puzzle/puzzle.dart';
import 'package:planets/puzzle_solver/puzzle_solver.dart';

part 'puzzle_helper_state.dart';

class PuzzleHelperCubit extends Cubit<PuzzleHelperState> {
  int _autoSolverSteps = 0;
  int get autoSolverSteps => _autoSolverSteps;

  late PuzzleSolver _puzzleSolver;

  PuzzleHelperCubit(PuzzleBloc puzzleBloc) : super(const PuzzleHelperState()) {
    _puzzleSolver = PuzzleSolver(
      puzzleBloc: puzzleBloc,
      puzzleHelperCubit: this,
    );
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

    // emit state
    emit(state.copyWith(
      isAutoSolving: true,
    ));
  }

  void stopAutoSolver() {
    // we are not immediately emiting state
    // state will be emited, once auto solver is finished
    // and onAutoSolvingEnded is invoked
    _puzzleSolver.stop();
  }

  void onAutoSolvingEnded() {
    // emit state
    emit(state.copyWith(
      isAutoSolving: false,
    ));
  }

  void onShowHelp() {
    emit(state.copyWith(
      showHelp: true,
    ));
  }

  void onHideHelp() {
    emit(state.copyWith(
      isAutoSolving: false,
    ));
  }
}
