import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../dashboard/cubit/planet_selection_cubit.dart';
import '../../global/stylized_container.dart';
import '../../layout/utils/responsive_layout_builder.dart';
import '../../resource/app_string.dart';

class PuzzleHeader extends StatelessWidget {
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedPlanet = context.read<PlanetSelectionCubit>().planet;
    final titleText =
        selectedPlanet == null ? AppString.dashboard : AppString.solarSystem;

    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => child!,
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => child!,
      child: (layoutSize) {
        final bool isSmall = layoutSize == ResponsiveLayoutSize.small;

        return InkWell(
          onTap: () => Navigator.pop(context),
          child: StylizedContainer(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // back button
                Icon(
                  Icons.chevron_left,
                  size: isSmall ? 16.0 : 32.0,
                ),

                // gap
                isSmall ? const Gap(4.0) : const Gap(8.0),

                // text
                Text(
                  titleText,
                  style: TextStyle(fontSize: isSmall ? 16.0 : 18.0),
                ),

                // gap
                isSmall ? const Gap(4.0) : const Gap(8.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
