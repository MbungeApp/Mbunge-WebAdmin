import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mbungeweb/models/user_model.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/repository/shared_preference_repo.dart';

part 'authenticiation_state.dart';

class AuthenticiationCubit extends Cubit<AuthenticiationState> {
  final AdminRepo adminRepo;
  final SharedPreferenceRepo sharedPreferenceRepo;
  AuthenticiationCubit(this.adminRepo, this.sharedPreferenceRepo)
      : super(AuthenticiationInitial());

  Future<void> isUserLoggedIn() async {
    try {
      String token = await sharedPreferenceRepo.getUserToken();
      if (token == null || token.isEmpty) {
        emit(AuthenticiationLoggedOut());
      } else {
        print("1");
        String userJson = await sharedPreferenceRepo.getUserProfile();
        print("2");
        final userModel = userModelFromJson(userJson);
        print("3");
        emit(
          AuthenticiationLoggedIn(
            token: token,
            userModel: userModel,
          ),
        );
        print("4");
      }
    } catch (e) {
      emit(AuthenticiationError(message: e.toString()));
    }
  }

  Future<void> logOutUser() async {
    try {
      await sharedPreferenceRepo.destorySharedPreferences();
      emit(AuthenticiationLoggedOut());
    } catch (e) {
      emit(AuthenticiationError(message: e.toString()));
    }
  }
}
