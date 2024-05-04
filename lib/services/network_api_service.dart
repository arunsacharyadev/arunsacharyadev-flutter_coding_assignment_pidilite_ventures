import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class NetworkApiService {
  static final NetworkApiService _instance = NetworkApiService._internal();

  factory NetworkApiService() => _instance;

  late Duration timeLimit;

  NetworkApiService._internal() {
    timeLimit = const Duration(seconds: 10);
  }

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
          .timeout(timeLimit ?? this.timeLimit);
      responseJson = processResponse(response);
      return responseJson;
    } catch (e) {
      throw ExceptionHandlers().getExceptionString(e);
    }
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
          .timeout(timeLimit ?? this.timeLimit);
      responseJson = processResponse(response);
      return responseJson;
    } catch (e) {
      throw ExceptionHandlers().getExceptionString(e);
    }
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
          .timeout(timeLimit ?? this.timeLimit);
      responseJson = processResponse(response);
      return responseJson;
    } catch (e) {
      throw ExceptionHandlers().getExceptionString(e);
    }
  }

  dynamic processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      case 400:
        throw BadRequestException(jsonDecode(response.body)['message']);
      case 401:
        throw UnAuthorizedException(jsonDecode(response.body)['message']);
      case 403:
        throw ForbiddenException(jsonDecode(response.body)['message']);
      case 404:
        throw NotFoundException(jsonDecode(response.body)['message']);
      case 500:
        throw ServerErrorException(jsonDecode(response.body)['message']);
      default:
        throw Exception(response.reasonPhrase);
    }
  }
}

class ExceptionHandlers {
  getExceptionString(error) {
    if (error is SocketException) {
      return 'No internet connection.';
    } else if (error is HttpException) {
      return 'HTTP error occurred.';
    } else if (error is FormatException) {
      return 'Invalid data format.';
    } else if (error is TimeoutException) {
      return 'Request timeout.';
    } else if (error is BadRequestException) {
      return error.message.toString();
    } else if (error is UnAuthorizedException) {
      return error.message.toString();
    } else if (error is NotFoundException) {
      return error.message.toString();
    } else if (error is FetchDataException) {
      return error.message.toString();
    } else {
      return 'Unknown error occurred.';
    }
  }
}

class AppException implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  AppException([this.message, this.prefix, this.url]);
}

class BadRequestException extends AppException {
  BadRequestException([String? message, String? url])
      : super(message, 'Bad request', url);
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
      : super(message, 'Unable to process the request', url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message, String? url])
      : super(message, 'Api not responding', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url])
      : super(message, 'Unauthorized request', url);
}

class ForbiddenException extends AppException {
  ForbiddenException([String? message, String? url])
      : super(message, 'Forbidden Error', url);
}

class NotFoundException extends AppException {
  NotFoundException([String? message, String? url])
      : super(message, 'Page not found', url);
}

class ServerErrorException extends AppException {
  ServerErrorException([String? message, String? url])
      : super(message, 'Server Error', url);
}
