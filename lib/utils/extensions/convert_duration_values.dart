extension ConvertDurationValues on Duration {
  String get inMinutesAndSeconds{
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }
}
