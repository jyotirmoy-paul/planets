import 'package:flutter/material.dart';
import 'package:planets/helpers/modal_helpers.dart';

abstract class InfoCard {
  static Future<void> show({required BuildContext context}) {
    return showAppDialog(
      context: context,
      child: const _InfoCard(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
