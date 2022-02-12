part of 'level_selection_cubit.dart';

class LevelSelectionState extends Equatable {
  final PuzzleLevel level;

  const LevelSelectionState(this.level);

  @override
  List<Object> get props => [level];
}
