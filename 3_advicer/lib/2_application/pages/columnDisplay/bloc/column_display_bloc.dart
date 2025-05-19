import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

part 'column_display_event.dart';
part 'column_display_state.dart';

class ColumnDisplayBloc extends Bloc<ColumnDisplayEvent, ColumnDisplayState> {
  ColumnDisplayBloc() : super(ColumnDisplayInitial()) {
    on<ColumnDisplayEvent>((event, emit) async {
      emit(ColumnDisplayLoading());
      // execute business logic
      // for example get and advice
      debugPrint('fake get items triggered');
      await Future.delayed(const Duration(seconds: 3), () {});
      debugPrint('got items');
      emit(const ColumnDisplayLoaded(data: [
        MapEntry('item 1', false),
        MapEntry('item 2', true),
        MapEntry('item 3', true),
        MapEntry('item 4', false),
        MapEntry('item 5', false),
        MapEntry('item 6', false),
        MapEntry('item 7', false),
        MapEntry('item 8', false),
        MapEntry('item 9', false),
        MapEntry('item 10', false),
      ]));
      // emit(const ColumnDisplayError(message: 'error message'));
    });
  }
}
