import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/lesson/lesson_model.dart';

class ViewMode {}

class LessonsListMode extends ViewMode {}

class LessonsPlayerMode extends ViewMode {}

class SwitchLessonModeCubit extends Cubit<ViewMode> {
  SwitchLessonModeCubit() : super(LessonsListMode());
  LessonModel? selectedLesson;

  void switchToLessonPlayerMode(LessonModel lessonData) {
    selectedLesson = lessonData;
    emit(LessonsPlayerMode());
  }

  void switchToLessonListMode() {
    selectedLesson = null;
    emit(LessonsListMode());
  }
}
