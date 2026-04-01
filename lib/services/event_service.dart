import '../models/event.dart';
import '../models/event_plan.dart';
import 'api_client.dart';
import 'service_utils.dart';

class EventDetails {
  const EventDetails({required this.event, required this.plans});

  final PortalEvent event;
  final List<EventPlan> plans;
}

class EventService {
  EventService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PortalEvent>> fetchOpenEvents() async {
    final response = await _apiClient.getJson('/api/events/open');
    return jsonModelList(response, 'events', PortalEvent.fromJson);
  }

  Future<EventDetails> fetchEventDetails(int eventId) async {
    final response = await _apiClient.getJson('/api/events/$eventId');
    return EventDetails(
      event: jsonModel(response, 'event', PortalEvent.fromJson),
      plans: jsonModelList(response, 'plans', EventPlan.fromJson),
    );
  }
}
