import 'dart:convert';

import 'package:get_it/get_it.dart';

import '../../domain/helpers/api_client.dart';
import '../../domain/models/auth/create_account_model.dart';
import '../../domain/models/auth/login_model.dart';
import '../../domain/models/custom_response_result_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/local_storage_repository.dart';
import '../../utils/constants/preference_keys.dart';

class AuthRepositoryImpl extends ApiHelper implements AuthRepository {
  @override
  Future<CustomResponseResultModel> login(LoginModel data) async {
    final response = await GetIt.instance<ApiClient>().postRequest(
      endpointSuffix: '/auth/login',
      requestData: data.toMap(),
      shouldAuthorize: false,
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

  @override
  Future<CustomResponseResultModel> createAccount(CreateAccountModel data) async {
    final response = await GetIt.instance<ApiClient>().postRequest(
      endpointSuffix: '/auth/register',
      requestData: data.toMap(),
      shouldAuthorize: false,
    );

    const commonError = 'User cannot be created';

    try {
      if (response != null) {
        if (response.statusCode == 201) {
          var decoded = jsonDecode(response.body);

          String? message = decoded['msg'];

          return CustomResponseResultModel(
            statusCode: response.statusCode,
            messageForClient: message ?? 'User registered successfully',
          );
        } else if (response.statusCode == 400) {
          var decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            if (decoded.containsKey('msg')) {
              String? message = decoded['msg'];
              return CustomResponseResultModel(
                statusCode: response.statusCode,
                messageForClient: message ?? commonError,
              );
            } else if (decoded.containsKey('errors')) {
              return CustomResponseResultModel(
                statusCode: response.statusCode,
                messageForClient: 'Please enter valid values',
              );
            }
          }
        } else {
          return CustomResponseResultModel(
            statusCode: response.statusCode,
            messageForClient: commonError,
          );
        }
      }
    } catch (e) {
      logException('/auth/register', e);
    }

    return CustomResponseResultModel();
  }
}
