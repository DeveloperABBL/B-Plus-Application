import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool iconOnly;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = iconOnly
        ? const Icon(Icons.arrow_forward, color: Colors.white)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            ],
          );

    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF15B34A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: buttonChild,
      ),
    );
  }
}
