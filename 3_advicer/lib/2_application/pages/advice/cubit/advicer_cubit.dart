import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/usecases/advice_uscases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advicer_state.dart';

class AdvicerCubit extends Cubit<AdvicerCubitState> {
  AdvicerCubit() : super(AdvicerInitial());
  AdviceUscases adviceUscases = AdviceUscases();
  // could also use other usecases

  void adviceRequested() async {
    emit(AdvicerStateLoading());
    try {
      final advice = await adviceUscases.getAdvice();
      emit(AdvicerStateLoaded(advice: advice));
    } catch (e) {
      emit(AdvicerStateError(message: e.toString()));
    }
  }
}
