import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/puzzle.dart';

part 'level_selection_state.dart';

class LevelSelectionCubit extends Cubit<LevelSelectionState> {
  LevelSelectionCubit() : super(const LevelSelectionState(PuzzleLevel.easy));

  void onNewLevelSelected(PuzzleLevel newLevel) {
    emit(LevelSelectionState(newLevel));
  }
}
