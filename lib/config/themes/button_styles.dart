import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';

abstract class ButtonStyles {

  /// Elevated Button style for primary button
  static ButtonStyle primaryElevatedButtonStyle(BuildContext context) => ElevatedButton.styleFrom(
        elevation: 0,
        fixedSize: Size(MediaQuery.sizeOf(context).width, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
        backgroundColor: AppColors.indigo1,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        surfaceTintColor: Colors.transparent,
      );
}
