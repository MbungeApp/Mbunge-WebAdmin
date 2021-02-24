import 'package:bloc/bloc.dart';
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

  streamChanges(String id) {
    HtmlWebSocketChannel channel;
    if (channel == null) {
      try {
        channel = HtmlWebSocketChannel.connect(
          Uri.parse('wss://api.mbungeapp.tech/api/v1/webinar/ws'),
        );
        AppLogger.logDebug("Connected succesfully");
        channel.stream.listen((message) {
          print("new stufff");
          AppLogger.logWTF(message);
          fetchQuestions(id);
        });
      } catch (e) {
        AppLogger.logWTF(e.toString());
      }
    } else {
      channel.stream.listen((message) {
        print("new stufff");
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
