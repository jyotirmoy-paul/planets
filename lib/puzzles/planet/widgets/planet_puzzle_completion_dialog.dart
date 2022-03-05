import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:planets/dashboard/cubit/planet_selection_cubit.dart';
import 'package:planets/global/stylized_icon.dart';
import 'package:planets/puzzle/cubit/puzzle_helper_cubit.dart';
import 'package:planets/utils/utils.dart';
import '../../../dashboard/cubit/level_selection_cubit.dart';
import '../../../global/stylized_button.dart';
import '../../../global/stylized_container.dart';
import '../../../global/stylized_text.dart';
import '../../../layout/utils/responsive_layout_builder.dart';
import '../../../puzzle/puzzle.dart';
import '../../../timer/timer.dart';

class PlanetPuzzleCompletionDialog extends StatelessWidget {
  const PlanetPuzzleCompletionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.50),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          width: 2.0,
          color: Colors.amber,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        child: ResponsiveLayoutBuilder(
          small: (_, __) => const _PlanetPuzzleCompletionDialogSmall(
            key: Key('PlanetPuzzleCompletionDialogSmall'),
          ),
          medium: (_, Widget? child) => child!,
          large: (_, Widget? child) => child!,
          child: (_) => const _PlanetPuzzleCompletionDialogLarge(
            key: Key('PlanetPuzzleCompletionDialogLarge'),
          ),
        ),
      ),
    );
  }
}

class _PlanetPuzzleCompletionDialogSmall extends StatelessWidget {
  const _PlanetPuzzleCompletionDialogSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secondsElapsed = context.read<TimerBloc>().state.secondsElapsed;
    final totalMoves = context.read<PuzzleBloc>().state.numberOfMoves;
    final planet = context.read<PlanetSelectionCubit>().planet;
    final autoSolverSteps = context.read<PuzzleHelperCubit>().autoSolverSteps;
    final level = context.read<LevelSelectionCubit>().puzzleSize;
    final isAutoSolverUsed = autoSolverSteps != 0;

    final xOffset = -MediaQuery.of(context).size.width * 0.50;

    return Stack(
      alignment: Alignment.center,
      children: [
        // planet image
        Transform.translate(
          offset: Offset(xOffset, 0.0),
          child: Transform.scale(
            scale: 1.5,
            child: Image.asset(
              Utils.getPlanetImageFor(planet.type),
            ),
          ),
        ),

        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.60),
          ),
        ),

        // main body
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // heading
              const FittedBox(
                fit: BoxFit.fitWidth,
                child: StylizedText(
                  text: 'Congracts!',
                  strokeWidth: 4.0,
                  offset: 1.0,
                ),
              ),

              const Text(
                "You're an intergalactic champ!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  letterSpacing: 2.0,
                ),
              ),

              const Gap(32.0),

              Text(
                'You have successfully put together ${planet.name} without any aid',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  letterSpacing: 1.5,
                  wordSpacing: 1.5,
                ),
              ),

              const Gap(48.0),

              // star
              WinStarWidget(
                star: Utils.getScore(
                  secondsTaken: secondsElapsed,
                  totalSteps: totalMoves,
                  autoSolverSteps: autoSolverSteps,
                  puzzleSize: level,
                ),
              ),

              const Gap(48.0),

              const StylizedText(
                textAlign: TextAlign.center,
                text: 'Score Board',
                fontSize: 24.0,
                strokeWidth: 5.0,
                offset: 2.0,
              ),

              const Gap(16.0),

              ScoreTile(
                icon: FontAwesomeIcons.hashtag,
                text: '$totalMoves moves',
              ),

              const Gap(8.0),

              ScoreTile(
                icon: FontAwesomeIcons.stopwatch,
                text: Utils.getFormattedElapsedSeconds(secondsElapsed),
              ),

              const Gap(8.0),

              ScoreTile(
                icon: FontAwesomeIcons.laptopCode,
                text: isAutoSolverUsed ? 'Used Autosolve' : 'No Autosolve',
              ),

              const Gap(48.0),

              // buttons
              const ScoreButtons(
                facebookTap: Utils.onFacebookTap,
                twitterTap: Utils.onTwitterTap,
                downloadTap: Utils.onDownloadTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ScoreButtons extends StatelessWidget {
  final VoidCallback facebookTap;
  final VoidCallback twitterTap;
  final VoidCallback downloadTap;

  const ScoreButtons({
    Key? key,
    required this.facebookTap,
    required this.twitterTap,
    required this.downloadTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StylizedButton(
          child: const StylizedContainer(
            color: Color(0xffF0F0F0),
            child: Icon(
              FontAwesomeIcons.facebook,
              size: 24.0,
              color: Color(0xff3b5998),
            ),
          ),
        ),

        // twitter
        StylizedButton(
          child: const StylizedContainer(
            color: Color(0xffF0F0F0),
            child: Icon(
              FontAwesomeIcons.twitter,
              size: 24.0,
              color: Color(0xff00acee),
            ),
          ),
        ),

        // download
        StylizedButton(
          child: const StylizedContainer(
            color: Color(0xffF0F0F0),
            child: Icon(
              FontAwesomeIcons.download,
              size: 24.0,
            ),
          ),
        ),
      ],
    );
  }
}

class ScoreTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const ScoreTile({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // icon
        Expanded(
          child: Icon(
            icon,
            size: 24.0,
            color: Colors.white,
          ),
        ),

        // text
        Expanded(
          flex: 4,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanetPuzzleCompletionDialogLarge extends StatelessWidget {
  const _PlanetPuzzleCompletionDialogLarge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secondsElapsed = context.read<TimerBloc>().state.secondsElapsed;
    final moves = context.read<PuzzleBloc>().state.numberOfMoves;

    return StylizedContainer(
      color: Colors.lightBlueAccent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [],
      ),
    );
  }
}

class WinStarWidget extends StatelessWidget {
  static const maxStar = 5;
  final int star;

  const WinStarWidget({Key? key, this.star = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(maxStar, (index) {
        return StylizedIcon(
          size: 32.0,
          icon: FontAwesomeIcons.star,
          color: index >= star ? Colors.grey : Colors.white,
        );
      }).toList(),
    );
  }
}
