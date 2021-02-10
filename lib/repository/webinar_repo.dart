part of '_repository.dart';

class WebinarRepo {
  WebinarRepo._internal();
  static final WebinarRepo _webinarRepo = WebinarRepo._internal();
  factory WebinarRepo() {
    return _webinarRepo;
  }

  final httpClient = HttpClient();

  // Methods
  Future<List<WebinarModel>> getHttpWebinars() async {
    http.Response response = await httpClient.getRequest(
      "/dashboard/webinar/",
    );
    if (response != null) {
      if (!response.body.toString().contains("null")) {
        final webinars = webinarModelFromJson(response.body);
        return webinars ?? [];
      } else {
        return [];
      }
    } else if (response.statusCode == 404) {
      throw NetworkException();
    } else {
      return null;
    }
  }

  Future<String> addHttpWebinar(AddWebinarModel addWebinarModel) async {
    http.Response response = await httpClient.postRequest(
      "/dashboard/webinar/add",
      addWebinarModel.toJson(),
    );
    if (response != null && response.statusCode == 201) {
      return response.body.toString();
    } else {
      return null;
    }
  }

  Future<String> deleteHttpWebinar(String webinarid) async {
    http.Response response = await httpClient.deleteRequest(
      "/dashboard/webinar/delete/$webinarid",
    );
    if (response != null) {
      return response.body.toString();
    } else {
      return null;
    }
  }
}
