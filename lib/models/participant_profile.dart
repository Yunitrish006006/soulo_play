class ParticipantProfile {
  const ParticipantProfile({
    required this.legalName,
    required this.gender,
    required this.ageRange,
    required this.phone,
    required this.occupation,
    required this.birthDate,
    required this.nationalId,
    required this.emergencyName,
    required this.emergencyRelation,
    required this.emergencyPhone,
    required this.igHandle,
    required this.lineId,
    this.nickname,
    this.city,
    required this.dietType,
    required this.foodAvoidances,
    this.allergiesText,
    required this.musicPreferences,
    this.hobbiesText,
    required this.referralSource,
    this.createdAt,
    this.updatedAt,
  });

  final String legalName;
  final String gender;
  final String ageRange;
  final String phone;
  final String occupation;
  final String birthDate;
  final String nationalId;
  final String emergencyName;
  final String emergencyRelation;
  final String emergencyPhone;
  final String igHandle;
  final String lineId;
  final String? nickname;
  final String? city;
  final String dietType;
  final List<String> foodAvoidances;
  final String? allergiesText;
  final List<String> musicPreferences;
  final String? hobbiesText;
  final String referralSource;
  final String? createdAt;
  final String? updatedAt;

  factory ParticipantProfile.fromJson(Map<String, dynamic> json) {
    return ParticipantProfile(
      legalName: json['legal_name'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      ageRange: json['age_range'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      occupation: json['occupation'] as String? ?? '',
      birthDate: json['birth_date'] as String? ?? '',
      nationalId: json['national_id'] as String? ?? '',
      emergencyName: json['emergency_name'] as String? ?? '',
      emergencyRelation: json['emergency_relation'] as String? ?? '',
      emergencyPhone: json['emergency_phone'] as String? ?? '',
      igHandle: json['ig_handle'] as String? ?? '',
      lineId: json['line_id'] as String? ?? '',
      nickname: json['nickname'] as String?,
      city: json['city'] as String?,
      dietType: json['diet_type'] as String? ?? '',
      foodAvoidances: (json['food_avoidances'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
      allergiesText: json['allergies_text'] as String?,
      musicPreferences:
          (json['music_preferences'] as List<dynamic>? ?? const [])
              .map((item) => item.toString())
              .toList(),
      hobbiesText: json['hobbies_text'] as String?,
      referralSource: json['referral_source'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'legal_name': legalName,
      'gender': gender,
      'age_range': ageRange,
      'phone': phone,
      'occupation': occupation,
      'birth_date': birthDate,
      'national_id': nationalId,
      'emergency_name': emergencyName,
      'emergency_relation': emergencyRelation,
      'emergency_phone': emergencyPhone,
      'ig_handle': igHandle,
      'line_id': lineId,
      'nickname': nickname,
      'city': city,
      'diet_type': dietType,
      'food_avoidances': foodAvoidances,
      'allergies_text': allergiesText,
      'music_preferences': musicPreferences,
      'hobbies_text': hobbiesText,
      'referral_source': referralSource,
    };
  }
}
