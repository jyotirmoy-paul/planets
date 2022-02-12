import 'package:flutter/material.dart';
import 'package:planets/layout/utils/app_breakpoints.dart';

class SunWidget extends StatelessWidget {
  final double scale;

  const SunWidget({
    Key? key,
    this.scale = 1.0,
  }) : super(key: key);

  double _getFactor(double width) {
    if (width < AppBreakpoints.medium) return 1.0;
    if (width < AppBreakpoints.small) return 1.2;

    return 0.90;
  }

  @override
  Widget build(BuildContext context) {
    final parentSize = MediaQuery.of(context).size;
    final sunSize = parentSize.width * 0.33;

    return Positioned(
      key: const Key('Sun'),
      top: parentSize.height / 2 - sunSize / 2,
      left: (-sunSize / 2) * _getFactor(parentSize.width),
      child: Transform.scale(
        scale: scale,
        child: Container(
          height: sunSize,
          width: sunSize,
          decoration: BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
            border: Border.all(
              width: 10.0,
              color: Colors.yellow,
            ),
          ),
        ),
      ),
    );
  }
}
