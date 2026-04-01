import 'participant_profile.dart';
import 'payment_submission.dart';

class RegistrationEventSummary {
  const RegistrationEventSummary({
    required this.id,
    required this.title,
    required this.slug,
    required this.startDate,
    required this.endDate,
  });

  final int id;
  final String title;
  final String slug;
  final String startDate;
  final String endDate;

  factory RegistrationEventSummary.fromJson(Map<String, dynamic> json) {
    return RegistrationEventSummary(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
    );
  }
}

class RegistrationPlanSummary {
  const RegistrationPlanSummary({
    required this.id,
    required this.code,
    required this.label,
    required this.minPeople,
    required this.maxPeople,
    required this.pricePerPerson,
    required this.shuttlePricePerPerson,
    required this.paymentDueDays,
  });

  final int id;
  final String code;
  final String label;
  final int minPeople;
  final int maxPeople;
  final int pricePerPerson;
  final int shuttlePricePerPerson;
  final int paymentDueDays;

  factory RegistrationPlanSummary.fromJson(Map<String, dynamic> json) {
    return RegistrationPlanSummary(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String? ?? '',
      label: json['label'] as String? ?? '',
      minPeople: (json['min_people'] as num?)?.toInt() ?? 1,
      maxPeople: (json['max_people'] as num?)?.toInt() ?? 1,
      pricePerPerson: (json['price_per_person'] as num?)?.toInt() ?? 0,
      shuttlePricePerPerson:
          (json['shuttle_price_per_person'] as num?)?.toInt() ?? 0,
      paymentDueDays: (json['payment_due_days'] as num?)?.toInt() ?? 3,
    );
  }
}

class PaymentInstructions {
  const PaymentInstructions({
    required this.bankCode,
    required this.bankAccount,
  });

  final String bankCode;
  final String bankAccount;

  factory PaymentInstructions.fromJson(Map<String, dynamic> json) {
    return PaymentInstructions(
      bankCode: json['bank_code'] as String? ?? '',
      bankAccount: json['bank_account'] as String? ?? '',
    );
  }
}

class RegistrationMember {
  const RegistrationMember({
    required this.id,
    required this.registrationId,
    required this.memberName,
    required this.sortOrder,
  });

  final int id;
  final int registrationId;
  final String memberName;
  final int sortOrder;

  factory RegistrationMember.fromJson(Map<String, dynamic> json) {
    return RegistrationMember(
      id: (json['id'] as num).toInt(),
      registrationId: (json['registration_id'] as num).toInt(),
      memberName: json['member_name'] as String? ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

class EventRegistration {
  const EventRegistration({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.planId,
    required this.status,
    required this.reviewStatus,
    required this.groupSize,
    required this.arrivalMode,
    required this.shuttleRequired,
    this.amountDue,
    this.reviewNote,
    this.paymentDueAt,
    this.submittedAt,
    this.approvedAt,
    this.paidAt,
    required this.event,
    required this.plan,
    this.paymentInstructions,
    required this.members,
    this.profileSnapshot,
    this.paymentSubmission,
  });

  final int id;
  final int eventId;
  final int userId;
  final int planId;
  final String status;
  final String reviewStatus;
  final int groupSize;
  final String arrivalMode;
  final bool shuttleRequired;
  final int? amountDue;
  final String? reviewNote;
  final String? paymentDueAt;
  final String? submittedAt;
  final String? approvedAt;
  final String? paidAt;
  final RegistrationEventSummary event;
  final RegistrationPlanSummary plan;
  final PaymentInstructions? paymentInstructions;
  final List<RegistrationMember> members;
  final ParticipantProfile? profileSnapshot;
  final PaymentSubmission? paymentSubmission;

  factory EventRegistration.fromJson(Map<String, dynamic> json) {
    return EventRegistration(
      id: (json['id'] as num).toInt(),
      eventId: (json['event_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      planId: (json['plan_id'] as num).toInt(),
      status: json['status'] as String? ?? '',
      reviewStatus: json['review_status'] as String? ?? '',
      groupSize: (json['group_size'] as num?)?.toInt() ?? 1,
      arrivalMode: json['arrival_mode'] as String? ?? '',
      shuttleRequired: json['shuttle_required'] as bool? ?? false,
      amountDue: (json['amount_due'] as num?)?.toInt(),
      reviewNote: json['review_note'] as String?,
      paymentDueAt: json['payment_due_at'] as String?,
      submittedAt: json['submitted_at'] as String?,
      approvedAt: json['approved_at'] as String?,
      paidAt: json['paid_at'] as String?,
      event: RegistrationEventSummary.fromJson(
        json['event'] as Map<String, dynamic>,
      ),
      plan: RegistrationPlanSummary.fromJson(
        json['plan'] as Map<String, dynamic>,
      ),
      paymentInstructions: json['payment_instructions'] is Map<String, dynamic>
          ? PaymentInstructions.fromJson(
              json['payment_instructions'] as Map<String, dynamic>,
            )
          : null,
      members: (json['members'] as List<dynamic>? ?? const [])
          .map(
            (item) => RegistrationMember.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      profileSnapshot: json['profile_snapshot'] is Map<String, dynamic>
          ? ParticipantProfile.fromJson(
              json['profile_snapshot'] as Map<String, dynamic>,
            )
          : null,
      paymentSubmission: json['payment_submission'] is Map<String, dynamic>
          ? PaymentSubmission.fromJson(
              json['payment_submission'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
