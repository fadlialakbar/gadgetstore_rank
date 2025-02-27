import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildRankIcon(int rank) {
  Color color;

  switch (rank) {
    case 1:
      color = Colors.amber;
      break;
    case 2:
      color = const Color(0xFFC0C0C0);
      break;
    case 3:
      color = const Color(0xFFCD7F32);
      break;
    default:
      color = Colors.grey;
  }

  return SizedBox(
    width: 32,
    height: 32,
    child: Stack(
      children: [
        SvgPicture.asset(
          'assets/icons/crown.svg',
          height: 32,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          top: 0,
          child: Center(
            child: Text(
              rank.toString(),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2.0,
                    color: Colors.black38,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
