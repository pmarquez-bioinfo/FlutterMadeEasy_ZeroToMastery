import 'package:equatable/equatable.dart';

class AdviceEntity extends Equatable {
  // Extend Equatable to allow value comparison, useful to test equality of instances
  // This is particularly useful in state management scenarios where you want to compare states

  final String id;
  final String advice;

  const AdviceEntity({
    required this.id,
    required this.advice,
  });

  @override
  String toString() {
    return 'AdviceEntity(id: $id, advice: $advice';
  }

  @override
  List<Object?> get props => [advice, id];
}
