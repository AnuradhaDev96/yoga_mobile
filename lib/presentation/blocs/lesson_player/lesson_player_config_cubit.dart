import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/constants/app_colors.dart';
import '../../states/data_payload_state.dart';

class LessonPlayerConfigCubit extends Cubit<DataPayloadState> {
  LessonPlayerConfigCubit() : super(InitialState());

  VideoPlayerController? _videoPlayerController;
  ChewieController? chewieController;

  Future<void> configureVideoFromUrl(String url) async {
    emit(RequestingState());

    if (url.isEmpty) {
      emit(ErrorState("Video file is not available"));
    }

    // Config video url
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

      await _videoPlayerController!.initialize();

      if (_videoPlayerController!.value.isInitialized) {
        _setChewieController();

        emit(SuccessState());
      } else {
        emit(ErrorState("This video cannot be initialized"));
      }
    } catch (e) {
      emit(ErrorState("This video cannot be played"));
    }
  }

  void _setChewieController() {
    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        backgroundColor: Colors.white,
        handleColor: AppColors.indigo1,
        playedColor: AppColors.indigo1.withOpacity(0.8),
        bufferedColor: AppColors.indigo1.withOpacity(0.25),
      ),
    );
  }

  void resumePlay() {
    chewieController!.videoPlayerController.play();
  }

  void pausePlay() {
    chewieController!.videoPlayerController.pause();
  }

  void jumpForward() {
    var currentPosition = chewieController!.videoPlayerController.value.position;
    chewieController!.videoPlayerController.seekTo(currentPosition + const Duration(seconds: 5));
  }

  void jumpBackward() {
    var currentPosition = chewieController!.videoPlayerController.value.position;
    chewieController!.videoPlayerController.seekTo(currentPosition - const Duration(seconds: 5));
  }

  bool get isVideoControllerInitialized =>
      (chewieController?.videoPlayerController != null && chewieController!.videoPlayerController.value.isInitialized);
}
