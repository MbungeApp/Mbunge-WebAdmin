
part of '_repository.dart';

class MetricsRepo {
  MetricsRepo._internal();
  static final MetricsRepo _metricsRepo = MetricsRepo._internal();
  factory MetricsRepo() {
    return _metricsRepo;
  }

  final httpClient = HttpClient();
  // Methods
  Future<Metrics> getHttpPost() async {
    http.Response response = await httpClient.getRequest(
      "/dashboard/metrics",
    );
    if (response != null && response.statusCode == 200) {
      final post = metricsFromJson(
        response.body,
      );
      return post;
    } else if (response.statusCode == 404) {
      throw NetworkException();
    } else {
      return null;
    }
  }
}

class NetworkException implements Exception {}
