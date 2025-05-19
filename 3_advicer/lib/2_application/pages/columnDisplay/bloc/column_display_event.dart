part of 'column_display_bloc.dart';

@immutable
abstract class ColumnDisplayEvent extends Equatable {
  const ColumnDisplayEvent();

  @override
  List<Object> get props => [];
}

class ColumnDisplayRequestEvent extends ColumnDisplayEvent {}
