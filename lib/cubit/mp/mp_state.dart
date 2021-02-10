part of 'mp_cubit.dart';

abstract class MpState extends Equatable {
  const MpState();

  @override
  List<Object> get props => [];
}

class MpInitial extends MpState {}

class MpSuccess extends MpState {
  final List<MpModel> mps;
  final ActionState actionState;

  MpSuccess({this.mps, this.actionState});
  @override
  List<Object> get props => [mps, actionState];
}

class MpError extends MpState {
  final String message;

  MpError({@required this.message});
  @override
  List<Object> get props => [message];
}
