import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mbungeweb/models/webinar_questions.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/utils/logger.dart';
import 'package:web_socket_channel/html.dart';

part 'webinarquestions_state.dart';

class WebinarquestionsCubit extends Cubit<WebinarquestionsState> {
  final WebinarRepo webinarRepo;
  WebinarquestionsCubit({@required this.webinarRepo})
      : super(WebinarquestionsInitial());

  var channel;

  streamChanges(String id) {
    if (channel == null) {
      channel = HtmlWebSocketChannel.connect(
          Uri.parse('ws://api.mbungeapp.tech/api/v1/webinar/ws'));
    } else {
      channel.stream.listen((message) {
        AppLogger.logWTF(message);
        fetchQuestions(id);
      });
    }
  }

  Future<void> fetchQuestions(String id) async {
    try {
      final _questions = await webinarRepo.getWebinarQuestions(id);
      if (_questions != null) {
        emit(WebinarquestionsSuccess(_questions));
      } else {
        emit(WebinarquestionsError());
      }
    } catch (e) {
      emit(WebinarquestionsError());
    }
  }
}
