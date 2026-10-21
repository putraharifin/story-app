import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:story_app/core/constants/api_constants.dart';
import 'package:story_app/core/error/app_exception.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> get(String path, {String? token}) {
    return _send(() => _client.get(_uri(path), headers: _headers(token)));
  }

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, String> body,
    String? token,
  }) {
    return _send(
      () => _client.post(
        _uri(path),
        headers: {..._headers(token), 'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ),
    );
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,
    required String fileField,
    required File file,
    required String token,
  }) {
    return _send(() async {
      final request = http.MultipartRequest('POST', _uri(path))
        ..headers.addAll(_headers(token))
        ..fields.addAll(fields)
        ..files.add(await http.MultipartFile.fromPath(fileField, file.path));
      final streamed = await request.send();
      return http.Response.fromStream(streamed);
    });
  }

  Uri _uri(String path) => Uri.parse('${ApiConstants.baseUrl}$path');

  Map<String, String> _headers(String? token) => {
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    final http.Response response;
    try {
      response = await request().timeout(ApiConstants.timeout);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const ApiException();
    }
    if (decoded is! Map<String, dynamic>) throw const ApiException();

    final isSuccess =
        response.statusCode >= 200 &&
        response.statusCode < 300 &&
        decoded['error'] != true;
    if (!isSuccess) throw ApiException(decoded['message'] as String?);

    return decoded;
  }
}
