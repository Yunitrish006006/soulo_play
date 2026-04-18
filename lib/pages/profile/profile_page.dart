import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../services/api_client.dart';
import '../../services/auth_service.dart';
import 'package:user_ui_settings/user_ui_settings.dart';
import '../../utils/snackbar.dart';
import '../../widgets/settings_panel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _customAvatarUrlController = TextEditingController();

  String _avatarSource = 'google';
  int? _seededUserId;
  Uint8List? _pendingAvatarBytes;
  String? _pendingAvatarMimeType;
  String? _pendingAvatarFileName;
  bool _isUploadingAvatar = false;
  bool _isRemovingAvatar = false;

  AuthService get _auth => context.read<AuthService>();
  Map<String, String> get _t => context.read<LocaleProvider>().translation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = _auth.user;
    if (user != null && _seededUserId != user.id) {
      _seededUserId = user.id;
      _nameController.text = user.name;
      _bioController.text = user.bio ?? '';
      _customAvatarUrlController.text = user.customAvatarUrl ?? '';
      _avatarSource = ['google', 'custom', 'upload'].contains(user.avatarSource)
          ? user.avatarSource!
          : 'google';
      _clearPendingAvatarSelection();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _customAvatarUrlController.dispose();
    super.dispose();
  }

  void _clearPendingAvatarSelection() {
    _pendingAvatarBytes = null;
    _pendingAvatarMimeType = null;
    _pendingAvatarFileName = null;
  }

  String _previewAvatarUrl(AppUser user) {
    final customAvatarUrl = _customAvatarUrlController.text.trim();
    if (_avatarSource == 'custom') {
      return customAvatarUrl;
    }
    if (_avatarSource == 'upload') {
      return user.uploadedAvatarUrl ?? '';
    }
    return user.googleAvatarUrl ?? '';
  }

  bool _hasUploadedAvatar(AppUser user) {
    return (user.uploadedAvatarUrl ?? '').isNotEmpty;
  }

  bool _canUseGoogleAvatar(AppUser user) {
    return (user.googleAvatarUrl ?? '').isNotEmpty;
  }

  String _avatarSourceDescription() {
    switch (_avatarSource) {
      case 'custom':
        return _t.text(
          'Use your custom image URL. Future Google sign-ins will not overwrite it.',
        );
      case 'upload':
        return _t.text(
          'Use an uploaded image stored in Soulo Play. You can pick a file from your device and future Google sign-ins will not overwrite it.',
        );
      case 'google':
      default:
        return _t.text(
          'Use your Google sign-in avatar. It will sync again the next time you sign in.',
        );
    }
  }

  void _selectAvatarSource(String nextSource, AppUser user) {
    if (nextSource == 'google' && !_canUseGoogleAvatar(user)) {
      showAppSnackBar(
        context,
        _t.text('This account does not have an available Google avatar.'),
      );
      return;
    }
    if (nextSource == 'upload' &&
        _pendingAvatarBytes == null &&
        !_hasUploadedAvatar(user)) {
      showAppSnackBar(context, _t.text('Please upload an avatar image first'));
      return;
    }
    setState(() {
      _avatarSource = nextSource;
    });
  }

  String? _detectImageMimeType(PlatformFile file) {
    final extension = file.extension?.toLowerCase();
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      default:
        return null;
    }
  }

  Future<void> _pickAvatarImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: const ['png', 'jpg', 'jpeg', 'webp', 'gif'],
    );
    if (!mounted || result == null || result.files.isEmpty) {
      return;
    }

    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      showAppSnackBar(context, _t.text('Selected file has no readable bytes'));
      return;
    }

    final mimeType = _detectImageMimeType(file);
    if (mimeType == null) {
      showAppSnackBar(context, _t.text('Selected image is unsupported'));
      return;
    }

    if (bytes.length > 1024 * 1024) {
      showAppSnackBar(context, _t.text('Image must be 1 MB or smaller'));
      return;
    }

    setState(() {
      _pendingAvatarBytes = bytes;
      _pendingAvatarMimeType = mimeType;
      _pendingAvatarFileName = file.name;
      _avatarSource = 'upload';
    });
    showAppSnackBar(context, _t.text('Selected image ready'));
  }

  Future<void> _uploadAvatarImage({bool showSuccessMessage = true}) async {
    final bytes = _pendingAvatarBytes;
    final mimeType = _pendingAvatarMimeType;
    if (bytes == null || mimeType == null) {
      if (showSuccessMessage && mounted) {
        showAppSnackBar(
          context,
          _t.text('Please upload an avatar image first'),
        );
      }
      return;
    }

    setState(() {
      _isUploadingAvatar = true;
    });

    try {
      await _auth.uploadAvatarImage(
        bytesBase64: base64Encode(bytes),
        contentType: mimeType,
        fileName: _pendingAvatarFileName,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _clearPendingAvatarSelection();
        _avatarSource = 'upload';
      });
      if (showSuccessMessage) {
        showAppSnackBar(
          context,
          _t.text('Avatar image uploaded successfully'),
        );
      }
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, e.message);
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingAvatar = false;
        });
      }
    }
  }

  Future<void> _deleteUploadedAvatar() async {
    setState(() {
      _isRemovingAvatar = true;
    });

    try {
      await _auth.deleteAvatarImage();
      if (!mounted) {
        return;
      }
      setState(() {
        _clearPendingAvatarSelection();
        _avatarSource = 'google';
      });
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, e.message);
    } finally {
      if (mounted) {
        setState(() {
          _isRemovingAvatar = false;
        });
      }
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      showAppSnackBar(context, _t.text('Name is required'));
      return;
    }

    try {
      if (_avatarSource == 'upload' && _pendingAvatarBytes != null) {
        await _uploadAvatarImage(showSuccessMessage: false);
      }
      if (!mounted) {
        return;
      }

      final latestUser = _auth.user;
      if (_avatarSource == 'upload' &&
          (latestUser?.uploadedAvatarUrl == null ||
              latestUser!.uploadedAvatarUrl!.isEmpty)) {
        showAppSnackBar(
          context,
          _t.text('Please upload an avatar image first'),
        );
        return;
      }

      await _auth.updateProfile(
        name: name,
        bio: _bioController.text.trim(),
        avatarSource: _avatarSource,
        customAvatarUrl: _customAvatarUrlController.text.trim(),
      );
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, _t.text('Profile updated'));
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().user;
    final theme = Theme.of(context);
    final t = context.watch<LocaleProvider>().translation;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.text('Profile'))),
        body: Center(child: Text(t.text('Please log in first'))),
      );
    }

    final previewUrl = _previewAvatarUrl(user);
    final hasUploadedAvatar = _hasUploadedAvatar(user);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.text('Profile and settings')),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
            icon: const Icon(Icons.arrow_back),
            label: Text(t.text('Back to home')),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
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
                        t.text('Account Profile'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: [
                          SizedBox(
                            width: 220,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.text('Current avatar preview'),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: CircleAvatar(
                                    radius: 56,
                                    backgroundImage: previewUrl.isNotEmpty
                                        ? NetworkImage(previewUrl)
                                        : null,
                                    child: previewUrl.isEmpty
                                        ? Text(
                                            user.name.isEmpty
                                                ? '?'
                                                : user.name[0],
                                            style:
                                                theme.textTheme.headlineMedium,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(_avatarSourceDescription()),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _pickAvatarImage,
                                    icon: const Icon(Icons.upload_file_outlined),
                                    label: Text(t.text('Pick image')),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: _isUploadingAvatar
                                        ? null
                                        : _uploadAvatarImage,
                                    icon: _isUploadingAvatar
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.cloud_upload_outlined),
                                    label: Text(t.text('Upload image')),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: (!hasUploadedAvatar &&
                                            _pendingAvatarBytes == null) ||
                                            _isRemovingAvatar
                                        ? null
                                        : _deleteUploadedAvatar,
                                    icon: _isRemovingAvatar
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.delete_outline),
                                    label: Text(
                                      t.text('Remove uploaded image'),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _pendingAvatarFileName ??
                                      (hasUploadedAvatar
                                          ? t.text('Uploaded image')
                                          : t.text('No uploaded image stored yet')),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 520,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: t.text('Display name'),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: _bioController,
                                  minLines: 3,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    labelText: t.text('Bio'),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                TextFormField(
                                  enabled: false,
                                  initialValue: user.email,
                                  decoration: InputDecoration(
                                    labelText: t.text('Email'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  t.text('Your account email cannot be changed here.'),
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 18),
                                DropdownButtonFormField<String>(
                                  initialValue: _avatarSource,
                                  decoration: InputDecoration(
                                    labelText: t.text('Avatar source'),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: 'google',
                                      child: Text(t.text('Google avatar')),
                                    ),
                                    DropdownMenuItem(
                                      value: 'custom',
                                      child: Text(t.text('Custom image URL')),
                                    ),
                                    DropdownMenuItem(
                                      value: 'upload',
                                      child: Text(t.text('Uploaded image')),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }
                                    _selectAvatarSource(value, user);
                                  },
                                ),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: _customAvatarUrlController,
                                  decoration: InputDecoration(
                                    labelText: t.text('Custom avatar URL'),
                                    hintText: 'https://example.com/avatar.png',
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: FilledButton.icon(
                                    onPressed: _save,
                                    icon: const Icon(Icons.save_outlined),
                                    label: Text(t.text('Save profile')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SettingsPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
