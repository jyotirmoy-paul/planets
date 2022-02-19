import 'package:flutter/material.dart';
import 'package:planets/global/stylized_container.dart';

import '../layout/layout.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              color: Colors.amber[100]!,
              child: Material(
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: child,
              ),
            ),
          ),
        ),
      ),
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize) {
        final dialogWidth =
            layoutSize == ResponsiveLayoutSize.large ? 740.0 : 700.0;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: dialogWidth,
            child: child,
          ),
        );
      },
    );
  }
}
