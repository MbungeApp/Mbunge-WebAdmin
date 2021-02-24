import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mbungeweb/models/edit_webinar.dart';
import 'package:mbungeweb/models/webinar.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/models/add_webinar.dart';
import 'package:mbungeweb/utils/logger.dart';

part 'webinar_state.dart';

class WebinarCubit extends Cubit<WebinarState> {
  final WebinarRepo webinarRepo;
  WebinarCubit({@required this.webinarRepo}) : super(WebinarInitial());

  Future<void> fetchWebinars() async {
    try {
      final webinars = await webinarRepo.getHttpWebinars();
      if (webinars != null) {
        emit(WebinarSuccess(
          webinars: webinars,
          webinarSuccessAction: WebinarSuccessAction(
            isSucess: true,
            message: "",
          ),
        ));
      }
    } catch (e) {
      emit(WebinarError(message: e.toString()));
    }
  }

  Future<void> addWebinar(AddWebinarModel webinarModel) async {
    final currentState = state;
    if (currentState is WebinarSuccess) {
      try {
        String response = await webinarRepo.addHttpWebinar(webinarModel);
        if (response != null) {
          emit(
            WebinarSuccess(
              webinars: currentState.webinars,
              webinarSuccessAction: WebinarSuccessAction(
                isSucess: true,
                message: "Add webinar successfully",
              ),
            ),
          );
          this.fetchWebinars();
        }
      } catch (e) {
        AppLogger.logWTF(e.toString());
        emit(
          WebinarSuccess(
            webinars: currentState.webinars,
            webinarSuccessAction: WebinarSuccessAction(
              isSucess: false,
              message: "Unable to add webinar",
            ),
          ),
        );
      }
    }
  }

  Future<void> editWebinar(String id, EditWebinarModel editWebinarModel) async {
    final currentState = state;
    if (currentState is WebinarSuccess) {
      final webinars = currentState.webinars;
      int indexToRemove = webinars.indexWhere(
            (element) => element.id == id,
          ) ??
          null;
      try {
        AppLogger.logWTF(editWebinarModel.toJson().toString());
        WebinarModel webinarModel = await webinarRepo.editWebinar(
          id,
          editWebinarModel,
        );
        if (indexToRemove != null) {
          if (webinarModel != null) {
            webinars.removeAt(indexToRemove);
            webinars.insert(indexToRemove, webinarModel);
            emit(
              WebinarSuccess(
                webinars: webinars,
                webinarSuccessAction: WebinarSuccessAction(
                  isSucess: true,
                  message: "Edited webinar successfully",
                ),
              ),
            );
          } else {
            emit(
              WebinarSuccess(
                webinars: webinars,
                webinarSuccessAction: WebinarSuccessAction(
                  isSucess: false,
                  message: "Unable to edit webinar",
                ),
              ),
            );
          }
        }
      } catch (e) {
        emit(
          WebinarSuccess(
            webinars: webinars,
            webinarSuccessAction: WebinarSuccessAction(
              isSucess: false,
              message: e.toString(),
            ),
          ),
        );
      }
    }
  }

  Future<void> deleteWebinar(String webinarId) async {
    final currentState = state;
    if (currentState is WebinarSuccess) {
      try {
        String res = await webinarRepo.deleteHttpWebinar(webinarId);
        if (res != null) {
          final webinars = currentState.webinars;
          int indexToRemove = webinars.indexWhere(
            (element) => element.id == webinarId,
          );
          webinars.removeAt(indexToRemove);
          emit(
            WebinarSuccess(
              webinars: webinars,
              webinarSuccessAction: WebinarSuccessAction(
                isSucess: true,
                message: "deleted webinar  successfully",
              ),
            ),
          );
        }
      } catch (e) {
        emit(
          WebinarSuccess(
            webinars: currentState.webinars,
            webinarSuccessAction: WebinarSuccessAction(
              isSucess: false,
              message: "Unable to delete webinar",
            ),
          ),
        );
      }
    }
  }
}
