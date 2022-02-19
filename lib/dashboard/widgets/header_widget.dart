import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../global/controls/music_control.dart';
import '../../global/stylized_button.dart';
import '../../global/stylized_text.dart';
import '../../layout/layout.dart';
import '../../layout/utils/responsive_layout_builder.dart';
import '../cubit/level_selection_cubit.dart';
import '../../global/stylized_container.dart';
import '../../models/puzzle.dart';
import '../../resource/app_string.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const FractionalOffset(0.5, 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // header title
          ResponsiveLayoutBuilder(
            small: (_, Widget? child) => child!,
            medium: (_, Widget? child) => child!,
            large: (_, Widget? child) => child!,
            child: (layoutSize) {
              final bool isSmall = layoutSize == ResponsiveLayoutSize.small;

              return StylizedContainer(
                key: isSmall
                    ? const Key('header_widget_small')
                    : const Key('header_widget_normal'),
                color: const Color(0xffffcc33),
                child: StylizedText(
                  text: AppString.dashboardHeading,
                  fontSize: isSmall ? 24.0 : 32.0,
                  strokeWidth: isSmall ? 5.0 : 6.0,
                ),
              );
            },
          ),

          // gap
          const Gap(32.0),

          // level selection
          BlocBuilder<LevelSelectionCubit, LevelSelectionState>(
            builder: (context, state) {
              return _SegmentedControl(
                groupValue: state.level,
                children: const {
                  PuzzleLevel.easy: 'Easy',
                  PuzzleLevel.medium: 'Medium',
                  PuzzleLevel.hard: 'Hard',
                },
                onValueChanged:
                    context.read<LevelSelectionCubit>().onNewLevelSelected,
              );
            },
          ),

          // gap
          const Gap(32),

          // music control for medium & small screens
          ResponsiveLayoutBuilder(
            small: (_, Widget? child) => child!,
            medium: (_, Widget? child) => child!,
            large: (_, __) => const SizedBox.shrink(),
            child: (_) => const MusicControl(),
          ),
        ],
      ),
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  final PuzzleLevel groupValue;
  final Map<PuzzleLevel, String> children;
  final ValueChanged<PuzzleLevel> onValueChanged;

  const _SegmentedControl({
    Key? key,
    required this.groupValue,
    required this.children,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => SizedBox(
        width: 350.0,
        child: child!,
      ),
      medium: (_, Widget? child) => SizedBox(
        width: 400.0,
        child: child!,
      ),
      large: (_, Widget? child) => SizedBox(
        width: 400.0,
        child: child!,
      ),
      child: (layoutSize) {
        final isSmall = layoutSize == ResponsiveLayoutSize.small;

        return Row(
          key: isSmall
              ? const Key('segmented_control_small')
              : const Key('segmented_control_normal'),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: children.entries.map<Widget>(
            (value) {
              final isSelected = groupValue == value.key;

              return StylizedButton(
                onPressed: () {
                  onValueChanged(value.key);
                },
                child: StylizedContainer(
                  color: isSelected ? Colors.blueAccent : Colors.grey,
                  child: StylizedText(
                    strokeWidth: 4.0,
                    offset: 1.0,
                    text: value.value,
                    fontSize: isSmall ? 15.0 : 18.0,
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
