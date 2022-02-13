import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:planets/dashboard/cubit/planet_selection_cubit.dart';
import 'package:planets/layout/utils/responsive_layout_builder.dart';
import 'package:planets/models/planet.dart';
import 'package:planets/resource/app_string.dart';

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

        return SizedBox(
          width: isLarge ? 500.0 : null,
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
              isLarge ? const Gap(24.0) : const Gap(6.0),

              // description
              Text(
                'This can be something interesting, but for now, leaving it black. I mean a long string blank.',
                textAlign: isLarge ? TextAlign.start : TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isLarge ? 24.0 : 16.0,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
