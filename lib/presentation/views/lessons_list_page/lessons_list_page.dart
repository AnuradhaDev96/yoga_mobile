import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';

class LessonsListPage extends StatelessWidget {
  LessonsListPage({super.key});

  // final _bottomScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset('assets/png/temp_image.png', width: MediaQuery.sizeOf(context).width, fit: BoxFit.fitWidth)
        ],
      ),
      bottomSheet: Container(
        height: MediaQuery.sizeOf(context).height * 0.54,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            )),
        child: CustomScrollView(
          // controller: _bottomScrollController,
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(color: AppColors.grey4, borderRadius: BorderRadius.circular(100)),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 24, right: 14, bottom: 21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        'Yoga Pilates Full Body',
                        style: TextStyle(
                          color: AppColors.black1,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '5 Lessons',
                      style: TextStyle(
                        color: AppColors.indigo1,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 30),
                itemBuilder: (context, index) {
                  return Container(
                    // height: 50,
                    padding: const EdgeInsets.fromLTRB(24, 12, 21, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          offset: const Offset(0, 3),
                          spreadRadius: 0,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(Assets.lessonAvatar, width: 40, height: 40),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Lesson 01',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.black1,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.6,
                                  child: const Text(
                                    'Lorem Ipsum is simply dummy text of',
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF7B7F82),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SvgPicture.asset(Assets.lessonCardPlayIcon, width: 27, height: 27),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 23),
                itemCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
