import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mbungeweb/models/user_model.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/repository/shared_preference_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AdminRepo adminRepo;
  final SharedPreferenceRepo sharedPreferenceRepo;
  LoginCubit({@required this.sharedPreferenceRepo, @required this.adminRepo})
      : super(LoginInitial());

  Future<void> isUserLoggedIn() async {
    try {
      String token = await sharedPreferenceRepo.getUserToken();
      if (token == null) {
        emit(UserLoggedOut());
      } else {
        print("1");
        String userJson = await sharedPreferenceRepo.getUserProfile();
        print("2");
        final userModel = userModelFromJson(userJson);
        print("3");
        emit(
          UserLoggedIn(
            token: token,
            userModel: userModel,
          ),
        );
        print("4");
      }
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  Future<void> loginUser(String email, String password) async {
    Map<String, dynamic> userDetails = {"email": email, "password": password};
    try {
      UserModel userModel = await adminRepo.loginUser(userDetails);
      if (userModel != null) {
        sharedPreferenceRepo.setUserProfile(
          json.encode(userModel.toJson()),
        );
        sharedPreferenceRepo.setUserToken(userModel.token);
        emit(
          UserLoggedIn(
            token: userModel.token,
            userModel: userModel,
          ),
        );
      }
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  Future<void> logOutUser() async {
    try {
      await sharedPreferenceRepo.destorySharedPreferences();
      emit(UserLoggedOut());
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }
}