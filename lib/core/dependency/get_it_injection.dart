part of "path.dart";

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 300),
        receiveTimeout: const Duration(seconds: 300),
      ),
    ),
  );

  serviceLocator.registerFactory(() => InternetConnection());

  /// core
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );

  /// ===================== DB =====================
  serviceLocator.registerFactory<DBHelper>(
    () => DBHelper(),
  );

  /// ================= Api client ================
  serviceLocator.registerFactory<ApiClient>(
    () => ApiClient(),
  );
}
