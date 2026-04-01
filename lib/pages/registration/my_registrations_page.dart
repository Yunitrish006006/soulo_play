import 'package:flutter/material.dart';

import '../../models/registration.dart';
import '../../services/api_client.dart';
import '../../services/registration_service.dart';
import '../../utils/snackbar.dart';
import 'registration_detail_page.dart';

class MyRegistrationsPage extends StatefulWidget {
  const MyRegistrationsPage({super.key});

  @override
  State<MyRegistrationsPage> createState() => _MyRegistrationsPageState();
}

class _MyRegistrationsPageState extends State<MyRegistrationsPage> {
  late final RegistrationService _service;
  bool _isLoading = true;
  List<EventRegistration> _registrations = const [];

  @override
  void initState() {
    super.initState();
    _service = RegistrationService(ApiClient());
    _load();
  }

  Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'payment_pending':
      case 'payment_submitted':
        return Theme.of(context).colorScheme.primary;
      case 'rejected':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
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
        return '已完成';
      case 'rejected':
        return '未通過';
      default:
        return status;
    }
  }

  Future<void> _load() async {
    try {
      final registrations = await _service.fetchMyRegistrations();
      if (!mounted) {
        return;
      }
      setState(() {
        _registrations = registrations;
      });
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('我的報名')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: _registrations.isEmpty
                ? const Center(child: Text('目前還沒有報名紀錄'))
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: _registrations.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final registration = _registrations[index];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(20),
                            title: Text(
                              registration.event.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${registration.event.startDate} - ${registration.event.endDate}',
                                  ),
                                  const SizedBox(height: 6),
                                  Text('方案：${registration.plan.label}'),
                                  const SizedBox(height: 6),
                                  Text('人數：${registration.groupSize} 人'),
                                  if (registration.amountDue != null) ...[
                                    const SizedBox(height: 6),
                                    Text('應付金額：\$${registration.amountDue}'),
                                  ],
                                ],
                              ),
                            ),
                            trailing: Chip(
                              backgroundColor: _statusColor(
                                context,
                                registration.status,
                              ).withValues(alpha: 0.14),
                              label: Text(
                                _statusLabel(registration.status),
                                style: TextStyle(
                                  color: _statusColor(
                                    context,
                                    registration.status,
                                  ),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => RegistrationDetailPage(
                                    registrationId: registration.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
