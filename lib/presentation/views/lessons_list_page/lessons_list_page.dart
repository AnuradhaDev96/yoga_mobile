import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/models/session/session_model.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';

class LessonsListPage extends StatefulWidget {
  const LessonsListPage({super.key, required this.sessionData});

  final SessionModel sessionData;

  @override
  State<LessonsListPage> createState() => _LessonsListPageState();
}

class _LessonsListPageState extends State<LessonsListPage> {
  bool _isLessonPlayMode = false;

  final _bottomContentHeightFraction = 0.35;
  final _gradientHeightFraction = 0.3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset('assets/png/temp_image.png', width: MediaQuery.sizeOf(context).width, fit: BoxFit.fitWidth),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * _gradientHeightFraction,
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
                Colors.black,
                Colors.black.withOpacity(0),
              ])),
            ),
          ),
          Positioned(
            top: 31,
            left: 23,
            child: InkWell(
              customBorder: const CircleBorder(),
              radius: 20,
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(Assets.leftArrowWhite, width: 24, height: 24),
            ),
          ),
          Positioned(
            top: 40,
            right: 24,
            child: InkWell(
              onTap: () {
                if (_isLessonPlayMode) {
                  _switchToLessonListMode();
                } else {
                  Navigator.pop(context);
                }
              },
              customBorder: const CircleBorder(),
              radius: 20,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.black1,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
          if (_isLessonPlayMode)
            const Positioned(
              bottom: 30,
              left: 24,
              right: 24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lesson name",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomSheet: Material(
        surfaceTintColor: Colors.transparent,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 1400),
          curve: Curves.fastOutSlowIn,
          alignment: Alignment.topCenter,
          child: Container(
              height: _isLessonPlayMode
                  ? MediaQuery.sizeOf(context).height * _bottomContentHeightFraction
                  : MediaQuery.sizeOf(context).height * 0.54,
              width: MediaQuery.sizeOf(context).width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
              ),
              child: _isLessonPlayMode ? _buildLessonPlayer(context) : _buildLessonList(context)),
        ),
      ),
    );
  }

  Widget _buildLessonList(BuildContext context) {
    return CustomScrollView(
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
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 14, bottom: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    '${widget.sessionData.title ?? 'N/A'} ${widget.sessionData.category ?? 'N/A'}',
                    style: const TextStyle(
                      color: AppColors.black1,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${widget.sessionData.lessons?.length ?? '0'} lesson${widget.sessionData.lessons?.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: AppColors.indigo1,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          child: (widget.sessionData.lessons != null && widget.sessionData.lessons!.isNotEmpty)
              ? ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 30),
                  itemBuilder: (context, index) {
                    var lessonData = widget.sessionData.lessons![index];

                    return GestureDetector(
                      onTap: () {
                        _switchToLessonPlayMode();
                      },
                      child: Container(
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
                                    Text(
                                      lessonData.title ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.black1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width * 0.6,
                                      child: Text(
                                        lessonData.description ?? 'N/A',
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        style: const TextStyle(
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
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 23),
                  itemCount: widget.sessionData.lessons!.length,
                )
              : const Center(child: Text('No Lessons available')),
        ),
      ],
    );
  }

  Widget _buildLessonPlayer(BuildContext context) {
    return CustomScrollView(
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
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.playerJumpBackward, width: 26, height: 26),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.76),
                child: SvgPicture.asset(Assets.playerPlayButton, width: 58, height: 58),
              ),
              SvgPicture.asset(Assets.playerJumpForward, width: 26, height: 26),
            ],
          ),
        ),
      ],
    );
  }

  void _switchToLessonPlayMode() {
    setState(() {
      _isLessonPlayMode = true;
    });
  }

  void _switchToLessonListMode() {
    setState(() {
      _isLessonPlayMode = false;
    });
  }
}
