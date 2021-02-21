part of 'authenticiation_cubit.dart';

abstract class AuthenticiationState extends Equatable {
  const AuthenticiationState();

  @override
  List<Object> get props => [];
}

class AuthenticiationInitial extends AuthenticiationState {}

class AuthenticiationLoggedIn extends AuthenticiationState {
  final UserModel userModel;
  final String token;

  AuthenticiationLoggedIn({
    @required this.userModel,
    @required this.token,
  });

  @override
  List<Object> get props => [userModel, token];
}

class AuthenticiationLoggedOut extends AuthenticiationState {}

class AuthenticiationError extends AuthenticiationState {
  final String message;

  AuthenticiationError({@required this.message});

  @override
  List<Object> get props => [message];
}
