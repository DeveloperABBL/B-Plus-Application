import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool iconOnly;
  final String? iconPath;
  final Alignment alignment;
  final OutlinedBorder? shape;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconOnly = false,
    this.iconPath,
    this.alignment = Alignment.center,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = iconOnly
        ? SvgPicture.asset(
            iconPath ?? 'assets/svg/ic_arrow_right.svg',
            width: 20,
            height: 20,
          )
        : Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (iconPath != null) ...[
                const SizedBox(width: 8),
                SvgPicture.asset(iconPath!, width: 20, height: 20),
              ],
            ],
          );

    return SizedBox(
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2FBA38),
          shape:
              shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          alignment: alignment,
          padding: iconOnly ? EdgeInsets.zero : null,
          minimumSize: iconOnly ? Size.zero : null,
          tapTargetSize: iconOnly ? MaterialTapTargetSize.shrinkWrap : null,
        ),
        onPressed: onPressed,
        child: buttonChild,
      ),
    );
  }
}
