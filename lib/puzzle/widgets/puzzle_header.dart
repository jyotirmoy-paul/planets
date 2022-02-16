import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../global/stylized_button.dart';
import '../../global/stylized_text.dart';
import '../../utils/app_logger.dart';
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

        return Container(
          margin: const EdgeInsets.all(25.0),
          child: StylizedButton(
            key: ValueKey(isSmall),
            onPressed: () => Navigator.pop(context),
            child: StylizedContainer(
              color: Colors.redAccent,
              child: StylizedText(
                text: 'Back to Solar System',
                strokeWidth: isSmall ? 5.0 : 6.0,
                offset: isSmall ? 1.0 : 2.0,
                fontSize: isSmall ? 18.0 : 24.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
