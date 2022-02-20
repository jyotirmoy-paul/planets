import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoPair {
  final IconData titleIcon;
  final String titleText;
  final String description;

  // show icon will not show the text
  final bool showIcon;

  const InfoPair({
    this.titleIcon = FontAwesomeIcons.info,
    this.titleText = '',
    required this.description,
    this.showIcon = false,
  });
}
