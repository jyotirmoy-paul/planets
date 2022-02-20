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
  final _puzzleLevels = PuzzleLevel.values;

  void onNewLevelSelected(PuzzleLevel newLevel) {
    _level = newLevel;
    emit(LevelSelectionState(newLevel));
  }

  void onLevelIncrease() {
    int currentLevel = _puzzleLevels.indexOf(state.level);
    currentLevel = (currentLevel + 1) % _puzzleLevels.length;
    onNewLevelSelected(_puzzleLevels[currentLevel]);
  }

  void onLevelDecrease() {
    int currentLevel = _puzzleLevels.indexOf(state.level);
    currentLevel = (currentLevel - 1) % _puzzleLevels.length;
    onNewLevelSelected(_puzzleLevels[currentLevel]);
  }

  int get puzzleSize => _puzzleSize[_level]!;
}
