import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/models/session/session_model.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';
import '../../blocs/lesson_list_page/switch_lesson_mode_cubit.dart';
import '../../blocs/lesson_player/lesson_player_config_cubit.dart';
import '../../states/data_payload_state.dart';
import 'widgets/lesson_list_view.dart';
import 'widgets/lesson_player_controls_view.dart';
import 'widgets/lesson_player_handler.dart';

class LessonsListPage extends StatefulWidget {
  const LessonsListPage({super.key, required this.sessionData});

  final SessionModel sessionData;

  @override
  State<LessonsListPage> createState() => _LessonsListPageState();
}

class _LessonsListPageState extends State<LessonsListPage> {
  final _lessonPlayerConfigCubit = LessonPlayerConfigCubit();
  final _switchModeCubit = SwitchLessonModeCubit();

  bool _isReadMore = false;

  final _lessonControllerHeightFraction = 0.35; //0.35
  final _gradientHeightFraction = 0.3;

  @override
  void initState() {
    super.initState();
    // if (widget.sessionData.lessons != null && widget.sessionData.lessons!.isNotEmpty) {
    //   _selectedLesson = widget.sessionData.lessons!.first;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LessonPlayerConfigCubit>(
          create: (context) => _lessonPlayerConfigCubit,
        ),
        BlocProvider<SwitchLessonModeCubit>(
          create: (context) => _switchModeCubit,
        ),
      ],
      child: BlocBuilder<SwitchLessonModeCubit, ViewMode>(
          bloc: _switchModeCubit,
          builder: (context, viewMode) {
            return BlocBuilder<LessonPlayerConfigCubit, DataPayloadState>(
              bloc: _lessonPlayerConfigCubit,
              builder: (context, playerConfigState) {
                return WillPopScope(
                  onWillPop: () async {
                    if (viewMode is LessonsPlayerMode) {
                      _switchToLessonListMode();
                      return false;
                    } else {
                      return true;
                    }
                  },
                  child: Scaffold(
                    backgroundColor: AppColors.grey4,
                    body: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        LessonPlayerHandler(sessionImageUrl: widget.sessionData.imageUrl ?? ''),
                        Positioned(
                          bottom: (playerConfigState is SuccessState) ? -10 : MediaQuery.sizeOf(context).height * 0.2,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onDoubleTap: () => _enterFullScreen(),
                            onVerticalDragEnd: (dragDetails) => _enterFullScreen(),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).height * _gradientHeightFraction,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                // gradient: LinearGradient(
                                //   begin: Alignment.bottomCenter,
                                //   end: Alignment.topCenter,
                                //   colors: [
                                //     Colors.black,
                                //     Colors.black.withOpacity(0),
                                //   ],
                                // ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 31,
                          left: 23,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            radius: 30,
                            onTap: () {
                              if (viewMode is LessonsPlayerMode) {
                                _switchToLessonListMode();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: SvgPicture.asset(Assets.leftArrowWhite, width: 24, height: 24),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 24,
                          child: InkWell(
                            onTap: () {
                              if (viewMode is LessonsPlayerMode) {
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
                        Positioned(
                          bottom: (playerConfigState is SuccessState) ? 12 : MediaQuery.sizeOf(context).height * 0.38,
                          left: 24,
                          right: 24,
                          child: AnimatedOpacity(
                            opacity: viewMode is LessonsPlayerMode ? 1 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onDoubleTap: () => _enterFullScreen(),
                              onVerticalDragEnd: (dragDetails) => _enterFullScreen(),
                              onTap: () {
                                setState(() {
                                  _isReadMore = !_isReadMore;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _switchModeCubit.selectedLesson?.title ?? 'N/A',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Wrap(
                                    children: [
                                      Text(
                                        _switchModeCubit.selectedLesson?.description ?? 'N/A',
                                        maxLines: _isReadMore ? null : 3,
                                        overflow: _isReadMore ? null : TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        _isReadMore ? 'Read less' : 'Read more',
                                        style: const TextStyle(
                                            letterSpacing: 1.1,
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                            height: viewMode is LessonsPlayerMode
                                ? MediaQuery.sizeOf(context).height * _lessonControllerHeightFraction
                                : MediaQuery.sizeOf(context).height * 0.54,
                            width: MediaQuery.sizeOf(context).width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                topLeft: Radius.circular(16),
                              ),
                            ),
                            child: viewMode is LessonsPlayerMode
                                ? const LessonPlayerControlsView()
                                : LessonsListView(sessionData: widget.sessionData)),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  void _switchToLessonListMode() {
    _switchModeCubit.switchToLessonListMode();
  }

  void _enterFullScreen() {
    if (_lessonPlayerConfigCubit.isVideoControllerInitialized) {
      _lessonPlayerConfigCubit.chewieController!.enterFullScreen();
    }
  }
}
