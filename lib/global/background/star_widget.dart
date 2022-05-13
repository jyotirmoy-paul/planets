import 'package:flutter/material.dart';

import '../../models/star.dart';
import '../../utils/constants.dart';

class StarWidget extends StatelessWidget {
  final Star star;
  const StarWidget({
    Key? key,
    required this.star,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: kMS500,
      left: star.pos.x.toDouble(),
      top: star.pos.y.toDouble(),
      width: star.size,
      height: star.size,
      child: Transform.rotate(
        angle: star.rotation,
        child: Icon(
          Icons.star_rounded,
          color: const Color(0xB3ffffff),
          size: star.size,
        ),
      ),
    );
  }
}
