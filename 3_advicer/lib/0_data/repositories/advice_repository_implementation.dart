// in the repository implementation file, we implement the methods defined in the interface

import 'package:advicer/0_data/datasources/advice_remote_datasource.dart';
import 'package:advicer/0_data/exceptions/exceptions.dart';
import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/failures/failures.dart';
import 'package:advicer/1_domain/repositories/advice_repository.dart';
import 'package:dartz/dartz.dart';

class AdviceRepositoryImplementation implements AdviceRepository {
  // This is where we will implement the methods defined in the AdviceRepository interface.
  // For now, we will return a fake advice after a delay to simulate a network call.

  final AdviceRemoteDatasourceImplementation adviceRemoteDatasource = AdviceRemoteDatasourceImplementation();

  @override
  Future<Either<Failure, AdviceEntity>> getAdviceFromDataSource() async {
    try {
      // Fetch advice from the remote data source
      final adviceEntity = await adviceRemoteDatasource.getRandomAdviceFromAPI();

      // Return the entity wrapped in a Right (success)
      return Right(adviceEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      // If an error occurs, return a Left (failure)
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
