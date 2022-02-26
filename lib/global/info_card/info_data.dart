import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:planets/global/info_card/info_pair.dart';

class InfoData {
  final String title;
  final List<InfoPair> infoPairs;

  const InfoData({
    required this.title,
    required this.infoPairs,
  });
}

abstract class AppShortcutData {
  static const List<InfoData> data = [
    // app shortcuts
    /// [m] key -> mute/unmute music
    /// [s] key -> mute/unmute sound effect
    InfoData(
      title: 'App Shortcuts',
      infoPairs: [
        InfoPair(
          titleText: 'M',
          description: 'Mute/Unmute music',
        ),
        InfoPair(
          titleText: 'S',
          description: 'Mute/Unmute sound effect',
        ),
      ],
    ),

    // dashboard shortcuts
    /// [Space] key -> play/pause planet orbital animation
    /// [LeftArrow] key -> decrease difficulty level
    /// [RightArrow] key -> increase difficulty level
    /// [i] key -> show info card
    /// [esc] key -> close dialog
    InfoData(
      title: 'Dashboard Shorcuts',
      infoPairs: [
        InfoPair(
          showIcon: true,
          titleIcon: Icons.space_bar_rounded,
          description: 'Play/Pause planet orbit animation',
        ),
        InfoPair(
          showIcon: true,
          titleIcon: FontAwesomeIcons.arrowLeft,
          description: 'Decrease difficulty level',
        ),
        InfoPair(
          showIcon: true,
          titleIcon: FontAwesomeIcons.arrowRight,
          description: 'Increase difficulty level',
        ),
        InfoPair(
          titleText: 'i',
          description: 'Show this shortcut dialog',
        ),
        InfoPair(
          titleText: 'ESC',
          description: 'Close dialog',
        ),
      ],
    ),

    // puzzle page shortcuts
    /// [Space] Start / Auto Solve / Stop
    /// [R] key -> restart
    /// [V] key -> toggle visibility of helpers (numbers)
    /// [UpArrow] key -> move whitespace up
    /// [DownArrow] key -> move whitespace down
    /// [LeftArrow] key -> move whitespace left
    /// [RightArrow] key -> move whitespace right
    /// [esc] key -> move back to solar system
    InfoData(
      title: 'Puzzle Page Shortcuts',
      infoPairs: [
        InfoPair(
          showIcon: true,
          titleIcon: Icons.space_bar_rounded,
          description: 'Play/Pause planet orbit animation',
        ),
        InfoPair(
          titleText: 'R',
          description: 'Restart puzzle',
        ),
        InfoPair(
          titleText: 'V',
          description: 'Toggle number hint visibility',
        ),
        InfoPair(
          showIcon: true,
          titleIcon: FontAwesomeIcons.arrowUp,
          description: 'Move whitespace up',
        ),
        InfoPair(
          showIcon: true,
          titleIcon: FontAwesomeIcons.arrowDown,
          description: 'Move whitespace down',
        ),
        InfoPair(
          showIcon: true,
          titleIcon: FontAwesomeIcons.arrowLeft,
          description: 'Move whitespace left',
        ),
        InfoPair(
          showIcon: true,
          titleIcon: FontAwesomeIcons.arrowRight,
          description: 'Move whitespace right',
        ),
        InfoPair(
          titleText: 'ESC',
          description: 'Go back to solar system',
        ),
      ],
    ),
  ];
}
