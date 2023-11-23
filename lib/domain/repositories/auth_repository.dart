import '../models/auth/login_model.dart';
import '../models/custom_response_result_model.dart';

abstract class AuthRepository {
  /// Login request
  Future<CustomResponseResultModel> login(LoginModel data);
}
