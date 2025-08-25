import 'dart:io';

import 'package:advicer/0_data/datasources/advice_remote_datasource.dart';
import 'package:advicer/0_data/repositories/advice_repository_implementation.dart';
import 'package:advicer/1_domain/repositories/advice_repository.dart';
import 'package:advicer/1_domain/usecases/advice_uscases.dart';
import 'package:advicer/2_application/pages/advice/cubit/advicer_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';

final sl = GetIt.instance; // sl is the service locator instance

Future<void> init() async {
  // Register the external dependencies in the correct order

  // ! external Layer - Register external dependencies first
  sl.registerFactory<IOClient>(() => IOClient(HttpClient()..badCertificateCallback = (cert, host, port) => true));

  // ! data Layer - Register concrete implementations
  sl.registerFactory<AdviceRemoteDataSource>(() => AdviceRemoteDatasourceImplementation(client: sl()));
  sl.registerFactory<AdviceRepository>(() => AdviceRepositoryImplementation(adviceRemoteDatasource: sl()));

  // ! domain Layer
  sl.registerFactory(() => AdviceUscases(adviceRepository: sl()));

  // ! application Layer
  // Factory = every time a new instance is requested for that class, a new instance is created
  sl.registerFactory(() => AdvicerCubit(adviceUscases: sl()));
}
