import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/puzzle.dart';

part 'level_selection_state.dart';

const Map<PuzzleLevel, int> _puzzleSize = {
  PuzzleLevel.easy: 3,
  PuzzleLevel.medium: 4,
  PuzzleLevel.hard: 5,
};

class LevelSelectionCubit extends Cubit<LevelSelectionState> {
  LevelSelectionCubit() : super(const LevelSelectionState(PuzzleLevel.easy));

  PuzzleLevel _level = PuzzleLevel.easy;

  void onNewLevelSelected(PuzzleLevel newLevel) {
    _level = newLevel;
    emit(LevelSelectionState(newLevel));
  }

  int get puzzleSize => _puzzleSize[_level]!;
}
