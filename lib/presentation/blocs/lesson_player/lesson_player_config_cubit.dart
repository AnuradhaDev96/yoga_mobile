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
      emit(ErrorState("Video is not available"));
    }

    // Config video url
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

      await _videoPlayerController!.initialize();

      if (_videoPlayerController!.value.isInitialized) {
        _setChewieController();

        emit(SuccessState());
      } else {
        emit(ErrorState("Error in initializing video"));
      }
    } catch (e) {
      emit(ErrorState("Unsupported video source"));
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
}
