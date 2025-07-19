// Here we put the use cases for the advice feature.
// This is where the business logic for the advice feature is implemented.
import 'package:advicer/1_domain/entities/advice_entity.dart';

class AdviceUscases {
  Future<AdviceEntity> getAdvice() async {
    // TODO call a repository or an API to get the advice or failure
    // manipulate the data as needed
    // For now, we will return a fake advice after a delay to simulate a network call

    // Simulate a network call or some business logic to get advice
    await Future.delayed(const Duration(seconds: 2));
    return const AdviceEntity(
      id: '1',
      advice: 'Stay positive and keep pushing forward!',
    );
  }
}
