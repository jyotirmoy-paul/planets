import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import '../../../l10n/l10n.dart';
import '../../../dashboard/cubit/planet_selection_cubit.dart';
import '../../../global/stylized_icon.dart';
import '../../../puzzle/cubit/puzzle_helper_cubit.dart';
import '../../../utils/utils.dart';
import '../../../dashboard/cubit/level_selection_cubit.dart';
import '../../../global/stylized_button.dart';
import '../../../global/stylized_container.dart';
import '../../../global/stylized_text.dart';
import '../../../layout/utils/responsive_layout_builder.dart';
import '../../../models/planet.dart';
import '../../../puzzle/puzzle.dart';
import '../../../timer/timer.dart';

class PlanetPuzzleCompletionDialog extends StatelessWidget {
  PlanetPuzzleCompletionDialog({Key? key}) : super(key: key);

  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            width: 2.0,
            color: Colors.amber,
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          child: ResponsiveLayoutBuilder(
            small: (_, __) => _PlanetPuzzleCompletionDialogSmall(
              key: const Key('PlanetPuzzleCompletionDialogSmall'),
              globalKey: globalKey,
            ),
            medium: (_, Widget? child) => child!,
            large: (_, Widget? child) => child!,
            child: (_) => _PlanetPuzzleCompletionDialogLarge(
              key: const Key('PlanetPuzzleCompletionDialogLarge'),
              globalKey: globalKey,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanetPuzzleCompletionDialogSmall extends StatelessWidget {
  final GlobalKey globalKey;

  const _PlanetPuzzleCompletionDialogSmall({
    Key? key,
    required this.globalKey,
  }) : super(key: key);

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
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // heading
              FittedBox(
                fit: BoxFit.fitWidth,
                child: StylizedText(
                  text: context.l10n.congrats,
                  strokeWidth: 4.0,
                  offset: 1.0,
                ),
              ),

              Text(
                context.l10n.congratsSubTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  letterSpacing: 2.0,
                ),
              ),

              const Gap(32.0),

              Text(
                context.l10n.successMessage(
                  planet.name,
                  Utils.getSuccessExtraText(
                    totalSteps: totalMoves,
                    autoSolverSteps: autoSolverSteps,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  letterSpacing: 1.5,
                  wordSpacing: 1.5,
                ),
              ),

              const Gap(38.0),

              // star
              WinStarWidget(
                star: Utils.getScore(
                  secondsTaken: secondsElapsed,
                  totalSteps: totalMoves,
                  autoSolverSteps: autoSolverSteps,
                  puzzleSize: level,
                ),
              ),

              const Gap(38.0),

              StylizedText(
                textAlign: TextAlign.center,
                text: context.l10n.scoreBoard,
                fontSize: 24.0,
                strokeWidth: 5.0,
                offset: 2.0,
              ),

              const Gap(16.0),

              ScoreTile(
                icon: FontAwesomeIcons.hashtag,
                text: context.l10n.totalMoves(totalMoves),
              ),

              const Gap(8.0),

              ScoreTile(
                icon: FontAwesomeIcons.stopwatch,
                text: Utils.getFormattedElapsedSeconds(secondsElapsed),
              ),

              const Gap(8.0),

              ScoreTile(
                icon: FontAwesomeIcons.laptopCode,
                text: isAutoSolverUsed
                    ? context.l10n.usedAutosolve
                    : context.l10n.noAutosolve,
              ),

              const Gap(38.0),

              StylizedText(
                text: context.l10n.share,
                fontSize: 24.0,
              ),

              const Gap(32),

              // buttons
              ShareButtons(planet: planet, globalKey: globalKey),
            ],
          ),
        ),
      ],
    );
  }
}

class ShareButtons extends StatelessWidget {
  final Planet planet;
  final GlobalKey globalKey;

  const ShareButtons({
    Key? key,
    required this.planet,
    required this.globalKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StylizedButton(
          onPressed: () {
            Utils.onFacebookTap(planet.name, context);
          },
          child: const StylizedContainer(
            padding: EdgeInsets.all(8.0),
            color: Color(0xffF0F0F0),
            child: Icon(
              FontAwesomeIcons.facebook,
              size: 22.0,
              color: Color(0xff3b5998),
            ),
          ),
        ),

        // twitter
        StylizedButton(
          onPressed: () {
            Utils.onTwitterTap(planet.name, context);
          },
          child: const StylizedContainer(
            padding: EdgeInsets.all(8.0),
            color: Color(0xffF0F0F0),
            child: Icon(
              FontAwesomeIcons.twitter,
              size: 22.0,
              color: Color(0xff00acee),
            ),
          ),
        ),

        // download
        StylizedButton(
          onPressed: () async {
            final bytes = await Utils.capturePng(globalKey);
            Utils.onDownloadTap(bytes);
          },
          child: const StylizedContainer(
            padding: EdgeInsets.all(8.0),
            color: Color(0xffF0F0F0),
            child: Icon(
              FontAwesomeIcons.download,
              size: 22.0,
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
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
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
          color: index >= star ? Colors.white.withOpacity(0.20) : Colors.white,
        );
      }).toList(),
    );
  }
}

class _PlanetPuzzleCompletionDialogLarge extends StatelessWidget {
  final GlobalKey globalKey;

  const _PlanetPuzzleCompletionDialogLarge({
    Key? key,
    required this.globalKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secondsElapsed = context.read<TimerBloc>().state.secondsElapsed;
    final totalMoves = context.read<PuzzleBloc>().state.numberOfMoves;
    final planet = context.read<PlanetSelectionCubit>().planet;
    final autoSolverSteps = context.read<PuzzleHelperCubit>().autoSolverSteps;
    final level = context.read<LevelSelectionCubit>().puzzleSize;
    final isAutoSolverUsed = autoSolverSteps != 0;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        Utils.getPlanetImageFor(planet.type),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.45),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StylizedText(
                          text: context.l10n.congrats,
                          fontSize: 48.0,
                        ),

                        Text(
                          context.l10n.congratsSubTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            letterSpacing: 2.0,
                          ),
                        ),

                        const Gap(32.0),

                        Text(
                          context.l10n.successMessage(
                            planet.name,
                            Utils.getSuccessExtraText(
                              totalSteps: totalMoves,
                              autoSolverSteps: autoSolverSteps,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            letterSpacing: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),

                        const Gap(32.0),

                        // star
                        WinStarWidget(
                          star: Utils.getScore(
                            secondsTaken: secondsElapsed,
                            totalSteps: totalMoves,
                            autoSolverSteps: autoSolverSteps,
                            puzzleSize: level,
                          ),
                        ),

                        const Gap(32.0),

                        StylizedText(
                          textAlign: TextAlign.center,
                          text: context.l10n.scoreBoard,
                          fontSize: 24.0,
                          strokeWidth: 5.0,
                          offset: 2.0,
                        ),

                        const Gap(16.0),

                        ScoreTile(
                          icon: FontAwesomeIcons.hashtag,
                          text: context.l10n.totalMoves(totalMoves),
                        ),

                        const Gap(8.0),

                        ScoreTile(
                          icon: FontAwesomeIcons.stopwatch,
                          text: Utils.getFormattedElapsedSeconds(
                            secondsElapsed,
                          ),
                        ),

                        const Gap(8.0),

                        ScoreTile(
                          icon: FontAwesomeIcons.laptopCode,
                          text: isAutoSolverUsed
                              ? context.l10n.usedAutosolve
                              : context.l10n.noAutosolve,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Gap(24.0),

          // share
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // share title text
                StylizedText(
                  text: context.l10n.share,
                  fontSize: 32.0,
                ),

                const Gap(32.0),

                // buttons
                ShareButtons(planet: planet, globalKey: globalKey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
