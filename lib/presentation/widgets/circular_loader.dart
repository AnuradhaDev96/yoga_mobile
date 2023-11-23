import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({
    Key? key,
    this.lineColor = AppColors.grey2,
    this.circleSize = 60,
    this.strokeWidth = 3,
  }) : super(key: key);

  final Color lineColor;
  final double circleSize;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: circleSize,
        width: circleSize,
        child: CircularProgressIndicator(
          color: lineColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}