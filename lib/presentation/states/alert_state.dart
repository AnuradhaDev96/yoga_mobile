class AlertState {}

class CleanScreen extends AlertState {}

class AlertOnScreen extends AlertState {
  final String alertMessage;
  final Duration alertDuration;
  final bool isErrorMessage;

  AlertOnScreen(this.alertMessage, this.alertDuration, this.isErrorMessage);
}
