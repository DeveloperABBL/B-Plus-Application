import 'package:flutter/material.dart';

/// A wrapper widget that dismisses the keyboard when the user taps
/// outside of any focused text field.
class KeyboardDismissible extends StatelessWidget {
  final Widget child;

  const KeyboardDismissible({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
