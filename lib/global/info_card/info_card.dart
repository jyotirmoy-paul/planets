import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../helpers/modal_helpers.dart';
import '../../layout/utils/responsive_layout_builder.dart';
import '../stylized_icon.dart';
import '../stylized_text.dart';
import 'info_data.dart';
import 'info_pair.dart';

abstract class InfoCard {
  static bool _isVisible = false;
  static Future<void> show({required BuildContext context}) async {
    if (_isVisible) return;
    _isVisible = true;

    await showAppDialog(
      context: context,
      child: _InfoCard(AppShortcutData.data(context)),
    );

    _isVisible = false;
  }
}

class _InfoCard extends StatelessWidget {
  final List<InfoData> _data;

  const _InfoCard(this._data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.80),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          width: 2.0,
          color: Colors.amber,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
        physics: const BouncingScrollPhysics(),
        child: ResponsiveLayoutBuilder(
          small: (_, __) => Column(
            children: _data
                .map<Widget>((d) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: _ShortcutColumn(d),
                    ))
                .toList(),
          ),
          medium: (_, Widget? child) => child!,
          large: (_, Widget? child) => child!,
          child: (_) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _data
                .map<Widget>((d) => Expanded(child: _ShortcutColumn(d)))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _ShortcutColumn extends StatelessWidget {
  final InfoData infoData;
  const _ShortcutColumn(this.infoData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // header
        _ShortcutScreenHeader(infoData.title),

        // gap
        const Gap(28),

        // body
        Column(
          mainAxisSize: MainAxisSize.min,
          children: infoData.infoPairs
              .map<Widget>((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _ShortcutListTile(d),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _ShortcutScreenHeader extends StatelessWidget {
  final String _header;
  const _ShortcutScreenHeader(this._header, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StylizedText(
      text: _header,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 28.0,
        color: Colors.white,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _ShortcutListTile extends StatelessWidget {
  final InfoPair _infopair;
  const _ShortcutListTile(this._infopair, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _infopair.showIcon
              ? StylizedIcon(icon: _infopair.titleIcon)
              : StylizedText(text: _infopair.titleText, fontSize: 24.0),
        ),
        Expanded(
          flex: 2,
          child: Text(
            _infopair.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ],
    );
  }
}
