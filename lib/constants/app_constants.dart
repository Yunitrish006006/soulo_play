class AppConstants {
  static const String appName = 'Soulo Play Portal';

  // Same-origin by default so the Worker can host both frontend and API.
  // Override during separate local frontend dev if needed:
  // flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8787
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  // Required for Google sign-in on web.
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '405845862030-fobmh27c757hvn9tf5ujj0d36ffpth1f.apps.googleusercontent.com',
  );
}
