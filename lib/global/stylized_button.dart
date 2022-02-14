import 'package:flutter/material.dart';

class StylizedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  StylizedButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  final _buttonPressedVn = ValueNotifier<bool>(false);

  void _animate() {
    _buttonPressedVn.value = true;
  }

  Future<void> _reverseAnimate() async {
    await Future.delayed(const Duration(milliseconds: 50));
    _buttonPressedVn.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _animate(),
        onTapUp: (_) async {
          await _reverseAnimate();
          onPressed?.call();
        },
        onTapCancel: _reverseAnimate,
        child: ValueListenableBuilder(
          valueListenable: _buttonPressedVn,
          child: child,
          builder: (_, bool isPressed, Widget? child) {
            return AnimatedScale(
              scale: isPressed ? 0.90 : 1.0,
              curve: Curves.elasticOut,
              duration: const Duration(milliseconds: 280),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
