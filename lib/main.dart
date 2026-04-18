import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/app_constants.dart';
import 'pages/general/auth_page.dart';
import 'pages/general/splash_page.dart';
import 'pages/home/home_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/registration/events_page.dart';
import 'pages/registration/my_registrations_page.dart';
import 'pages/registration/participant_profile_page.dart';
import 'pages/settings/settings_page.dart';
import 'package:user_ui_settings/user_ui_settings.dart';

import 'constants/locale_catalog.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';

void main() {
  final apiClient = ApiClient();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService(apiClient)),
        ChangeNotifierProxyProvider<AuthService, ThemeProvider>(
          create: (_) => ThemeProvider(),
          update: (_, auth, themeProvider) {
            final provider = themeProvider ?? ThemeProvider();
            provider.syncForUser(
              auth.user?.id,
              themeMode: auth.user?.themeMode,
            );
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthService, UiSettingsProvider>(
          create: (_) => UiSettingsProvider(),
          update: (_, auth, uiSettingsProvider) {
            final provider = uiSettingsProvider ?? UiSettingsProvider();
            provider.syncForUser(
              auth.user?.id,
              fontScale: auth.user?.fontSizeScale,
            );
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthService, LocaleProvider>(
          create: (_) => LocaleProvider(
            defaultLocale: defaultLocaleCode,
            translationResolver: translationForLocale,
          ),
          update: (_, auth, localeProvider) {
            final provider =
                localeProvider ??
                LocaleProvider(
                  defaultLocale: defaultLocaleCode,
                  translationResolver: translationForLocale,
                );
            provider.syncForUser(auth.user?.id, locale: auth.user?.locale);
            return provider;
          },
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, UiSettingsProvider>(
      builder: (context, themeProvider, uiSettings, child) {
        return MaterialApp(
          title: AppConstants.appName,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0C8A83),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0C8A83),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: themeProvider.themeMode,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(uiSettings.fontScale)),
              child: child!,
            );
          },
          routes: {
            '/': (_) => const SplashPage(),
            '/login': (_) => const AuthPage(),
            '/home': (_) => const HomePage(),
            '/profile': (_) => const ProfilePage(),
            '/participant-profile': (_) => const ParticipantProfilePage(),
            '/events': (_) => const EventsPage(),
            '/my-registrations': (_) => const MyRegistrationsPage(),
            '/settings': (_) => const SettingsPage(),
          },
        );
      },
    );
  }
}
