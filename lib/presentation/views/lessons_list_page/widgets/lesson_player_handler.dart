import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/lesson_list_page/switch_lesson_mode_cubit.dart';
import '../../../blocs/lesson_player/lesson_player_config_cubit.dart';
import '../../../widgets/circular_loader.dart';
import 'lesson_player.dart';

class LessonPlayerHandler extends StatefulWidget {
  const LessonPlayerHandler({super.key, required this.sessionImageUrl});

  final String sessionImageUrl;

  @override
  State<LessonPlayerHandler> createState() => _LessonPlayerHandlerState();
}

class _LessonPlayerHandlerState extends State<LessonPlayerHandler> {
  late final SwitchLessonModeCubit _switchLessonModeCubit;
  late final LessonPlayerConfigCubit _lessonPlayerConfigCubit;

  @override
  void initState() {
    super.initState();
    print("recreating handle widget");

    _switchLessonModeCubit = BlocProvider.of<SwitchLessonModeCubit>(context);
    _lessonPlayerConfigCubit = BlocProvider.of<LessonPlayerConfigCubit>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _lessonPlayerConfigCubit.chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _switchLessonModeCubit,
      builder: (context, viewMode) {
        if (viewMode is LessonsPlayerMode) {
          return LessonPlayer(
            videoUrl: _switchLessonModeCubit.selectedLesson?.videoUrl ?? '',
            height: MediaQuery.sizeOf(context).height * 0.65,
            width: MediaQuery.sizeOf(context).width,
            // height: 300,
            // width: MediaQuery.sizeOf(context).width,
          );
        } else {
          return CachedNetworkImage(
            height: MediaQuery.sizeOf(context).height * 0.8,
            fit: BoxFit.fitHeight,
            imageUrl: widget.sessionImageUrl,
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
      },
    );
  }
}