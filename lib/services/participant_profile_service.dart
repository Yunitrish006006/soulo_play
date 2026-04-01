import '../models/participant_profile.dart';
import 'api_client.dart';
import 'service_utils.dart';

class ParticipantProfileService {
  ParticipantProfileService(this._apiClient);

  final ApiClient _apiClient;

  Future<ParticipantProfile?> fetchProfile() async {
    final response = await _apiClient.getJson('/api/participant-profile');
    return jsonNullableModel(response, 'profile', ParticipantProfile.fromJson);
  }

  Future<ParticipantProfile> saveProfile(ParticipantProfile profile) async {
    final response = await _apiClient.putJson(
      '/api/participant-profile',
      profile.toJson(),
    );
    return jsonModel(response, 'profile', ParticipantProfile.fromJson);
  }
}
