import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/utility/route_observers.dart';
import '../../../blocs/lesson_player/lesson_player_config_cubit.dart';
import '../../../states/data_payload_state.dart';
import '../../../widgets/circular_loader.dart';
import '../../../widgets/list_placeholder.dart';

class LessonPlayer extends StatefulWidget {
  const LessonPlayer({super.key, required this.videoUrl, required this.width, required this.height});

  final String videoUrl;
  final double width;
  final double height;

  @override
  State<LessonPlayer> createState() => _LessonPlayerState();
}

class _LessonPlayerState extends State<LessonPlayer> with RouteAware {
  late final LessonPlayerConfigCubit _lessonPlayerConfigCubit;

  bool get _isVideoControllerInitialized => (_lessonPlayerConfigCubit.chewieController?.videoPlayerController != null &&
      _lessonPlayerConfigCubit.chewieController!.videoPlayerController.value.isInitialized);

  @override
  void initState() {
    super.initState();
    _lessonPlayerConfigCubit = BlocProvider.of<LessonPlayerConfigCubit>(context);

    //initialize video url
    _lessonPlayerConfigCubit.configureVideoFromUrl(widget.videoUrl);
  }

  @override
  void dispose() {
    if (mounted) {
      _lessonPlayerConfigCubit.chewieController?.videoPlayerController.dispose();
    }

    primaryStudentRouteObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void didPushNext() {
    if (_isVideoControllerInitialized) {
      _lessonPlayerConfigCubit.chewieController!.videoPlayerController.pause();
    }
    super.didPushNext();
  }

  @override
  void didChangeDependencies() {
    primaryStudentRouteObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonPlayerConfigCubit, DataPayloadState>(
      bloc: _lessonPlayerConfigCubit,
      builder: (context, state) {
        if (state is InitialState) {
          return const SizedBox.shrink();
        } else if (state is RequestingState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.2),
            child: const CircularLoader(),
          );
        } else if (state is SuccessState) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: _isVideoControllerInitialized
                ? Chewie(controller: _lessonPlayerConfigCubit.chewieController!)
                : const CircularLoader(),
          );
        } else if (state is ErrorState) {
          return ListPlaceHolder(placeHolderText: state.errorMessage);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
