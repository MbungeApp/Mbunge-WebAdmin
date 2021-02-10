import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mbungeweb/models/add_admin.dart';
import 'package:mbungeweb/models/admin_model.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/utils/logger.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepo adminRepo;
  AdminCubit({this.adminRepo}) : super(AdminInitial());

  Future<void> fetchAdmins() async {
    try {
      final admins = await adminRepo.getHttpAdmins();
      if (admins == null) {
        emit(AdminError(message: "An error occured"));
      } else {
        emit(AdminSuccess(
          admins: admins,
          actionState: AdminActionState(
            isSuccess: true,
            message: "Loaded admins",
          ),
        ));
      }
    } catch (e) {
      AppLogger.logDebug(e.toString());
      emit(AdminError(message: e.toString()));
    }
  }

  Future<void> addAdmin(AddAdminModel adminModel) async {
    print(adminModel.toJson().toString());
    final currentState = state;
    if (currentState is AdminSuccess) {
      try {
        print("reached 1");
        String res = await adminRepo.addAdmin(adminModel);
        print("reached 2: $res");
        if (res != null && res.contains("Added admin successfully")) {
          emit(AdminSuccess(
            admins: currentState.admins,
            actionState: AdminActionState(
              isSuccess: true,
              message: "Added admin",
            ),
          ));
          this.fetchAdmins();
        } else {
          emit(AdminSuccess(
            admins: currentState.admins,
            actionState: AdminActionState(
              isSuccess: false,
              message: "Unable to admin",
            ),
          ));
        }
      } catch (e) {
        AppLogger.logDebug(e.toString());
        emit(AdminSuccess(
          admins: currentState.admins,
          actionState: AdminActionState(
            isSuccess: false,
            message: e.toString(),
          ),
        ));
      }
    }
  }

  Future<void> editAdmin() async {}
  Future<void> deleteAdmin(String adminId) async {
    final currentState = state;
    if (currentState is AdminSuccess) {
      try {
        final admins = currentState.admins;
        final res = await adminRepo.deleteAdmin(adminId);
        if (res != null && res.contains("deleted successfully")) {
          int indexToRemove = admins.indexWhere(
                (element) => element.id == adminId,
              ) ??
              null;
          if (indexToRemove != null) {
            admins.removeAt(indexToRemove);
            emit(AdminSuccess(
              admins: admins,
              actionState: AdminActionState(
                isSuccess: false,
                message: "Deleted successfully",
              ),
            ));
          }
        } else {}
      } catch (e) {
        emit(AdminSuccess(
          admins: currentState.admins,
          actionState: AdminActionState(
            isSuccess: false,
            message: e.toString(),
          ),
        ));
      }
    }
  }
}
