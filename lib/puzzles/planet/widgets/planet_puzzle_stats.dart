import 'package:flutter/material.dart';
import 'package:planets/layout/utils/responsive_layout_builder.dart';

class PlanetPuzzleStats extends StatelessWidget {
  const PlanetPuzzleStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => child!,
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => child!,
      child: (layoutSize) {
        final isSmall = layoutSize == ResponsiveLayoutSize.small;
        final isLarge = layoutSize == ResponsiveLayoutSize.large;

        return Text(
          '00:00:00 | 27 Moves',
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
      },
    );
  }
}
