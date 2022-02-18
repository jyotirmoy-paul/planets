import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:planets/global/stylized_icon.dart';
import '../../global/stylized_button.dart';
import '../../global/stylized_text.dart';
import '../../global/stylized_container.dart';
import '../../layout/utils/responsive_layout_builder.dart';
import '../../resource/app_string.dart';

class PuzzleHeader extends StatelessWidget {
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StylizedIcon(
                    icon: FontAwesomeIcons.chevronLeft,
                    size: isSmall ? 18.0 : 24.0,
                    offset: isSmall ? 1.0 : 2.0,
                  ),
                  isSmall ? const Gap(12.0) : const Gap(24.0),
                  StylizedText(
                    text: AppString.solarSystem,
                    strokeWidth: isSmall ? 5.0 : 6.0,
                    offset: isSmall ? 1.0 : 2.0,
                    fontSize: isSmall ? 18.0 : 22.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
