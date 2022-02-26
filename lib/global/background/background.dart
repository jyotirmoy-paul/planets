import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../models/position.dart';
import '../../models/star.dart';
import '../../utils/constants.dart';

class Background extends StatefulWidget {
  final Widget child;

  const Background({Key? key, required this.child}) : super(key: key);

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  final List<Star> stars = [];
  final _random = math.Random();

  List<Star> _makeStars(int n) {
    const size = kStarsDrawingCanvasSize;

    return List.generate(
      n,
      (i) => Star(
        value: i,
        pos: Position(
          x: _random.nextInt(size.width.toInt()),
          y: _random.nextInt(size.height.toInt()),
        ),
        size:
            math.max(_random.nextDouble(), kMinStarPercentage) * kBaseStarSize,
        rotation: _random.nextDouble() * math.pi,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() => stars.addAll(_makeStars(kNoStars)));
    });
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
