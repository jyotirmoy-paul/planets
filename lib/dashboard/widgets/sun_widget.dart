import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../resource/app_assets.dart';

class SunWidget extends StatelessWidget {
  final double scale;

  const SunWidget({
    Key? key,
    this.scale = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentSize = MediaQuery.of(context).size;
    final double sunSize = math.max(parentSize.width * 0.33, 350.0);

    return Positioned(
      key: const Key('Sun'),
      top: parentSize.height / 2 - sunSize / 2,
      left: (-sunSize / 2),
      child: Transform.scale(
        scale: scale,
        child: Transform.rotate(
          angle: math.pi / 2,
          // turns: 1,
          // duration: const Duration(milliseconds: 100),
          child: Image.asset(
            AppAssets.sunImage,
            width: sunSize,
            height: sunSize,
          ),
        ),
        // child: Container(
        //   height: sunSize,
        //   width: sunSize,
        //   decoration: BoxDecoration(
        //     color: Colors.amber,
        //     shape: BoxShape.circle,
        //     border: Border.all(
        //       width: 10.0,
        //       color: Colors.yellow,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
