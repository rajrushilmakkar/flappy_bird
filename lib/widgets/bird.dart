import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Bird extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      child: SvgPicture.asset('lib/assets/images/birdi.svg'),
    );
  }
}
