import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../layout/utils/responsive_layout_builder.dart';

class ScrollButtons extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const ScrollButtons({
    Key? key,
    this.onNext,
    this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.50)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // previous button
              ResponsiveLayoutBuilder(
                small: (_, __) => IconButton(
                  iconSize: 24.0,
                  onPressed: onPrevious,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                medium: (_, __) => IconButton(
                  iconSize: 32.0,
                  onPressed: onPrevious,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                large: (_, __) => const SizedBox.shrink(),
              ),

              // gap
              const Gap(24.0),

              // next button
              ResponsiveLayoutBuilder(
                small: (_, __) => IconButton(
                  iconSize: 24.0,
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
                medium: (_, __) => IconButton(
                  iconSize: 32.0,
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
                large: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
