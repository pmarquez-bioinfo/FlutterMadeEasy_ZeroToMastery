import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/failures/failures.dart';
import 'package:advicer/1_domain/usecases/advice_uscases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advicer_state.dart';

const String generalFailureMessage = 'Unexpected Error Occurred';
const String serverFailureMessage = 'Something went wrong with the server, please try again';
const String cacheFailureMessage = 'Something went wrong with the cache, please try again';

class AdvicerCubit extends Cubit<AdvicerCubitState> {
  AdvicerCubit({required this.adviceUscases}) : super(AdvicerInitial());
  AdviceUscases adviceUscases;
  // could also use other usecases

  void adviceRequested() async {
    emit(AdvicerStateLoading());
    final result = await adviceUscases.getAdvice();
    result.fold(
      (failure) => emit(AdvicerStateError(message: _mapFailureToMessage(failure))),
      (advice) => emit(AdvicerStateLoaded(advice: advice)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return generalFailureMessage;
    }
  }
}
