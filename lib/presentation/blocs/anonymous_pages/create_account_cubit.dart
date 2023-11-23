import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/models/auth/create_account_model.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../states/data_payload_state.dart';

class CreateAccountCubit extends Cubit<DataPayloadState> {
  CreateAccountCubit() : super(InitialState());

  Future<void> createAccount({
    required String email,
    required String password,
    required String username,
    required String gender,
    String? age,
  }) async {
    emit(RequestingState());

    final result = await GetIt.instance<AuthRepository>().createAccount(
      CreateAccountModel(
        email: email,
        password: password,
        username: username,
        gender: gender,
        age: age,
      ),
    );

    if (result.statusCode == 201) {
      emit(SuccessState());
    } else {
      emit(ErrorState(result.messageForClient));
    }
  }
}
