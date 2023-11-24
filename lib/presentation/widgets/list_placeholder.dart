import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../domain/enums/data_error_enum.dart';
import '../../utils/constants/app_colors.dart';

class ListPlaceHolder extends StatelessWidget {
  const ListPlaceHolder({
    super.key,
    required this.placeHolderText,
    this.errorType = DataErrorEnum.general,
  });

  final String placeHolderText;
  final DataErrorEnum errorType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            errorType.iconSource,
            width: 75,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 15),
          Text(
            placeHolderText,
            style: const TextStyle(
              color: AppColors.black1,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
