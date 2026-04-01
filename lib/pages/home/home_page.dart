import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../services/locale_provider.dart';
import '../../widgets/soulo_wordmark.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().user;
    final t = context.watch<LocaleProvider>().translation;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/login'),
            child: Text(t.text('Please log in first')),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Soulo Play'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthService>().logout();
              if (!context.mounted) {
                return;
              }
              Navigator.of(context).pushReplacementNamed('/login');
            },
            icon: const Icon(Icons.logout),
            tooltip: t.text('Logout'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 8),
              const _BrandHero(),
              const SizedBox(height: 28),
              _ActionCard(
                title: '個人資料填寫',
                subtitle: '建立或更新主檔資料',
                icon: Icons.badge_outlined,
                onTap: () =>
                    Navigator.of(context).pushNamed('/participant-profile'),
              ),
              const SizedBox(height: 16),
              _ActionCard(
                title: '活動報名頁面',
                subtitle: '查看活動並開始報名',
                icon: Icons.event_available_outlined,
                onTap: () => Navigator.of(context).pushNamed('/events'),
              ),
              const SizedBox(height: 16),
              _ActionCard(
                title: '我的報名',
                subtitle: '查看審核與付款狀態',
                icon: Icons.receipt_long_outlined,
                onTap: () =>
                    Navigator.of(context).pushNamed('/my-registrations'),
              ),
              const SizedBox(height: 16),
              _ActionCard(
                title: '偏好設定',
                subtitle: '調整介面與系統偏好',
                icon: Icons.tune,
                onTap: () => Navigator.of(context).pushNamed('/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandHero extends StatelessWidget {
  const _BrandHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0C8A83), Color(0xFF0A615C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(12, 138, 131, 0.22),
                blurRadius: 30,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: const Center(
            child: SouloWordmark(
              lightVariant: true,
              wordHeight: 38,
              gap: 10,
              alignment: CrossAxisAlignment.center,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Soulo Play',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
