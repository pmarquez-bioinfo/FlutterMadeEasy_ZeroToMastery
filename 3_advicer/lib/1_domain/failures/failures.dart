abstract class Failure {
  final String message;
  Failure({this.message = "An unexpected error occurred."});
}

class ServerFailure extends Failure {
  ServerFailure({required String message}) : super(message: message);
}

// This class represents a failure that occurs when there is an issue with the cache.
// It could be due to data not being found, or an error while reading/writing to the cache.
class CacheFailure extends Failure {
  CacheFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  NetworkFailure({required String message}) : super(message: message);
}

class GeneralFailure extends Failure {
  GeneralFailure({required String message}) : super(message: message);
}
