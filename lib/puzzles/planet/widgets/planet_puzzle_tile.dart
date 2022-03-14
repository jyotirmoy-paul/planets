import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../global/stylized_text.dart';
import '../../../puzzle/cubit/puzzle_helper_cubit.dart';
import '../../../utils/constants.dart';
import '../../../utils/app_logger.dart';
import '../../../global/shake_animator.dart';
import '../../../models/tile.dart';
import '../../../puzzle/cubit/puzzle_init_cubit.dart';
import '../../../puzzle/puzzle.dart';
import '../bloc/planet_puzzle_bloc.dart';
import '../layout/planet_puzzle_layout_delegate.dart';
import '../../../theme/bloc/theme_bloc.dart';
import '../../../utils/utils.dart';
import 'package:rive/rive.dart';

import '../../../layout/layout.dart';

class PlanetPuzzleTile extends StatefulWidget {
  final Tile tile;

  const PlanetPuzzleTile({Key? key, required this.tile}) : super(key: key);

  @override
  State<PlanetPuzzleTile> createState() => _PlanetPuzzleTileState();
}

class _PlanetPuzzleTileState extends State<PlanetPuzzleTile> {
  final childVn = ValueNotifier<Widget?>(null);
  late ThemeBloc themeBloc;
  late PuzzleInitCubit puzzleInitCubit;
  Timer? _timer;

  double scale = 1.0;

  void _onHovering(bool isHovering) {
    setState(() {
      scale = isHovering ? 0.9 : 1.0;
    });
  }

  double get size {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= AppBreakpoints.small) {
      return BoardSize.small;
    }

    if (screenWidth <= AppBreakpoints.medium) {
      return BoardSize.medium;
    }

    return BoardSize.large;
  }

  _buildChild() {
    final theme = themeBloc.state.theme;

    if (context.read<PuzzleHelperCubit>().state.optimized) {
      // if we need to play optimized puzzle, just show images, instead of animations
      childVn.value = Image.asset(theme.placeholderAssetForTile);
      puzzleInitCubit.onInit(widget.tile.value);
    } else {
      // show animations if we don't wanna play optimized puzzle
      childVn.value = RiveAnimation.asset(
        theme.assetForTile,
        controllers: [puzzleInitCubit.getRiveControllerFor(widget.tile.value)],
        onInit: (_) => puzzleInitCubit.onInit(widget.tile.value),
        fit: BoxFit.cover,
        placeHolder: Image.asset(
          theme.placeholderThumbnail,
          fit: BoxFit.fill,
          height: size,
          width: size,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    themeBloc = context.read<ThemeBloc>();
    puzzleInitCubit = context.read<PuzzleInitCubit>();
    _timer = Timer(kMS800, () {
      _buildChild();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    puzzleInitCubit.getRiveControllerFor(widget.tile.value).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubitState = context.select((PuzzleInitCubit cubit) => cubit.state);
    final isReady = cubitState is PuzzleInitReady;

    final puzzleBloc = context.select((PuzzleBloc bloc) => bloc);
    final puzzleIncomplete =
        puzzleBloc.state.puzzleStatus == PuzzleStatus.incomplete;

    final puzzleHelperState =
        context.select((PuzzleHelperCubit cubit) => cubit.state);
    final isAutoSolving = puzzleHelperState.isAutoSolving;
    final showHelp = puzzleHelperState.showHelp;

    AppLogger.log('PlanetPuzzleTile: updated: isAutoSolving: $isAutoSolving');

    final status = context.select((PlanetPuzzleBloc bloc) => bloc.state.status);
    final hasStarted = status == PlanetPuzzleStatus.started;

    final movementDuration =
        status == PlanetPuzzleStatus.loading ? kMS800 : kMS350;

    final canPress = hasStarted && puzzleIncomplete && !isAutoSolving;

    final offset = size / widget.tile.puzzleSize;
    final x = widget.tile.currentPosition.x;
    final y = widget.tile.currentPosition.y;

    final correctX = widget.tile.correctPosition.x;
    final correctY = widget.tile.correctPosition.y;

    return AnimatedPositioned(
      duration: movementDuration,
      curve: Curves.easeInOut,
      top: offset * (y - correctY),
      left: offset * (x - correctX),
      child: ShakeAnimator(
        controller: puzzleBloc.getShakeControllerFor(
          widget.tile.value,
        ),
        child: AnimatedScale(
          scale: scale,
          curve: Curves.easeInOut,
          duration: kMS250,
          alignment: FractionalOffset(
            ((correctX + 1 / 2) * offset) / size,
            ((correctY + 1 / 2) * offset) / size,
          ),
          child: ClipPath(
            clipper: _PuzzlePieceClipper(widget.tile),
            child: MouseRegion(
              cursor: canPress
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.forbidden,
              onEnter: (_) {
                if (canPress) _onHovering(true);
              },
              onExit: (_) {
                _onHovering(false);
              },
              child: GestureDetector(
                onTap: () {
                  if (canPress) {
                    context.read<PuzzleBloc>().add(TileTapped(widget.tile));
                  }
                },
                child: SizedBox.square(
                  dimension: size,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Stack(
                      children: [
                        ValueListenableBuilder<Widget?>(
                          valueListenable: childVn,
                          builder: (_, child, __) =>
                              child ?? const SizedBox.shrink(),
                        ),
                        !isReady
                            ? SizedBox.square(
                                key: const Key('puzzle_tile_image'),
                                dimension: size,
                                child: Image.asset(
                                  themeBloc.state.theme.placeholderThumbnail,
                                  height: size,
                                  width: size,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : const SizedBox.shrink(),
                        _HelpWidget(
                          key: ValueKey(widget.tile.value),
                          tile: widget.tile,
                          showHelp: showHelp,
                          size: size,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HelpWidget extends StatelessWidget {
  final Tile tile;
  final bool showHelp;
  final double size;

  const _HelpWidget({
    Key? key,
    required this.tile,
    required this.showHelp,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final correctX = tile.correctPosition.x;
    final correctY = tile.correctPosition.y;

    final offset = size / tile.puzzleSize;

    const containerSize = 40.0;

    return Transform.translate(
      offset: Offset(
        ((correctX + 1 / 2) * offset) - containerSize / 2,
        ((correctY + 1 / 2) * offset) - containerSize / 2,
      ),
      child: AnimatedSwitcher(
        duration: kMS250,
        reverseDuration: kMS250,
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: showHelp
            ? Container(
                key: Key('helper_widget_${tile.value}'),
                width: containerSize,
                height: containerSize,
                alignment: Alignment.center,
                child: StylizedText(
                  text: '${tile.value + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: tile.puzzleSize == 3 ? 35.0 : 20.0,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _PuzzlePieceClipper extends CustomClipper<Path> {
  final Tile tile;

  const _PuzzlePieceClipper(this.tile);

  @override
  Path getClip(Size size) {
    return _getPiecePath(size, tile);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

Path _getPiecePath(Size size, Tile tile) {
  return Utils.getPuzzlePath(size, tile.puzzleSize, tile.correctPosition);
}
