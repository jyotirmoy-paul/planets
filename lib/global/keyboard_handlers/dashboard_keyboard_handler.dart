import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planets/dashboard/cubit/level_selection_cubit.dart';
import 'package:planets/dashboard/cubit/planet_selection_cubit.dart';
import 'package:planets/dashboard/cubit/planet_selection_helper_cubit.dart';
import 'package:planets/models/planet.dart';

class DashboardKeyboardHandler extends StatefulWidget {
  final Widget child;

  const DashboardKeyboardHandler({
    Key? key,
    required this.child,
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

  /// For the dashboard, the following keyboard events are important
  /// [Space] key -> play/pause planet orbital animation
  /// [LeftArrow] key -> decrease difficulty level
  /// [RightArrow] key -> increase difficulty level
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final physicalKey = event.data.physicalKey;

      if (physicalKey == PhysicalKeyboardKey.space) {
        context.read<PlanetSelectionHelperCubit>().onPlanetMovementToggle();
      } else if (physicalKey == PhysicalKeyboardKey.arrowLeft) {
        context.read<LevelSelectionCubit>().onLevelDecrease();
      } else if (physicalKey == PhysicalKeyboardKey.arrowRight) {
        context.read<LevelSelectionCubit>().onLevelIncrease();
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
