import 'package:flutter/material.dart';

class SunWidget extends StatelessWidget {
  const SunWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentSize = MediaQuery.of(context).size;
    final sunSize = parentSize.width * 0.33;

    return Positioned(
      top: parentSize.height / 2 - sunSize / 2,
      left: (-sunSize / 2) * 0.90,
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
    );
  }
}
