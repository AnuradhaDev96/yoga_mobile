import '../models/session/session_model.dart';

abstract class YogaActivitiesRepository {
  Future<List<SessionModel>> getSessions();
}
