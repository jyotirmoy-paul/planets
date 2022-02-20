import 'package:flutter/material.dart';

import '../global/app_dialog.dart';

/// Displays the [AppDialog] above the current contents of the app.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
  String barrierLabel = '',
}) =>
    showGeneralDialog<T>(
      transitionBuilder: (context, animation, secondaryAnimation, widget) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.decelerate,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 450),
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => AppDialog(
        child: child,
      ),
    );
