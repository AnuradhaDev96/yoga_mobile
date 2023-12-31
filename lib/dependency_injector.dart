import 'package:get_it/get_it.dart';

import 'data/data_sources/local_storage_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/yoga_activities_repository_impl.dart';
import 'domain/helpers/api_client.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/local_storage_repository.dart';
import 'domain/repositories/yoga_activities_repository.dart';

abstract class DependencyInjector {

  /// Inject dependencies with get_it
  static void injectDependencies() {
    GetIt.instance.registerLazySingleton<LocalStorageRepository>(() => LocalStorageRepositoryImpl());
    GetIt.instance.registerLazySingleton<ApiClient>(() => ApiClient());
    GetIt.instance.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
    GetIt.instance.registerLazySingleton<YogaActivitiesRepository>(() => YogaActivitiesRepositoryImpl());
  }
}
