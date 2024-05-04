import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class NetworkApiService {
  static final NetworkApiService _instance = NetworkApiService._internal();

  factory NetworkApiService() => _instance;

  NetworkApiService._internal();

  Future getApiService({
    String? url,
    Uri? uri,
    Map<String, String>? headers,
    Duration? timeLimit,
  }) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(uri ?? Uri.parse(url!), headers: headers)
          .timeout(timeLimit ?? const Duration(seconds: 10));
      responseJson = this.responseJson(response);
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('error');
    }
    return responseJson;
  }

  Future postApiService({
    String? url,
    Uri? uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeLimit,
  }) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(uri ?? Uri.parse(url!),
              headers: headers, body: body, encoding: encoding)
          .timeout(timeLimit ?? const Duration(seconds: 10));
      responseJson = this.responseJson(response);
    } on SocketException {
      throw Exception('No internet connection');
    }
    return responseJson;
  }

  Future putApiService({
    String? url,
    Uri? uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeLimit,
  }) async {
    dynamic responseJson;
    try {
      final response = await http
          .put(uri ?? Uri.parse(url!),
              headers: headers, body: body, encoding: encoding)
          .timeout(timeLimit ?? const Duration(seconds: 10));
      responseJson = this.responseJson(response);
    } on SocketException {
      throw Exception('No internet connection');
    }
    return responseJson;
  }

  dynamic responseJson(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      default:
        throw Exception(response.reasonPhrase);
    }
  }
}
