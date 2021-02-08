part of '_repository.dart';

class MpRepo {
  MpRepo._internal();
  static final MpRepo _mpRepo = MpRepo._internal();
  factory MpRepo() {
    return _mpRepo;
  }

  final httpClient = HttpClient();

  // Methods
  Future<List<MpModel>> getHttpMPs() async {
    http.Response response = await httpClient.getRequest(
      "/dashboard/mp/",
    );
    if (response != null && response.statusCode == 200) {
      final mps = mpModelFromJson(response.body);
      return mps;
    } else if (response.statusCode == 404) {
      throw NetworkException();
    } else {
      return null;
    }
  }

  Future<String> addMp({
    @required AddMpModel model,
    @required Uint8List imageBytes,
  }) async {
    print("Reached add mp repo");
    http.Response response = await httpClient.uploadFile(
      endpoint: "/dashboard/mp/add",
      map: model.toJson(),
      imageBytes: imageBytes,
    );
    print("Reached add mp repo sucessfully");
    if (response != null && response.statusCode == 201) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String> deleteMp(String mpId) async {
    http.Response response = await httpClient.deleteRequest(
      "/dashboard/mp/delete/$mpId",
    );
    if (response != null) {
      return response.body;
    } else {
      return null;
    }
  }
}
