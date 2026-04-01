class PaymentSubmission {
  const PaymentSubmission({
    required this.id,
    required this.registrationId,
    required this.payerName,
    required this.bankLast5,
    required this.submittedAmount,
    required this.status,
    this.adminNote,
    this.submittedAt,
    this.verifiedAt,
  });

  final int id;
  final int registrationId;
  final String payerName;
  final String bankLast5;
  final int submittedAmount;
  final String status;
  final String? adminNote;
  final String? submittedAt;
  final String? verifiedAt;

  factory PaymentSubmission.fromJson(Map<String, dynamic> json) {
    return PaymentSubmission(
      id: (json['id'] as num?)?.toInt() ?? 0,
      registrationId: (json['registration_id'] as num?)?.toInt() ?? 0,
      payerName: json['payer_name'] as String? ?? '',
      bankLast5: json['bank_last5'] as String? ?? '',
      submittedAmount: (json['submitted_amount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      adminNote: json['admin_note'] as String?,
      submittedAt: json['submitted_at'] as String?,
      verifiedAt: json['verified_at'] as String?,
    );
  }
}
