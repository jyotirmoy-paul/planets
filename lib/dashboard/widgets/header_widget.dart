import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
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
          const StylizedContainer(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Text(
              AppString.dashboardHeading,
              style: TextStyle(
                fontSize: 32.0,
              ),
            ),
          ),

          // gap
          const Gap(18.0),

          // level selection
          BlocBuilder<LevelSelectionCubit, LevelSelectionState>(
            builder: (context, state) {
              return CupertinoSegmentedControl<PuzzleLevel>(
                pressedColor: Colors.white.withOpacity(0.80),
                groupValue: state.level,
                children: const {
                  PuzzleLevel.easy: _LevelSelectionWidget('Easy'),
                  PuzzleLevel.medium: _LevelSelectionWidget('Medium'),
                  PuzzleLevel.hard: _LevelSelectionWidget('Hard'),
                },
                onValueChanged:
                    context.read<LevelSelectionCubit>().onNewLevelSelected,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LevelSelectionWidget extends StatelessWidget {
  final String text;
  const _LevelSelectionWidget(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }
}
