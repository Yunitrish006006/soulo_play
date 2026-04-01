class PortalEvent {
  const PortalEvent({
    required this.id,
    required this.title,
    required this.slug,
    required this.startDate,
    required this.endDate,
    this.introHtml,
    required this.agenda,
    this.rulesHtml,
    this.refundPolicyHtml,
    required this.packingRequired,
    required this.packingRecommended,
    required this.pickupInfo,
    this.organizerIg,
    this.organizerLineUrl,
    required this.status,
  });

  final int id;
  final String title;
  final String slug;
  final String startDate;
  final String endDate;
  final String? introHtml;
  final List<dynamic> agenda;
  final String? rulesHtml;
  final String? refundPolicyHtml;
  final List<dynamic> packingRequired;
  final List<dynamic> packingRecommended;
  final Map<String, dynamic> pickupInfo;
  final String? organizerIg;
  final String? organizerLineUrl;
  final String status;

  factory PortalEvent.fromJson(Map<String, dynamic> json) {
    return PortalEvent(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      introHtml: json['intro_html'] as String?,
      agenda: (json['agenda'] as List<dynamic>? ?? const []),
      rulesHtml: json['rules_html'] as String?,
      refundPolicyHtml: json['refund_policy_html'] as String?,
      packingRequired: (json['packing_required'] as List<dynamic>? ?? const []),
      packingRecommended:
          (json['packing_recommended'] as List<dynamic>? ?? const []),
      pickupInfo:
          (json['pickup_info'] as Map<String, dynamic>? ??
          const <String, dynamic>{}),
      organizerIg: json['organizer_ig'] as String?,
      organizerLineUrl: json['organizer_line_url'] as String?,
      status: json['status'] as String? ?? '',
    );
  }
}
