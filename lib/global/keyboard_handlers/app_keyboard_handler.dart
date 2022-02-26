import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/bloc/audio_control_bloc.dart';

class AppKeyboardHandler extends StatefulWidget {
  final Widget child;

  const AppKeyboardHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _AppKeyboardHandlerState createState() => _AppKeyboardHandlerState();
}

class _AppKeyboardHandlerState extends State<AppKeyboardHandler> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// For the app, the following keyboard events are important
  /// [m] key -> mute/unmute music
  /// [s] key -> mute/unmute sound effect
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final physicalKey = event.data.physicalKey;

      if (physicalKey == PhysicalKeyboardKey.keyM) {
        context.read<AudioControlBloc>().add(const AudioControlMusicToggle());
      } else if (physicalKey == PhysicalKeyboardKey.keyS) {
        context
            .read<AudioControlBloc>()
            .add(const AudioControlSoundEffectToggle());
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
