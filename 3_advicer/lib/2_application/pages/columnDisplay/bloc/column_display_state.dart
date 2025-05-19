part of 'column_display_bloc.dart';

@immutable
abstract class ColumnDisplayState extends Equatable {
  const ColumnDisplayState();

  @override
  List<Object> get props => [];
}

class ColumnDisplayInitial extends ColumnDisplayState {}

class ColumnDisplayLoading extends ColumnDisplayState {}

class ColumnDisplayLoaded extends ColumnDisplayState {
  final List<MapEntry<String, bool>> data;

  const ColumnDisplayLoaded({this.data = const []});

  @override
  List<Object> get props => [data];
}

class ColumnDisplayError extends ColumnDisplayState {
  final String message;

  const ColumnDisplayError({required this.message});

  @override
  List<Object> get props => [message];
}
