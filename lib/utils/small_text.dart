import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final int? maxLine;
  final String? fontFamily;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final double? height;
  final TextDecoration? decoration; // New property
  final TextDecoration? letterspcing; // New property
  final Color? decorationColor;

  const SmallText({
    super.key,
    required this.text,
    this.color,
    this.size = 16,
    this.height,
    this.fontStyle,
    this.fontWeight,
    this.maxLine,
    this.overflow,
    this.textStyle,
    this.textAlign,
    this.fontFamily,
    this.decoration,
    this.decorationColor,
    this.letterspcing// New constructor parameter
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLine,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        height: height,
        fontFamily: fontFamily,
        decoration: decoration, // Set decoration
        decorationColor:decorationColor,
      ),
    );
  }
}
