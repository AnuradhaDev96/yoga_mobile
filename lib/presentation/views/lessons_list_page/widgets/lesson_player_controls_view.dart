import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../domain/enums/data_error_enum.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/assets.dart';
import '../../../../utils/extensions/convert_duration_values.dart';
import '../../../blocs/lesson_player/lesson_player_config_cubit.dart';
import '../../../states/data_payload_state.dart';
import '../../../widgets/list_placeholder.dart';

class LessonPlayerControlsView extends StatefulWidget {
  const LessonPlayerControlsView({super.key});

  @override
  State<LessonPlayerControlsView> createState() => _LessonPlayerControlsViewState();
}

class _LessonPlayerControlsViewState extends State<LessonPlayerControlsView> {
  late final LessonPlayerConfigCubit _lessonPlayerConfigCubit;

  @override
  void initState() {
    super.initState();
    _lessonPlayerConfigCubit = BlocProvider.of<LessonPlayerConfigCubit>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonPlayerConfigCubit, DataPayloadState>(
      bloc: _lessonPlayerConfigCubit,
      builder: (context, state) {
        return CustomScrollView(
          // key: _controllersScrollGlobalKey,
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
                          child: ValueListenableBuilder(
                              valueListenable: _lessonPlayerConfigCubit.chewieController!.videoPlayerController,
                              builder: (context, videoController, _) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          videoController.position.inMinutesAndSeconds,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          videoController.duration.inMinutesAndSeconds,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
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
                                          child: videoController.isPlaying
                                              ? SvgPicture.asset(
                                                  Assets.playerPauseButton,
                                                  width: 58,
                                                  height: 58,
                                                )
                                              : SvgPicture.asset(
                                                  Assets.playerPlayButton,
                                                  width: 58,
                                                  height: 58,
                                                ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _lessonPlayerConfigCubit.jumpForward();
                                          },
                                          icon: SvgPicture.asset(Assets.playerJumpForward, width: 26, height: 26),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  )
                : SliverFillRemaining(
                    child: ListPlaceHolder(
                      errorType: DataErrorEnum.controllerError,
                      placeHolderText: state is ErrorState ? 'Video controls are disabled' : 'Waiting for video file',
                    ),
                  ),
          ],
        );
      }
    );
  }
}