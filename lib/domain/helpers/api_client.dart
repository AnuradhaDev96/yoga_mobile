import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../presentation/blocs/alert_cubit.dart';
import '../../presentation/blocs/authentication_bloc.dart';
import '../../presentation/states/authentication_state.dart';
import '../../utils/constants/preference_keys.dart';
import '../../utils/resources/message_utils.dart';
import '../repositories/local_storage_repository.dart';
import 'endpoint_helper.dart';

class ApiClient extends ApiHelper {
  static const _defaultBaseUrl = EndpointHelper.baseUrl;

  final Map<String, String> _commonHeaders = {
    'Accept': 'application/json;',
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<Map<String, String>> get _authorizationHeader async {
    String accessToken = await GetIt.instance<LocalStorageRepository>().getStringValue(PreferenceKeys.userTokenKey);
    return {
      'Authorization': 'Bearer $accessToken',
    };
  }

  Future<http.Response?> postRequest({
    String baseUrl = _defaultBaseUrl,
    required String endpointSuffix,
    bool shouldAuthorize = true,
    Map<String, dynamic>? requestData,
  }) async {
    Uri endpoint = Uri.parse('$baseUrl$endpointSuffix');

    var headers = _commonHeaders;
    if (shouldAuthorize) {
      headers.addAll(await _authorizationHeader);
    }

    try {
      var response = await http.post(
        endpoint,
        headers: headers,
        body: requestData == null ? null : jsonEncode(requestData),
      );
      logEndpoint(endpoint, response.statusCode);
      return response;
    } on SocketException catch (exception) {
      logException(endpoint, exception);
      handleHostLookupFailure();
    } catch (error) {
      logException(endpoint, error);
    }
    return null;
  }

  // TODO: implement expire token and logout logic
  Future<http.Response?> getRequest({
    String baseUrl = _defaultBaseUrl,
    required String endpointSuffix,
    bool shouldAuthorize = true,
  }) async {
    Uri endpoint = Uri.parse('$baseUrl$endpointSuffix');

    var headers = _commonHeaders;
    if (shouldAuthorize) {
      headers.addAll(await _authorizationHeader);
    }

    try {
      var response = await http.get(endpoint, headers: headers);

      // Handle token expire event
      if (response.statusCode == 400) {
        var decoded = jsonDecode(response.body);
        if (decoded is String && decoded.contains('Token has expired')) {
          AuthenticationBloc().add(LoggedOut());
          return null;
        }
        return response;
      }

      logEndpoint(endpoint, response.statusCode);
      return response;
    } on SocketException catch (exception) {
      logException(endpoint, exception);
      handleHostLookupFailure();
    } catch (error) {
      logException(endpoint, error);
    }
    return null;
  }
}

abstract class ApiHelper {
  void logEndpoint(dynamic endpoint, int statusCode) {
    if (kDebugMode) {
      print('[Calling endpoint: $endpoint]\nStatus code: $statusCode');
    }
  }

  void logException(dynamic endpoint, dynamic e) {
    if (kDebugMode) {
      print('[Endpoint: $endpoint]\nException: $e');
    }
  }

  void handleHostLookupFailure() {
    AlertCubit().showErrorOnScreen(MessageUtils.noInternetAvailable, const Duration(milliseconds: 2000));
  }
}
