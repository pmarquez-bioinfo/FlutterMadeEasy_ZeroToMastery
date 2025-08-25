import 'dart:convert';
import 'dart:io';

import 'package:advicer/0_data/exceptions/exceptions.dart';
import 'package:advicer/0_data/models/advice_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

abstract class AdviceRemoteDataSource {
  /// Fetches a random piece of advice from the remote server.
  ///
  /// Returns a [AdviceModel] containing the advice.
  /// Throws a [ServerException] if the request fails, and status code is not 200.
  Future<AdviceModel> getRandomAdviceFromAPI();
}

class AdviceRemoteDatasourceImplementation implements AdviceRemoteDataSource {
  AdviceRemoteDatasourceImplementation({required this.client});
  final IOClient client;

  @override
  Future<AdviceModel> getRandomAdviceFromAPI() async {
    // final httpClient = HttpClient()..badCertificateCallback = (cert, host, port) => true;
    // final client = IOClient(httpClient);

    final response = await client.get(
      Uri.parse('https://api.flutter-community.com/api/v1/advice'),
      headers: {
        'content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // final Map<String, dynamic> jsonResponse = Map<String, dynamic>.from(response.body as Map);
      final jsonResponse = json.decode(response.body);
      return AdviceModel.fromJson(jsonResponse);
    } else {
      throw ServerException(message: 'Failed to load advice');
    }
  }
}
