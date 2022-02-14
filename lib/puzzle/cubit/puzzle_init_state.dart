part of 'puzzle_init_cubit.dart';

abstract class PuzzleInitState extends Equatable {
  const PuzzleInitState();

  @override
  List<Object> get props => [];
}

class PuzzleInitLoading extends PuzzleInitState {
  const PuzzleInitLoading();
}

class PuzzleInitReady extends PuzzleInitState {
  const PuzzleInitReady();
}
