import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/models/auth/login_model.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../states/authentication_state.dart';
import '../../states/data_payload_state.dart';
import '../authentication_bloc.dart';

class LoginRequestCubit extends Cubit<DataPayloadState> {
  LoginRequestCubit() : super(InitialState());

  Future<void> requestLogin(String email, String password) async {
    emit(RequestingState());

    final result = await GetIt.instance<AuthRepository>().login(LoginModel(email: email, password: password));

    if (result.statusCode == 200) {
      emit(SuccessState());
      AuthenticationBloc().add(LoggedIn());
    } else {
      emit(ErrorState(result.messageForClient));
    }
  }
}
