import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomMarker extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final VoidCallback onPressed;

  CustomMarker({
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // bu tarz kullanmayı unutma bidahikine
          SvgPicture.asset(
            'lib/assets/icons/iconbackground.svg',
            width: iconSize + 90,
            height: iconSize + 90,
            alignment: Alignment.center,
          ),
          Transform.translate(
            offset: Offset(0, -2),
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
