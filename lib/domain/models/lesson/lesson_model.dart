class LessonModel {
  final String id;
  final String sessionId;
  final String? title;
  final String? description;
  final String? videoUrl;

  LessonModel.fromMap(Map<String, dynamic> map):
        id = map['id'],
        sessionId = map['sessionId'],
        title = map['title'],
        description = map['description'],
        videoUrl = map['videoUrl'];
}
