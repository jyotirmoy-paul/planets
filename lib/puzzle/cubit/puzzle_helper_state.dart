part of 'puzzle_helper_cubit.dart';

class PuzzleHelperState extends Equatable {
  const PuzzleHelperState({
    this.isAutoSolving = false,
    this.showHelp = false,
  });

  final bool isAutoSolving;
  final bool showHelp;

  @override
  List<Object> get props => [
        isAutoSolving,
        showHelp,
      ];

  PuzzleHelperState copyWith({
    bool? isAutoSolving,
    bool? showHelp,
  }) {
    return PuzzleHelperState(
      isAutoSolving: isAutoSolving ?? this.isAutoSolving,
      showHelp: showHelp ?? this.showHelp,
    );
  }
}