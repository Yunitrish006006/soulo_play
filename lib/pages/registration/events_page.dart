import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../services/api_client.dart';
import '../../services/event_service.dart';
import '../../utils/snackbar.dart';
import 'registration_form_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late final EventService _service;
  bool _isLoading = true;
  List<PortalEvent> _events = const [];

  @override
  void initState() {
    super.initState();
    _service = EventService(ApiClient());
    _load();
  }

  String _stripHtml(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return value.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll('&nbsp;', ' ');
  }

  Future<void> _load() async {
    try {
      final events = await _service.fetchOpenEvents();
      if (!mounted) {
        return;
      }
      setState(() {
        _events = events;
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
      appBar: AppBar(title: const Text('活動報名')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: _events.isEmpty
                ? const Center(child: Text('目前沒有開放報名的活動'))
                : ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: _events.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      final preview = _stripHtml(event.introHtml).trim();
                      return Card(
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
                              if (preview.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  preview,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: FilledButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => RegistrationFormPage(
                                          eventId: event.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('開始報名'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
