import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import '../../app/cubit/audio_player_cubit.dart';

import '../../global/controls/audio_control.dart';
import '../../global/stylized_button.dart';
import '../../global/stylized_container.dart';
import '../../global/stylized_icon.dart';
import '../../global/stylized_text.dart';
import '../../l10n/l10n.dart';
import '../../layout/utils/responsive_layout_builder.dart';
import '../cubit/puzzle_helper_cubit.dart';

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
          margin: isSmall
              ? const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0)
              : const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // back button
              StylizedButton(
                key: ValueKey(isSmall),
                onPressed: () {
                  context.read<AudioPlayerCubit>().onBackToSolarSystem();
                  Navigator.pop(context);
                },
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
                        text: context.l10n.solarSystem,
                        strokeWidth: isSmall ? 5.0 : 6.0,
                        offset: isSmall ? 1.0 : 2.0,
                        fontSize: isSmall ? 16.0 : 22.0,
                      ),
                    ],
                  ),
                ),
              ),

              // show other control buttons
              Row(
                key: ValueKey('puzzle_header_$isSmall'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  // music control buttons
                  AudioControl(isSmall: isSmall),

                  // gap
                  isSmall ? const Gap(4.0) : const Gap(18.0),

                  // show number button
                  BlocBuilder<PuzzleHelperCubit, PuzzleHelperState>(
                    builder: (_, state) {
                      return Semantics(
                        label: context.l10n.visibilityButtonSemanticLabel,
                        child: StylizedButton(
                          onPressed: () {
                            context.read<PuzzleHelperCubit>().onHelpToggle();
                          },
                          child: StylizedContainer(
                            padding: isSmall
                                ? const EdgeInsets.all(8.0)
                                : const EdgeInsets.symmetric(
                                    horizontal: 18.0,
                                    vertical: 12.0,
                                  ),
                            color: state.showHelp
                                ? Colors.blueAccent
                                : Colors.grey,
                            child: StylizedIcon(
                              icon: state.showHelp
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              size: 18.0,
                              strokeWidth: 4.0,
                              offset: 1.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
