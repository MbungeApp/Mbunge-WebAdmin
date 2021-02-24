part of 'webinarquestions_cubit.dart';

// abstract class WebinarquestionsState extends Equatable {
//   const WebinarquestionsState();

//   @override
//   List<Object> get props => [];
// }

abstract class WebinarquestionsState {
  const WebinarquestionsState();

}

class WebinarquestionsInitial extends WebinarquestionsState {}

class WebinarquestionsSuccess extends WebinarquestionsState {
  final List<Questions> questions;

  WebinarquestionsSuccess(this.questions);
}

class WebinarquestionsError extends WebinarquestionsState {}
