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
    try {
      http.Response response = await http.Client().post(
        baseUrl(endpoint),
        body: body,
      );
      AppLogger.logInfo("postRequest:\nurl:$endpoint\nresponse:\n$response");
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
      AppLogger.logInfo("deleteRequest:\nurl:$endpoint\nresponse:\n$response");
      return response;
    } catch (e) {
      AppLogger.logError(e);
      throw e;
    }
  }
}
