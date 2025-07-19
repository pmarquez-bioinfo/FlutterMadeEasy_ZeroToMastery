//models exist to convert data from the API to a usable format in the app
// they convert the raw data from the API to an entity that the app can use
import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:equatable/equatable.dart';

// the model class extends the entity class and implements EquatableMixin for equality comparison
// it also provides a factory constructor to create an instance from a JSON map or to a JSON map
class AdviceModel extends AdviceEntity with EquatableMixin {
  const AdviceModel({
    required String id,
    required String advice,
  }) : super(id: id, advice: advice);

  // factory constructor to create an instance from a JSON map
  factory AdviceModel.fromJson(Map<String, dynamic> json) {
    return AdviceModel(
      id: json['advice_id'].toString(),
      advice: json['advice'] as String,
    );
  }

  // method to convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'advice': advice,
    };
  }

  @override
  List<Object?> get props => [id, advice];
}
