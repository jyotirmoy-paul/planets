part of 'puzzle_helper_cubit.dart';

class PuzzleHelperState extends Equatable {
  const PuzzleHelperState({
    this.isAutoSolving = false,
    this.showHelp = false,
    this.optimized = false,
  });

  final bool isAutoSolving;
  final bool showHelp;
  final bool optimized;

  @override
  List<Object> get props => [
        isAutoSolving,
        showHelp,
        optimized,
      ];

  PuzzleHelperState copyWith({
    bool? isAutoSolving,
    bool? showHelp,
    bool? optimized,
  }) {
    return PuzzleHelperState(
      isAutoSolving: isAutoSolving ?? this.isAutoSolving,
      showHelp: showHelp ?? this.showHelp,
      optimized: optimized ?? this.optimized,
    );
  }
}
