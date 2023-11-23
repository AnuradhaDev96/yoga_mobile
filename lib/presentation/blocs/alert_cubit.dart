import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/resources/message_utils.dart';
import '../states/alert_state.dart';

/// Initially state is false because app is running in clean mode.
/// Use [toggleAlertBehavior] to change the alert status
class AlertCubit extends Cubit<AlertState> {
  AlertCubit._() : super(CleanScreen());

  static final AlertCubit _instance = AlertCubit._();

  factory AlertCubit() {
    return _instance;
  }

  // display error on any screen
  void showErrorOnScreen(String alertMessage, Duration alertDuration) {
    emit(AlertOnScreen(alertMessage, alertDuration, true));
  }

  // display success message on any screen
  void showSuccessOnScreen(String alertMessage, Duration alertDuration) {
    emit(AlertOnScreen(alertMessage, alertDuration, false));
  }

  void showAlert(BuildContext context, String alertMessage, Duration alertDuration, bool isErrorMessage) async {
    //show message
    MessageUtils.showSnackBarOverBarrier(context, alertMessage, isErrorMessage: isErrorMessage);

    // reset state
    await Future.delayed(alertDuration, () {
      emit(CleanScreen());
    });
  }
}
