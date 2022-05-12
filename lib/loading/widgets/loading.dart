import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../models/position.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

const Duration _animationTick = kMS200;
const int _fallOffset = 2;

class Loading extends StatefulWidget {
  final int n;
  final double tileSize;
  Loading({Key? key, this.n = 3, this.tileSize = 30.0})
      : assert(n.isOdd),
        super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  int get n => widget.n;
  int get gridSize => n * n;
  double get tileSize => widget.tileSize;

  int iterationNumber = 0;

  final List<_TileHolder> tiles = [];
  final List<int> animationOrder = [];
  late StreamSubscription streamSubscription;

  Position getPosition(int index) {
    if (index == -1) return const Position(x: 0, y: -_fallOffset);

    int x = index % n;
    int y = index ~/ n;

    return Position(x: x, y: y);
  }

  /// generates initial list of positions
  void generateList(int n) {
    int i = 0;
    int c = 0;
    List<int> orderedList = [-1];
    while (i < gridSize) {
      List<int> tmp = [];
      int count = 0;
      while (i < gridSize) {
        tmp.add(i);
        i += 1;
        count += 1;
        if (count == n) break;
      }
      if (c.isOdd) {
        orderedList.addAll(tmp.reversed);
      } else {
        orderedList.addAll(tmp);
      }
      c += 1;
    }

    animationOrder.clear();
    animationOrder.addAll(orderedList.reversed);

    log('loading.dart: generateList :: Generated loading sequence');

    tiles.clear();
    tiles.addAll(
      orderedList.reversed.map(
        (i) => _TileHolder(
          iterationNumber: iterationNumber,
          value: i,
          currentPosition: getPosition(i),
          fade: i == -1,
          tileSize: tileSize,
        ),
      ),
    );
  }

  void rebuild() {
    if (mounted) setState(() {});
  }

  void init() {
    // generate initial list
    generateList(n);
    rebuild();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAnimation();
    });
  }

  Future<void> reset() async {
    iterationNumber += 1;
    whiteSpaceIndex = -1;
    trendCounter = 0;
    lastTrend = _Trend.right;
    currentTrend = _Trend.right;

    // restart animation
    await Future.delayed(_animationTick);

    generateList(n);
    rebuild();

    // restart animation
    await Future.delayed(_animationTick);

    if (mounted) startAnimation();
  }

  int whiteSpaceIndex = -1;
  int trendCounter = 0;
  _Trend lastTrend = _Trend.right;
  _Trend currentTrend = _Trend.right;

  void startAnimation() async {
    for (final value in animationOrder) {
      if (!mounted) return;
      if (value == -1) {
        // one half ends
        tiles.firstWhere((t) => t.value == value).doItAgain();
        rebuild();
        await reset();
      } else {
        animate(tiles.indexWhere((e) => e.value == value));
      }
      await Future.delayed(_animationTick);
    }
  }

  void animate(int currentIndex) {
    if (whiteSpaceIndex != -1) {
      switch (currentTrend) {
        case _Trend.left:
          tiles[currentIndex].moveLeft();
          break;

        case _Trend.right:
          tiles[currentIndex].moveRight();
          break;

        case _Trend.down:
          tiles[currentIndex].moveDown();
          break;
      }
    } else {
      whiteSpaceIndex = currentIndex;
      tiles[currentIndex].makeFall();
    }

    trendCounter += 1;
    if (trendCounter == n) {
      trendCounter = 0;
      lastTrend = currentTrend.other;
      currentTrend = _Trend.down;
    } else if (currentTrend == _Trend.down) {
      currentTrend = lastTrend;
    }

    rebuild();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    // streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: tileSize * n,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: tiles.map((t) => t.widget).toList(),
      ),
    );
  }
}

enum _Trend {
  left,
  right,
  down,
}

extension _TrendHelper on _Trend {
  _Trend get other {
    assert(this != _Trend.down);

    if (this == _Trend.left) {
      return _Trend.right;
    } else {
      return _Trend.left;
    }
  }
}

class _TileHolder {
  final double tileSize;
  int iterationNumber;
  Position currentPosition;
  int value;
  bool fade;

  _TileHolder({
    required this.value,
    required this.currentPosition,
    this.fade = false,

    // this is used for animation only
    this.iterationNumber = 0,
    required this.tileSize,
  });

  void doItAgain() {
    fade = false;
    assert(value == -1);
    currentPosition = Position.zero();
  }

  void makeFall() {
    fade = true;
    currentPosition = Position(
      x: currentPosition.x,
      y: currentPosition.y + _fallOffset,
    );
  }

  void moveLeft() {
    currentPosition = currentPosition.left;
  }

  void moveRight() {
    currentPosition = currentPosition.right;
  }

  void moveDown() {
    currentPosition = currentPosition.bottom;
  }

  Widget get widget => _Tile(
        key: Key('$value-$iterationNumber'),
        position: currentPosition,
        value: value,
        fade: fade,
        tileSize: tileSize,
      );
}

class _Tile extends StatelessWidget {
  final double tileSize;
  final Position position;
  final int value;
  final bool fade;

  const _Tile({
    Key? key,
    required this.position,
    required this.value,
    required this.fade,
    required this.tileSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: _animationTick,
      left: position.x * tileSize,
      top: position.y * tileSize,
      width: tileSize,
      height: tileSize,
      child: AnimatedOpacity(
        duration: _animationTick,
        curve: Curves.easeInOut,
        opacity: fade ? 0.0 : 1.0,
        child: Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Utils.darkenColor(Colors.blue, 0.38),
            boxShadow: const [
              BoxShadow(
                blurRadius: 0.1,
                spreadRadius: 2.0,
                color: Colors.white,
                offset: Offset(1.0, 1.0),
              ),
            ],
            // border: Border.all(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.circular(4.0),
          ),
          alignment: Alignment.center,
          child: const FlutterLogo(),
        ),
      ),
    );
  }
}
