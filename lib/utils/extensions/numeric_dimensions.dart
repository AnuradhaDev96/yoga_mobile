extension BarHeightFactor on int {
  double get toAudioWaveHeightFactor {
    int remainder = this % 20;
    switch (remainder){
      case 0:
      case 7:
      case 11:
      case 18:
      case 19:
        return 0.25;
      case 1:
      case 6:
      case 8:
      case 14:
      case 17:
        return 0.76;
      case 2: return 1;
      case 3:
      case 13:
      case 16:
        return 0.68;
      case 4:
      case 5:
      case 9:
      case 10:
        return 0.47;
      case 12: return 0.15;
      case 15: return 0.88;
      default:
        return 0.3;
    }
  }
}
