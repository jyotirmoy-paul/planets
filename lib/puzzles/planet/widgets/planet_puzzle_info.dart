import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import '../../../global/animated_text.dart';
import '../../../global/stylized_icon.dart';
import '../../../global/stylized_text.dart';
import '../../../l10n/l10n.dart';
import '../../../puzzle/cubit/puzzle_helper_cubit.dart';
import '../cubit/planet_fact_cubit.dart';

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
          height: isLarge
              ? 250
              : isSmall
                  ? 160
                  : 180,
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
              const Spacer(),

              // description
              _FactWidget(
                key: const Key('planet-fact-widget'),
                isLarge: isLarge,
                isSmall: isSmall,
              ),

              // gap
              const Spacer(),

              // puzzle optimize label
              context.read<PuzzleHelperCubit>().state.optimized
                  ? Tooltip(
                      message: context.l10n.optimizedDescription,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14.0,
                        letterSpacing: 1.5,
                        wordSpacing: 2.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const StylizedIcon(
                            icon: FontAwesomeIcons.bolt,
                            color: Colors.redAccent,
                          ),
                          const Gap(12.0),
                          StylizedText(
                            text: context.l10n.optimizedLabel,
                            textColor: Colors.redAccent,
                            strokeWidth: 4.0,
                            offset: 1.5,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.read<PlanetFactCubit>().newFact();
        },
        child: AppAnimatedWidget(
          showOnComplete: true,
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
        ),
      ),
    );
  }
}
