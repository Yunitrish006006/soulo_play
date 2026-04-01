import '../models/participant_profile.dart';
import '../models/payment_submission.dart';
import '../models/registration.dart';
import 'api_client.dart';
import 'service_utils.dart';

class RegistrationService {
  RegistrationService(this._apiClient);

  final ApiClient _apiClient;

  Future<EventRegistration> createRegistration({
    required int eventId,
    required int planId,
    required int groupSize,
    required String arrivalMode,
    required bool shuttleRequired,
    required List<String> memberNames,
    required ParticipantProfile participantProfile,
  }) async {
    final response = await _apiClient.postJson('/api/registrations', {
      'event_id': eventId,
      'plan_id': planId,
      'group_size': groupSize,
      'arrival_mode': arrivalMode,
      'shuttle_required': shuttleRequired,
      'member_names': memberNames,
      'participant_profile': participantProfile.toJson(),
      'agreements': {'accepted': true},
    });
    return jsonModel(response, 'registration', EventRegistration.fromJson);
  }

  Future<List<EventRegistration>> fetchMyRegistrations() async {
    final response = await _apiClient.getJson('/api/registrations/me');
    return jsonModelList(response, 'registrations', EventRegistration.fromJson);
  }

  Future<EventRegistration> fetchRegistration(int registrationId) async {
    final response = await _apiClient.getJson(
      '/api/registrations/$registrationId',
    );
    return jsonModel(response, 'registration', EventRegistration.fromJson);
  }

  Future<PaymentSubmission?> submitPayment({
    required int registrationId,
    required String payerName,
    required String bankLast5,
    required int submittedAmount,
  }) async {
    final response = await _apiClient
        .postJson('/api/registrations/$registrationId/payment-submission', {
          'payer_name': payerName,
          'bank_last5': bankLast5,
          'submitted_amount': submittedAmount,
        });
    return jsonNullableModel(
      response,
      'payment_submission',
      PaymentSubmission.fromJson,
    );
  }
}
