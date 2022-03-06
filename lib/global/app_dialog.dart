import 'package:flutter/material.dart';

import '../layout/layout.dart';
import 'stylized_button.dart';
import 'stylized_container.dart';
import 'stylized_icon.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) {
        const paddingVertical = 48.0 * 2.0;
        const paddingHorizontal = 8.0 * 2.0;
        final size = MediaQuery.of(context).size;
        return Stack(
          alignment: Alignment.center,
          children: [
            // main body
            SizedBox(
              width: size.width - paddingHorizontal,
              height: size.height - paddingVertical,
              child: Material(
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: child,
              ),
            ),

            // close button
            Positioned(
              right: paddingHorizontal / 4,
              top: paddingVertical / 4,
              child: StylizedButton(
                onPressed: () => Navigator.pop(context),
                child: const StylizedContainer(
                  color: Colors.redAccent,
                  child: StylizedIcon(
                    icon: Icons.close_rounded,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize) {
        final dialogWidth =
            layoutSize == ResponsiveLayoutSize.large ? 1200.0 : 900.0;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: _LargeDialogBody(child: child, dialogWidth: dialogWidth),
        );
      },
    );
  }
}

class _LargeDialogBody extends StatelessWidget {
  final double dialogWidth;
  final Widget child;

  _LargeDialogBody({
    Key? key,
    required this.child,
    required this.dialogWidth,
  }) : super(key: key);

  final dialogSizeVn = ValueNotifier<Size?>(null);
  final dialogKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      dialogSizeVn.value =
          (dialogKey.currentContext?.findRenderObject() as RenderBox?)?.size;
    });

    return Stack(
      alignment: Alignment.center,
      children: [
        // main body
        SizedBox(
          key: dialogKey,
          width: dialogWidth,
          child: child,
        ),

        // close button
        ValueListenableBuilder<Size?>(
          valueListenable: dialogSizeVn,
          child: Align(
            alignment: Alignment.topRight,
            child: StylizedButton(
              onPressed: () => Navigator.pop(context),
              child: const StylizedContainer(
                padding: EdgeInsets.all(8.0),
                color: Colors.redAccent,
                child: StylizedIcon(
                  icon: Icons.close_rounded,
                  size: 24.0,
                  offset: 2,
                ),
              ),
            ),
          ),
          builder: (_, Size? size, Widget? child) {
            if (size == null) return const SizedBox.shrink();

            return SizedBox.fromSize(
              size: Size(size.width + 20.0, size.height + 20.0),
              child: child,
            );
          },
        ),
      ],
    );
  }
}
