import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mbungeweb/cubit/observer.dart';
import 'package:mbungeweb/models/add_mp.dart';
import 'package:mbungeweb/models/edit_mp.dart';
import 'package:mbungeweb/models/mp_model.dart';
import 'package:mbungeweb/repository/_repository.dart';

part 'mp_state.dart';

class MpCubit extends Cubit<MpState> {
  final MpRepo mpRepo;
  MpCubit({@required this.mpRepo}) : super(MpInitial());

  Future<void> fetchAllMps() async {
    try {
      final mps = await mpRepo.getHttpMPs();
      if (mps == null) {
        emit(MpError(message: "An error occured"));
      } else {
        emit(
          MpSuccess(
            mps: mps,
            actionState: ActionState("", true),
          ),
        );
      }
    } catch (e) {
      emit(MpError(message: e.toString()));
    }
  }

  Future<void> addMp({
    @required AddMpModel model,
    @required Uint8List imageBytes,
  }) async {
    final currentState = state;
    if (currentState is MpSuccess) {
      try {
        final mp = await mpRepo.addMp(
          model: model,
          imageBytes: imageBytes,
        );
        if (mp != null && mp.toString().contains("added successfully")) {
          emit(
            MpSuccess(
              mps: currentState.mps,
              actionState: ActionState("Add mp successfully", true),
            ),
          );
          this.fetchAllMps();
        } else {
          MpSuccess(
            mps: currentState.mps,
            actionState: ActionState("An error adding MP", false),
          );
        }
      } catch (e) {}
    }
  }

  Future<void> deleteMp(String mpId) async {
    final currentState = state;
    if (currentState is MpSuccess) {
      try {
        final mp = await mpRepo.deleteMp(mpId);
        if (mp != null && mp.contains("Deleted successfully")) {
          final mps = currentState.mps;
          int indexToRemove = mps.indexWhere((element) => element.id == mpId);
          mps.removeAt(indexToRemove);
          emit(
            MpSuccess(
              mps: mps,
              actionState: ActionState("Deleted mp successfully", true),
            ),
          );
        } else {
          MpSuccess(
            mps: currentState.mps,
            actionState: ActionState("An error deleting MP", false),
          );
        }
      } catch (e) {}
    }
  }

  Future<void> editMp(String id, EditMpModel editMpModel) async {
    final currentState = state;
    if (currentState is MpSuccess) {
      final mps = currentState.mps;
      int indexToRemove = mps.indexWhere(
            (element) => element.id == id,
          ) ??
          null;
      try {
        MpModel mpModel = await mpRepo.editMp(
          id,
          editMpModel,
        );
        if (indexToRemove != null) {
          if (mpModel != null) {
            mps.removeAt(indexToRemove);
            mps.insert(indexToRemove, mpModel);
            emit(MpSuccess(
              mps: mps,
              actionState: ActionState(
                "Edited Mp",
                true,
              ),
            ));
          } else {
            emit(MpSuccess(
              mps: mps,
              actionState: ActionState(
                "Unable to edit mp",
                false,
              ),
            ));
          }
        }
      } catch (e) {
        emit(MpSuccess(
          mps: mps,
          actionState: ActionState(
            e.toString(),
            false,
          ),
        ));
      }
    }
  }
}
