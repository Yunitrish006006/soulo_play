import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/settings.dart';
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsModel()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: Consumer<SettingsModel>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Soulo Play',
            theme: ThemeData(
              brightness: settings.isDark ? Brightness.dark : Brightness.light,
              textTheme: Theme.of(context).textTheme.apply(
                    fontSizeFactor: settings.fontScale,
                  ),
            ),
            initialRoute: '/',
            routes: {
              '/': (_) => const LoginPage(),
              '/home': (_) => const HomePage(),
              '/settings': (_) => const SettingsPage(),
            },
          );
        },
      ),
    );
  }
}
