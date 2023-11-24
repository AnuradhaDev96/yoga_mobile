import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/enums/data_error_enum.dart';
import '../../../domain/models/lesson/lesson_model.dart';
import '../../../domain/models/session/session_model.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/assets.dart';
import '../../blocs/lesson_player/lesson_player_config_cubit.dart';
import '../../states/data_payload_state.dart';
import '../../widgets/circular_loader.dart';
import '../../widgets/list_placeholder.dart';
import 'widgets/lesson_player.dart';

class LessonsListPage extends StatefulWidget {
  const LessonsListPage({super.key, required this.sessionData});

  final SessionModel sessionData;

  @override
  State<LessonsListPage> createState() => _LessonsListPageState();
}

class _LessonsListPageState extends State<LessonsListPage> {
  bool _isLessonPlayMode = false;
  LessonModel? _selectedLesson;
  final _lessonPlayerConfigCubit = LessonPlayerConfigCubit();

  final _lessonControllerHeightFraction = 0.35; //0.35
  final _gradientHeightFraction = 0.3;

  @override
  void initState() {
    super.initState();
    if (widget.sessionData.lessons != null && widget.sessionData.lessons!.isNotEmpty) {
      _selectedLesson = widget.sessionData.lessons!.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LessonPlayerConfigCubit>(
      create: (context) => _lessonPlayerConfigCubit,
      child: BlocBuilder<LessonPlayerConfigCubit, DataPayloadState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (_isLessonPlayMode) {
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
                  _buildLessonPlayer(context),
                  Positioned(
                    bottom: (state is SuccessState) ? -10 : MediaQuery.sizeOf(context).height * 0.2,
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * _gradientHeightFraction,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black,
                            Colors.black.withOpacity(0),
                          ],
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
                  Positioned(
                    bottom: (state is SuccessState) ? 10 : MediaQuery.sizeOf(context).height * 0.38,
                    left: 24,
                    right: 24,
                    child: AnimatedOpacity(
                      opacity: _isLessonPlayMode ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedLesson?.title ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _selectedLesson?.description ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
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
                      height: _isLessonPlayMode
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
                      child:
                          _isLessonPlayMode ? _buildLessonPlayerController(context, state) : _buildLessonList(context)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLessonList(BuildContext context) {
    return CustomScrollView(
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
                        _switchToLessonPlayMode(lessonData);
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
              : const ListPlaceHolder(placeHolderText: 'No lessons available'),
        ),
      ],
    );
  }

  Widget _buildLessonPlayerController(BuildContext context, DataPayloadState state) {
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
        (state is SuccessState)
            ? Builder(
                builder: (context) {
                  if (_lessonPlayerConfigCubit.isVideoControllerInitialized) {
                    return SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              _lessonPlayerConfigCubit.jumpBackward();
                            },
                            icon: SvgPicture.asset(Assets.playerJumpBackward, width: 26, height: 26),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_lessonPlayerConfigCubit.isVideoControllerInitialized &&
                                  _lessonPlayerConfigCubit.chewieController!.isPlaying) {
                                _lessonPlayerConfigCubit.pausePlay();
                              } else {
                                _lessonPlayerConfigCubit.resumePlay();
                              }
                            },
                            child: ValueListenableBuilder(
                                valueListenable: _lessonPlayerConfigCubit.chewieController!.videoPlayerController,
                                builder: (context, videoController, _) {
                                  return videoController.isPlaying
                                      ? SvgPicture.asset(
                                          Assets.playerPauseButton,
                                          width: 58,
                                          height: 58,
                                        )
                                      : SvgPicture.asset(
                                          Assets.playerPlayButton,
                                          width: 58,
                                          height: 58,
                                        );
                                }),
                          ),
                          IconButton(
                            onPressed: () {
                              _lessonPlayerConfigCubit.jumpForward();
                            },
                            icon: SvgPicture.asset(Assets.playerJumpForward, width: 26, height: 26),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              )
            : const SliverFillRemaining(
                child: ListPlaceHolder(
                  errorType: DataErrorEnum.controllerError,
                  placeHolderText: 'Video controls are disabled',
                ),
              ),
      ],
    );
  }

  Widget _buildLessonPlayer(BuildContext context) {
    if (_isLessonPlayMode) {
      return LessonPlayer(
        videoUrl: _selectedLesson?.videoUrl ?? '',
        height: MediaQuery.sizeOf(context).height * 0.65,
        width: MediaQuery.sizeOf(context).width,
        // height: 300,
        // width: MediaQuery.sizeOf(context).width,
      );
    } else {
      return CachedNetworkImage(
        height: MediaQuery.sizeOf(context).height * 0.8,
        fit: BoxFit.fitHeight,
        imageUrl: widget.sessionData.imageUrl ?? '',
        placeholder: (_, __) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.2),
            child: const CircularLoader(),
          );
        },
        errorWidget: (_, __, ___) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.2),
              child: const Icon(Icons.image, size: 60),
            ),
          );
        },
      );
    }
  }

  void _switchToLessonPlayMode(LessonModel lessonData) {
    setState(() {
      _isLessonPlayMode = true;
      _selectedLesson = lessonData;
    });
  }

  void _switchToLessonListMode() {
    setState(() {
      _isLessonPlayMode = false;
    });
  }
}
