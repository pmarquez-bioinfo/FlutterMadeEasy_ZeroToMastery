import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/failures/failures.dart';
import 'package:dartz/dartz.dart';

// This is the repository interface for the advice feature.
// It defines the contract for the advice repository, which will be implemented by the data layer.
// The repository will be responsible for fetching advice from the data source (e.g., API, cache, etc.)
// and returning it as an AdviceEntity or a Failure if something goes wrong.
abstract class AdviceRepository {
  Future<Either<Failure, AdviceEntity>> getAdviceFromDataSource();
}
