import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mbungeweb/utils/logger.dart';

class HttpClient {
  // Setup a singleton
  static final HttpClient _httpClient = HttpClient._internal();
  factory HttpClient() {
    return _httpClient;
  }
  HttpClient._internal();

  static String baseUrl(String subEndpoint) =>
      "https://api.mbungeapp.tech/api/v1$subEndpoint";

  Future<http.Response> getRequest(String endpoint) async {
    try {
      http.Response response = await http.Client().get(
        baseUrl(endpoint),
      );
      AppLogger.logInfo(
          "getRequest:\nurl:$endpoint\nresponse:${response.statusCode}");
      return response;
    } catch (e) {
      AppLogger.logError(e);
      throw e;
    }
  }

  Future<http.Response> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      http.Response response = await http.Client().post(
        baseUrl(endpoint),
        body: json.encode(body),
        headers: headers,
      );
      AppLogger.logInfo(
        "postRequest:\nurl:$endpoint\nresponse:\n${response.statusCode}",
      );
      return response;
    } catch (e) {
      AppLogger.logError(e);
      throw e;
    }
  }

  Future<http.Response> deleteRequest(String endpoint) async {
    try {
      http.Response response = await http.Client().delete(
        baseUrl(endpoint),
      );
      AppLogger.logInfo(
        "deleteRequest:\nurl:$endpoint\nresponse:\n${response.body}",
      );
      return response;
    } catch (e) {
      AppLogger.logError(e);
      throw e;
    }
  }

  Future<http.Response> uploadFile({
    @required String endpoint,
    @required Map<String, String> map,
    @required Uint8List imageBytes,
  }) async {
    try {
      var postUri = Uri.parse(baseUrl(endpoint));
      var request = http.MultipartRequest("POST", postUri);
      request.fields.addAll(map);
      request.fields['picture'] = base64Encode(imageBytes);
      http.StreamedResponse res = await request.send();
      var response = await http.Response.fromStream(res);
      AppLogger.logInfo(
        "uploadFile:\nurl:$endpoint\nresponse:${response.statusCode}",
      );
      AppLogger.logInfo(
        "uploadFile:\nurl:$endpoint\nresponse:${response.body}",
      );
      return response;
    } catch (e) {
      AppLogger.logError(e);
      throw e;
    }
  }
}
