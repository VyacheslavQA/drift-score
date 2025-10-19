import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';

class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  final _formKey = GlobalKey<FormState>();

  // Форма создания кода
  String _selectedFishingType = 'carp';
  final _customLabelController = TextEditingController();
  String _codeType = 'single_use';
  final _noteController = TextEditingController();

  // Список кодов
  List<Map<String, dynamic>> _codes = [];
  bool _isLoadingCodes = true;

  // Фильтр кодов
  String _codeFilter = 'all'; // 'all', 'active', 'used', 'deactivated'

  @override
  void initState() {
    super.initState();
    _loadCodes();
  }

  @override
  void dispose() {
    _customLabelController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// Загрузить список созданных кодов
  Future<void> _loadCodes() async {
    setState(() => _isLoadingCodes = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('access_codes')
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();

      setState(() {
        _codes = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data(),
          };
        }).toList();
        _isLoadingCodes = false;
      });

      print('✅ Loaded ${_codes.length} codes');
    } catch (e) {
      print('❌ Error loading codes: $e');
      setState(() => _isLoadingCodes = false);
    }
  }

  /// Фильтрация кодов
  List<Map<String, dynamic>> get _filteredCodes {
    if (_codeFilter == 'all') {
      return _codes;
    }

    return _codes.where((codeData) {
      final isActive = codeData['isActive'] as bool? ?? true;
      final currentUses = codeData['currentUses'] as int? ?? 0;
      final maxUses = codeData['maxUses'] as int? ?? 1;
      final deactivatedBy = codeData['deactivatedBy'] as String?;

      final bool isUsedUp = currentUses >= maxUses && maxUses > 0;
      final bool isManuallyDeactivated = !isActive && deactivatedBy == 'admin';

      switch (_codeFilter) {
        case 'active':
          return isActive && !isUsedUp;
        case 'used':
          return isUsedUp;
        case 'deactivated':
          return isManuallyDeactivated;
        default:
          return true;
      }
    }).toList();
  }

  /// Сгенерировать уникальный код
  Future<String> _generateUniqueCode(String fishingType, String? customLabel) async {
    int attempts = 0;
    const maxAttempts = 10;

    while (attempts < maxAttempts) {
      final code = _buildCode(fishingType, customLabel);

      // Проверяем уникальность в Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('access_codes')
          .where('code', isEqualTo: code)
          .get();

      if (snapshot.docs.isEmpty) {
        print('✅ Generated unique code: $code');
        return code;
      }

      print('⚠️ Code $code already exists, retrying...');
      attempts++;
    }

    throw Exception('Не удалось сгенерировать уникальный код после $maxAttempts попыток');
  }

  /// Построить код
  String _buildCode(String fishingType, String? customLabel) {
    // Префиксы для типов рыбалки
    final Map<String, String> prefixes = {
      'float': 'FLOAT',
      'spinning': 'SPIN',
      'carp': 'CARP',
      'feeder': 'FEED',
      'ice_jig': 'ICEJ',
      'ice_spoon': 'ICES',
      'trout': 'TROUT',
      'fly': 'FLY',
      'casting': 'CAST',
    };

    final prefix = prefixes[fishingType] ?? 'COMP';
    final middle = (customLabel != null && customLabel.isNotEmpty)
        ? customLabel.toUpperCase()
        : _generateRandomString(4);
    final suffix = _generateRandomString(4);

    return '$prefix-$middle-$suffix';
  }

  /// Сгенерировать случайную строку (буквы + цифры)
  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Без 0, O, I, 1
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// Создать код доступа
  Future<void> _createAccessCode() async {
    if (!_formKey.currentState!.validate()) return;

    // Показываем загрузку
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: AppDimensions.paddingMedium),
                Text('Генерация кода...', style: AppTextStyles.body),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Генерируем уникальный код
      final customLabel = _customLabelController.text.trim();
      final code = await _generateUniqueCode(
        _selectedFishingType,
        customLabel.isEmpty ? null : customLabel,
      );

      // Сохраняем в Firestore
      await FirebaseFirestore.instance.collection('access_codes').add({
        'code': code,
        'fishingType': _selectedFishingType,
        'customLabel': customLabel.isEmpty ? null : customLabel,
        'type': _codeType,
        'maxUses': _codeType == 'single_use' ? 1 : 5,
        'currentUses': 0,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': 'admin',
        'purchaseMethod': 'manual',
        'note': _noteController.text.trim(),
        'usedBy': [],
        'competitions': [],
      });

      if (!mounted) return;
      Navigator.pop(context); // Закрываем диалог загрузки

      // Показываем успех с кодом
      _showSuccessDialog(code);

      // Очищаем форму
      _customLabelController.clear();
      _noteController.clear();
      setState(() {
        _selectedFishingType = 'carp';
        _codeType = 'single_use';
      });

      // Обновляем список
      _loadCodes();
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Закрываем диалог загрузки

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка создания кода: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Показать диалог успешного создания
  void _showSuccessDialog(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 28),
            SizedBox(width: AppDimensions.paddingSmall),
            Text('Код создан!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: SelectableText(
                code,
                style: AppTextStyles.h2.copyWith(
                  fontFamily: 'monospace',
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: AppDimensions.paddingMedium),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Код скопирован'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              icon: Icon(Icons.copy),
              label: Text('Копировать'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  /// Деактивировать код
  Future<void> _deactivateCode(String codeId, String code) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Деактивировать код?'),
        content: Text('Код станет неактивным. Существующие соревнования останутся доступными.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Деактивировать'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('access_codes')
          .doc(codeId)
          .update({
        'isActive': false,
        'deactivatedAt': FieldValue.serverTimestamp(),
        'deactivatedBy': 'admin',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Код деактивирован'),
          backgroundColor: Colors.orange,
        ),
      );

      _loadCodes();
    } catch (e) {
      print('❌ Error deactivating code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Реактивировать код
  Future<void> _reactivateCode(String codeId, String code) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Активировать код?'),
        content: Text('Код снова станет активным.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.success),
            child: Text('Активировать'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('access_codes')
          .doc(codeId)
          .update({
        'isActive': true,
        'reactivatedAt': FieldValue.serverTimestamp(),
        'reactivatedBy': 'admin',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Код активирован'),
          backgroundColor: AppColors.success,
        ),
      );

      _loadCodes();
    } catch (e) {
      print('❌ Error reactivating code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Показать соревнования по коду
  Future<void> _showCompetitionsByCode(String code) async {
    // TODO: Реализовать загрузку соревнований из Firestore или Isar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Просмотр соревнований по коду: $code'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            Icon(Icons.shield, color: AppColors.primary),
            SizedBox(width: AppDimensions.paddingSmall),
            Text('Админ-панель', style: AppTextStyles.h2),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Форма создания кода
            _buildCreateCodeForm(),

            SizedBox(height: AppDimensions.paddingXLarge),

            // Список кодов
            _buildCodesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateCodeForm() {
    return Card(
      color: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Создать код доступа',
                style: AppTextStyles.h2,
              ),
              SizedBox(height: AppDimensions.paddingLarge),

              // Тип рыбалки
              Text('Тип рыбалки:', style: AppTextStyles.bodyLarge),
              SizedBox(height: AppDimensions.paddingSmall),
              DropdownButtonFormField<String>(
                value: _selectedFishingType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  prefixIcon: Icon(Icons.phishing, color: AppColors.primary),
                ),
                items: [
                  DropdownMenuItem(value: 'float', child: Text('Поплавок')),
                  DropdownMenuItem(value: 'spinning', child: Text('Спиннинг')),
                  DropdownMenuItem(value: 'carp', child: Text('Карпфишинг')),
                  DropdownMenuItem(value: 'feeder', child: Text('Фидер')),
                  DropdownMenuItem(value: 'ice_jig', child: Text('Зимняя мормышка')),
                  DropdownMenuItem(value: 'ice_spoon', child: Text('Зимняя блесна')),
                  DropdownMenuItem(value: 'trout', child: Text('Форель')),
                  DropdownMenuItem(value: 'fly', child: Text('Нахлыст')),
                  DropdownMenuItem(value: 'casting', child: Text('Кастинг')),
                ],
                onChanged: (value) {
                  setState(() => _selectedFishingType = value!);
                },
              ),

              SizedBox(height: AppDimensions.paddingMedium),

              // Дополнительная метка
              Text('Метка (необязательно):', style: AppTextStyles.bodyLarge),
              SizedBox(height: AppDimensions.paddingSmall),
              TextFormField(
                controller: _customLabelController,
                decoration: InputDecoration(
                  hintText: 'WINTER, CUP2025...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  prefixIcon: Icon(Icons.label_outline, color: AppColors.primary),
                ),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                  LengthLimitingTextInputFormatter(10),
                ],
              ),

              SizedBox(height: AppDimensions.paddingLarge),

              // Количество соревнований
              Text('Количество соревнований:', style: AppTextStyles.bodyLarge),
              SizedBox(height: AppDimensions.paddingSmall),

              // 1 соревнование
              GestureDetector(
                onTap: () => setState(() => _codeType = 'single_use'),
                child: Container(
                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: _codeType == 'single_use'
                        ? AppColors.secondary.withOpacity(0.2)
                        : AppColors.surfaceMedium,
                    border: Border.all(
                      color: _codeType == 'single_use'
                          ? AppColors.secondary
                          : AppColors.borderDark,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event,
                        color: _codeType == 'single_use'
                            ? AppColors.secondary
                            : AppColors.textSecondary,
                        size: 28,
                      ),
                      SizedBox(width: AppDimensions.paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1 соревнование',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _codeType == 'single_use'
                                    ? AppColors.secondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Базовый вариант',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      if (_codeType == 'single_use')
                        Icon(Icons.check, color: AppColors.secondary, size: 24),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.paddingMedium),

              // 5 соревнований
              GestureDetector(
                onTap: () => setState(() => _codeType = 'pack_5'),
                child: Container(
                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: _codeType == 'pack_5'
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.surfaceMedium,
                    border: Border.all(
                      color: _codeType == 'pack_5'
                          ? AppColors.primary
                          : AppColors.borderDark,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        color: _codeType == 'pack_5'
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 28,
                      ),
                      SizedBox(width: AppDimensions.paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '5 соревнований',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _codeType == 'pack_5'
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Выгодный пакет',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      if (_codeType == 'pack_5')
                        Icon(Icons.check, color: AppColors.primary, size: 24),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.paddingLarge),

              // Примечание
              Text('Примечание:', style: AppTextStyles.bodyLarge),
              SizedBox(height: AppDimensions.paddingSmall),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: 'Зимний турнир Павлодар',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  prefixIcon: Icon(Icons.notes, color: AppColors.primary),
                ),
                maxLines: 2,
              ),

              SizedBox(height: AppDimensions.paddingLarge),

              // Кнопка создания
              ElevatedButton.icon(
                onPressed: _createAccessCode,
                icon: Icon(Icons.add_circle_outline),
                label: Text('Создать код'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium + 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodesList() {
    return Card(
      color: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Коды доступа', style: AppTextStyles.h2),
                TextButton.icon(
                  onPressed: _loadCodes,
                  icon: Icon(Icons.refresh, size: 20),
                  label: Text('Обновить'),
                ),
              ],
            ),

            SizedBox(height: AppDimensions.paddingMedium),

            // Фильтры
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Все', 'all'),
                  SizedBox(width: 8),
                  _buildFilterChip('Активные', 'active'),
                  SizedBox(width: 8),
                  _buildFilterChip('Использованные', 'used'),
                  SizedBox(width: 8),
                  _buildFilterChip('Деактивированные', 'deactivated'),
                ],
              ),
            ),

            SizedBox(height: AppDimensions.paddingMedium),

            if (_isLoadingCodes)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingXLarge),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (_filteredCodes.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingXLarge),
                  child: Text(
                    'Нет кодов в этой категории',
                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filteredCodes.length,
                itemBuilder: (context, index) {
                  final codeData = _filteredCodes[index];
                  return _buildCodeItem(codeData);
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Фильтр-чип
  Widget _buildFilterChip(String label, String value) {
    final isSelected = _codeFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _codeFilter = value);
      },
      backgroundColor: AppColors.surfaceMedium,
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: AppTextStyles.caption.copyWith(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.divider,
        width: isSelected ? 2 : 1,
      ),
    );
  }

  Widget _buildCodeItem(Map<String, dynamic> codeData) {
    final code = codeData['code'] as String;
    final isActive = codeData['isActive'] as bool? ?? true;
    final currentUses = codeData['currentUses'] as int? ?? 0;
    final maxUses = codeData['maxUses'] as int? ?? 1;
    final note = codeData['note'] as String?;
    final createdAt = codeData['createdAt'] as Timestamp?;
    final codeType = codeData['type'] as String?;
    final deactivatedBy = codeData['deactivatedBy'] as String?;
    final competitions = codeData['competitions'] as List?;

    // Определяем состояние кода
    final bool isUsedUp = currentUses >= maxUses && maxUses > 0;
    final bool isManuallyDeactivated = !isActive && deactivatedBy == 'admin';

    // Цвет и иконка статуса
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (isActive && !isUsedUp) {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle;
      statusText = 'Активен';
    } else if (isManuallyDeactivated) {
      statusColor = Colors.orange;
      statusIcon = Icons.block;
      statusText = 'Деактивирован';
    } else if (isUsedUp) {
      statusColor = Colors.grey;
      statusIcon = Icons.hourglass_empty;
      statusText = 'Использован';
    } else {
      statusColor = Colors.grey;
      statusIcon = Icons.cancel;
      statusText = 'Неактивен';
    }

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: isActive && !isUsedUp
            ? AppColors.surfaceMedium
            : AppColors.surfaceMedium.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Строка: Статус + Кнопки действий
          Row(
            children: [
              // Статус
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    SizedBox(width: 4),
                    Text(
                      statusText,
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              // Кнопки действий
              IconButton(
                icon: Icon(Icons.copy, size: 20),
                tooltip: 'Копировать',
                color: AppColors.primary,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Код скопирован'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
              // Кнопка просмотра соревнований
              if (competitions != null && competitions.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.visibility, size: 20),
                  tooltip: 'Просмотр соревнований',
                  color: AppColors.secondary,
                  onPressed: () => _showCompetitionsByCode(code),
                ),
              if (isActive && !isUsedUp)
                IconButton(
                  icon: Icon(Icons.block, size: 20),
                  tooltip: 'Деактивировать',
                  color: Colors.red,
                  onPressed: () => _deactivateCode(codeData['id'], code),
                ),
              if (isManuallyDeactivated)
                IconButton(
                  icon: Icon(Icons.refresh, size: 20),
                  tooltip: 'Активировать',
                  color: AppColors.success,
                  onPressed: () => _reactivateCode(codeData['id'], code),
                ),
            ],
          ),

          SizedBox(height: 8),

          // Код (крупный, моноширинный)
          SelectableText(
            code,
            style: AppTextStyles.h2.copyWith(
              fontFamily: 'monospace',
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),

          // Примечание
          if (note != null && note.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              note,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ],

          SizedBox(height: 8),

          // Бейджи (использование, дата, тип)
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              // Использование
              _buildBadge(
                icon: Icons.bar_chart,
                text: '$currentUses/$maxUses',
              ),

              // Количество соревнований
              if (competitions != null && competitions.isNotEmpty)
                _buildBadge(
                  icon: Icons.event,
                  text: '${competitions.length} сорев.',
                  color: AppColors.secondary.withOpacity(0.2),
                  textColor: AppColors.secondary,
                ),

              // Дата (короткая)
              if (createdAt != null)
                _buildBadge(
                  icon: Icons.calendar_today,
                  text: DateFormat('dd.MM.yy').format(createdAt.toDate()),
                ),

              // Тип
              if (codeType == 'pack_5')
                _buildBadge(
                  icon: Icons.workspace_premium,
                  text: 'Пакет 5',
                  color: AppColors.primary.withOpacity(0.2),
                  textColor: AppColors.primary,
                ),

              // ✅ НОВОЕ: Метод создания кода
              _buildPurchaseMethodBadge(codeData),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String text,
    Color? color,
    Color? textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceMedium.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor ?? AppColors.textSecondary),
          SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              color: textColor ?? AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ НОВОЕ: Бейдж метода создания кода
  Widget _buildPurchaseMethodBadge(Map<String, dynamic> codeData) {
    final purchaseMethod = codeData['purchaseMethod'] as String?;

    if (purchaseMethod == null) return SizedBox.shrink();

    IconData icon;
    String text;
    Color bgColor;
    Color textColor;

    switch (purchaseMethod) {
      case 'manual':
        icon = Icons.admin_panel_settings;
        text = 'Вручную';
        bgColor = Colors.blue.withOpacity(0.2);
        textColor = Colors.blue;
        break;
      case 'app_store':
        icon = Icons.shopping_bag;
        text = 'App Store';
        bgColor = Colors.purple.withOpacity(0.2);
        textColor = Colors.purple;
        break;
      case 'google_play':
        icon = Icons.shop;
        text = 'Google Play';
        bgColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green;
        break;
      default:
        return SizedBox.shrink();
    }

    return _buildBadge(
      icon: icon,
      text: text,
      color: bgColor,
      textColor: textColor,
    );
  }
}