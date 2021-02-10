part of 'events_cubit.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];
}

class EventsInitial extends EventsState {}

class EventsSuccess extends EventsState {
  final List<EventModel> events;
  final EventActionState eventActionState;

  EventsSuccess({
    @required this.events,
    @required this.eventActionState,
  });
  @override
  List<Object> get props => [events, eventActionState];
}

class EventsError extends EventsState {
  final String message;

  EventsError({@required this.message});
  @override
  List<Object> get props => [message];
}

class EventActionState {
  final bool isSuccess;
  final String message;

  EventActionState({@required this.isSuccess, @required this.message});
}
