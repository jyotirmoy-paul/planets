import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:planets/global/stylized_button.dart';
import 'package:planets/global/stylized_text.dart';
import 'package:planets/layout/utils/responsive_gap.dart';
import 'package:planets/layout/utils/responsive_layout_builder.dart';
import 'package:planets/puzzle/cubit/puzzle_init_cubit.dart';
import 'package:planets/resource/app_string.dart';
import '../puzzle/puzzle.dart';
import '../puzzles/planet/planet.dart';
import '../timer/timer.dart';
import 'stylized_container.dart';

class PuzzleControl extends StatelessWidget {
  const PuzzleControl({Key? key}) : super(key: key);

  void _onStart(BuildContext context, bool hasStarted) {
    context.read<TimerBloc>().add(const TimerReset());

    context.read<PlanetPuzzleBloc>().add(
          PlanetCountdownReset(
            secondsToBegin: hasStarted ? 5 : 3,
          ),
        );

    if (hasStarted) {
      context.read<PuzzleBloc>().add(
            const PuzzleInitialized(shufflePuzzle: false),
          );
    }
  }

  void _onAutoSolve() {}

  void _onRestart() {}

  @override
  Widget build(BuildContext context) {
    final puzzleInitState =
        context.select((PuzzleInitCubit cubit) => cubit.state);
    final isReady = puzzleInitState is PuzzleInitReady;

    final status = context.select((PlanetPuzzleBloc bloc) => bloc.state.status);
    final hasStarted = status == PlanetPuzzleStatus.started;
    final isLoading = status == PlanetPuzzleStatus.loading;

    final text = !isReady
        ? AppString.pleaseWait
        : isLoading
            ? AppString.getReady
            : hasStarted
                ? AppString.autoSolve
                : AppString.start;

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
            // auto solve / start
            StylizedButton(
              key: Key('puzzle_control_${hasStarted}_${isLoading}_$isReady'),
              onPressed: () {
                if (!isReady) return;

                if (hasStarted) {
                  _onAutoSolve();
                } else {
                  _onStart(context, hasStarted);
                }
              },
              child: StylizedContainer(
                color: !isReady || isLoading ? Colors.grey : Colors.greenAccent,
                child: StylizedText(
                  text: text,
                  fontSize: isLarge ? 24.0 : 20.0,
                ),
              ),
            ),

            isLarge ? const Gap(38.0) : const Gap(32.0),

            // restart
            StylizedButton(
              onPressed: hasStarted ? _onRestart : null,
              child: StylizedContainer(
                color: hasStarted ? Colors.greenAccent : Colors.grey,
                child: StylizedText(
                  text: AppString.restart,
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
