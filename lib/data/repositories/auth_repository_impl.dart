import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:yoga_app/domain/models/custom_response_result_model.dart';

import '../../domain/helpers/api_client.dart';
import '../../domain/models/auth/login_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/local_storage_repository.dart';
import '../../utils/constants/preference_keys.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<CustomResponseResultModel> login(LoginModel data) async {
    final response = await GetIt.instance<ApiClient>().postRequest(
      endpointSuffix: '/auth/login',
      requestData: data.toMap(),
    );

    if (response != null) {
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);

        String? token = decoded['token'];

        if (token != null && token.isNotEmpty) {
          // token is available
          await GetIt.instance<LocalStorageRepository>().saveStringValue(PreferenceKeys.userTokenKey, token);

          return CustomResponseResultModel(statusCode: response.statusCode, messageForClient: 'Successfully logged in');
        } else {
          // token is not available
          return CustomResponseResultModel(
            statusCode: response.statusCode,
            messageForClient: 'Invalid access token',
          );
        }
      } else if (response.statusCode == 401) {
        var decoded = jsonDecode(response.body);

        String? message = decoded['msg'];

        return CustomResponseResultModel(
          statusCode: response.statusCode,
          messageForClient: message ?? 'Invalid login attempt',
        );
      } else {
        return CustomResponseResultModel(
          statusCode: response.statusCode,
          messageForClient: 'Invalid login attempt',
        );
      }
    }

    return CustomResponseResultModel();
  }
}
