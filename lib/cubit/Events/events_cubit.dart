import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mbungeweb/models/add_event.dart';
import 'package:mbungeweb/models/event.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/utils/logger.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventsRepo eventsRepo;
  EventsCubit({this.eventsRepo}) : super(EventsInitial());

  Future<void> fetchEvents() async {
    try {
      final events = await eventsRepo.getHttpEvents();
      if (events == null) {
        emit(EventsError(message: "An error occured"));
      } else {
        emit(EventsSuccess(
          events: events,
          eventActionState: EventActionState(
            isSuccess: true,
            message: "Loaded events",
          ),
        ));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final currentState = state;
    if (currentState is EventsSuccess) {
      final events = currentState.events;
      int indexToRemove = events.indexWhere(
            (element) => element.id == eventId,
          ) ??
          null;
      if (indexToRemove != null) {
        String res = await eventsRepo.deleteEvent(eventId);
        if (res != null && res.contains("deleted successfully")) {
          events.removeAt(indexToRemove);
          emit(EventsSuccess(
            events: events,
            eventActionState: EventActionState(
              isSuccess: true,
              message: "Deleted Event",
            ),
          ));
        } else {
          emit(EventsSuccess(
            events: events,
            eventActionState: EventActionState(
              isSuccess: false,
              message: "Unable to delete event",
            ),
          ));
        }
      } else {
        emit(EventsSuccess(
          events: events,
          eventActionState: EventActionState(
            isSuccess: false,
            message: "An error occured",
          ),
        ));
      }
    }
  }

  Future<void> addAnEvent({
    @required AddEventModel model,
    
    @required Uint8List imageBytes,
  }) async {
    final currentState = state;
    try {
      String data = await eventsRepo.addEvent(
        model: model,
        imageBytes: imageBytes,
      );
      if (currentState is EventsSuccess) {
        if (data.contains("Added successfully")) {
          emit(EventsSuccess(
            events: currentState.events,
            eventActionState: EventActionState(
              isSuccess: true,
              message: "Added successfully",
            ),
          ));
          this.fetchEvents();
        } else {
          emit(EventsSuccess(
            events: currentState.events,
            eventActionState: EventActionState(
              isSuccess: false,
              message: "Failed to add event",
            ),
          ));
        }
      }
    } catch (e) {
      AppLogger.logError(e.toString());
      if (currentState is EventsSuccess) {
        emit(EventsSuccess(
          events: currentState.events,
          eventActionState: EventActionState(
            isSuccess: false,
            message: "is your device online?",
          ),
        ));
      }
    }
  }
}
