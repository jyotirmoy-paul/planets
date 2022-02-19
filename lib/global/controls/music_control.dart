import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:planets/app/bloc/music_bloc.dart';
import 'package:planets/global/stylized_button.dart';
import 'package:planets/global/stylized_container.dart';
import 'package:planets/global/stylized_icon.dart';

class MusicControl extends StatelessWidget {
  const MusicControl({Key? key}) : super(key: key);

  void _onMusicToggle(BuildContext context) {
    context.read<MusicBloc>().add(const MusicToggle());
  }

  void _onSoundEffectToggle(BuildContext context) {
    context.read<MusicBloc>().add(const SoundEffectToggle());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((MusicBloc bloc) => bloc.state);
    final isMusicEnabled = state.isMusicEnabled;
    final isSoundEffectEnabled = state.isSoundEffectEnabled;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // music button
        StylizedButton(
          onPressed: () => _onMusicToggle(context),
          child: StylizedContainer(
            color: isMusicEnabled ? Colors.blueAccent : Colors.grey,
            child: StylizedIcon(
              icon: isMusicEnabled
                  ? Icons.music_note_rounded
                  : Icons.music_off_rounded,
              size: 18.0,
              strokeWidth: 4.0,
              offset: 1.0,
            ),
          ),
        ),

        // gap
        const Gap(18.0),

        StylizedButton(
          onPressed: () => _onSoundEffectToggle(context),
          child: StylizedContainer(
            color: isSoundEffectEnabled ? Colors.blueAccent : Colors.grey,
            child: StylizedIcon(
              icon: isSoundEffectEnabled
                  ? FontAwesomeIcons.volumeUp
                  : FontAwesomeIcons.volumeMute,
              size: 18.0,
              strokeWidth: 4.0,
              offset: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}
