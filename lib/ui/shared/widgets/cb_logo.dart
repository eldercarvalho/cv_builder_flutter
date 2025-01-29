import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CbLogo extends StatelessWidget {
  const CbLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/mascot.svg',
      width: 140,
    );
  }
}
