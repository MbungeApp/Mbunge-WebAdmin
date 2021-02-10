part of '_repository.dart';

class AdminRepo {
  AdminRepo._internal();
  static final AdminRepo _adminRepo = AdminRepo._internal();
  factory AdminRepo() {
    return _adminRepo;
  }

  final httpClient = HttpClient();

  // Methods
  Future<UserModel> loginUser(Map<String, dynamic> credentials) async {
    http.Response response = await httpClient.postRequest(
      "/dashboard/management/sign_in",
      credentials,
    );
    if (response.statusCode == 201) {
      final user = userModelFromJson(response.body);
      if (user.token == "") {
        return null;
      } else {
        return user;
      }
    } else {
      return null;
    }
  }

  Future<List<AdminModel>> getHttpAdmins() async {
    http.Response response = await httpClient.getRequest(
      "/dashboard/management/",
    );
    if (response != null) {
      debugPrint("Response body: " + response.body);
      if (!response.body.toString().contains("null")) {
        debugPrint("admin repo called 2");
        final admins = adminModelFromJson(response.body);
        return admins ?? [];
      } else {
        debugPrint("admin repo called 1");
        return [];
      }
    } else if (response.statusCode == 404) {
      throw NetworkException();
    } else {
      return null;
    }
  }

  Future<String> addAdmin(AddAdminModel model) async {
    print("reached 3: ${model.toJson()}");
    http.Response response = await httpClient.postRequest(
      "/dashboard/management/add",
      model.toJson(),
    );

    if (response != null && response.statusCode == 201) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String> deleteAdmin(String adminId) async {
    http.Response response = await httpClient.deleteRequest(
      "/dashboard/management/delete/$adminId",
    );
    if (response != null) {
      return response.body;
    } else {
      return null;
    }
  }
}
