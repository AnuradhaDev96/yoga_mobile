import 'dart:convert';

import 'package:get_it/get_it.dart';

import '../../domain/helpers/api_client.dart';
import '../../domain/models/session/session_model.dart';
import '../../domain/repositories/yoga_activities_repository.dart';

class YogaActivitiesRepositoryImpl extends ApiHelper implements YogaActivitiesRepository {

  @override
  Future<List<SessionModel>> getSessions() async {
    var response = await GetIt.instance<ApiClient>().getRequest(endpointSuffix: '/sessions');

    try {
      if (response != null) {
        List<dynamic>? responseList = jsonDecode(response.body);
        if (responseList != null) {
          return responseList.map((item) => SessionModel.fromMap(item)).toList();
        }
      }
    } catch (e) {
      logException('/sessions', e);
    }

    return <SessionModel>[];
  }

}