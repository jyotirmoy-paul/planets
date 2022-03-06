import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../app/bloc/audio_control_bloc.dart';

class AudioControlListener extends StatefulWidget {
  final AudioPlayer? audioPlayer;
  final Widget child;

  const AudioControlListener({
    Key? key,
    this.audioPlayer,
    required this.child,
  }) : super(key: key);

  @override
  State<AudioControlListener> createState() => _AudioControlListenerState();
}

class _AudioControlListenerState extends State<AudioControlListener> {
  @override
  void didChangeDependencies() {
    _updateAudioPlayer(
        muted: context.read<AudioControlBloc>().state.isSoundEffectEnabled);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AudioControlListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAudioPlayer(
        muted: context.read<AudioControlBloc>().state.isSoundEffectEnabled);
  }

  void _updateAudioPlayer({required bool muted}) {
    widget.audioPlayer?.setVolume(muted ? 0.0 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AudioControlBloc, AudioControlState>(
      listener: (context, state) => _updateAudioPlayer(
        muted: state.isSoundEffectEnabled,
      ),
      child: widget.child,
    );
  }
}
