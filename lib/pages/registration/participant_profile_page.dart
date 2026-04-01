import 'package:flutter/material.dart';

import '../../models/participant_profile.dart';
import '../../services/api_client.dart';
import '../../services/participant_profile_service.dart';
import '../../utils/snackbar.dart';

class ParticipantProfilePage extends StatefulWidget {
  const ParticipantProfilePage({super.key});

  @override
  State<ParticipantProfilePage> createState() => _ParticipantProfilePageState();
}

class _ParticipantProfilePageState extends State<ParticipantProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _legalNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _occupationController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _igController = TextEditingController();
  final _lineController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _cityController = TextEditingController();
  final _foodAvoidancesController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _musicPreferencesController = TextEditingController();
  final _hobbiesController = TextEditingController();

  late final ParticipantProfileService _service;

  bool _isLoading = true;
  bool _isSaving = false;
  String _gender = '女性';
  String _ageRange = '26-30';
  String _dietType = '葷食';
  String _referralSource = 'Instagram';

  @override
  void initState() {
    super.initState();
    _service = ParticipantProfileService(ApiClient());
    _load();
  }

  @override
  void dispose() {
    _legalNameController.dispose();
    _phoneController.dispose();
    _occupationController.dispose();
    _birthDateController.dispose();
    _nationalIdController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationController.dispose();
    _emergencyPhoneController.dispose();
    _igController.dispose();
    _lineController.dispose();
    _nicknameController.dispose();
    _cityController.dispose();
    _foodAvoidancesController.dispose();
    _allergiesController.dispose();
    _musicPreferencesController.dispose();
    _hobbiesController.dispose();
    super.dispose();
  }

  List<String> _splitCommaSeparated(String value) {
    return value
        .split(RegExp(r'[,，\n]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  Future<void> _load() async {
    try {
      final profile = await _service.fetchProfile();
      if (!mounted) {
        return;
      }
      if (profile != null) {
        _seed(profile);
      }
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

  void _seed(ParticipantProfile profile) {
    _legalNameController.text = profile.legalName;
    _phoneController.text = profile.phone;
    _occupationController.text = profile.occupation;
    _birthDateController.text = profile.birthDate;
    _nationalIdController.text = profile.nationalId;
    _emergencyNameController.text = profile.emergencyName;
    _emergencyRelationController.text = profile.emergencyRelation;
    _emergencyPhoneController.text = profile.emergencyPhone;
    _igController.text = profile.igHandle;
    _lineController.text = profile.lineId;
    _nicknameController.text = profile.nickname ?? '';
    _cityController.text = profile.city ?? '';
    _foodAvoidancesController.text = profile.foodAvoidances.join(', ');
    _allergiesController.text = profile.allergiesText ?? '';
    _musicPreferencesController.text = profile.musicPreferences.join(', ');
    _hobbiesController.text = profile.hobbiesText ?? '';
    _gender = profile.gender;
    _ageRange = profile.ageRange;
    _dietType = profile.dietType;
    _referralSource = profile.referralSource;
  }

  ParticipantProfile _buildProfile() {
    return ParticipantProfile(
      legalName: _legalNameController.text.trim(),
      gender: _gender,
      ageRange: _ageRange,
      phone: _phoneController.text.trim(),
      occupation: _occupationController.text.trim(),
      birthDate: _birthDateController.text.trim(),
      nationalId: _nationalIdController.text.trim(),
      emergencyName: _emergencyNameController.text.trim(),
      emergencyRelation: _emergencyRelationController.text.trim(),
      emergencyPhone: _emergencyPhoneController.text.trim(),
      igHandle: _igController.text.trim(),
      lineId: _lineController.text.trim(),
      nickname: _nicknameController.text.trim().isEmpty
          ? null
          : _nicknameController.text.trim(),
      city: _cityController.text.trim().isEmpty
          ? null
          : _cityController.text.trim(),
      dietType: _dietType,
      foodAvoidances: _splitCommaSeparated(_foodAvoidancesController.text),
      allergiesText: _allergiesController.text.trim().isEmpty
          ? null
          : _allergiesController.text.trim(),
      musicPreferences: _splitCommaSeparated(_musicPreferencesController.text),
      hobbiesText: _hobbiesController.text.trim().isEmpty
          ? null
          : _hobbiesController.text.trim(),
      referralSource: _referralSource,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final saved = await _service.saveProfile(_buildProfile());
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, '報名資料已儲存');
      Navigator.of(context).pop(saved);
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, e.message);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      validator:
          validator ??
          (value) {
            if ((value ?? '').trim().isEmpty) {
              return '此欄位必填';
            }
            return null;
          },
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> options,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: options
          .map(
            (item) =>
                DropdownMenuItem<T>(value: item, child: Text(item.toString())),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('報名主檔資料')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '這些資料會在之後報名活動時自動帶入。',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('生日請使用 YYYY-MM-DD，例如 2025-06-15。'),
                          SizedBox(height: 4),
                          Text('忌口與音樂偏好可用逗號分隔。'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: 410,
                        child: _buildTextField('真實姓名', _legalNameController),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildDropdown<String>(
                          label: '性別',
                          value: _gender,
                          options: const ['男性', '女性'],
                          onChanged: (value) => setState(() {
                            _gender = value ?? _gender;
                          }),
                        ),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildDropdown<String>(
                          label: '年齡區間',
                          value: _ageRange,
                          options: const ['18-20', '21-25', '26-30', '31-35'],
                          onChanged: (value) => setState(() {
                            _ageRange = value ?? _ageRange;
                          }),
                        ),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildTextField('手機號碼', _phoneController),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildTextField('職業', _occupationController),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildTextField(
                          '出生年月日',
                          _birthDateController,
                          hint: 'YYYY-MM-DD',
                          validator: (value) {
                            final text = (value ?? '').trim();
                            if (text.isEmpty) {
                              return '此欄位必填';
                            }
                            if (!RegExp(
                              r'^\d{4}-\d{2}-\d{2}$',
                            ).hasMatch(text)) {
                              return '請使用 YYYY-MM-DD';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildTextField('身分證字號', _nationalIdController),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildTextField(
                          '緊急聯絡人姓名',
                          _emergencyNameController,
                        ),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildTextField(
                          '緊急聯絡人關係',
                          _emergencyRelationController,
                        ),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildTextField(
                          '緊急聯絡人電話',
                          _emergencyPhoneController,
                        ),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildTextField('IG 帳號', _igController),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildTextField('LINE ID', _lineController),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildTextField(
                          '暱稱',
                          _nicknameController,
                          validator: (_) => null,
                        ),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildTextField(
                          '居住地 / 工作地',
                          _cityController,
                          validator: (_) => null,
                        ),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildDropdown<String>(
                          label: '飲食習慣',
                          value: _dietType,
                          options: const ['葷食', '素食', '蛋奶素', '其他'],
                          onChanged: (value) => setState(() {
                            _dietType = value ?? _dietType;
                          }),
                        ),
                      ),
                      SizedBox(
                        width: 410,
                        child: _buildDropdown<String>(
                          label: '從哪裡知道我們',
                          value: _referralSource,
                          options: const ['Instagram', 'LINE', 'EG'],
                          onChanged: (value) => setState(() {
                            _referralSource = value ?? _referralSource;
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    '忌口食物',
                    _foodAvoidancesController,
                    hint: '例如：牛, 蝦, 海鮮',
                    validator: (_) => null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    '過敏原',
                    _allergiesController,
                    maxLines: 2,
                    validator: (_) => null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    '平常聽的音樂類型',
                    _musicPreferencesController,
                    hint: '例如：中文歌, EDM, HIP HOP',
                    validator: (_) => null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    '興趣或才藝',
                    _hobbiesController,
                    maxLines: 3,
                    validator: (_) => null,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: _isSaving ? null : _save,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(_isSaving ? '儲存中...' : '儲存主檔資料'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
