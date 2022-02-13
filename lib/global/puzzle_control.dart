import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:planets/global/app_icon_button.dart';
import 'package:planets/global/stylized_container.dart';

class PuzzleControl extends StatelessWidget {
  const PuzzleControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StylizedContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // start / auto solve button
          ElevatedButton(
            onPressed: () {},
            child: Text('Auto Solve'),
          ),

          // gap
          const Gap(32.0),

          // restart
          AppIconButton(iconData: Icons.restart_alt),
        ],
      ),
    );
  }
}
