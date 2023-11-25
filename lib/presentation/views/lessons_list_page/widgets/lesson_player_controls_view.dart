import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../domain/enums/data_error_enum.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/assets.dart';
import '../../../../utils/extensions/convert_duration_values.dart';
import '../../../blocs/lesson_player/lesson_player_config_cubit.dart';
import '../../../states/data_payload_state.dart';
import '../../../widgets/audio_wave_form.dart';
import '../../../widgets/list_placeholder.dart';
import '../../../../utils/extensions/numeric_dimensions.dart';

class LessonPlayerControlsView extends StatefulWidget {
  const LessonPlayerControlsView({super.key});

  @override
  State<LessonPlayerControlsView> createState() => _LessonPlayerControlsViewState();
}

class _LessonPlayerControlsViewState extends State<LessonPlayerControlsView> {
  late final LessonPlayerConfigCubit _lessonPlayerConfigCubit;
  Duration elapsedValue = Duration.zero;

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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24),
                                        child: Row(
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
                                            // Flexible(
                                            //   child: RectangleWaveform(
                                            //     // samples: const [ 0,2,34,352,5,],
                                            //     samples: [],
                                            //     height: 62,
                                            //     width: 400,
                                            //     maxDuration: videoController.duration,
                                            //     elapsedDuration: videoController.position,
                                            //   ),
                                            // ),
                                            Builder(
                                              builder: (context) {
                                                var durationInMilliSeconds = _lessonPlayerConfigCubit.chewieController!
                                                    .videoPlayerController.value.duration.inMilliseconds;
                                                int noOfElements = (durationInMilliSeconds / timeGap).ceil();

                                                return Flexible(
                                                  child: Container(
                                                    height: 80,
                                                    margin: const EdgeInsets.symmetric(horizontal:5),
                                                    child: ListView(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      scrollDirection: Axis.horizontal,
                                                      shrinkWrap: true,
                                                      physics: const BouncingScrollPhysics(),
                                                      children: [
                                                        AudioVisualizer(barCount: noOfElements),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
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
        });
  }
}

class AudioVisualizer extends StatefulWidget {
  const AudioVisualizer({super.key, required this.barCount});

  // final List<WaveBar> listOfBars;
  final int barCount;

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer> {
  late final LessonPlayerConfigCubit _lessonPlayerConfigCubit;

  @override
  void initState() {
    super.initState();
    _lessonPlayerConfigCubit = BlocProvider.of<LessonPlayerConfigCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _lessonPlayerConfigCubit.chewieController!.videoPlayerController,
      builder: (context, videoPlayerController, _) {
        // bar at index of the current duration should be painted

        int currentPosition = videoPlayerController.position.inMilliseconds;

        int currentBarPosition = (currentPosition / timeGap).floor();

        return AudioWaveForm(
          height: 60,
          spacing: 2.0,
          animationLoop: 1,
          beatRate: const Duration(milliseconds: 45),
          bars: List.generate(
            widget.barCount,
            (index) {
              bool shouldHighlight = false;

              if (currentBarPosition > 0 && (currentBarPosition - 1) >= index) {
                shouldHighlight = true;
              }

              return WaveBar(
                heightFactor: index.toAudioWaveHeightFactor,
                color: shouldHighlight ? AppColors.indigo1 : AppColors.black2,
              );
            },
          ),
        );
      },
    );
  }
}

int timeGap = 200;
