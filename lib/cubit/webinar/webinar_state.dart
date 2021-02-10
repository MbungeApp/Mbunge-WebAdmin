part of 'webinar_cubit.dart';

abstract class WebinarState extends Equatable {
  const WebinarState();

  @override
  List<Object> get props => [];
}

class WebinarInitial extends WebinarState {}

class WebinarSuccess extends WebinarState {
  final List<WebinarModel> webinars;
  final WebinarSuccessAction webinarSuccessAction;

  WebinarSuccess({
    @required this.webinars,
    @required this.webinarSuccessAction,
  });

  @override
  List<Object> get props => [webinars, webinarSuccessAction];
}

class WebinarError extends WebinarState {
  final String message;

  WebinarError({@required this.message});

  @override
  List<Object> get props => [message];
}

class WebinarSuccessAction {
  final String message;
  final bool isSucess;

  WebinarSuccessAction({
    @required this.message,
    @required this.isSucess,
  });
}
