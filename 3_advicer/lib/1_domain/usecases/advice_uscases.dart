// Here we put the use cases for the advice feature.
// This is where the business logic for the advice feature is implemented.
import 'package:advicer/0_data/repositories/advice_repository_implementation.dart';
import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/failures/failures.dart';
import 'package:advicer/1_domain/repositories/advice_repository.dart';
import 'package:dartz/dartz.dart'; 

class AdviceUscases {
  final AdviceRepository adviceRepository = AdviceRepositoryImplementation();

  Future<Either<Failure, AdviceEntity>> getAdvice() async {
    return await adviceRepository.getAdviceFromDataSource();
  }
}
