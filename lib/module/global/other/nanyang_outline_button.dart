import 'package:flutter/material.dart';

class NanyangOutlineButton extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final void Function() onPressed;
  const NanyangOutlineButton({super.key, required this.child, required this.backgroundColor, required this.onPressed});

  @override
  State<NanyangOutlineButton> createState() => _NanyangOutlineButtonState();
}

class _NanyangOutlineButtonState extends State<NanyangOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: widget.onPressed, child: widget.child, style: OutlinedButton.styleFrom(backgroundColor: widget.backgroundColor));
  }
}