import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';

class NanyangBadge extends StatelessWidget {
  final String text;
  final String status;
  final double fontSize;
  const NanyangBadge({super.key, required this.text, required this.status, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? textColor;

    switch (status) {
      case 'success':
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case 'danger':
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case 'warning':
        backgroundColor = Colors.yellow;
        textColor = Colors.black;
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: dynamicFontSize(fontSize, context),
          fontWeight: FontWeight.w500,
        ),
      )
    );
  }
}