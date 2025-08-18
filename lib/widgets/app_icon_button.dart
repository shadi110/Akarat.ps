import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double fontSize;
  final double iconSize;
  final double borderRadius;

  const AppIconButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.iconSize = 20,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize, color: textColor),
      label: Text(
        text,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
