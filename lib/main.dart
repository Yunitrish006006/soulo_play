import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/app_constants.dart';
import 'pages/general/auth_page.dart';
import 'pages/general/splash_page.dart';
import 'pages/home/home_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/settings/settings_page.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'services/locale_provider.dart';
import 'services/theme_provider.dart';
import 'services/ui_settings_provider.dart';

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
            provider.syncFromUser(auth.user);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthService, UiSettingsProvider>(
          create: (_) => UiSettingsProvider(),
          update: (_, auth, uiSettingsProvider) {
            final provider = uiSettingsProvider ?? UiSettingsProvider();
            provider.syncFromUser(auth.user);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthService, LocaleProvider>(
          create: (_) => LocaleProvider(),
          update: (_, auth, localeProvider) {
            final provider = localeProvider ?? LocaleProvider();
            provider.syncFromUser(auth.user);
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
            '/settings': (_) => const SettingsPage(),
          },
        );
      },
    );
  }
}
