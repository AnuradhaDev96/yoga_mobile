import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/enums/session_category_enum.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';
import '../../blocs/authentication_bloc.dart';
import '../../states/authentication_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Good morning',
          style: TextStyle(color: AppColors.black1, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          Image.asset(Assets.userAvatarPng, width: 32, height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 10),
            child: InkWell(
              onTap: () {
                AuthenticationBloc().add(LoggedOut());
              },
              child: SvgPicture.asset(Assets.logoutIcon, width: 31, height: 31),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 135,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 24, right: 24),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var category = SessionCategoryEnum.values[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        margin: const EdgeInsets.only(bottom: 13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(category.source),
                          )
                        ),
                      ),
                      Text(
                        category.text,
                        style: const TextStyle(
                          color: AppColors.black1,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemCount: SessionCategoryEnum.values.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
