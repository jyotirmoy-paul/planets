import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/position.dart';
import '../../models/star.dart';
import '../../utils/constants.dart';

class Background extends StatefulWidget {
  final Widget child;

  const Background({Key? key, required this.child}) : super(key: key);

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> with WidgetsBindingObserver {
  final List<Star> stars = [];
  final _random = math.Random();

  Size? _lastSize;
  List<Position>? _starPositions;
  late List<double> _starSizes;
  late List<double> _starRotations;

  List<Position> _generatePositions(int n, {required Size currentSize}) {
    if (_lastSize == null || _starPositions == null) {
      // as no last size is available, generate new positions
      _starPositions = List<Position>.generate(
        n,
        (i) => Position(
          x: _random.nextInt(currentSize.width.toInt()),
          y: _random.nextInt(currentSize.height.toInt()),
        ),
      );
    } else {
      // as this is a re-size of window, redistribute the existing positions, to fit well in the new resized window
      _starPositions = List<Position>.generate(
        n,
        (i) => Position(
          x: _starPositions![i].x * currentSize.width ~/ _lastSize!.width,
          y: _starPositions![i].y * currentSize.height ~/ _lastSize!.height,
        ),
      );
    }

    return _starPositions!;
  }

  List<Star> _makeStars(int n) {
    final size = MediaQuery.of(context).size;

    // get positions for all n stars
    final positions = _generatePositions(n, currentSize: size);

    _lastSize = size;

    return List.generate(
      n,
      (i) => Star(
        value: i,
        pos: positions[i],
        size: _starSizes[i],
        rotation: _starRotations[i],
      ),
    );
  }

  Timer? _debounce;

  void _buildStars({bool isFirstTime = false}) {
    if (_debounce?.isActive == true) _debounce?.cancel();
    _debounce = Timer(kMS150, () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (!isFirstTime) stars.clear();
        setState(() => stars.addAll(_makeStars(kNoStars)));
      });
    });
  }

  void _initStarVariables() {
    _starSizes = List.generate(
      kNoStars,
      (i) => math.max(_random.nextDouble(), kMinStarPercentage) * kBaseStarSize,
    );

    _starRotations = List.generate(
      kNoStars,
      (i) => _random.nextDouble() * math.pi,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initStarVariables();
    _buildStars(isFirstTime: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _buildStars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: kBackgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // stars
              ...stars.map<Widget>((s) => s.widget).toList(),

              // widget
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}
