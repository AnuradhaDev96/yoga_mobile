import '../lesson/lesson_model.dart';

class SessionModel {
  final String id;
  final String? title;
  final String? instructor;
  final String? category;
  final String? imageUrl;
  final List<LessonModel>? lessons;

  SessionModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        instructor = map['instructor'],
        category = map['category'],
        imageUrl = map['imageUrl'],
        lessons = map['lessons'] == null
            ? null
            : List<LessonModel>.from(map['lessons'].map((item) => LessonModel.fromMap(item)));
}
