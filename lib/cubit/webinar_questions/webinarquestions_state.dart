part of 'webinarquestions_cubit.dart';

abstract class WebinarquestionsState extends Equatable {
  const WebinarquestionsState();

  @override
  List<Object> get props => [];
}

class WebinarquestionsInitial extends WebinarquestionsState {}

class WebinarquestionsSuccess extends WebinarquestionsState {
  final List<Questions> questions;

  WebinarquestionsSuccess(this.questions);

  @override
  List<Object> get props => [questions];
}

class WebinarquestionsError extends WebinarquestionsState {}
