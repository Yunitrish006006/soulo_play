class EventPlan {
  const EventPlan({
    required this.id,
    required this.eventId,
    required this.code,
    required this.label,
    required this.minPeople,
    required this.maxPeople,
    required this.pricePerPerson,
    required this.shuttlePricePerPerson,
    required this.paymentDueDays,
    required this.bankCode,
    required this.bankAccount,
    required this.active,
  });

  final int id;
  final int eventId;
  final String code;
  final String label;
  final int minPeople;
  final int maxPeople;
  final int pricePerPerson;
  final int shuttlePricePerPerson;
  final int paymentDueDays;
  final String bankCode;
  final String bankAccount;
  final bool active;

  factory EventPlan.fromJson(Map<String, dynamic> json) {
    return EventPlan(
      id: (json['id'] as num).toInt(),
      eventId: (json['event_id'] as num).toInt(),
      code: json['code'] as String? ?? '',
      label: json['label'] as String? ?? '',
      minPeople: (json['min_people'] as num?)?.toInt() ?? 1,
      maxPeople: (json['max_people'] as num?)?.toInt() ?? 1,
      pricePerPerson: (json['price_per_person'] as num?)?.toInt() ?? 0,
      shuttlePricePerPerson:
          (json['shuttle_price_per_person'] as num?)?.toInt() ?? 0,
      paymentDueDays: (json['payment_due_days'] as num?)?.toInt() ?? 3,
      bankCode: json['bank_code'] as String? ?? '',
      bankAccount: json['bank_account'] as String? ?? '',
      active: json['active'] as bool? ?? false,
    );
  }
}
