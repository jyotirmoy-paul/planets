import 'package:flutter/material.dart';

import 'bordered_text.dart';

class StylizedText extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color strokeColor;
  final double strokeWidth;
  final double fontSize;
  final double offset;
  final TextStyle? style;
  final TextAlign? textAlign;
  final String? semanticsLabel;

  const StylizedText({
    Key? key,
    required this.text,
    this.textColor = Colors.white,
    this.strokeColor = Colors.black,
    this.strokeWidth = 6.0,
    this.fontSize = 16.0,
    this.offset = 2.0,
    this.style,
    this.textAlign,
    this.semanticsLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderedText(
      offset: offset,
      strokeWidth: strokeWidth,
      strokeColor: strokeColor,
      child: Text(
        text,
        textAlign: textAlign,
        style: style ??
            TextStyle(
              color: textColor,
              fontSize: fontSize,
              letterSpacing: 1.2,
            ),
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}
