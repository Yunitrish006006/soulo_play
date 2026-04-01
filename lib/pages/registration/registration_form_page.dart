import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../models/event_plan.dart';
import '../../models/participant_profile.dart';
import '../../services/api_client.dart';
import '../../services/event_service.dart';
import '../../services/participant_profile_service.dart';
import '../../services/registration_service.dart';
import '../../utils/snackbar.dart';
import 'participant_profile_page.dart';
import 'registration_detail_page.dart';

class RegistrationFormPage extends StatefulWidget {
  const RegistrationFormPage({super.key, required this.eventId});

  final int eventId;

  @override
  State<RegistrationFormPage> createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final EventService _eventService;
  late final ParticipantProfileService _profileService;
  late final RegistrationService _registrationService;

  bool _isLoading = true;
  bool _isSubmitting = false;
  PortalEvent? _event;
  List<EventPlan> _plans = const [];
  ParticipantProfile? _profile;
  EventPlan? _selectedPlan;
  int _groupSize = 1;
  String _arrivalMode = '自行開車';
  final List<TextEditingController> _memberControllers = [];

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient();
    _eventService = EventService(apiClient);
    _profileService = ParticipantProfileService(apiClient);
    _registrationService = RegistrationService(apiClient);
    _load();
  }

  @override
  void dispose() {
    for (final controller in _memberControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final details = await _eventService.fetchEventDetails(widget.eventId);
      final profile = await _profileService.fetchProfile();
      if (!mounted) {
        return;
      }
      _event = details.event;
      _plans = details.plans;
      _selectedPlan = _plans.isNotEmpty ? _plans.first : null;
      _groupSize = _selectedPlan?.minPeople ?? 1;
      _profile = profile;
      _syncMemberControllers();
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

  void _syncMemberControllers() {
    final expected = (_groupSize - 1).clamp(0, 10);
    while (_memberControllers.length < expected) {
      _memberControllers.add(TextEditingController());
    }
    while (_memberControllers.length > expected) {
      _memberControllers.removeLast().dispose();
    }
  }

  String _stripHtml(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return value.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll('&nbsp;', ' ');
  }

  Future<void> _openParticipantProfile() async {
    final saved = await Navigator.of(context).push<ParticipantProfile>(
      MaterialPageRoute<ParticipantProfile>(
        builder: (_) => const ParticipantProfilePage(),
      ),
    );

    if (!mounted) {
      return;
    }
    if (saved != null) {
      setState(() {
        _profile = saved;
      });
      showAppSnackBar(context, '已更新報名主檔資料');
    } else {
      await _load();
    }
  }

  int _calculateTotal() {
    final plan = _selectedPlan;
    if (plan == null) {
      return 0;
    }
    final shuttleRequired = _arrivalMode == '主辦方協助包車接送';
    return (plan.pricePerPerson * _groupSize) +
        (shuttleRequired ? plan.shuttlePricePerPerson * _groupSize : 0);
  }

  Future<void> _submit() async {
    if (_profile == null) {
      showAppSnackBar(context, '請先建立報名主檔資料');
      return;
    }
    if (_selectedPlan == null) {
      showAppSnackBar(context, '目前沒有可用方案');
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final registration = await _registrationService.createRegistration(
        eventId: widget.eventId,
        planId: _selectedPlan!.id,
        groupSize: _groupSize,
        arrivalMode: _arrivalMode,
        shuttleRequired: _arrivalMode == '主辦方協助包車接送',
        memberNames: _memberControllers
            .map((controller) => controller.text.trim())
            .where((name) => name.isNotEmpty)
            .toList(),
        participantProfile: _profile!,
      );
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, '報名送出成功，等待審核');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) =>
              RegistrationDetailPage(registrationId: registration.id),
        ),
      );
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

  List<DropdownMenuItem<int>> _groupSizeItems(EventPlan plan) {
    return List<DropdownMenuItem<int>>.generate(
      plan.maxPeople - plan.minPeople + 1,
      (index) {
        final value = plan.minPeople + index;
        return DropdownMenuItem<int>(value: value, child: Text('$value 人'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final event = _event;
    final selectedPlan = _selectedPlan;
    if (event == null) {
      return const Scaffold(body: Center(child: Text('讀取活動失敗')));
    }

    final intro = _stripHtml(event.introHtml).trim();
    final rules = _stripHtml(event.rulesHtml).trim();
    final refund = _stripHtml(event.refundPolicyHtml).trim();

    return Scaffold(
      appBar: AppBar(title: const Text('填寫活動報名')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Form(
              key: _formKey,
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
                            event.title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          Text('${event.startDate} - ${event.endDate}'),
                          if (intro.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(intro),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '重複性資料主檔',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const Spacer(),
                              OutlinedButton.icon(
                                onPressed: _openParticipantProfile,
                                icon: const Icon(Icons.edit_outlined),
                                label: Text(
                                  _profile == null ? '先建立主檔' : '編輯主檔',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (_profile == null)
                            const Text('尚未建立報名主檔資料，請先完成後再送出報名。')
                          else
                            Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              children: [
                                _SummaryChip(
                                  label: '姓名',
                                  value: _profile!.legalName,
                                ),
                                _SummaryChip(
                                  label: '手機',
                                  value: _profile!.phone,
                                ),
                                _SummaryChip(
                                  label: 'IG',
                                  value: _profile!.igHandle,
                                ),
                                _SummaryChip(
                                  label: 'LINE',
                                  value: _profile!.lineId,
                                ),
                                _SummaryChip(
                                  label: '飲食',
                                  value: _profile!.dietType,
                                ),
                                _SummaryChip(
                                  label: '緊急聯絡人',
                                  value:
                                      '${_profile!.emergencyName} / ${_profile!.emergencyPhone}',
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '活動專屬資料',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<EventPlan>(
                            initialValue: selectedPlan,
                            decoration: const InputDecoration(
                              labelText: '報名方案',
                              border: OutlineInputBorder(),
                            ),
                            items: _plans
                                .map(
                                  (plan) => DropdownMenuItem<EventPlan>(
                                    value: plan,
                                    child: Text(
                                      '${plan.label} / \$${plan.pricePerPerson} 每人',
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedPlan = value;
                                _groupSize = value.minPeople;
                                _syncMemberControllers();
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          if (selectedPlan != null)
                            DropdownButtonFormField<int>(
                              initialValue: _groupSize,
                              decoration: const InputDecoration(
                                labelText: '報名人數',
                                border: OutlineInputBorder(),
                              ),
                              items: _groupSizeItems(selectedPlan),
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _groupSize = value;
                                  _syncMemberControllers();
                                });
                              },
                            ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _arrivalMode,
                            decoration: const InputDecoration(
                              labelText: '如何前往活動場地',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: '自行開車',
                                child: Text('自行開車'),
                              ),
                              DropdownMenuItem(
                                value: '自行騎車',
                                child: Text('自行騎車'),
                              ),
                              DropdownMenuItem(
                                value: '主辦方協助包車接送',
                                child: Text('主辦方協助包車接送'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _arrivalMode = value ?? _arrivalMode;
                              });
                            },
                          ),
                          if (_memberControllers.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Text(
                              '團報成員姓名',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            for (
                              var index = 0;
                              index < _memberControllers.length;
                              index += 1
                            ) ...[
                              TextFormField(
                                controller: _memberControllers[index],
                                decoration: InputDecoration(
                                  labelText: '團員 ${index + 1}',
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if ((value ?? '').trim().isEmpty) {
                                    return '請填寫團員姓名';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '預估總額：\$${_calculateTotal()}',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _arrivalMode == '主辦方協助包車接送'
                                      ? '包含接駁費，實際匯款資訊會在審核通過後顯示。'
                                      : '不含接駁費，實際匯款資訊會在審核通過後顯示。',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (rules.isNotEmpty || refund.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '活動規則與退費說明',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            if (rules.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(rules),
                            ],
                            if (refund.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(refund),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: _isSubmitting ? null : _submit,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_outlined),
                      label: Text(_isSubmitting ? '送出中...' : '送出報名'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
