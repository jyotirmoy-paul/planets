import 'package:flutter/material.dart';

import '../../models/orbit.dart';

class OrbitWidget extends StatelessWidget {
  final Orbit orbit;

  const OrbitWidget({
    Key? key,
    required this.orbit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: orbit.origin.x,
      top: orbit.origin.y,
      child: Container(
        width: orbit.r1,
        height: orbit.r2,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white10, width: orbit.orbitWidth),
          borderRadius: BorderRadius.all(
            Radius.elliptical(orbit.r1, orbit.r2),
          ),
        ),
      ),
    );
  }
}
