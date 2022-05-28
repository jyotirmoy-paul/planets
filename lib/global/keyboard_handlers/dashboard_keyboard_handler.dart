import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/models/orbit.dart';
import '../../dashboard/cubit/level_selection_cubit.dart';
import '../../dashboard/cubit/planet_selection_cubit.dart';
import '../../dashboard/cubit/planet_selection_helper_cubit.dart';

import '../info_card/info_card.dart';

class DashboardKeyboardHandler extends StatefulWidget {
  final Widget child;
  final List<Orbit> orbits;

  const DashboardKeyboardHandler({
    Key? key,
    required this.child,
    required this.orbits,
  }) : super(key: key);

  @override
  _DashboardKeyboardHandlerState createState() =>
      _DashboardKeyboardHandlerState();
}

class _DashboardKeyboardHandlerState extends State<DashboardKeyboardHandler> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void openPlanetAt(int digit) =>
      context.read<PlanetSelectionCubit>().onPlanetSelected(
            widget.orbits[digit - 1].planet,
          );

  /// For the dashboard, the following keyboard events are important
  /// [Space] key -> play/pause planet orbital animation
  /// [LeftArrow] key -> decrease difficulty level
  /// [RightArrow] key -> increase difficulty level
  /// [i] key -> show info card
  /// [1 - 9] num key -> choose a planet (Mercury - Pluto)
  /// [esc] key -> close dialog
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final physicalKey = event.data.physicalKey;

      if (physicalKey == PhysicalKeyboardKey.space) {
        context.read<PlanetSelectionHelperCubit>().onPlanetMovementToggle();
      } else if (physicalKey == PhysicalKeyboardKey.arrowLeft) {
        context.read<LevelSelectionCubit>().onLevelDecrease();
      } else if (physicalKey == PhysicalKeyboardKey.arrowRight) {
        context.read<LevelSelectionCubit>().onLevelIncrease();
      } else if (physicalKey == PhysicalKeyboardKey.keyI) {
        InfoCard.show(context: context);
      } else if (physicalKey == PhysicalKeyboardKey.digit1) {
        openPlanetAt(1);
      } else if (physicalKey == PhysicalKeyboardKey.digit2) {
        openPlanetAt(2);
      } else if (physicalKey == PhysicalKeyboardKey.digit3) {
        openPlanetAt(3);
      } else if (physicalKey == PhysicalKeyboardKey.digit4) {
        openPlanetAt(4);
      } else if (physicalKey == PhysicalKeyboardKey.digit5) {
        openPlanetAt(5);
      } else if (physicalKey == PhysicalKeyboardKey.digit6) {
        openPlanetAt(6);
      } else if (physicalKey == PhysicalKeyboardKey.digit7) {
        openPlanetAt(7);
      } else if (physicalKey == PhysicalKeyboardKey.digit8) {
        openPlanetAt(8);
      } else if (physicalKey == PhysicalKeyboardKey.digit9) {
        openPlanetAt(9);
      } else if (physicalKey == PhysicalKeyboardKey.escape) {
        final navigatorState = Navigator.of(context);
        if (navigatorState.canPop()) navigatorState.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: Builder(builder: (context) {
        if (!_focusNode.hasFocus) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
        return widget.child;
      }),
    );
  }
}
