part of '_repository.dart';

class EventsRepo {
  EventsRepo._internal();
  static final EventsRepo _eventsRepo = EventsRepo._internal();
  factory EventsRepo() {
    return _eventsRepo;
  }

  final httpClient = HttpClient();
  // Methods
  // 1. get all events as list
  Future<List<EventModel>> getHttpEvents() async {
    http.Response response = await httpClient.getRequest(
      "/dashboard/event/",
    );
    if (response != null && response.statusCode == 200) {
      final eventModel = List<EventModel>.from(
        json.decode(response.body).map((x) {
          return EventModel.fromJson(x);
        }),
      );
      return eventModel;
    } else if (response.statusCode == 404) {
      throw NetworkException();
    } else {
      return null;
    }
  }

  // 2. Add an event
  Future<String> addEvent({
    @required AddEventModel model,
    @required Uint8List imageBytes,
  }) async {
    http.Response response = await httpClient.uploadFile(
      endpoint: "/dashboard/event/add",
      map: model.toJson(),
      imageBytes: imageBytes,
    );
    if (response != null && response.statusCode == 201) {
      return response.body;
    } else {
      return null;
    }
  }

  // 3. Edit an event
  // that takes a key and a value
  Future<EventModel> editEvent(String id, EditEventModel editEventModel) async {
    http.Response response = await httpClient.postRequest(
      "/dashboard/event/edit/$id",
      editEventModel.toJson(),
    );
    if (response != null && response.statusCode == 200) {
      final event = EventModel.fromJson(json.decode(response.body));
      return event;
    } else {
      return null;
    }
  }

  // 4. delete an event
  // takes an event id
  Future<String> deleteEvent(String eventId) async {
    http.Response response = await httpClient.deleteRequest(
      "/dashboard/event/delete/$eventId",
    );
    if (response != null) {
      return response.body;
    } else {
      return null;
    }
  }
}
