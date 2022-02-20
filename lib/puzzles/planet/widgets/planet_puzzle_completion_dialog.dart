import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:planets/global/stylized_button.dart';
import 'package:planets/global/stylized_container.dart';
import 'package:planets/global/stylized_icon.dart';
import 'package:planets/global/stylized_text.dart';
import 'package:planets/layout/utils/responsive_layout_builder.dart';
import 'package:planets/puzzle/puzzle.dart';
import 'package:planets/timer/timer.dart';
import 'package:planets/utils/utils.dart';

class PlanetPuzzleCompletionDialog extends StatelessWidget {
  const PlanetPuzzleCompletionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => const _PlanetPuzzleCompletionDialogSmall(
        key: Key('PlanetPuzzleCompletionDialogSmall'),
      ),
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => child!,
      child: (_) => const _PlanetPuzzleCompletionDialogLarge(
        key: Key('PlanetPuzzleCompletionDialogLarge'),
      ),
    );
  }
}

class _PlanetPuzzleCompletionDialogSmall extends StatelessWidget {
  const _PlanetPuzzleCompletionDialogSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secondsElapsed = context.read<TimerBloc>().state.secondsElapsed;
    final moves = context.read<PuzzleBloc>().state.numberOfMoves;

    return Column(
      children: [
        // congracts heading
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: StylizedText(
            text: 'Congracts!',
            fontSize: 38.0,
          ),
        ),

        // row
        Expanded(
          child: Stack(
            children: [
              // planet

              Transform.translate(
                offset: Offset(-MediaQuery.of(context).size.width, 0.0),
                child: Transform.scale(
                  scale: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // well done text
                        const StylizedText(
                          text: 'Well Done',
                          fontSize: 28.0,
                        ),

                        // gap
                        const Gap(24.0),

                        // appretiation text
                        StylizedText(
                          text:
                              'You have successfully put together our Saturn with a little help',
                          fontSize: 20.0,
                          offset: 1.0,
                          strokeWidth: 4.0,
                        ),

                        // gap
                        const Gap(48.0),

                        // score
                        const StylizedText(
                          text: 'Your Score',
                          fontSize: 28.0,
                        ),

                        // gap
                        const Gap(24.0),

                        const StylizedText(
                          text: '00:03:35',
                          fontSize: 22.0,
                          offset: 1.0,
                          strokeWidth: 4.0,
                        ),

                        // gap
                        const Gap(6.0),

                        Text(
                          '149 Moves',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                          ),
                        ),

                        // const StylizedText(
                        //   text: '149 Moves',
                        //   fontSize: 22.0,
                        //   offset: 1.0,
                        //   strokeWidth: 4.0,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),

              // download buttons
              Align(
                alignment: const FractionalOffset(0.50, 0.95),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // facebook
                    StylizedButton(
                      child: const StylizedContainer(
                        color: Colors.white70,
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
                        color: Colors.white70,
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
                ),
              ),
            ],
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
