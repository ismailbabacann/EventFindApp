import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomMarker extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final VoidCallback onPressed;
  final String backgroundSvg;

  CustomMarker({
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.onPressed,
    required this.backgroundSvg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            backgroundSvg,
            width: iconSize + 40,
            height: iconSize + 40,
            alignment: Alignment.center,
          ),
          Transform.translate(
        offset: Offset(-8, -12),
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
        ),
        ],
      ),
    );
  }
}
