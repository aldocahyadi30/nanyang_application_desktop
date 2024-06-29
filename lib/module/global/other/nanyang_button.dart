import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';

enum ButtonSize { small, medium, large }

class NanyangButton extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color overlayColor;
  final void Function() onPressed;
  final ButtonSize size;
  final Icon? icon;
  final BorderRadius? borderRadius;

  const NanyangButton({
    super.key,
    required this.child,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.overlayColor = Colors.black,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
    this.borderRadius,
  });

  @override
  State<NanyangButton> createState() => _NanyangButtonState();
}

class _NanyangButtonState extends State<NanyangButton> {
  late double height;

  @override
  void initState() {
    super.initState();
    switch (widget.size) {
      case ButtonSize.small:
        height = 20;
        break;
      case ButtonSize.medium:
        height = 40;
        break;
      case ButtonSize.large:
        height = 60;
        break;
      default:
        height = 40;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dynamicHeight(height, context),
      child: FilledButton.icon(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(dynamicPaddingAll(8, context)),
          backgroundColor: WidgetStateProperty.all<Color>(widget.backgroundColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            ),
          ),
        ),
        icon: widget.icon,
        label: widget.child,
      ),
    );
  }
}