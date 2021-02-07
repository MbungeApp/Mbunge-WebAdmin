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

  Future<String> addMp(AddMpModel model) async {
    http.Response response = await httpClient.postRequest(
      "/dashoard/mp/add",
      model.toJson(),
    );
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
