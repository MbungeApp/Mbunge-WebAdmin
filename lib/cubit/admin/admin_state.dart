part of 'admin_cubit.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminInitial extends AdminState {}

class AdminSuccess extends AdminState {
  final List<AdminModel> admins;
  final AdminActionState actionState;

  AdminSuccess({
    @required this.admins,
    @required this.actionState,
  });
  @override
  List<Object> get props => [admins, actionState];
}

class AdminError extends AdminState {
  final String message;

  AdminError({this.message});
  @override
  List<Object> get props => [message];
}

class AdminActionState {
  final String message;
  final bool isSuccess;

  AdminActionState({
    @required this.message,
    @required this.isSuccess,
  });
}
