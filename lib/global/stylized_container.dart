import 'package:flutter/material.dart';
import '../utils/utils.dart';

class StylizedContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color color;

  const StylizedContainer({
    Key? key,
    this.child,
    this.padding,
    this.margin,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Utils.darkenColor(color),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Transform.translate(
        offset: const Offset(0.0, -8.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
