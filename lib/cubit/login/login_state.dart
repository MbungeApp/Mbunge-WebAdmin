part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class UserLoggedIn extends LoginState {
  final UserModel userModel;
  final String token;

  UserLoggedIn({
    @required this.userModel,
    @required this.token,
  });

  @override
  List<Object> get props => [userModel,token];
}

class UserLoggedOut extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError({this.message});

  @override
  List<Object> get props => [message];
}

class LoginSuccessState {}
