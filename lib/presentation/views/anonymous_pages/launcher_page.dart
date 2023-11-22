import 'package:flutter/material.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';
import 'create_account_page.dart';

class LauncherPage extends StatelessWidget {
  const LauncherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey1,
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
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                    AppColors.grey1,
                    AppColors.grey1,
                    AppColors.grey1.withOpacity(0.0),
                  ]),
                ),
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 24, top: 32),
                      child: Text(
                        'keepyoga',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24, color: Color(0xFFAFBCCB), letterSpacing: -1.3),
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
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateAccountPage()),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                fixedSize: Size(MediaQuery.sizeOf(context).width, 48),
                foregroundColor: AppColors.black1,
                backgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                surfaceTintColor: Colors.transparent,
              ),
              child: const Text('Get started'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                fixedSize: Size(MediaQuery.sizeOf(context).width, 48),
                backgroundColor: AppColors.indigo1,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                surfaceTintColor: Colors.transparent,
              ),
              child: const Text('Log in'),
            )
          ],
        ),
      ),
    );
  }
}
