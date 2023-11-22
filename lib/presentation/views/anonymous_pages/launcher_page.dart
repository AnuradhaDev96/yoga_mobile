import 'package:flutter/material.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';

class LauncherPage extends StatelessWidget {
  const LauncherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAE2EB),
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              child: Image.asset(
                Assets.launcherScreenImage,
                width: MediaQuery.sizeOf(context).width,
                fit: BoxFit.fitWidth,
              ),
            ),
            const Positioned(
              top: 0,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 24, top: 32),
                    child: Text(
                      'keepyoga',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: Color(0xFFAFBCCB),
                          letterSpacing: -1.3),
                    ),
                  ),
                  Text(
                    'Practice yoga\nwhenever you want.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      height: 1.2,
                      color: AppColors.black1,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
