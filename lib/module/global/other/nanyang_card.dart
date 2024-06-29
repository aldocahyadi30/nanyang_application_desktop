import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';

class NanyangCard extends StatelessWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget child;

  const NanyangCard({super.key, required this.title, required this.actions, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: dynamicPaddingSymmetric(16, 32, context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title,
                Row(
                  children: actions,
                ),
              ],
            ),
            SizedBox(height: dynamicHeight(16, context)),
            child,
          ],
        ),
      ),
    );
  }
}