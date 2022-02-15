import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/puzzles/planet/planet.dart';
import '../../../layout/utils/responsive_layout_builder.dart';
import '../../../puzzle/puzzle.dart';
import '../../../timer/timer.dart';

class PlanetPuzzleStats extends StatelessWidget {
  final PuzzleState state;
  const PlanetPuzzleStats({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlanetPuzzleBloc, PlanetPuzzleState>(
      listener: (context, state) {
        if (!state.isCountdownRunning) {
          return;
        }

        if (state.status == PlanetPuzzleStatus.started) {
          context.read<TimerBloc>().add(const TimerStarted());
        }

        // on every tick, we shuffle the puzzle
        if (state.secondsToBegin >= 1 && state.secondsToBegin <= 3) {
          context.read<PuzzleBloc>().add(const PuzzleReset());
        }
      },
      child: ResponsiveLayoutBuilder(
        small: (_, Widget? child) => child!,
        medium: (_, Widget? child) => child!,
        large: (_, Widget? child) => child!,
        child: (layoutSize) {
          return _PuzzleStats(layoutSize: layoutSize, puzzleState: state);
        },
      ),
    );
  }
}

class _PuzzleStats extends StatelessWidget {
  final ResponsiveLayoutSize layoutSize;
  final PuzzleState puzzleState;

  const _PuzzleStats({
    Key? key,
    required this.layoutSize,
    required this.puzzleState,
  }) : super(key: key);

  String _getFormattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((PlanetPuzzleBloc bloc) => bloc.state);
    final secondsElapsed = context.select(
      (TimerBloc bloc) => bloc.state.secondsElapsed,
    );

    final isSmall = layoutSize == ResponsiveLayoutSize.small;
    final isLarge = layoutSize == ResponsiveLayoutSize.large;

    String textToShow = '';
    bool isTicking = false;

    if (!state.isCountdownRunning || state.secondsToBegin > 3) {
      // show: '00:00:00 | 0 Moves',
      final timeText = _getFormattedDuration(Duration(seconds: secondsElapsed));
      textToShow = '$timeText | ${puzzleState.numberOfMoves} Moves';
    } else {
      // show: ticking 3..2..1..Go!
      isTicking = true;
      if (state.secondsToBegin > 0) {
        textToShow = '${state.secondsToBegin}';
      } else {
        textToShow = 'Go!';
      }
    }

    if (state.status == PlanetPuzzleStatus.notStarted) {
      textToShow = 'Not Started';
    }

    final child = Text(
      textToShow,
      style: TextStyle(
        color: Colors.white,
        fontSize: isLarge
            ? 32.0
            : isSmall
                ? 24.0
                : 28.0,
        letterSpacing: 1.5,
      ),
    );

    if (isTicking) {
      return _Animated(key: ValueKey(state.secondsToBegin), child: child);
    } else {
      return child;
    }
  }
}

class _Animated extends StatefulWidget {
  final Widget child;

  const _Animated({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<_Animated> createState() => _AnimatedState();
}

class _AnimatedState extends State<_Animated>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> inOpacity;
  late Animation<double> inScale;
  late Animation<double> outOpacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    inOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    inScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    outOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.81, 1, curve: Curves.easeIn),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: outOpacity,
      child: FadeTransition(
        opacity: inOpacity,
        child: ScaleTransition(
          scale: inScale,
          child: widget.child,
        ),
      ),
    );
  }
}
