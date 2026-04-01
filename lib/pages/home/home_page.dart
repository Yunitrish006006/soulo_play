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

    final theme = Theme.of(context);
    final wordmarkHeight = MediaQuery.sizeOf(context).width < 560 ? 50.0 : 70.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.text('Portal Home')),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
            icon: const Icon(Icons.person_outline),
            tooltip: t.text('Profile'),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
            icon: const Icon(Icons.tune),
            tooltip: t.text('Settings'),
          ),
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
          constraints: const BoxConstraints(maxWidth: 840),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF0C8A83), const Color(0xFF0A615C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(12, 138, 131, 0.18),
                      blurRadius: 30,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SouloWordmark(
                      lightVariant: true,
                      wordHeight: wordmarkHeight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t.text('Welcome back'),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.name,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t.text(
                        'Manage your account, preferences, and future social systems from one portal.',
                      ),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color.fromRGBO(255, 255, 255, 0.88),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _InfoCard(
                    title: t.text('Account'),
                    lines: [
                      '${t.text('Signed in as')}: ${user.email}',
                      '${t.text('Role')}: ${user.role}',
                    ],
                    icon: Icons.badge_outlined,
                  ),
                  _InfoCard(
                    title: t.text('Session status'),
                    lines: const [
                      'Google session cookie active',
                      '/api/me ready',
                    ],
                    icon: Icons.verified_user_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final twoColumns = width >= 640;
                  final cardWidth = twoColumns ? (width - 16) / 2 : width;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: _ActionCard(
                          title: '活動報名',
                          subtitle: '查看目前開放活動',
                          icon: Icons.event_available_outlined,
                          onTap: () =>
                              Navigator.of(context).pushNamed('/events'),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _ActionCard(
                          title: '我的報名',
                          subtitle: '查看審核與付款狀態',
                          icon: Icons.receipt_long_outlined,
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed('/my-registrations'),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _ActionCard(
                          title: t.text('Profile'),
                          subtitle: t.text('Open profile'),
                          icon: Icons.person_outline,
                          onTap: () =>
                              Navigator.of(context).pushNamed('/profile'),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _ActionCard(
                          title: t.text('Preferences'),
                          subtitle: t.text('Open settings'),
                          icon: Icons.tune,
                          onTap: () =>
                              Navigator.of(context).pushNamed('/settings'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.lines,
    required this.icon,
  });

  final String title;
  final List<String> lines;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 320,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final line in lines) ...[
                Text(line),
                if (line != lines.last) const SizedBox(height: 6),
              ],
            ],
          ),
        ),
      ),
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
