import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/repositories/local_storage_repository.dart';
import '../../utils/constants/preference_keys.dart';
import '../states/authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc._() : super(AuthenticationInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  static final AuthenticationBloc _instance = AuthenticationBloc._();

  factory AuthenticationBloc() {
    return _instance;
  }

  void _onAppStarted(AppStarted event, Emitter<AuthenticationState> emit) async {
    final bool isLoggedIn = await GetIt.instance<LocalStorageRepository>().getBoolValue(PreferenceKeys.isLoggedInKey);
    if (isLoggedIn) {
      emit(AuthenticationAuthenticated());
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationAuthenticated());

    //store log in status in the middle logic
    await GetIt.instance<LocalStorageRepository>().saveBoolValue(PreferenceKeys.isLoggedInKey, true);
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationUnauthenticated());

    //store log in status in the middle logic
    await GetIt.instance<LocalStorageRepository>().saveBoolValue(PreferenceKeys.isLoggedInKey, false);
  }
}
