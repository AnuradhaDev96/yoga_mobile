import '../../utils/constants/assets.dart';

enum DataErrorEnum {
  general(iconSource: Assets.emptyListIcon),
  videoError(iconSource: Assets.videoErrorIcon),
  controllerError(iconSource: Assets.videoControllerIcon);

  final String iconSource;

  const DataErrorEnum({required this.iconSource});
}
