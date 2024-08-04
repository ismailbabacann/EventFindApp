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
    Color mainColor = Color(0xFF6D3B8C);
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // bu tarz kullanmayı unutma bidahikine
          SvgPicture.asset(
            'lib/assets/icons/iconbackground_purple(8A3AC8).svg',
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
