import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../constants/assets.dart';

abstract class MessageUtils {
  static const noInternetAvailable = 'Please check your internet connection.';

  /// Show message on top of the screen
  static Future<void> showSnackBarOverBarrier(
      BuildContext context,
      String message, {
        bool isErrorMessage = false,
      }) async {
    await Flushbar(
      backgroundColor: isErrorMessage ? AppColors.grey2 : AppColors.indigo1,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(milliseconds: 1800),
      animationDuration: const Duration(milliseconds: 350),
      borderRadius: BorderRadius.circular(16),
      margin: const EdgeInsets.only(top: 8, left: 7, right: 7),
      padding: const EdgeInsets.only(top: 15, left: 20, right: 18, bottom: 15),
      title: isErrorMessage ? 'Oops !' : 'Success !',
      borderColor: Colors.white,
      borderWidth: 3,
      messageText: Text(
        message,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      icon: isErrorMessage
          ? SvgPicture.asset(Assets.errorFlushbarIcon, width: 40, height: 40)
          : SvgPicture.asset(Assets.successFlushbarIcon, width: 32, height: 32),
    ).show(context);
  }
}