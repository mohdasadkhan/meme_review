import 'package:get_it/get_it.dart';
import 'package:meme_review/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:meme_review/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:meme_review/features/authentication/domain/repositories/auth_repository.dart';
import 'package:meme_review/features/authentication/presentation/cubit/auth_cubit.dart';

final GetIt getIt = GetIt.instance;

/// Registers app-wide dependencies. Call once before [runApp].
Future<void> configureDependencies() async {
  if (getIt.isRegistered<AuthRepository>()) {
    return;
  }

  getIt
    ..registerLazySingleton<AuthRemoteDataSource>(AuthRemoteDataSource.new)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
    )
    ..registerLazySingleton<AuthCubit>(
      () => AuthCubit(getIt<AuthRepository>()),
    );
}
