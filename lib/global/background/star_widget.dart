import 'package:flutter/material.dart';

import '../../models/star.dart';

class StarWidget extends StatelessWidget {
  final Star star;
  const StarWidget({
    Key? key,
    required this.star,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: star.pos.x.toDouble(),
      top: star.pos.y.toDouble(),
      width: star.size,
      height: star.size,
      child: Transform.rotate(
        angle: star.rotation,
        child: Icon(
          Icons.star_rounded,
          color: Colors.white,
          size: star.size,
        ),
      ),
    );
  }
}
