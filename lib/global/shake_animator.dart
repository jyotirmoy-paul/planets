import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/constants.dart';

const _shakeAnimationDuration = kMS400;
const double _offsetAmount = 8.0;
const double _w = 26.4;
const double _a = 0.8;

class ShakeAnimator extends StatefulWidget {
  const ShakeAnimator({
    Key? key,
    this.controller,
    this.child,
  }) : super(key: key);

  final ShakeAnimatorController? controller;
  final Widget? child;

  @override
  State<ShakeAnimator> createState() => _ShakeAnimatorState();
}

class _ShakeAnimatorState extends State<ShakeAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  ShakeDirection _shakeDirection = ShakeDirection.horizontal;

  void shake(ShakeDirection direction) {
    _shakeDirection = direction;
    _animationController.forward(from: 0.0);
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController.value = 0.0;
    }
  }

  void _init() {
    widget.controller?.state = this;
    _animationController = AnimationController(
      vsync: this,
      duration: _shakeAnimationDuration,
    );

    _animationController.addStatusListener(_animationStatusListener);

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: const SpringCurve(),
    ));
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Offset _getOffset() {
    switch (_shakeDirection) {
      case ShakeDirection.horizontal:
        return Offset(_offsetAmount * _animation.value, 0.0);

      case ShakeDirection.vertical:
        return Offset(0.0, _offsetAmount * _animation.value);

      case ShakeDirection.diagonal:
        final value = _offsetAmount * _animation.value;
        return Offset(value, value);

      case ShakeDirection.oppositeDiagonal:
        final value = _offsetAmount * _animation.value;
        return Offset(-value, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (_, Widget? child) => Transform.translate(
        offset: _getOffset(),
        child: child,
      ),
    );
  }
}

enum ShakeDirection {
  horizontal,
  vertical,
  diagonal,
  oppositeDiagonal,
}

class ShakeAnimatorController {
  _ShakeAnimatorState? state;

  void shake([ShakeDirection direction = ShakeDirection.horizontal]) {
    state?.shake(direction);
  }
}

class SpringCurve extends Curve {
  const SpringCurve();

  @override
  double transformInternal(double t) {
    return (1 - math.pow(t, 2)) *
        (math.pow(math.e, -t / _a) * (math.sin(t * _w)));
  }
}
