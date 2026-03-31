const String defaultLocaleCode = 'zh-Hant';
const String englishLocaleCode = 'en';

final Map<String, Map<String, String>> localeCatalog = {
  'zh-Hant': {
    'Soulo Play Portal': 'Soulo Play 入口',
    'Please log in first': '請先登入',
    'Profile': '個人資料',
    'Settings': '設定',
    'Logout': '登出',
    'Google Sign-In': 'Google 登入',
    'Login Guide': '登入說明',
    'Google sign-in uses a secure session cookie to keep you logged in.':
        'Google 登入後會使用安全 Cookie 維持 session。',
    'Secure session restored automatically when available.':
        '若瀏覽器仍有有效 session，會自動還原登入狀態。',
    'Current session is verified through /api/me.':
        '目前 session 會透過 /api/me 驗證。',
    'A Google Web Client ID is required before sign-in can work.':
        '要啟用 Google 登入，必須先設定 Google Web Client ID。',
    'Set GOOGLE_WEB_CLIENT_ID via --dart-define before building or running.':
        '請在 build 或 run 時用 --dart-define 設定 GOOGLE_WEB_CLIENT_ID。',
    'Continue with Google': '使用 Google 繼續',
    'Google sign-in initialization failed': 'Google 登入初始化失敗',
    'Google sign-in is currently unavailable': 'Google 登入目前無法使用',
    'Google sign-in did not return a usable credential':
        'Google 登入沒有回傳可用的憑證',
    'Google sign-in error': 'Google 登入錯誤',
    'Google sign-in is currently available on web only':
        'Google 登入目前只支援網頁版',
    'Welcome back': '歡迎回來',
    'Manage your account, preferences, and future social systems from one portal.':
        '在同一個 portal 裡管理帳號、偏好設定，以及之後要擴充的社交系統。',
    'Open profile': '打開個人資料',
    'Open settings': '打開設定',
    'Signed in as': '目前登入帳號',
    'Role': '角色',
    'Email': 'Email',
    'Display Settings': '顯示設定',
    'Theme Mode': '主題模式',
    'Follow System': '跟隨系統',
    'Light': '亮色',
    'Dark': '深色',
    'Language': '語言',
    'Traditional Chinese': '繁體中文',
    'English': '英文',
    'Japanese': '日文',
    'Font Size': '字體大小',
    'Account Profile': '帳號資料',
    'Display name': '顯示名稱',
    'Bio': '自我介紹',
    'Avatar source': '頭像來源',
    'Google avatar': 'Google 頭像',
    'Custom image URL': '自訂圖片網址',
    'Uploaded image': '上傳圖片',
    'Pick image': '選擇圖片',
    'Upload image': '上傳圖片',
    'Remove uploaded image': '刪除已上傳圖片',
    'Save profile': '儲存個人資料',
    'Profile updated': '個人資料已更新',
    'Avatar image uploaded successfully': '頭像圖片上傳成功',
    'This account does not have an available Google avatar.':
        '這個帳號目前沒有可用的 Google 頭像。',
    'Please upload an avatar image first': '請先上傳頭像圖片',
    'Selected file has no readable bytes': '選到的檔案沒有可讀取內容',
    'Selected image is unsupported': '選到的圖片格式不支援',
    'Image must be 1 MB or smaller': '圖片大小必須小於 1 MB',
    'Use your Google sign-in avatar. It will sync again the next time you sign in.':
        '使用 Google 登入頭像，下次登入時會再次同步。',
    'Use your custom image URL. Future Google sign-ins will not overwrite it.':
        '使用自訂圖片網址，之後 Google 登入也不會覆蓋它。',
    'Use an uploaded image stored in Soulo Play. You can pick a file from your device and future Google sign-ins will not overwrite it.':
        '使用上傳到 Soulo Play 的圖片，可以從裝置選圖，之後 Google 登入也不會覆蓋它。',
    'Current avatar preview': '目前頭像預覽',
    'Your account email cannot be changed here.': '帳號 Email 目前不能在這裡修改。',
    'Profile and settings': '個人資料與設定',
    'Back to home': '回到首頁',
    'Name is required': '名稱不能為空',
    'Custom avatar URL': '自訂頭像網址',
    'Selected image ready': '圖片已選取，等待上傳',
    'No uploaded image stored yet': '目前還沒有上傳頭像',
    'No custom avatar URL set': '尚未設定自訂頭像網址',
    'Portal Home': '入口首頁',
    'Session status': 'Session 狀態',
    'Account': '帳號',
    'Preferences': '偏好設定',
  },
  'en': {
    'Soulo Play Portal': 'Soulo Play Portal',
    'Please log in first': 'Please log in first',
    'Profile': 'Profile',
    'Settings': 'Settings',
    'Logout': 'Logout',
    'Google Sign-In': 'Google Sign-In',
    'Login Guide': 'Login Guide',
    'Google sign-in uses a secure session cookie to keep you logged in.':
        'Google sign-in uses a secure session cookie to keep you logged in.',
    'Secure session restored automatically when available.':
        'Secure session restored automatically when available.',
    'Current session is verified through /api/me.':
        'Current session is verified through /api/me.',
    'A Google Web Client ID is required before sign-in can work.':
        'A Google Web Client ID is required before sign-in can work.',
    'Set GOOGLE_WEB_CLIENT_ID via --dart-define before building or running.':
        'Set GOOGLE_WEB_CLIENT_ID via --dart-define before building or running.',
    'Continue with Google': 'Continue with Google',
    'Google sign-in initialization failed':
        'Google sign-in initialization failed',
    'Google sign-in is currently unavailable':
        'Google sign-in is currently unavailable',
    'Google sign-in did not return a usable credential':
        'Google sign-in did not return a usable credential',
    'Google sign-in error': 'Google sign-in error',
    'Google sign-in is currently available on web only':
        'Google sign-in is currently available on web only',
    'Welcome back': 'Welcome back',
    'Manage your account, preferences, and future social systems from one portal.':
        'Manage your account, preferences, and future social systems from one portal.',
    'Open profile': 'Open profile',
    'Open settings': 'Open settings',
    'Signed in as': 'Signed in as',
    'Role': 'Role',
    'Email': 'Email',
    'Display Settings': 'Display Settings',
    'Theme Mode': 'Theme Mode',
    'Follow System': 'Follow System',
    'Light': 'Light',
    'Dark': 'Dark',
    'Language': 'Language',
    'Traditional Chinese': 'Traditional Chinese',
    'English': 'English',
    'Japanese': 'Japanese',
    'Font Size': 'Font Size',
    'Account Profile': 'Account Profile',
    'Display name': 'Display name',
    'Bio': 'Bio',
    'Avatar source': 'Avatar source',
    'Google avatar': 'Google avatar',
    'Custom image URL': 'Custom image URL',
    'Uploaded image': 'Uploaded image',
    'Pick image': 'Pick image',
    'Upload image': 'Upload image',
    'Remove uploaded image': 'Remove uploaded image',
    'Save profile': 'Save profile',
    'Profile updated': 'Profile updated',
    'Avatar image uploaded successfully':
        'Avatar image uploaded successfully',
    'This account does not have an available Google avatar.':
        'This account does not have an available Google avatar.',
    'Please upload an avatar image first':
        'Please upload an avatar image first',
    'Selected file has no readable bytes':
        'Selected file has no readable bytes',
    'Selected image is unsupported': 'Selected image is unsupported',
    'Image must be 1 MB or smaller': 'Image must be 1 MB or smaller',
    'Use your Google sign-in avatar. It will sync again the next time you sign in.':
        'Use your Google sign-in avatar. It will sync again the next time you sign in.',
    'Use your custom image URL. Future Google sign-ins will not overwrite it.':
        'Use your custom image URL. Future Google sign-ins will not overwrite it.',
    'Use an uploaded image stored in Soulo Play. You can pick a file from your device and future Google sign-ins will not overwrite it.':
        'Use an uploaded image stored in Soulo Play. You can pick a file from your device and future Google sign-ins will not overwrite it.',
    'Current avatar preview': 'Current avatar preview',
    'Your account email cannot be changed here.':
        'Your account email cannot be changed here.',
    'Profile and settings': 'Profile and settings',
    'Back to home': 'Back to home',
    'Name is required': 'Name is required',
    'Custom avatar URL': 'Custom avatar URL',
    'Selected image ready': 'Selected image ready',
    'No uploaded image stored yet': 'No uploaded image stored yet',
    'No custom avatar URL set': 'No custom avatar URL set',
    'Portal Home': 'Portal Home',
    'Session status': 'Session status',
    'Account': 'Account',
    'Preferences': 'Preferences',
  },
  'ja': {
    'Soulo Play Portal': 'Soulo Play Portal',
    'Please log in first': 'Please log in first',
    'Profile': 'Profile',
    'Settings': 'Settings',
    'Logout': 'Logout',
    'Google Sign-In': 'Google Sign-In',
    'Login Guide': 'Login Guide',
    'Google sign-in uses a secure session cookie to keep you logged in.':
        'Google sign-in uses a secure session cookie to keep you logged in.',
    'Secure session restored automatically when available.':
        'Secure session restored automatically when available.',
    'Current session is verified through /api/me.':
        'Current session is verified through /api/me.',
    'A Google Web Client ID is required before sign-in can work.':
        'A Google Web Client ID is required before sign-in can work.',
    'Set GOOGLE_WEB_CLIENT_ID via --dart-define before building or running.':
        'Set GOOGLE_WEB_CLIENT_ID via --dart-define before building or running.',
    'Continue with Google': 'Continue with Google',
    'Google sign-in initialization failed':
        'Google sign-in initialization failed',
    'Google sign-in is currently unavailable':
        'Google sign-in is currently unavailable',
    'Google sign-in did not return a usable credential':
        'Google sign-in did not return a usable credential',
    'Google sign-in error': 'Google sign-in error',
    'Google sign-in is currently available on web only':
        'Google sign-in is currently available on web only',
    'Welcome back': 'Welcome back',
    'Manage your account, preferences, and future social systems from one portal.':
        'Manage your account, preferences, and future social systems from one portal.',
    'Open profile': 'Open profile',
    'Open settings': 'Open settings',
    'Signed in as': 'Signed in as',
    'Role': 'Role',
    'Email': 'Email',
    'Display Settings': 'Display Settings',
    'Theme Mode': 'Theme Mode',
    'Follow System': 'Follow System',
    'Light': 'Light',
    'Dark': 'Dark',
    'Language': 'Language',
    'Traditional Chinese': 'Traditional Chinese',
    'English': 'English',
    'Japanese': 'Japanese',
    'Font Size': 'Font Size',
    'Account Profile': 'Account Profile',
    'Display name': 'Display name',
    'Bio': 'Bio',
    'Avatar source': 'Avatar source',
    'Google avatar': 'Google avatar',
    'Custom image URL': 'Custom image URL',
    'Uploaded image': 'Uploaded image',
    'Pick image': 'Pick image',
    'Upload image': 'Upload image',
    'Remove uploaded image': 'Remove uploaded image',
    'Save profile': 'Save profile',
    'Profile updated': 'Profile updated',
    'Avatar image uploaded successfully':
        'Avatar image uploaded successfully',
    'This account does not have an available Google avatar.':
        'This account does not have an available Google avatar.',
    'Please upload an avatar image first':
        'Please upload an avatar image first',
    'Selected file has no readable bytes':
        'Selected file has no readable bytes',
    'Selected image is unsupported': 'Selected image is unsupported',
    'Image must be 1 MB or smaller': 'Image must be 1 MB or smaller',
    'Use your Google sign-in avatar. It will sync again the next time you sign in.':
        'Use your Google sign-in avatar. It will sync again the next time you sign in.',
    'Use your custom image URL. Future Google sign-ins will not overwrite it.':
        'Use your custom image URL. Future Google sign-ins will not overwrite it.',
    'Use an uploaded image stored in Soulo Play. You can pick a file from your device and future Google sign-ins will not overwrite it.':
        'Use an uploaded image stored in Soulo Play. You can pick a file from your device and future Google sign-ins will not overwrite it.',
    'Current avatar preview': 'Current avatar preview',
    'Your account email cannot be changed here.':
        'Your account email cannot be changed here.',
    'Profile and settings': 'Profile and settings',
    'Back to home': 'Back to home',
    'Name is required': 'Name is required',
    'Custom avatar URL': 'Custom avatar URL',
    'Selected image ready': 'Selected image ready',
    'No uploaded image stored yet': 'No uploaded image stored yet',
    'No custom avatar URL set': 'No custom avatar URL set',
    'Portal Home': 'Portal Home',
    'Session status': 'Session status',
    'Account': 'Account',
    'Preferences': 'Preferences',
  },
};

Map<String, String> translationForLocale(String locale) {
  return localeCatalog[locale] ?? localeCatalog[defaultLocaleCode]!;
}
