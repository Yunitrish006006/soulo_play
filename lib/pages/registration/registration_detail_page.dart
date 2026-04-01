import 'package:flutter/material.dart';

import '../../models/registration.dart';
import '../../services/api_client.dart';
import '../../services/registration_service.dart';
import '../../utils/snackbar.dart';

class RegistrationDetailPage extends StatefulWidget {
  const RegistrationDetailPage({super.key, required this.registrationId});

  final int registrationId;

  @override
  State<RegistrationDetailPage> createState() => _RegistrationDetailPageState();
}

class _RegistrationDetailPageState extends State<RegistrationDetailPage> {
  late final RegistrationService _service;
  final _formKey = GlobalKey<FormState>();
  final _payerNameController = TextEditingController();
  final _bankLast5Controller = TextEditingController();
  final _submittedAmountController = TextEditingController();

  bool _isLoading = true;
  bool _isSubmitting = false;
  EventRegistration? _registration;

  @override
  void initState() {
    super.initState();
    _service = RegistrationService(ApiClient());
    _load();
  }

  @override
  void dispose() {
    _payerNameController.dispose();
    _bankLast5Controller.dispose();
    _submittedAmountController.dispose();
    super.dispose();
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'submitted':
        return '審核中';
      case 'payment_pending':
        return '等待付款';
      case 'payment_submitted':
        return '已送出匯款資訊';
      case 'paid':
        return '報名完成';
      case 'rejected':
        return '未通過';
      default:
        return status;
    }
  }

  Future<void> _load() async {
    try {
      final registration = await _service.fetchRegistration(
        widget.registrationId,
      );
      if (!mounted) {
        return;
      }
      _registration = registration;
      _payerNameController.text =
          registration.profileSnapshot?.legalName ?? _payerNameController.text;
      _submittedAmountController.text =
          registration.amountDue?.toString() ?? _submittedAmountController.text;
      setState(() {});
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, e.message);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitPayment() async {
    final registration = _registration;
    if (registration == null) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _service.submitPayment(
        registrationId: registration.id,
        payerName: _payerNameController.text.trim(),
        bankLast5: _bankLast5Controller.text.trim(),
        submittedAmount: int.parse(_submittedAmountController.text.trim()),
      );
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, '匯款資訊已送出，等待核帳');
      await _load();
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, e.message);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final registration = _registration;
    if (registration == null) {
      return const Scaffold(body: Center(child: Text('查無報名資料')));
    }

    final snapshot = registration.profileSnapshot;
    final payment = registration.paymentSubmission;

    return Scaffold(
      appBar: AppBar(title: const Text('報名詳情')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          registration.event.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(_statusLabel(registration.status)),
                        const SizedBox(height: 12),
                        Text('方案：${registration.plan.label}'),
                        Text('人數：${registration.groupSize} 人'),
                        Text('交通方式：${registration.arrivalMode}'),
                        if (registration.reviewNote != null &&
                            registration.reviewNote!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('備註：${registration.reviewNote}'),
                        ],
                        if (registration.amountDue != null) ...[
                          const SizedBox(height: 8),
                          Text('應付金額：\$${registration.amountDue}'),
                        ],
                        if (registration.paymentDueAt != null) ...[
                          const SizedBox(height: 8),
                          Text('付款期限：${registration.paymentDueAt}'),
                        ],
                      ],
                    ),
                  ),
                ),
                if (snapshot != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '報名快照資料',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 12),
                          Text('姓名：${snapshot.legalName}'),
                          Text('手機：${snapshot.phone}'),
                          Text('IG：${snapshot.igHandle}'),
                          Text('LINE：${snapshot.lineId}'),
                          Text('飲食：${snapshot.dietType}'),
                        ],
                      ),
                    ),
                  ),
                ],
                if (registration.members.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '團報成員',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 12),
                          for (final member in registration.members)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text('• ${member.memberName}'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (registration.paymentInstructions != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '匯款資訊',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '銀行代碼：${registration.paymentInstructions!.bankCode}',
                          ),
                          Text(
                            '銀行帳號：${registration.paymentInstructions!.bankAccount}',
                          ),
                          if (registration.amountDue != null)
                            Text('匯款金額：\$${registration.amountDue}'),
                        ],
                      ),
                    ),
                  ),
                ],
                if (registration.status == 'payment_pending') ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '提交匯款資訊',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _payerNameController,
                              decoration: const InputDecoration(
                                labelText: '匯款人姓名',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if ((value ?? '').trim().isEmpty) {
                                  return '請填寫匯款人姓名';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _bankLast5Controller,
                              decoration: const InputDecoration(
                                labelText: '匯款帳號末五碼',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                final text = (value ?? '').trim();
                                if (!RegExp(r'^\d{5}$').hasMatch(text)) {
                                  return '請填寫 5 碼數字';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _submittedAmountController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: '本次匯款金額',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if ((value ?? '').trim().isEmpty) {
                                  return '缺少金額';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FilledButton.icon(
                                onPressed: _isSubmitting
                                    ? null
                                    : _submitPayment,
                                icon: _isSubmitting
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.payments_outlined),
                                label: Text(
                                  _isSubmitting ? '送出中...' : '送出匯款資訊',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                if (payment != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '最新匯款提交',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 12),
                          Text('匯款人：${payment.payerName}'),
                          Text('末五碼：${payment.bankLast5}'),
                          Text('金額：\$${payment.submittedAmount}'),
                          Text('狀態：${payment.status}'),
                          if (payment.adminNote != null &&
                              payment.adminNote!.isNotEmpty)
                            Text('核帳備註：${payment.adminNote}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
