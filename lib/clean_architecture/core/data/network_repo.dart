import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cleanarchexample/clean_architecture/core/exceptions/network_exceptions.dart';

enum Method { get, post }

abstract interface class INetworkRepository {
  Future<dynamic> makeRequest({
    required Method method,
    required String endPoint,
    String? baseUrl,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  });
}

class NetworkRepository implements INetworkRepository {
  final httpClient = http.Client();

  @override
  Future<dynamic> makeRequest({
    required Method method,
    required String endPoint,
    String? baseUrl,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      http.Response? response;
      final url = _buildUriWithQueryParams(
        baseUrl: baseUrl,
        endPoint: endPoint,
        queryParams: queryParams,
      );
      switch (method) {
        case Method.get:
          response = await httpClient.get(
            url,
            headers: headers,
          );
          break;
        case Method.post:
          response = await httpClient.post(
            url,
            headers: headers,
            body: body,
          );
          break;
      }

      if (response.statusCode != 200) {
        throw NetworkException(
          message: response.body.toString(),
          errorCode: response.statusCode,
        );
      }

      return json.decode(response.body);
    } catch (e) {
      throw NetworkException(
        message: e.toString(),
        errorCode: -1,
      );
    }
  }

  Uri _buildUriWithQueryParams({
    required String? baseUrl,
    required String endPoint,
    Map<String, dynamic>? queryParams,
  }) {
    final fullUrl = (baseUrl ?? "") + endPoint;
    final uri = Uri.parse(fullUrl);

    if (queryParams != null && queryParams.isNotEmpty) {
      // Convert Map<String, dynamic> to Map<String, String> for queryParameters
      final queryParameters = queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      );

      return uri.replace(queryParameters: queryParameters);
    }

    return uri;
  }
}
