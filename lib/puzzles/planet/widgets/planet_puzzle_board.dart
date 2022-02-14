import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/puzzle/cubit/puzzle_init_cubit.dart';

import '../../../layout/layout.dart';
import '../planet.dart';

class PlanetPuzzleBoard extends StatelessWidget {
  final List<Widget> tiles;

  const PlanetPuzzleBoard({Key? key, required this.tiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => _PuzzleBoard(
        child: child,
        size: BoardSize.small,
      ),
      medium: (_, Widget? child) => _PuzzleBoard(
        child: child,
        size: BoardSize.medium,
      ),
      large: (_, Widget? child) => _PuzzleBoard(
        child: child,
        size: BoardSize.large,
      ),
      child: (_) => Stack(children: tiles),
    );
  }
}

class _PuzzleBoard extends StatelessWidget {
  final double size;
  final Widget? child;

  const _PuzzleBoard({
    Key? key,
    this.child,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubitState = context.select((PuzzleInitCubit cubit) => cubit.state);
    final isReady = cubitState is PuzzleInitReady;

    return AnimatedOpacity(
      duration: Duration(milliseconds: isReady ? 250 : 0),
      opacity: isReady ? 1.0 : 0.1,
      curve: Curves.easeOutQuint,
      child: SizedBox.square(dimension: size, child: child),
    );
  }
}
