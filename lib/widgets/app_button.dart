import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isOutlined;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? Colors.transparent : color,
        side: isOutlined ? BorderSide(color: color) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isOutlined ? color : textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
