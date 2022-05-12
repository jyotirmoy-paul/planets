import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:planets/utils/quick_visit_counter.dart';

import '../../l10n/l10n.dart';
import '../../layout/utils/responsive_layout_builder.dart';
import '../../puzzle/cubit/puzzle_helper_cubit.dart';
import '../../puzzle/cubit/puzzle_init_cubit.dart';
import '../../puzzle/puzzle.dart';
import '../../puzzles/planet/planet.dart';
import '../../timer/timer.dart';
import '../stylized_button.dart';
import '../stylized_container.dart';
import '../stylized_text.dart';

class PuzzleControl extends StatelessWidget {
  const PuzzleControl({Key? key}) : super(key: key);

  void _onStart(BuildContext context, bool hasStarted) {
    context.read<TimerBloc>().add(const TimerReset());
    context.read<PlanetPuzzleBloc>().add(PlanetCountdownReset(
          secondsToBegin: hasStarted ? 5 : 3,
        ));
  }

  void _onAutoSolve(BuildContext context, PuzzleAutoSolveState autoSolveState) {
    if (autoSolveState == PuzzleAutoSolveState.start) {
      QuickVisitCounter.countAutoSolverUsed();
      context.read<PuzzleHelperCubit>().startAutoSolver();
    } else {
      context.read<PuzzleHelperCubit>().stopAutoSolver();
    }
  }

  void _onRestart(BuildContext context) {
    _onStart(context, true);
    context
        .read<PuzzleBloc>()
        .add(const PuzzleInitialized(shufflePuzzle: false));
  }

  @override
  Widget build(BuildContext context) {
    final puzzleInitState =
        context.select((PuzzleInitCubit cubit) => cubit.state);
    final isReady = puzzleInitState is PuzzleInitReady;

    final status = context.select((PlanetPuzzleBloc bloc) => bloc.state.status);
    final hasStarted = status == PlanetPuzzleStatus.started;
    final isLoading = status == PlanetPuzzleStatus.loading;

    final puzzleHelperState =
        context.select((PuzzleHelperCubit cubit) => cubit.state);
    final isAutoSolving = puzzleHelperState.isAutoSolving;

    final text = isAutoSolving
        ? context.l10n.stop
        : !isReady
            ? context.l10n.pleaseWait
            : isLoading
                ? context.l10n.getReady
                : hasStarted
                    ? context.l10n.autoSolve
                    : context.l10n.start;

    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => child!,
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => child!,
      child: (layoutSize) {
        final isLarge = layoutSize == ResponsiveLayoutSize.large;

        return Row(
          key: Key(isLarge.toString()),
          mainAxisSize: MainAxisSize.min,
          children: [
            // auto solve / pause (pause auto solve) / start
            StylizedButton(
              key: Key('puzzle_control_${hasStarted}_${isLoading}_$isReady'),
              onPressed: () {
                if (!isReady || isLoading) return;

                if (hasStarted) {
                  _onAutoSolve(
                    context,
                    isAutoSolving
                        ? PuzzleAutoSolveState.stop
                        : PuzzleAutoSolveState.start,
                  );
                } else {
                  _onStart(context, hasStarted);
                }
              },
              child: StylizedContainer(
                color: isAutoSolving
                    ? Colors.redAccent
                    : !isReady || isLoading
                        ? Colors.grey
                        : Colors.greenAccent,
                child: StylizedText(
                  text: text,
                  fontSize: isLarge ? 24.0 : 20.0,
                ),
              ),
            ),

            isLarge ? const Gap(38.0) : const Gap(32.0),

            // restart
            StylizedButton(
              onPressed: () {
                if (!hasStarted || isAutoSolving) return;
                _onRestart(context);
              },
              child: StylizedContainer(
                color: !hasStarted || isAutoSolving
                    ? Colors.grey
                    : Colors.greenAccent,
                child: StylizedText(
                  text: context.l10n.restart,
                  fontSize: isLarge ? 24.0 : 20.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
