import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:planets/global/animated_text.dart';
import 'package:planets/puzzles/planet/cubit/planet_fact_cubit.dart';

import '../../../dashboard/cubit/planet_selection_cubit.dart';
import '../../../layout/utils/responsive_layout_builder.dart';
import '../../../utils/utils.dart';

class PlanetPuzzleInfo extends StatelessWidget {
  const PlanetPuzzleInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final planet = context.read<PlanetSelectionCubit>().planet;

    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: child!,
      ),
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => child!,
      child: (layoutSize) {
        final bool isLarge = layoutSize == ResponsiveLayoutSize.large;
        final bool isSmall = layoutSize == ResponsiveLayoutSize.small;

        return SizedBox(
          width: isSmall ? null : 500.0,
          child: Column(
            crossAxisAlignment:
                isLarge ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              // title
              Text(
                Utils.planetName(planet.type, context),
                style: TextStyle(
                  fontSize: isLarge ? 48.0 : 32.0,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),

              // gap
              isSmall ? const Gap(32.0) : const Gap(24.0),

              // description
              _FactWidget(
                key: const Key('planet-fact-widget'),
                isLarge: isLarge,
                isSmall: isSmall,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FactWidget extends StatelessWidget {
  final bool isLarge;
  final bool isSmall;

  const _FactWidget({
    Key? key,
    required this.isLarge,
    required this.isSmall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.select((PlanetFactCubit cubit) => cubit.state);
    return AppAnimatedWidget(
      key: ValueKey(state.fact),
      child: Text(
        state.fact,
        textAlign: isLarge ? TextAlign.start : TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: isSmall
              ? 16.0
              : isLarge
                  ? 24.0
                  : 20.0,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
