import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../dashboard/cubit/planet_selection_cubit.dart';
import '../../../layout/utils/responsive_layout_builder.dart';
import '../../../models/planet.dart';
import '../../../resource/app_string.dart';

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
                planet == null ? AppString.community : planet.type.value,
                style: TextStyle(
                  fontSize: isLarge ? 48.0 : 32.0,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),

              // gap
              isSmall ? const Gap(32.0) : const Gap(24.0),

              // description
              Text(
                'This can be something interesting, but for now, leaving it black. I mean a long string blank.',
                textAlign: isLarge ? TextAlign.start : TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmall
                      ? 18.0
                      : isLarge
                          ? 24.0
                          : 20.0,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
