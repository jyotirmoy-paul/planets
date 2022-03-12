import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AppAnimatedWidget extends StatefulWidget {
  final Widget child;
  final bool showOnComplete;

  const AppAnimatedWidget({
    Key? key,
    required this.child,
    this.showOnComplete = false,
  }) : super(key: key);

  @override
  State<AppAnimatedWidget> createState() => _AppAnimatedWidgetState();
}

class _AppAnimatedWidgetState extends State<AppAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> inOpacity;
  late Animation<double> inScale;
  late Animation<double> outOpacity;

  bool isDone = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: kS1,
    );

    inOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    inScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    outOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.81, 1, curve: Curves.easeIn),
      ),
    );

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) setState(() => isDone = true);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showOnComplete) {
      if (isDone) {
        return widget.child;
      }
      return FadeTransition(
        opacity: inOpacity,
        child: ScaleTransition(
          scale: inScale,
          child: widget.child,
        ),
      );
    }

    return FadeTransition(
      opacity: outOpacity,
      child: FadeTransition(
        opacity: inOpacity,
        child: ScaleTransition(
          scale: inScale,
          child: widget.child,
        ),
      ),
    );
  }
}
