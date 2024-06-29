import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? colors;
  final FontWeight? fontWeight;
 final fontFamily;
  const CustomText(
      {Key? key, this.text, this.fontSize, this.colors, this.fontWeight, this.fontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text.toString(),
        style: TextStyle(
            fontSize: fontSize ?? 16,
            color:Colors.black,
            fontWeight: fontWeight ?? FontWeight.normal));
  }
}
