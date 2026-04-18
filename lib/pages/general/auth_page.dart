import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/web_only.dart' as google_web;
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../services/api_client.dart';
import '../../services/auth_service.dart';
import 'package:user_ui_settings/user_ui_settings.dart';
import '../../widgets/soulo_wordmark.dart';
import '../../utils/snackbar.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  StreamSubscription<GoogleSignInAuthenticationEvent>? _googleAuthSubscription;
  bool _isGoogleReady = !kIsWeb;
  bool _isGoogleSigningIn = false;
  String? _googleErrorMessage;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      unawaited(_initializeGoogleSignIn());
    }
  }

  @override
  void dispose() {
    _googleAuthSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeGoogleSignIn() async {
    final t = context.read<LocaleProvider>().translation;

    if (AppConstants.googleWebClientId.isEmpty) {
      setState(() {
        _isGoogleReady = false;
        _googleErrorMessage =
            '${t.text('A Google Web Client ID is required before sign-in can work.')}\n'
            '${t.text('Set GOOGLE_WEB_CLIENT_ID via --dart-define before building or running.')}';
      });
      return;
    }

    try {
      await _googleSignIn.initialize(clientId: AppConstants.googleWebClientId);

      _googleAuthSubscription = _googleSignIn.authenticationEvents.listen((
        event,
      ) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          unawaited(_handleGoogleAuthentication(event.user));
        }
      }, onError: _handleGoogleAuthenticationError);

      if (!mounted) {
        return;
      }
      setState(() {
        _isGoogleReady = true;
        _googleErrorMessage = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isGoogleReady = false;
        _googleErrorMessage =
            '${t.text('Google sign-in initialization failed')}: $e';
      });
    }
  }

  void _handleGoogleAuthenticationError(Object error) {
    final t = context.read<LocaleProvider>().translation;
    if (!mounted) {
      return;
    }
    setState(() {
      _isGoogleSigningIn = false;
    });
    showAppSnackBar(context, '${t.text('Google sign-in error')}: $error');
  }

  Future<void> _handleGoogleAuthentication(GoogleSignInAccount user) async {
    if (_isGoogleSigningIn || !mounted) {
      return;
    }

    final t = context.read<LocaleProvider>().translation;
    final auth = context.read<AuthService>();

    setState(() {
      _isGoogleSigningIn = true;
    });

    try {
      final idToken = user.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        showAppSnackBar(
          context,
          t.text('Google sign-in did not return a usable credential'),
        );
        return;
      }

      await auth.verifyGoogleToken(idToken);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed('/home');
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, e.message);
    } catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, '${t.text('Google sign-in error')}: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleSigningIn = false;
        });
      }
    }
  }

  Widget _buildGoogleButton(
    ThemeData theme,
    Map<String, String> t,
    double frameWidth,
  ) {
    if (!kIsWeb) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.desktop_windows_outlined),
          label: Text(
            t.text('Google sign-in is currently available on web only'),
          ),
        ),
      );
    }

    if (_googleErrorMessage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.error_outline),
              label: Text(t.text('Google sign-in is currently unavailable')),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(_googleErrorMessage!),
          ),
        ],
      );
    }

    if (!_isGoogleReady) {
      return const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return IgnorePointer(
      ignoring: _isGoogleSigningIn,
      child: Opacity(
        opacity: _isGoogleSigningIn ? 0.7 : 1,
        child: SizedBox(
          height: 56,
          child: Center(
            child: google_web.renderButton(
              configuration: google_web.GSIButtonConfiguration(
                theme: google_web.GSIButtonTheme.outline,
                text: google_web.GSIButtonText.signinWith,
                size: google_web.GSIButtonSize.large,
                shape: google_web.GSIButtonShape.rectangular,
                minimumWidth: frameWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LocaleProvider>().translation;
    final theme = Theme.of(context);
    final frameWidth = MediaQuery.sizeOf(context).width < 480 ? 280.0 : 360.0;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer.withOpacity(0.92),
              theme.colorScheme.surface,
              theme.colorScheme.secondaryContainer.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SouloWordmark(wordHeight: 44),
                    const SizedBox(height: 12),
                    Text(
                      t.text('Soulo Play Portal'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.text(
                        'Manage your account, preferences, and future social systems from one portal.',
                      ),
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.text('Login Guide'),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t.text(
                              'Google sign-in uses a secure session cookie to keep you logged in.',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t.text(
                              'Secure session restored automatically when available.',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t.text(
                              'Current session is verified through /api/me.',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildGoogleButton(theme, t, frameWidth),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
