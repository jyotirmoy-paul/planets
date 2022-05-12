import 'package:flutter/material.dart';

import '../utils/utils.dart';

class StylizedContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color color;

  const StylizedContainer({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 18.0,
      vertical: 12.0,
    ),
    this.margin,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  State<StylizedContainer> createState() => _StylizedContainerState();
}

class _StylizedContainerState extends State<StylizedContainer> {
  final globalKey = GlobalKey();

  Widget? topReflectionWidget;

  void _buildReflectionWidget(_) {
    final size = globalKey.currentContext?.size;
    if (size == null) return;

    setState(() {
      topReflectionWidget = Container(
        margin: const EdgeInsets.all(5.0),
        height: size.height * 0.50,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.60),
          borderRadius: BorderRadius.circular(8.0),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_buildReflectionWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: Utils.darkenColor(widget.color),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Transform.translate(
        offset: const Offset(0.0, -6.0),
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // reflection widget
              topReflectionWidget ?? const SizedBox.shrink(),

              // child widget
              Container(
                margin: widget.padding,
                key: globalKey,
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
